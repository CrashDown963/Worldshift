// Galaxy shaders

#include "utility.fxh"

texture BaseMap   <string NTM = "base";   int NTMIndex = 0;>;
//half  fBrightness      : GLOBAL = 1.0;

// Samplers:
sampler2D sBaseMap = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = Wrap; AddressV = Wrap;
};

texture ShaderMap0 <string NTM = "shader";   int NTMIndex = 0;>;

sampler2D sShaderMap = sampler_state
{
  texture = <ShaderMap0>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
};


// Time:
float    fTime          : GLOBAL = 1.0f;

// Camera position:
//float3 vWorldCamera         : GLOBAL = { 100.0f, 500.0f, 1000.0f };


// Transformations:
//float4x4  mWorld            : WORLD;
float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;


struct VS_STAR_INPUT {
  float4  vPos    : POSITION;
  half3   vNormal : NORMAL;     //x -> Phase, y -> Scale, z -> Size (from 0 to 1)
  half2   vTexC   : TEXCOORD;
  half4   cDiff   : COLOR0;
};

struct VS_STAR_OUTPUT {
  float4  vPos  : POSITION;
  half2   vTexC : TEXCOORD;
  half4   cDiff : COLOR0;
  half2   vData : TEXCOORD2;	//x -> desaturation value 1.0f -> max color, 0.0f -> white
								//y -> size of star (from 0.0f to 1.0f)
								
  half4   cWeightMask : COLOR1;	//r - weight from sBaseMap r canal
								//g - weight from sBaseMap g canal
								//b - weight from sBaseMap b canal
								//a - weight from sBaseMap a canal
};

VS_STAR_OUTPUT VS_Stars(VS_STAR_INPUT v)
{
  VS_STAR_OUTPUT o;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  o.cDiff = v.cDiff;
  
  float fDist = distance(v.vPos, vWorldCamera);
  float fDDD = min(fDist, 1500.0f) / 1500.0f;
  float fTimeScale = lerp(7.0f, 0.7f, fDDD);
  
  float fPhase = fmod(fTime / fTimeScale + v.vNormal.x, 1.0f);
  float fG = step(0.5f, fPhase);	//fG = 1 if fPhase > 0.5f
  float fS = step(fPhase, 0.5f);	//fS = 1 if fPhase <= 0.5f
  
  //float fMin = lerp(0.1f, 0.2f, fDDD);
  //float fMin = lerp(0.65f, 0.78f, fDDD);
  //float fMin = lerp(0.65f, 0.85f, fDDD);
  //float fMin = lerp(0.85f, 0.80f, fDDD);
  float fMin = lerp(0.85f, 0.79f, fDDD);
  float fMax = 1.0f;
  float f = fG * lerp(fMin, fMax, (fPhase - 0.5f) * 2) + fS * lerp(fMax, fMin, fPhase * 2);
  
  o.cWeightMask.r = abs(ceil(v.vNormal.x / 0.25f) - 4.0f) < 0.1;
  o.cWeightMask.g = abs(ceil(v.vNormal.x / 0.25f) - 1.0f) < 0.1;
  o.cWeightMask.b = abs(ceil(v.vNormal.x / 0.25f) - 2.0f) < 0.1;
  o.cWeightMask.a = abs(ceil(v.vNormal.x / 0.25f) - 3.0f) < 0.1;
  
  f = min(f, 1.0f);
  //f = 1.0f;
  
  float fAlpha = min(fDist, 15000.0f) / 15000.0f;
  fAlpha = max(fAlpha, 0.6f);
  
  o.cDiff.a *= f * fAlpha;
  o.vData.x = v.vNormal.z;
  o.vData.y = 0;
  return o;
}

void PS_Stars(VS_STAR_OUTPUT In, out half4 cOut: COLOR0)
{
  cOut = tex2D(sBaseMap, In.vTexC);
  //cOut.a = cOut.r;
  
  cOut.a =	cOut.r * In.cWeightMask.r + 
			cOut.g * In.cWeightMask.g + 
			cOut.b * In.cWeightMask.b + 
			cOut.a * In.cWeightMask.a;
  

  half2 hCoord = {1 - cOut.a, In.vData.x};
  half4 cMask = tex2D(sShaderMap, hCoord);
  
  //cOut.r = ((1.0f - cOut.a) * In.cDiff.r + cOut.a * cMask.r) * fBrightness;
  //cOut.g = ((1.0f - cOut.a) * In.cDiff.g + cOut.a * cMask.g) * fBrightness;
  //cOut.b = ((1.0f - cOut.a) * In.cDiff.b + cOut.a * cMask.b) * fBrightness;
  
  //cOut.r = (1.0f - cOut.a) * In.cDiff.r + cOut.a * cMask.r;
  //cOut.g = (1.0f - cOut.a) * In.cDiff.g + cOut.a * cMask.g;
  //cOut.b = (1.0f - cOut.a) * In.cDiff.b + cOut.a * cMask.b;
  //cOut.rgb = (1.0f - cOut.a) * In.cDiff.rgb + cOut.a * cMask.rgb;
  
  //cOut.rgb = 1.0f;
  
			
//cOut.a =	cOut.b * In.cWeightMask.b;
  
  
  //cOut.r = 1.0f;
  //cOut.g = 1.0f;
  //cOut.b = 1.0f;
  
  cOut.a *= In.cDiff.a;
}

technique Stars
<
  string shadername = "Stars";
  int implementation = 0;
  string description = "Galaxy stars implementation.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    CullMode = None;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 32;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Stars();
    PixelShader = compile ps_2_0 PS_Stars();
  }
}





//------------------------------------------Front stars shaders

VS_STAR_OUTPUT VS_StarsFront(VS_STAR_INPUT v)
{
  VS_STAR_OUTPUT o;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  o.cDiff = v.cDiff;
  
  float fDist = distance(v.vPos, vWorldCamera);
  float fDDD = min(fDist, 1500.0f) / 1500.0f;
  float fTimeScale = lerp(7.0f, 0.7f, fDDD);
  
  float fPhase = fmod(fTime / fTimeScale + v.vNormal.x, 1.0f);
  float fG = step(0.5f, fPhase);	//fG = 1 if fPhase > 0.5f
  float fS = step(fPhase, 0.5f);	//fS = 1 if fPhase <= 0.5f
  
  //float fMin = lerp(0.1f, 0.2f, fDDD);
  //float fMin = lerp(0.65f, 0.78f, fDDD);
  //float fMin = lerp(0.65f, 0.85f, fDDD);
  //float fMin = lerp(0.85f, 0.80f, fDDD);
  float fMin = lerp(0.85f, 0.79f, fDDD);
  float fMax = 1.0f;
  float f = fG * lerp(fMin, fMax, (fPhase - 0.5f) * 2) + fS * lerp(fMax, fMin, fPhase * 2);
  
  o.cWeightMask.r = abs(ceil(v.vNormal.x / 0.25f) - 4.0f) < 0.1;
  o.cWeightMask.g = abs(ceil(v.vNormal.x / 0.25f) - 1.0f) < 0.1;
  o.cWeightMask.b = abs(ceil(v.vNormal.x / 0.25f) - 2.0f) < 0.1;
  o.cWeightMask.a = abs(ceil(v.vNormal.x / 0.25f) - 3.0f) < 0.1;
  
  f = min(f, 1.0f);
  //f = 1.0f;
  o.cDiff.a *= f;
  o.vData.x = v.vNormal.z;
  o.vData.y = 0;
  return o;
}

void PS_StarsFront(VS_STAR_OUTPUT In, out half4 cOut: COLOR0)
{
  cOut = tex2D(sBaseMap, In.vTexC);
  //cOut.a = cOut.r;
  
  cOut.a =	cOut.r * In.cWeightMask.r + 
			cOut.g * In.cWeightMask.g + 
			cOut.b * In.cWeightMask.b + 
			cOut.a * In.cWeightMask.a;
  

  half2 hCoord = {1 - cOut.a, In.vData.x};
  half4 cMask = tex2D(sShaderMap, hCoord);
  
  //cOut.r = ((1.0f - cOut.a) * In.cDiff.r + cOut.a * cMask.r) * fBrightness;
  //cOut.g = ((1.0f - cOut.a) * In.cDiff.g + cOut.a * cMask.g) * fBrightness;
  //cOut.b = ((1.0f - cOut.a) * In.cDiff.b + cOut.a * cMask.b) * fBrightness;
  
  //cOut.r = (1.0f - cOut.a) * In.cDiff.r + cOut.a * cMask.r;
  //cOut.g = (1.0f - cOut.a) * In.cDiff.g + cOut.a * cMask.g;
  //cOut.b = (1.0f - cOut.a) * In.cDiff.b + cOut.a * cMask.b;
  cOut.rgb = (1.0f - cOut.a) * In.cDiff.rgb + cOut.a * cMask.rgb;
  
			
//cOut.a =	cOut.b * In.cWeightMask.b;
  
  
  //cOut.r = 1.0f;
  //cOut.g = 1.0f;
  //cOut.b = 1.0f;
  
  cOut.a *= In.cDiff.a;
}

technique StarsFront
<
  string shadername = "StarsFront";
  int implementation = 0;
  string description = "Galaxy front stars implementation.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    CullMode = None;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 32;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_StarsFront();
    PixelShader = compile ps_2_0 PS_StarsFront();
  }
}


//backgrounds shader!
struct VS_BG_INPUT {
  float4  vPos    : POSITION;
  half3   vNormal : NORMAL;     //x -> Phase, y -> timescale!, z -> min alpha
  half2   vTexC   : TEXCOORD;
  half4   cDiff   : COLOR0;
};

struct VS_BG_OUTPUT {
  float4  vPos  : POSITION;
  half2   vTexC : TEXCOORD;
  half4   cDiff : COLOR0;
};

float AnimateAlpha(float fPhase, float fTimeScale, float fMinAlpha)
{
  //Animate!
  float fMin = fMinAlpha;
  float f = sin(fTime * fTimeScale +  fPhase) * (1 - fMin) + fMin;
  return f;
}

float3 AnimateVertex(float3 vPos, float fPhase)
{
  float fTimeScale = 0.030f;
  vPos.x += cos((fTime +  fPhase + vPos.x) * fTimeScale) * 1300.0f;
  vPos.y += cos((fTime +  fPhase + vPos.y) * fTimeScale) * 1300.0f;
  return vPos;
}

VS_BG_OUTPUT VS_BG(VS_BG_INPUT v)
{
  VS_BG_OUTPUT o;
  
  o.vPos.xyz = AnimateVertex(v.vPos.xyz, v.vNormal.x);
  o.vPos.w = v.vPos.w;
  o.vPos = mul(o.vPos, mWorldViewProj);
  
  o.vTexC = v.vTexC;
  o.cDiff.rgb = v.cDiff.rgb;
  o.cDiff.a = AnimateAlpha(v.vNormal.x, v.vNormal.y, 0.85f);
  return o;
}

void PS_BG(VS_STAR_OUTPUT In, out half4 cOut: COLOR0)
{
  cOut = tex2D(sBaseMap, In.vTexC);
  cOut.a = In.cDiff.a;
}

technique Galaxy_BG
<
  string shadername = "Galaxy_BG";
  int implementation = 0;
  string description = "Galaxy background implementation.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    CullMode = None;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 32;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_BG();
    PixelShader = compile ps_2_0 PS_BG();
  }
}




//front background shader!
struct VS_FRONT_INPUT {
  float4  vPos    : POSITION;
  half2   vTexC   : TEXCOORD;
  half4   cDiff   : COLOR0;
};

struct VS_FRONT_OUTPUT {
  float4  vPos  : POSITION;
  half2   vTexC : TEXCOORD;
  half4   cDiff : COLOR0;
};


VS_FRONT_OUTPUT VS_FRONT(VS_FRONT_INPUT v)
{
  VS_FRONT_OUTPUT o;
  o.vPos = mul(v.vPos, mWorldViewProj);
  
  o.vTexC = v.vTexC;
  o.cDiff.rgb = v.cDiff.rgb;
  o.cDiff.a = AnimateAlpha(v.vPos.x, 2.0f, 0.85f);
  return o;
}

void PS_FRONT(VS_STAR_OUTPUT In, out half4 cOut: COLOR0)
{
  cOut = tex2D(sBaseMap, In.vTexC);
  cOut.a = In.cDiff.a;
}

technique Galaxy_FRONT
<
  string shadername = "Galaxy_FRONT";
  int implementation = 0;
  string description = "Galaxy front background implementation.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    CullMode = None;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 32;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_FRONT();
    PixelShader = compile ps_2_0 PS_FRONT();
  }
}

//Grid shader
struct VS_GRID_INPUT {
  float4  vPos    : POSITION;
  half3   vNormal : NORMAL;     //pos where to scale!
  half2   vTexC   : TEXCOORD;
  half2   vScale  : TEXCOORD1;   //x, y -> where to scale corresponding to camera distance!
  half2   vAlpha  : TEXCOORD2;   //if distance < vAlpha.x -> appear!, vAlpha.y -> Layer, 0 -> min one, 1 -> max one!
  half4   cDiff   : COLOR0;
};

struct VS_GRID_OUTPUT {
  float4  vPos  : POSITION;
  half4   cDiff : COLOR0;
  half2   vTexC : TEXCOORD;
  half2   vAlpha : TEXCOORD2;
};


VS_GRID_OUTPUT VS_GRID(VS_GRID_INPUT v)
{
  VS_GRID_OUTPUT o;
  
  float3 fPos = mul(v.vPos, mWorld);
  //float fDist = distance(fPos, vWorldCamera);
  float fDist = abs(fPos.z - vWorldCamera.z);
  
  float fMin = 0.0f;
  float fMax = 60.0f;
  float fMinD = 0.0f;
  float fMaxD = 30000.0f;
  
 
  float fFade1 = smoothstep(fMinD, fMaxD, fDist);
  float fFade2 = smoothstep(1.1 * v.vAlpha.x, v.vAlpha.x, fDist);
  
  
  float fW = fMin + (fMax - fMin) * fFade1;
  
  //fW += pow(v.vAlpha.y, 2) * 20.0f;
  
  v.vPos.xy +=  fW * v.vScale.xy;
  
  o.vPos = mul(v.vPos, mWorldViewProj);   
  o.vTexC = v.vTexC;
  o.cDiff = v.cDiff;
  
  o.cDiff.a = (0.025f + pow(v.vAlpha.y, 2) * 0.17f) * fFade2;
  //o.cDiff.a = 1.0f;
  //o.cDiff.a = v.vAlpha.x;
  
  
  //Calc fade!
  o.vAlpha.x = min(fFade1, 1.0f);
  o.vAlpha.y = min(fFade2, 1.0f);
  
  o.cDiff.a *= 2.0;
  return o;
}

void PS_GRID(VS_GRID_OUTPUT In, out half4 cOut: COLOR0)
{
  half4 c = tex2D(sBaseMap, In.vTexC);  
  
  cOut.rgb = In.cDiff.rgb;
  
  //c.a /= 3.0f;
  //c.a = 1 - In.vAlpha.x;
  //c.a = 1.0f;
  
  //c.a = min(In.vTexC.x + In.vTexC.y, 1.0f);
  //In.cDiff.a = 1;
  //In.vAlpha.y = 1;
  
  //Visible!
  if (In.vAlpha.y > 0.9999)
    cOut.a = c.a * In.cDiff.a;
    //cOut.a = In.cDiff.a;
  //Not visible!    
  else if (In.vAlpha.y < 0.0001)
    cOut.a = 0.0f;
  else {
    float f = sin(In.vAlpha.y * 3.1415926);
    cOut.a = ( (1 - f) * c.a + f) * In.cDiff.a;
  }
  
  //cOut.a = c.a;
  //cOut.a = In.cDiff.a;
}

technique Galaxy_GRID
<
  string shadername = "Galaxy_GRID";
  int implementation = 0;
  string description = "Galaxy GRID implementation.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    CullMode = None;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 32;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_GRID();
    PixelShader = compile ps_2_0 PS_GRID();
  }
}