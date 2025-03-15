// Embelishments shader

#include "Utility.fxh"

// Supported maps:
texture BaseMap  <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;
texture DarkMap  <string NTM = "dark";>;
texture EnvMap   <string NTM = "shader";>;
texture CaustMap <string NTM = "shader"; int NTMIndex = 4; string bss_file = "DATA/Textures/CaustVolume.dds";>;
texture AlphaMap <string NTM = "bump";>;  // in the normal map slot is the alpha mask texture

// Transformations:
half4x4   mWorldView     : WORLDVIEW;
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
half4x4   mInvWorldTrans : INVWORLDTRANSPOSE /*WorldInverseTranspose*/;
half4x4   mInvWorld      : INVWORLD;
half4x4   mWorldTrans    : WORLDTRANSPOSE;
half4x4   mInvView       : INVVIEW;
float4x4  mViewProj      : VIEWPROJ;


float4    vTrailPoints[64] : ATTRIBUTE;
float4    cColors[8]       : ATTRIBUTE;
float     fWidth           : ATTRIBUTE = 50.0f;
float     fMaxWidth        : ATTRIBUTE = 100.0f;
float     fPoints          : ATTRIBUTE = 0.0f;

struct VS_INPUT {
  float4 vPos  : POSITION;
  half2 vTexC  : TEXCOORD;
  half  fIndex : TEXCOORD1;
};

struct VS_OUTPUT {
  float4 vPos       : POSITION;
  half2  vTexC      : TEXCOORD;
//  half2  vAlphaTexC : TEXCOORD1;
  half4  cColor     : TEXCOORD1;
  half   fFog       : FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

VS_OUTPUT VS_Trail(const VS_INPUT v)
{
  VS_OUTPUT o;
  half3 vPos;
  float3 vX, vY, vZ;
  float fB;
  
  vZ = vTrailPoints[v.fIndex + 1] - vTrailPoints[v.fIndex];
  vX = vWorldCamera - vTrailPoints[v.fIndex]/* + vTrailPoints[v.fIndex + 1]) / 2*/;
  vY = cross(vZ, vX);
//  vX = cross(vY, vZ);
  fB = - dot(vX, vZ) / dot(vZ, vZ);
  vX = vX + fB * vZ;
  vY = normalize(vY) * lerp(fMaxWidth, fWidth, v.fIndex / (fPoints - 1)) / 2;
  vX = normalize(vX);
  o.vPos.xyz = vTrailPoints[v.fIndex] + vX * v.vPos.x + vY * v.vPos.y + vZ * v.vPos.z;
  o.vPos.w = 1;
  vPos = mul(o.vPos, mWorldView);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
//  o.vAlphaTexC = mul(half4(v.vTexC, 0, 1), mTexNormal);
/*  o.vAlphaTexC.y = v.vTexC.y;
  if (v.fIndex < 1)
    o.vAlphaTexC.x = 1;
  else 
    if (v.fIndex > fPoints - 2)
      o.vAlphaTexC.x = 0;
    else 
      o.vAlphaTexC.x = 0.5;
*/
  float fColorInd = vTrailPoints[v.fIndex].w;
  o.cColor = lerp(cColors[fColorInd], cColors[fColorInd + 1], frac(fColorInd));
  o.cColor = o.cColor.rgba * (half4(cMa * cAmbientLight, 0) + cMd * half4(cSunColor, 1) + half4(cMe, 0));
  o.fFog = CalcFog(length(vPos), fNearPlane, fFogFarPlane, fFogDepth);

  return o;
}

sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = 1;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = wrap; AddressV = clamp;
};

/*
sampler2D sAlpha = sampler_state
{
  texture = <AlphaMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};

sampler2D sDark = sampler_state
{
  texture = <DarkMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};

samplerCUBE sEnv = sampler_state
{
  texture = <EnvMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp; AddressW = clamp;
};

sampler3D sCaust = sampler_state
{
  texture = <CaustMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = Wrap; AddressV = Wrap; AddressW = Wrap;
};
*/

PS_OUTPUT PS_Trail(const VS_OUTPUT p)
{
  PS_OUTPUT o;
  half4 cPix, cAlpha;
  
  cPix = tex2D(sBase, p.vTexC);
//  cAlpha = tex2D(sAlpha, p.vAlphaTexC);
  
  o.cColor = cPix * p.cColor /* * cMd * fBrightness*/;
//  o.cColor.a *= cAlpha.r;
  
  return o;
}

technique _Trail
<
  string shadername = "_Trail";
  int implementation = 0;
  string description = "Trail particles billboarding shader with alpha blending";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  //bool DoubleSided = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
>
{
  pass P0
  {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 24;
*/    
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = true;
*/    

    CullMode = none;
  
    VertexShader = compile vs_1_1 VS_Trail();
    PixelShader = compile ps_2_0 PS_Trail();
  }
}
/*
technique _Trail_Additive
<
  string shadername = "_Trail_Additive";
  int implementation = 0;
  string description = "Trail particles billboarding shader with additive blending with alpha";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  //bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = true;
  
    VertexShader = compile vs_1_1 VS_Trail();
    PixelShader = compile ps_2_0 PS_Trail();
  }
}
*/