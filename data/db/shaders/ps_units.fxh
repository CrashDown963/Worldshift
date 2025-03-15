#ifndef __PS_UNITS_FXH
#define __PS_UNITS_FXH

// Units pixel shaders include file

#include "Utility.fxh"

// Supported maps:
texture BaseMap      <string NTM = "base";   int NTMIndex = 0;>;
texture NormalMap    <string NTM = "bump";   int NTMIndex = 0;>;
texture EnvMap       <string NTM = "shader";>;
texture ShadowMap    <string NTM = "shader"; int NTMIndex = 1; bool hidden = true;>;
texture MaskMap      <string NTM = "shader"; int NTMIndex = 3;>;
texture OcclusionMap <string NTM = "shader"; int NTMIndex = 6; bool hidden = true;>;
//texture AlphaBldMap  <string NTM = "shader"; int NTMIndex = 4;>;
texture AlphaBldMap  <string NTM = "decal";  int NTMIndex = 0;>;

// Colorization: 
half3 cColorization     : ATTRIBUTE <bool color = true;> = { 0.5f, 0.5f, 0.5f }; 

// Alpha to blend material emissive color into texture color before applying as emissive color
half fGlowAlpha         : ATTRIBUTE = 0.5f;
half fGlowPower         : ATTRIBUTE = 1.0f;
half fFogOfWar          : ATTRIBUTE <bool hidden = true;> = 1.0f;

struct VS_OUTPUT {
  float4  vPos     : POSITION;
  half3   cLights  : COLOR1;
  half2   vTexC    : TEXCOORD;
  half3   vVOC     : TEXCOORD1;
  float3  vHalfPos : TEXCOORD2;
  half3x3 mTan     : TEXCOORD3;
  float4  vShaC    : TEXCOORD6;  //.z - lightspace z;   .xyw - in warped post light space
  half    fFog     : FOG;
};

struct VS_VALPHA_OUTPUT {
  float4  vPos     : POSITION;
  half4   cVColor  : COLOR0;
  half3   cLights  : COLOR1;
  half2   vTexC    : TEXCOORD;
  half3   vVOC     : TEXCOORD1;
  float3  vHalfPos : TEXCOORD2;
  half3x3 mTan     : TEXCOORD3;
  float4  vShaC    : TEXCOORD6;  //.z - lightspace z;   .xyw - in warped post light space
  half    fFog     : FOG;
};

struct VS_ITEM_OUTPUT {
  float4  vPos     : POSITION;
  half4   vTexC    : TEXCOORD; // .xy - diffuse map, .zw - normal map
  half3   cLight   : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  half3x3 mTan     : TEXCOORD4;
  float4  vShaC    : TEXCOORD7;
  half    fFog     : FOG;
};

struct VS_BLD_OUTPUT {
  float4  vPos     : POSITION;
  half3   cLights  : COLOR1;
  half4   vTexC    : TEXCOORD;  // .xy - diffuse map, .zw - dark map
  half3   vVOC     : TEXCOORD1;
  float3  vHalfPos : TEXCOORD2;
  half3x3 mTan     : TEXCOORD3;
  float4  vShaC    : TEXCOORD6;  //.z - lightspace z;   .xyw - in warped post light space
  half    fFog     : FOG;
};


struct VS_BLD_BUILD_OUTPUT {
  float4  vPos     : POSITION;
  half3   cLights  : COLOR1;
  half4   vTexC    : TEXCOORD;  // .xy - diffuse map, .zw - dark map
  half3   vVOC     : TEXCOORD1;
  float3  vHalfPos : TEXCOORD2;
  half3x3 mTan     : TEXCOORD3;
  float4  vShaC    : TEXCOORD6;  //.z - lightspace z;   .xyw - in warped post light space
  half2   vAlphaBldTexC : TEXCOORD7;
  half    fFog     : FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};

samplerCUBE sEnv = sampler_state
{
  texture = <EnvMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp; AddressW = clamp;
};

sampler2D sMask = sampler_state
{
  texture = <MaskMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Point;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};

sampler2D sNormal = sampler_state
{
  texture = <NormalMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};

sampler2D sShadowMap = sampler_state
{
  texture = <ShadowMap>;
  SHADOW_SAMPLER_STATES;
};

sampler2D sOcclusion = sampler_state
{
  texture = <OcclusionMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp; AddressW = clamp;
};

sampler2D sAlphaBldMask = sampler_state
{
  texture = <AlphaBldMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};

PS_OUTPUT PS_Units(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
//  vNorm = vNorm.agbr;
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    //fVO *= CalcShadowShadowBufferPCF(sShadowMap, p.vShaC.xy, p.vShaC.z);
  cPix.rgb = lerp(cPix.rgb, cColorization, vNorm.a);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  if (bGlow) {
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a * fGlowPower);
  }
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
    
  return o;
}

PS_OUTPUT PS_Units_Mask(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm, cMask;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  cMask = tex2D(sMask, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
  if (bPlayerColor)    
    cPix.rgb = lerp(cPix.rgb, cColorization, cMask.a);
  vNorm.xyz = FixNorm(vNorm.xyz);
  vNorm.xyz = normalize(mul(vNorm.xyz, p.mTan));
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);                             
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  if (bOpacityMask)
    o.cColor.a *= cMask.g;
  if (bGlow)
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, cMask.r * fGlowPower);
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}


PS_OUTPUT PS_Units_VAlpha_Mask(VS_VALPHA_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm, cMask;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  cMask = tex2D(sMask, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
  if (bPlayerColor)    
    cPix.rgb = lerp(cPix.rgb, cColorization, cMask.a);
  vNorm.xyz = FixNorm(vNorm.xyz);
  vNorm.xyz = normalize(mul(vNorm.xyz, p.mTan));
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);                             
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  //if (bOpacityMask)
  o.cColor.a *= p.cVColor.a;
  if (bGlow)
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, cMask.r * fGlowPower);
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

PS_OUTPUT PS_Units_Mirror(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm, cMask;
  half3 vHalf, cEnv;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  cMask = tex2D(sMask, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
  if (bPlayerColor)    
    cPix.rgb = lerp(cPix.rgb, cColorization, cMask.a);
  vNorm.xyz = FixNorm(vNorm.xyz);
  vNorm.xyz = normalize(mul(vNorm.xyz, p.mTan));
  vHalf = CalcHalfway(p.vHalfPos, vSunDirection, vWorldCamera);
  cEnv = GetEnvironmentColor(sEnv, p.vHalfPos, vNorm, vWorldCamera, cMs);
  cPix.rgb = lerp(cPix, half3(1, 1, 1), 0.5);
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, vHalf, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  o.cColor.rgb += cEnv;
  if (bOpacityMask)
    o.cColor.a *= cMask.g;
  if (bGlow)
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, cMask.r * fGlowPower);
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

PS_OUTPUT PS_Bld(VS_BLD_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm, cMask, cDarkMask;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.xy);
  cMask = tex2D(sMask, p.vTexC.xy);
  cDarkMask = tex2D(sMask, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
  if (bPlayerColor)    
    cPix.rgb = lerp(cPix.rgb, cColorization, cMask.a);
  vNorm.xyz = FixNorm(vNorm.xyz);
  vNorm.xyz = normalize(mul(vNorm.xyz, p.mTan));
  //cPix.rgb *= cDarkMask.b;
  cPix.rgb *= cDarkMask.b + cMask.r - (cMask.r*cDarkMask.b);
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO/* * cDarkMask.b*/);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);                             
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  if (bOpacityMask)
    o.cColor.a *= cMask.g;
  if (bGlow)
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, cMask.r * fGlowPower);
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar; //saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

PS_OUTPUT PS_Bld_Build(VS_BLD_BUILD_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm, cMask, cDarkMask, cAlphaBldMask;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.xy);
  cMask = tex2D(sMask, p.vTexC.xy);
  cDarkMask = tex2D(sMask, p.vTexC.zw);
  cAlphaBldMask = tex2D(sAlphaBldMask, p.vAlphaBldTexC.xy);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
  if (bPlayerColor)    
    cPix.rgb = lerp(cPix.rgb, cColorization, cMask.a);
  vNorm.xyz = FixNorm(vNorm.xyz);
  vNorm.xyz = normalize(mul(vNorm.xyz, p.mTan));
  //cPix.rgb *= cDarkMask.b;
  cPix.rgb *= cDarkMask.b + cMask.r - (cMask.r*cDarkMask.b);
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO/* * cDarkMask.b*/);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);                             
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  
  o.cColor.a *= cAlphaBldMask.a;
  
  if (bOpacityMask)
    o.cColor.a *= cMask.g;
  if (bGlow)
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, cMask.r * fGlowPower);
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar; //saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

PS_OUTPUT PS_Units_Simple(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
  cPix.rgb = lerp(cPix.rgb, cColorization, vNorm.a);
  vNorm.xyz = normalize(mul(half3(0, 0, 1), p.mTan));
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);                             
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  if (bGlow) {
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a * fGlowPower);
  }
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  return o;
}

PS_OUTPUT PS_Units_Alpha(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    //fVO *= CalcShadowShadowBufferPCF(sShadowMap, p.vShaC.xy, p.vShaC.z);
  cPix.rgb = lerp(cPix.rgb, cColorization, vNorm.a);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, half4(cPix.rgb, 1),
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLights, half4(cPix.rgb, 1), fVO);
  o.cColor.a *= cPix.a;
  if (bGlow) {
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a * fGlowPower);
  }
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

PS_OUTPUT PS_Units_Rimlight(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
  cPix.rgb = lerp(cPix.rgb, cColorization, vNorm.a);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  o.cColor = CalcAmbDiffSpecRim(cMa, cMd, cMs, fShininess, 
                                cAmbientLight, cSunColor, cSunSpecColor, cPix,
                                fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);                                
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  if (bGlow) {
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a * fGlowPower);
  }
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  return o;
}

PS_OUTPUT PS_Units_Env(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  half3 cEnv;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
  if (bPlayerColor)
    cPix.rgb = lerp(cPix.rgb, cColorization, vNorm.a);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  cEnv = GetEnvironmentColor(sEnv, p.vHalfPos, vNorm, vWorldCamera, cMs);
 
  half fNdotL = dot(vSunDirection, vNorm);
  o.cColor.rgb = cAmbientLight * cMa * CalcBacklightMultiplier(fBacklightStrength, fNdotL) +
                 cSunColor * cMd.rgb * saturate(fNdotL) * fVO;
  o.cColor.rgb *= cPix.rgb;
#if _COMPILE_PIXEL_SPECULAR_ == 1  
  half fHdotN = dot(normalize(vSunDirection + vWorldCamera), vNorm);
  o.cColor.rgb += cSunSpecColor * cMs.rgb * pow(saturate(fHdotN), fShininess) * saturate(4 * fNdotL) * fVO * cPix.a;
#endif  
  o.cColor.a = cMd.a;
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLights, cPix, fVO);
  o.cColor = BlendEnvironment(o.cColor, cEnv, cPix.a);
  if (!bPlayerColor)
    o.cColor.a *= vNorm.a;
  if (bGlow) {
    o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a * fGlowPower);
  }
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  return o;
}

PS_OUTPUT PS_Units_Glow(VS_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
  cPix.rgb = lerp(cPix.rgb, cColorization, vNorm.a);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  half fNdotL = dot(vSunDirection, vNorm);
  o.cColor.rgb = cAmbientLight * cMa * CalcBacklightMultiplier(fBacklightStrength, fNdotL) + cSunColor * cMd.rgb * saturate(fNdotL) * fVO;
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLights, half4(cPix.rgb, 0), fVO);
  cPix.a *= fGlowPower;
  o.cColor.a = cMd.a;
  o.cColor = CalcGlow(o.cColor, cPix, cMe, fGlowAlpha);
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

PS_OUTPUT PS_Item(VS_ITEM_OUTPUT p, uniform bool bPlayerColor, uniform bool bGlow, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar, uniform bool bOpacityMask)
{
  PS_OUTPUT o;
  half4 cPix;
  half4 vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));

  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);                             
  o.cColor.rgb += DecodeLight(p.cLight, cPix, fVO);

  o.cColor.rgb = lerp(o.cColor.rgb, cMe * cColorization, vNorm.a);

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);    

  return o;
}

#define UNIT_STATES\
    AlphaBlendEnable = false;\
    AlphaTestEnable = false;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = <iFaction > 0>;\
    TwoSidedStencilMode = false;\
    StencilFail = REPLACE;\
    StencilPass = REPLACE;\
    StencilZFail = KEEP;\
    StencilFunc = ALWAYS;\
    StencilMask = 0x0f;\
    StencilWriteMask = 0x0f;\
    StencilRef = <iFaction>;\
    FogEnable = true;\
    CullMode = CW;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define UNIT_STATES_NOSTENCIL\
    AlphaBlendEnable = false;\
    AlphaTestEnable = false;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = false;\
    FogEnable = true;\
    CullMode = CW;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define UNIT_ALPHA_STATES_NOSTENCIL\
    AlphaBlendEnable = true;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = false;\
    FogEnable = true;\
    CullMode = CW;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define UNIT_ALPHA_STATES\
    AlphaBlendEnable = true;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = <iFaction > 0>; \
    TwoSidedStencilMode = false;\
    StencilFail = REPLACE;\
    StencilPass = REPLACE;\
    StencilZFail = KEEP;\
    StencilFunc = ALWAYS;\
    StencilMask = 0x0f;\
    StencilWriteMask = 0x0f;\
    StencilRef = <iFaction>;\
    FogEnable = true;\
    /*CullMode = NONE;*/\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define UNIT_TEST_STATES\
    AlphaBlendEnable = false;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = <iFaction > 0>; \
    TwoSidedStencilMode = false;\
    StencilFail = REPLACE;\
    StencilPass = REPLACE;\
    StencilZFail = KEEP;\
    StencilFunc = ALWAYS;\
    StencilMask = 0x0f;\
    StencilWriteMask = 0x0f;\
    StencilRef = <iFaction>;\
    FogEnable = true;\
    /*CullMode = NONE;*/\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true


#define BLD_STATES\
    AlphaBlendEnable = false;\
    AlphaTestEnable = false;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = false;\
    FogEnable = true;\
    CullMode = CW;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define BLD_ALPHA_STATES\
    AlphaBlendEnable = true;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = false; \
    FogEnable = true;\
    /*CullMode = NONE;*/\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define BLD_TEST_STATES\
    AlphaBlendEnable = false;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = false; \
    FogEnable = true;\
    /*CullMode = NONE;*/\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true


#define ITEM_STATES\
		AlphaBlendEnable = false;\
		AlphaTestEnable = false;\
		ColorWriteEnable = RED|GREEN|BLUE|ALPHA;\
		DitherEnable = true;\
		CullMode = CW;\
		StencilEnable = <!!iOccluder>;\
		TwoSidedStencilMode = false;\
		StencilFail = KEEP;\
		StencilPass = REPLACE;\
		StencilZFail = KEEP;\
		StencilFunc = ALWAYS;\
		StencilMask = 0x10;\
		StencilWriteMask = 0x10;\
		StencilRef = 0x10;\
		FogEnable = true;\
		ZEnable = true;\
		ZFunc = LESSEQUAL;\
		ZWriteEnable = true

#endif