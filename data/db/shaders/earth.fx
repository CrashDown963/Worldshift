// Earth shaders

#include "Utility.fxh"


// Supported maps:
texture BaseMap      <string NTM = "base";   int NTMIndex = 0;>;
texture NormalMap    <string NTM = "bump";   int NTMIndex = 0;>;
texture MaskMap      <string NTM = "shader"; int NTMIndex = 3;>;
texture EnvMap       <string NTM = "shader";>;
texture BaseMap2     <string NTM = "shader"; int NTMIndex = 5;>;
texture SelBaseMap   <string NTM = "detail";>;
texture ZoneMap      <string NTM = "dark";>;


// Transformations:
half4x4   mWorldView     : WORLDVIEW;
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
half4x4   mInvWorldTrans : INVWORLDTRANSPOSE;

float4 vSelZone          : GLOBAL = {0,  0,  0, 0};


float4 cSelClr          :  GLOBAL = {1,  1,  1, 1};


struct VS_INPUT {
  float4 vPos : POSITION;
  half2  vTexC: TEXCOORD;
  half3  vNorm: NORMAL; 
  half3  vBin : BINORMAL; 
  half3  vTan : TANGENT; 
};

struct VS_OUTPUT {
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half3   cLight   : TEXCOORD1;
  float3  vHalfPos : TEXCOORD3;
  half3x3 mTan     : TEXCOORD4;
  half    fFog     : FOG;
};

struct VS_OUTPUT_ALPHATEST {
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half4   cLight   : TEXCOORD1;
  half    fFog     : FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

#define TRANSITION_MULTIPLIER    4

VS_OUTPUT VS_Earth(VS_INPUT v, uniform bool bPosition)
{
  VS_OUTPUT o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  float3 vWorld = mul(v.vPos, mWorld);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition) 
    o.vHalfPos = vWorld;
  else 
    o.vHalfPos = vHalf;

//  v.vNorm = normalize(v.vPos);

  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans, true);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));

  return o;
}

half4 CalcAmbDiffEarth(half3 cAmbColor, half4 cDiffColor, 
                       half3 cAmbLight, half3 cDiffLight, half4 cTexel,
                       half fBacklightStrength, half3 vNorm, half3 vLight, half fShadow=1)
{
  half fNdotL = dot(vNorm, vLight);
  half4 cRes;
  
  fNdotL *= TRANSITION_MULTIPLIER;
  cRes.rgb = CalcBacklightMultiplier(fBacklightStrength, fNdotL) * cAmbColor * cAmbLight;
  cRes.rgb += cDiffColor * cDiffLight * saturate(fNdotL) * fShadow;
  cRes.rgb *= cTexel.rgb;
  cRes.a = cDiffColor.a;
  
  return cRes;
}

VS_OUTPUT_ALPHATEST VS_Earth_Clouds(VS_INPUT v)
{
  VS_OUTPUT_ALPHATEST o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  float3 vWorld = mul(v.vPos, mWorld);

  float3 vNorm;
  vNorm = normalize((float3) mul(v.vNorm, mInvWorldTrans));  
  
  o.cLight = CalcAmbDiffEarth(cMa, cMd, 
                              cAmbientLight, cSunColor, 1,
                              fBacklightStrength, vNorm, vSunDirection, 1);
  o.cLight.rgb += CalcAdditionalLights(vWorld, vNorm);
  
  o.cLight.a *= SlopedStep(0.95, 0.6, 1 - abs(dot(vNorm, normalize(vWorldCamera - vWorld))));
//  o.cLight.rgb = o.cLight.a;

  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

VS_OUTPUT_ALPHATEST VS_Earth_Grid(VS_INPUT v)
{
  VS_OUTPUT_ALPHATEST o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  float3 vWorld = mul(v.vPos, mWorld);

  float3 vNorm;
  vNorm = normalize((float3) mul(v.vNorm, mInvWorldTrans));  
  
  o.cLight = half4(cMe, cMd.a);
  
  o.cLight.a *= SlopedStep(0.3, 1, 1 - abs(dot(vNorm, normalize(vWorldCamera - vWorld))));
  o.cLight.a *= SlopedStep(0.95, 0.6, 1 - abs(dot(vNorm, normalize(vWorldCamera - vWorld))));  
//  o.cLight.rgb = o.cLight.a;

  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

void VS_Earth_Sky(in  float4 vInPos  : POSITION,
                  in  half2  vInTexC : TEXCOORD,
                  out float4 vOutPos : POSITION,
                  out half2  vOutTexC: TEXCOORD,
                  out half   fOutFog : FOG)
{
  vOutPos = mul(vInPos, mWorldViewProj);
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);
  fOutFog = 1.0;
}


sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};

sampler2D sMask = sampler_state
{
  texture = <MaskMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Point;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};

sampler2D sBase2 = sampler_state
{
  texture = <BaseMap2>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};

sampler2D sSelBase = sampler_state
{
  texture = <SelBaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};


sampler2D sZone = sampler_state
{
  texture = <ZoneMap>;
  MinFilter = Point; MagFilter = Point; MipFilter = None;
  RESET_BIAS;  
  //MaxAnisotropy = <iMaxAnisotropy>;
  AddressU = clamp; AddressV = clamp;
};


sampler2D sBaseWrap = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = wrap; AddressV = wrap;
};


sampler2D sNormal = sampler_state
{
  texture = <NormalMap>;
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

half4 CalcAmbDiffSpecEarth(half3 cAmbColor, half4 cDiffColor, half3 cSpecColor, half fSpecPower, 
                           half3 cAmbLight, half3 cDiffLight, half3 cSpecLight, half4 cTexel,
                           half fBacklightStrength, half3 vHalf, half3 vNorm, half3 vLight, half fShadow=1)
{
  half fNdotL;
  half4 cRes;
  // Only calculate backlight specular on highest detail level
  
  fNdotL = dot(vNorm, vLight);
  fNdotL = TRANSITION_MULTIPLIER * fNdotL;

  cRes.rgb = cAmbColor * cAmbLight;
  cRes.rgb *= CalcBacklightMultiplier(fBacklightStrength, fNdotL);
  cRes.rgb += cDiffColor * cDiffLight * saturate(fNdotL) * fShadow;
  cRes.rgb *= cTexel.rgb;
#if _COMPILE_PIXEL_SPECULAR_ == 1
  half fSpec = pow(saturate(dot(vNorm, vHalf)), fSpecPower) * saturate(4 * fNdotL);
  // The parentheses on the next line are VERY important. Without them the calculation becomes a vector one and bugs.
  cRes.rgb += cSpecColor * cSpecLight * (fSpec * cTexel.a * fShadow);
#if _COMPILE_CAMERA_SPECULAR_ == 1
  half fSpec1;
  half3 vHalf1 = normalize(-cross(vHalf, cross(vLight, vHalf)));
  fSpec1 = pow(saturate(dot(vNorm, vHalf1)), fSpecPower) * saturate(-4 * fNdotL) * fBacklightStrength;
  cRes.rgb += cSpecColor * cAmbLight * (fSpec1 * cTexel.a);
#endif
#endif
  cRes.a = cDiffColor.a;
  
  return cRes;
}


PS_OUTPUT PS_Earth(VS_OUTPUT p, uniform bool bExplicitFog)
{
  PS_OUTPUT o;
  half4 cPix, cPix2;
  half4 vNorm;
//  int bZone = 0;
//  float3 cZone = tex2D(sZone, p.vTexC);
//  if(abs(cZone.r - vSelZone.x) < 0.01f && abs(cZone.g - vSelZone.y) < 0.01f && abs(cZone.b - vSelZone.z) < 0.01f)
//    bZone = 1;

  cPix = tex2D(sBase, p.vTexC);
//  cPix2 = tex2D(sSelBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  half4 cMask = tex2D(sMask, p.vTexC);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));

  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                                  cAmbientLight, cSunColor, cSunSpecColor, cPix,
                                  fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, 1);
                                  
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), 1);
  o.cColor.rgb += DecodeLight(p.cLight, cPix, 1);
  
  o.cColor.rgb = lerp(o.cColor.rgb, cPix, cMask.r);

//  half3 cColorize;
//  cColorize.g = 0.686;
//  cColorize.b = 0.98;
//  cColorize.r = 0.3922;
  
//  if(bZone == 1)   
  //o.cColor.rgb = 1;
//  o.cColor.rgb = lerp(o.cColor.rgb, cColorize.rgb, cPix2.r);
  
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);    
    
  return o;
}

/*
PS_OUTPUT PS_Earth(VS_OUTPUT p, uniform bool bExplicitFog)
{
  PS_OUTPUT o;
  half4 cPix, cPix2;
  half4 vNorm;
  int bZone = 0;
  float3 cZone = tex2D(sZone, p.vTexC);
  if(abs(cZone.r - vSelZone.x) < 0.01f && abs(cZone.g - vSelZone.y) < 0.01f && abs(cZone.b - vSelZone.z) < 0.01f)
  {
    bZone = 1;
    cPix = tex2D(sSelBase, p.vTexC);
  }
  else
    cPix = tex2D(sBase, p.vTexC);
  //cPix.rgb = cZone.rgb;
  cPix2 = tex2D(sBase2, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));

  float fBaseAlpha = dot(vSunDirection, vNorm.xyz);
  fBaseAlpha *= -TRANSITION_MULTIPLIER;
  fBaseAlpha = saturate(fBaseAlpha);
  
//  fBaseAlpha = SlopedStep(0.5 + 0.1, 0.5 - 0.1, fBaseAlpha);
  if(bZone == 0)
  cPix.rgb = lerp(cPix.rgb, cPix2.rgb, fBaseAlpha);

  if(bZone == 0) {
    o.cColor = CalcAmbDiffSpecEarth(cMa, cMd, cMs, fShininess, 
                                  cAmbientLight, cSunColor, cSunSpecColor, cPix,
                                  fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, 1);
    OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), 1);                                  
  } else
    o.cColor = cPix;                                  

  o.cColor.rgb += cMe * fBaseAlpha * cPix2.a * cPix.rgb;                            

  o.cColor.rgb += DecodeLight(p.cLight, cPix, 1);
  
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);    
    
  return o;
}
*/
/*
PS_OUTPUT PS_Earth(VS_OUTPUT p, uniform bool bExplicitFog)
{
  PS_OUTPUT o;
  half4 cPix, cPix2;
  half4 vNorm;
  cPix = tex2D(sBase, p.vTexC);
  cPix2 = tex2D(sBase2, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));

  float fBaseAlpha = dot(vSunDirection, vNorm.xyz);
  fBaseAlpha *= -TRANSITION_MULTIPLIER;
  fBaseAlpha = saturate(fBaseAlpha); //  / 2 + 0.5
//  fBaseAlpha = SlopedStep(0.5 + 0.1, 0.5 - 0.1, fBaseAlpha);
  
  cPix.rgb = lerp(cPix.rgb, cPix2.rgb, fBaseAlpha);

  o.cColor = CalcAmbDiffSpecEarth(cMa, cMd, cMs, fShininess, 
                                  cAmbientLight, cSunColor, cSunSpecColor, cPix,
                                  fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, 1);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), 1);
  o.cColor.rgb += cMe * fBaseAlpha * cPix2.a * cPix.rgb;                            

  o.cColor.rgb += DecodeLight(p.cLight, cPix, 1);
  
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);    
    
  return o;
}
*/

PS_OUTPUT PS_Earth_Clouds(VS_OUTPUT_ALPHATEST p, uniform bool bExplicitFog)
{
  PS_OUTPUT o;
  half4 cPix;
  cPix = tex2D(sBaseWrap, p.vTexC);

  o.cColor = p.cLight * cPix;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
      
  return o;
}

PS_OUTPUT PS_Earth_Grid(VS_OUTPUT_ALPHATEST p, uniform bool bExplicitFog)
{
  PS_OUTPUT o;
  half4 cPix;
  cPix = tex2D(sBaseWrap, p.vTexC);

  o.cColor.rgb = p.cLight.rgb * cPix.rgb;
  o.cColor.a = pow(p.cLight.a, lerp(1, 0.4, cPix.a)) * cPix.a;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
      
  return o;
}

void PS_Earth_Sky(in  half2  vInTexC  : TEXCOORD,
                  out half4  cOutColor: COLOR)
{
  half4 cPix;
  cPix = tex2D(sBaseWrap, vInTexC);
  cOutColor = cPix * half4(cMe, cMd.a);
}

technique _Earth
<
  string description = "Planet earth shader with base texture, normal map and specular. Alpha in the base map is gloss mask.";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    AlphaTestEnable = false;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    CullMode = CW;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = true;
    ZFunc = LESSEQUAL;
//    ZFunc = NEVER;
    ZWriteEnable = true;
    
    VertexShader = compile _VS2X_ VS_Earth(false);
    PixelShader = compile _PS2X_ PS_Earth(false);
  }
}

technique _Earth_Clouds
<
  string description = "Earth cloud cover shader with base texture, diffuse lighting and translucency. Alpha in the base map is transparency (alpha blend).";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = true;
  bool ImplicitAlpha = true;
  bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaRef = 0;
    AlphaFunc = greater;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = true;
    ZFunc = LESSEQUAL;
//    ZFunc = NEVER;
    ZWriteEnable = false;
    
    VertexShader = compile _VS2X_ VS_Earth_Clouds();
    PixelShader = compile _PS2X_ PS_Earth_Clouds(false);
  }
}

technique _Earth_Grid
<
  string description = "Earth grid shader with base texture and translucency. Alpha in the base map is transparency (alpha blend).";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = true;
  bool ImplicitAlpha = true;
  bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaRef = 0;
    AlphaFunc = greater;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
    
    VertexShader = compile _VS2X_ VS_Earth_Grid();
    PixelShader = compile _PS2X_ PS_Earth_Grid(false);
  }
}

technique _Earth_Sky
<
  string description = "Earth sky shader with base texture and emissive lighting.";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    AlphaTestEnable = false;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    CullMode = CW;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = true;
    ZFunc = LESSEQUAL;
//    ZFunc = NEVER;
    ZWriteEnable = true;
    
    VertexShader = compile _VS2X_ VS_Earth_Sky();
    PixelShader = compile _PS2X_ PS_Earth_Sky();
  }
}