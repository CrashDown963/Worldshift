#include "utility.fxh"

// Galaxy shaders

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


// Time:
float    fTime          : GLOBAL = 1.0f;

// Camera position:
//float3 vWorldCamera         : GLOBAL = { 100.0, 100.0, 100.0 };


// Transformations:
//float4x4  mWorld            : WORLD;
float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;


struct VS_SNOW_INPUT {
  float4  vPos    : POSITION;
  half3   vNormal : NORMAL;     //x -> Phase, y -> Scale, z -> Size (from 0 to 1)
  half2   vTexC   : TEXCOORD;
  half4   cDiff   : COLOR0;
};

struct VS_SNOW_OUTPUT {
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

VS_SNOW_OUTPUT VS_Snow(VS_SNOW_INPUT v)
{
  VS_SNOW_OUTPUT o;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  o.cDiff = v.cDiff;
  
  //float fDist = distance(v.vPos, vWorldCamera);
  //float fDDD = min(fDist, 1500.0f) / 1500.0f;
  //float fTimeScale = lerp(7.0f, 0.7f, fDDD);
  
  //float fPhase = fmod(fTime / fTimeScale + v.vNormal.x, 1.0f);
  //float fG = step(0.5f, fPhase);	//fG = 1 if fPhase > 0.5f
  //float fS = step(fPhase, 0.5f);	//fS = 1 if fPhase <= 0.5f
  
  //float fMin = lerp(0.1f, 0.2f, fDDD);
  //float fMin = lerp(0.65f, 0.78f, fDDD);
  //float fMin = lerp(0.65f, 0.85f, fDDD);
  //float fMin = lerp(0.85f, 0.80f, fDDD);
  //float fMin = lerp(0.85f, 0.79f, fDDD);
  //float fMax = 1.0f;
  //float f = fG * lerp(fMin, fMax, (fPhase - 0.5f) * 2) + fS * lerp(fMax, fMin, fPhase * 2);
  
  o.cWeightMask.r = abs(ceil(v.vNormal.x / 0.25f) - 4.0f) < 0.1;
  o.cWeightMask.g = abs(ceil(v.vNormal.x / 0.25f) - 1.0f) < 0.1;
  o.cWeightMask.b = abs(ceil(v.vNormal.x / 0.25f) - 2.0f) < 0.1;
  o.cWeightMask.a = abs(ceil(v.vNormal.x / 0.25f) - 3.0f) < 0.1;
  //o.cWeightMask.r = 0.0f;
  //o.cWeightMask.g = 0.0f;
  //o.cWeightMask.b = 0.0f;
  //o.cWeightMask.a = 1.0f;
  
  
  //f = min(f, 1.0f);
  //f = 1.0f;
  
  float fDist = distance(v.vPos, vWorldCamera);
  float fDDD = min(fDist, 5000.0f) / 5000.0f;
  float fTimeScale = lerp(1.5f, 0.15f, fDDD);
  
  fTimeScale = min(fTimeScale, 0.8f);

  o.cDiff.a = fTimeScale;
  o.vData.x = v.vNormal.z;
  o.vData.y = 0;
  return o;
}

void PS_Snow(VS_SNOW_OUTPUT In, out half4 cOut: COLOR0)
{
  cOut = tex2D(sBaseMap, In.vTexC);
  //cOut.a = cOut.r;
  
  cOut.a =	cOut.r * In.cWeightMask.r + 
			      cOut.g * In.cWeightMask.g + 
			      cOut.b * In.cWeightMask.b + 
			      cOut.a * In.cWeightMask.a;


  //cOut.a =	cOut.g;
  cOut.rgb = 1.0f;
  cOut.a *= In.cDiff.a;
  

  //half2 hCoord = {1 - cOut.a, In.vData.x};
  //half4 cMask = tex2D(sShaderMap, hCoord);
  
  //cOut.r = ((1.0f - cOut.a) * In.cDiff.r + cOut.a * cMask.r) * fBrightness;
  //cOut.g = ((1.0f - cOut.a) * In.cDiff.g + cOut.a * cMask.g) * fBrightness;
  //cOut.b = ((1.0f - cOut.a) * In.cDiff.b + cOut.a * cMask.b) * fBrightness;
  
  //cOut.r = (1.0f - cOut.a) * In.cDiff.r + cOut.a * cMask.r;
  //cOut.g = (1.0f - cOut.a) * In.cDiff.g + cOut.a * cMask.g;
  //cOut.b = (1.0f - cOut.a) * In.cDiff.b + cOut.a * cMask.b;
  //cOut.rgb = (1.0f - cOut.a) * In.cDiff.rgb + cOut.a * cMask.rgb;
  
			
//cOut.a =	cOut.b * In.cWeightMask.b;
  
  
  //cOut.r = 1.0f;
  //cOut.g = 1.0f;
  //cOut.b = 1.0f;
  
  //cOut.a *= In.cDiff.a;
  //cOut.rgba = 1.0f;
}

technique Snow
<
  string shadername = "Snow";
  int implementation = 0;
  string description = "Snow implementation.";
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
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 1;
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Snow();
    PixelShader = compile ps_2_0 PS_Snow();
  }
}