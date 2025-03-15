// Shield effects shader

#include "Utility.fxh"

// Supported maps:
texture BaseMap  <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;
texture EnvMap   <string NTM = "shader"; int NTMIndex = 0; string name = "";>;
texture NoiseMap <string NTM = "shader"; int NTMIndex = 2; string name = "";>;
texture CaustMap <string NTM = "shader"; int NTMIndex = 4; string name = ""; string bss_file = "DATA/Textures/CaustVolume.dds";>;

// Transformations:
half4x4  mWorldView      : WORLDVIEW;
float4x4 mWorldViewProj  : WORLDVIEWPROJECTION;
half4x4  mInvWorldTrans  : INVWORLDTRANSPOSE /*WorldInverseTranspose*/;
half4x4  mInvWorld       : INVWORLD;
half4x4  mWorldTrans     : WORLDTRANSPOSE;
half4x4  mInvView        : INVVIEW;

float fTime              : ATTRIBUTE <bool hidden = true;> = 0.0;

// Shield parameters
float3  vShieldOrigin    : ATTRIBUTE <bool hidden = true;> = { 0, 0, 0 };
half3   vShieldDirection : ATTRIBUTE <bool hidden = true;> = { 0, 0, 1 };

struct VS_INPUT {
  float4 vPos: POSITION;
  half2  vTexC: TEXCOORD;
};

struct VS_OUTPUT_SHIELD {
  float4 vPos: POSITION;
  half3  vTexCAlpha: TEXCOORD;
  half   fFog: FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

float Log(float fBase, float fExp)
{
  return log(fExp) / log(fBase);
}

VS_OUTPUT_SHIELD VS_Shield(VS_INPUT v)
{
  VS_OUTPUT_SHIELD o;
  float3 vWorld;
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexCAlpha.xy = v.vTexC.xy;
  vWorld = mul(v.vPos, mWorld);
  o.vTexCAlpha.z = saturate(dot((half3) normalize((float3) vWorld - (float3) vShieldOrigin), vShieldDirection));
  float fShin;
  fShin = lerp(Log(10, 500), Log(10, fShininess), (cos(2 * PI * fTime * 3.5) + 1) / 2);
  fShin = pow(10, fShin);
  o.vTexCAlpha.z = pow(o.vTexCAlpha.z, fShin);
  o.fFog = CalcFog(length(mul(v.vPos, mWorldView)), fNearPlane, fFogFarPlane, fFogDepth);
  return o;
}

VS_OUTPUT_SHIELD VS_Shield_Appear(VS_INPUT v)
{
  VS_OUTPUT_SHIELD o;
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexCAlpha.xy = v.vTexC.xy;
  float3 vDelta = mul(v.vPos, mWorld) - vShieldOrigin;
  half fAngle = asin(normalize(vDelta).z);
/*  half fRef = PI / 4; //fTime / 10.0 * PI;
  fAngle = min(abs(fAngle - fRef), PI / 16) / (PI / 16);
  o.vTexCAlpha.z = lerp(1, 0.0, fAngle);
*/  
  o.vTexCAlpha.z = fAngle;
//  o.vTexCAlpha.z = 1.0f;

  o.fFog = CalcFog(length(mul(v.vPos, mWorldView)), fNearPlane, fFogFarPlane, fFogDepth);
  return o;
}


VS_OUTPUT_SHIELD VS_Shield_OnHit(VS_INPUT v)
{
  VS_OUTPUT_SHIELD o;
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexCAlpha.xy = v.vTexC.xy;
  float3 vDelta = mul(v.vPos, mWorld) - vShieldOrigin;
  //vDelta = normalize(vDelta);
  half fAngle = acos(dot(normalize(vDelta), normalize(vShieldDirection)));
  //half fAngle = asin(normalize(vDelta).z);
/*  half fRef = PI / 4; //fTime / 10.0 * PI;
  fAngle = min(abs(fAngle - fRef), PI / 16) / (PI / 16);
  o.vTexCAlpha.z = lerp(1, 0.0, fAngle);
*/  
  //half fAngle1 = asin(normalize(vDelta).z);
  //o.vTexCAlpha.z = max(fAngle, fAngle1);
  o.vTexCAlpha.z = 1 - fAngle;
//  o.vTexCAlpha.z = 1.0f;

  o.fFog = CalcFog(length(mul(v.vPos, mWorldView)), fNearPlane, fFogFarPlane, fFogDepth);
  return o;
}



sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = wrap; AddressV = wrap;
};

samplerCUBE sEnv = sampler_state
{
  texture = <EnvMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp; AddressW = clamp;
};

sampler2D sNoise = sampler_state
{
  texture = <NoiseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = wrap; AddressV = wrap;
};

sampler3D sCaust = sampler_state
{
  texture = <CaustMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = Wrap; AddressV = Wrap; AddressW = Wrap;
};

half4 SampleCaust(half2 vCoord)
{
  return tex3D(sCaust, half3(vCoord, fTime));
}

texture SinCosMap <string function = "GenSinCos"; int width = 512; int height = 16;>;
sampler2D sSinCos = sampler_state
{
  texture = <SinCosMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = Wrap; AddressV = Clamp;
};

float4 GenSinCos(in float4 iPos: TEXCOORD): COLOR
{
  float4 cRes;
  sincos(iPos.x * PI * 2, cRes.x, cRes.y);
  cRes.xy = cRes.xy / 2 + 0.5;
  cRes.z = iPos.z;
  cRes.w = 1;
  return cRes;
}

#define TEXGEN(ps) TEXGEN_TECH(_TexGen_##ps,ps)

TEXGEN(GenSinCos)


half4 PS_Shield(half3 vTexCAlpha: TEXCOORD): COLOR
{
  half4 cColor;
  half4 cCaust;
  half2 vSinCos;

  //sincos(fTime * PI * 2, vSinCos.x, vSinCos.y);
  sincos(0 * PI * 2, vSinCos.x, vSinCos.y);
// uncomment the following line to use a texture shader texture  
  //vSinCos = tex2D(sSinCos, float4(fTime, 0.5, 0, 1)) * 2 - 1;
  cCaust = SampleCaust(vTexCAlpha.xy/* + vSinCos.yx*/ - vSinCos.xy);
  //cColor.rgb = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
//  cColor.a = /*smoothstep(0, 0.5, cCaust.r)*/ cCaust.r;// / 2 + 0.5;
  //cColor.a = cCaust.r;
  cColor = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  cColor.a *= vTexCAlpha.z;
  //cColor.a = max(cColor.a, 0.01);
//  cColor.a = lerp(0.2, 1, cColor.a);
  
  return cColor;
}

half4 PS_Shield_Appear(half3 vTexCAlpha: TEXCOORD): COLOR
{
  half4 cColor;
  half4 cCaust;
  half2 vSinCos;

  sincos(fTime * PI * 2, vSinCos.x, vSinCos.y);
  cCaust = SampleCaust(vTexCAlpha.xy - vSinCos.xy);
  //cColor.rgb = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  //cColor.a = cCaust.r;
  cColor = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  
  half fT = frac(6 * fTime);
  half fRef = (1 - (fT * 3) * 2) * PI / 2;
  fRef = min(vTexCAlpha.z - fRef, PI / 16) / (PI / 16);
  fRef *= /*1 - fT;*/ min(1, -3/2 * fT + 3/2);
  
  cColor.a *= fRef;
  
  
  
  return cColor;
}

half4 PS_Shield_Idle(half3 vTexCAlpha: TEXCOORD): COLOR
{
  half4 cColor;
  half4 cCaust;
  half2 vSinCos;

  sincos(fTime * PI * 2, vSinCos.x, vSinCos.y);
  //sincos(0 * PI * 2, vSinCos.x, vSinCos.y);
  cCaust = SampleCaust(vTexCAlpha.xy - vSinCos.xy);
  //cColor.argb = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  //cColor.a = cCaust.r;
  cColor = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  
  half fT = frac(7 * fTime);
  half fRef = (1 - fT * 2) * PI / 2;
  fRef = min(abs(vTexCAlpha.z - fRef), PI / 10) / (PI / 10);  
  fRef = 1 - fRef;
  
  cColor.a *= fRef;
  
  return cColor;
}


half4 PS_Shield_OnHit(half3 vTexCAlpha: TEXCOORD): COLOR
{
  half4 cColor;
  half4 cCaust;
  half2 vSinCos;

  sincos(fTime * PI * 2, vSinCos.x, vSinCos.y);
  //sincos(0 * PI * 2, vSinCos.x, vSinCos.y);
  //cCaust = SampleCaust(vTexCAlpha.xy - vSinCos.xy);
  //cColor.argb = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  //cColor.a = cCaust.r;
  cColor = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  
  half fT = frac(7 * fTime);
  half fRef = (1 - fT * 2) * PI / 2;
  fRef = min(abs(vTexCAlpha.z - fRef), PI / 10) / (PI / 10);  
  fRef = abs(vTexCAlpha.z - fRef);
  fRef = 1 - fRef;
  
  cColor.a *= max(0, fRef - frac(fTime));
  //cColor.a *= max(0, vTexCAlpha.z - (1 - fT));
  
  return cColor;
}

half4 PS_Shield_Disappear(half3 vTexCAlpha: TEXCOORD): COLOR
{
  half4 cColor;
  half4 cCaust;
  half2 vSinCos;

  sincos(fTime * PI * 2, vSinCos.x, vSinCos.y);
  cCaust = SampleCaust(vTexCAlpha.xy - vSinCos.xy);
  //cColor.argb = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  //cColor.a = cCaust.r;
  cColor = tex2D(sBase, vTexCAlpha.xy + vSinCos.xy);// * fBrightness;
  
  half fT, fRef;
  fT = frac(4 * fTime);
  fRef = (1/2 - fT) * 2/2 * 2 * PI + PI;
  fRef = min(fRef - vTexCAlpha.z, PI / 16) / (PI / 16);
  fRef *= min(1, 2 * fT);
  
  cColor.a *= fRef;
  
  return cColor;
}

technique _Effect_Shield
<
  string shadername = "_Effect_Shield";
  int implementation = 0;
  string description = "Shield effect shader.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool DoubleSided = true;
  bool bPublic = true;
>
{
  pass P0
  {
    CullMode = None;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = one;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Shield();
    PixelShader = compile ps_2_0 PS_Shield();
  }
}

technique _Effect_Shield_Appear
<
  string shadername = "_Effect_Shield_Appear";
  int implementation = 0;
  string description = "Shield appearing effect shader.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = one;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Shield_Appear();
    PixelShader = compile ps_2_0 PS_Shield_Appear();
  }
}

technique _Effect_Shield_Idle
<
  string shadername = "_Effect_Shield_Idle";
  int implementation = 0;
  string description = "Shield idle effect shader.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = one;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Shield_Appear();
    PixelShader = compile ps_2_0 PS_Shield_Idle();
  }
}

technique _Effect_Shield_Disappear
<
  string shadername = "_Effect_Shield_Disappear";
  int implementation = 0;
  string description = "Shield disappearing effect shader.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = one;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Shield_Appear();
    PixelShader = compile ps_2_0 PS_Shield_Disappear();
  }
}

technique _Effect_Shield_OnHit
<
  string shadername = "_Effect_Shield_OnHit";
  int implementation = 0;
  string description = "Shield idle effect shader.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = one;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Shield_OnHit();
    PixelShader = compile ps_2_0 PS_Shield_OnHit();
  }
}