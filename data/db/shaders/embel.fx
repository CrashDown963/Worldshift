// Embelishments shader

#include "Utility.fxh"


// Supported maps:
texture BaseMap      <string NTM = "base";   int NTMIndex = 0;>;
texture NormalMap    <string NTM = "bump";   int NTMIndex = 0;>;
texture EnvMap       <string NTM = "shader";>;
texture ShadowMap    <string NTM = "shader"; int NTMIndex = 1; bool hidden = true;>;
//texture MaskMap      <string NTM = "shader"; int NTMIndex = 3;>;
texture OcclusionMap <string NTM = "shader"; int NTMIndex = 6; bool hidden = true;>;
texture GlowGradientMap  <string NTM = "shader"; int NTMIndex = 3;>;

// Transformations:
half4x4   mWorldView     : WORLDVIEW;
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
half4x4   mInvWorldTrans : INVWORLDTRANSPOSE;

// Texture transforms:
half4x4   mTexBump       : TEXTRANSFORMBUMP;
half4x4   mTexBumpTrans  : TEXTRANSFORMBUMPTRANSPOSE;

// Alpha to blend material emissive color into texture color before applying as emissive color
half fGlowAlpha         : ATTRIBUTE = 0.5f;
half fGlowPower         : ATTRIBUTE = 1.0f;
half fFogOfWar          : ATTRIBUTE <bool hidden = true;> = 1.0f;
half3 cColorization     : ATTRIBUTE <bool color = true;> = { 1, 1, 1 };   // Used by items shaders
half fFresnelPower      : ATTRIBUTE = 2.0f;

#include "Tint.fxh"


struct VS_INPUT {
  float4 vPos : POSITION;
  half2  vTexC: TEXCOORD;
  half3  vNorm: NORMAL; 
  half3  vBin : BINORMAL; 
  half3  vTan : TANGENT; 
  half4  cColor: COLOR;       //.x -> weight, used for animation
};

struct VS_INPUT_LOD {
  float4 vPos : POSITION;
  half2  vTexC: TEXCOORD;
  half3  vNorm: NORMAL; 
  half4  cColor: COLOR;       //.x -> weight, used for animation
};


struct VS_OUTPUT {
  float4  vPos     : POSITION;
  half4   vTexC    : TEXCOORD; // .xy - diffuse map, .zw - normal map
  half3   cLight   : TEXCOORD1;
  half4   vVOC     : TEXCOORD2;// .w - vertex alpha for high objects
  float3  vHalfPos : TEXCOORD3;
  half3x3 mTan     : TEXCOORD4;
  float4  vShaC    : TEXCOORD7;
  half    fFog     : FOG;
};

struct VS_OUTPUT_LOD {
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half3   vNorm    : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  float4  vShaC    : TEXCOORD4;
  half3   cLight   : TEXCOORD5;
  half    fFog     : FOG;
};


struct VS_OUTPUT_ALPHATEST {
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half3   vNorm    : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  half3   cLight   : TEXCOORD4;
  float4  vShaC    : TEXCOORD7;
  half    fFog     : FOG;
};

struct VS_OUTPUT_ALPHATEST_LOD {
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half3   vNorm    : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  float4  vShaC    : TEXCOORD4;
  half3   cLight   : TEXCOORD5;
  half    fFog     : FOG;
};

struct VS_OUTPUT_WATER {
  float4  vPos     : POSITION;
  half4   cColor   : COLOR;
  half4   vTexC    : TEXCOORD; // .xy - diffuse map, .zw - normal map
  half3   cLight   : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  half3x3 mTan     : TEXCOORD4;
  float4  vShaC    : TEXCOORD7;
  half    fFog     : FOG;
};

struct VS_OUTPUT_CRYSTAL {
  float4  vPos     : POSITION;
  half4   vTexC    : TEXCOORD; // .xy - diffuse map, .zw - normal map
  half3   cLight   : TEXCOORD1; //.w - fresnel info
  half4   vVOC     : TEXCOORD2;// .w - vertex alpha for high objects
  float3  vHalfPos : TEXCOORD3;
  half3x3 mTan     : TEXCOORD4;
  float4  vShaC    : TEXCOORD7;
  half    fFog     : FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};


#define HO_start_blending 2500.0f


// Shaders with darkmap assume that the base texture will be tiled/transformed, and the dark map will use the base texture coordinate set without any transformation.

VS_OUTPUT VS_Embel(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT o;
  half3 vHalf;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  
  o.vTexC.xy = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.vTexC.zw = v.vTexC;
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC.xyz = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  o.vVOC.w = 0;
  vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans, true);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  return o;
}

VS_OUTPUT VS_Embel_HO(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  
  o.vTexC.xy = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.vTexC.zw = v.vTexC;
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC.xyz = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  
  half fDistWorld = saturate(distance(vWorld.xy, vWorldCamera.xy) / HO_start_blending);
  half fDistView = ((o.vPos.y / o.vPos.w) + 1.0f) / 2.0f;
  fDistView = saturate(fDistView);
  fDistWorld *= fDistWorld;
  o.vVOC.w = lerp(1, 1.0f - fDistView, 1 - fDistWorld);
  o.vVOC.w *= o.vVOC.w;
  
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans, true);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  //o.fFog = CalcFog(fDistToCamera, fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  return o;
}

VS_OUTPUT_CRYSTAL VS_Embel_Crystal(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_CRYSTAL o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  
  o.vTexC.xy = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.vTexC.zw = v.vTexC;
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC.xyz = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  o.vVOC.w = 0;
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans, true);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight.xyz = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  /*
  float3 vCam;
  half3 vNorm;
  vNorm = v.vNorm;
  vNorm = mul(vNorm, (half3x3) mInvWorldTrans);
  vNorm = normalize(vNorm);
  vCam = normalize(vWorldCamera - vWorld);
  o.cLight.w = saturate(dot(vCam, vNorm));
  //o.cLight.w = lerp(1 - o.cLight.w, o.cLight.w, fInverseFresnel);  
 */   
  return o;
}

VS_OUTPUT_LOD VS_EmbelLOD(VS_INPUT_LOD v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_LOD o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
    
  float3 vv;
  vv.xyz = v.vNorm;  
  
  o.vNorm = mul(vv, mInvWorldTrans);
  o.vNorm = normalize(o.vNorm);
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.vNorm), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.vNorm, vSunDirection));
  CalcVertAmbDiff(o.vNorm, cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.vNorm, vSunDirection);
  
  return o;
}



VS_OUTPUT_ALPHATEST VS_Embel_AlphaTest(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_ALPHATEST o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf; 
  float3 vv;
  vv.xyz = v.vNorm;  
  
  o.vNorm = mul(vv, mInvWorldTrans);
  o.vNorm = normalize(o.vNorm);
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.vNorm), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.vNorm, vSunDirection));
  CalcVertAmbDiff(o.vNorm, cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.vNorm, vSunDirection);

  return o;
}



VS_OUTPUT_ALPHATEST_LOD VS_Embel_AlphaTestLOD(VS_INPUT_LOD v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_ALPHATEST_LOD o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
    
  float3 vv;
  vv.xyz = v.vNorm;  
  
  o.vNorm = mul(vv, mInvWorldTrans);
  o.vNorm = normalize(o.vNorm);
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
    
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.vNorm), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.vNorm, vSunDirection));
  CalcVertAmbDiff(o.vNorm, cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.vNorm, vSunDirection);
  
  return o;
}

VS_OUTPUT_WATER VS_Embel_Water(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_WATER o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.cColor = v.cColor;
  
  o.vTexC.xy = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.vTexC.zw = mul(half4(v.vTexC, 0, 1), mTexBump);
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf =  CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans, true);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  return o;
}


sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = wrap; AddressV = wrap;
};

sampler2D sNormal = sampler_state
{
  texture = <NormalMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = wrap; AddressV = wrap;
};

samplerCUBE sEnv = sampler_state
{
  texture = <EnvMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = wrap; AddressV = wrap; AddressW = wrap;
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

sampler2D sGlowGradient = sampler_state
{
  texture = <GlowGradientMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = None;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};
/*
sampler2D sMask = sampler_state
{
  texture = <MaskMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Point;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};
*/

PS_OUTPUT PS_Embel_AlphaTest(VS_OUTPUT_ALPHATEST p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix;
  half3 vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = p.vNorm;
  fVO = CalcVO(sOcclusion, p.vVOC);

  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    //fVO *= CalcShadowShadowBufferPCF(sShadowMap, p.vShaC.xy, p.vShaC.z);
 
  vNorm.xyz = normalize(vNorm);
  //if(p.vFace > 0) vNorm = -vNorm;
 
  o.cColor = CalcAmbDiff(cMa, half4(cMd.rgb, cPix.a * cMd.a), 
                         cAmbientLight, cSunColor, cPix,
                         fBacklightStrength, vNorm.xyz, vSunDirection, fVO);

  OverridePixelLight(o.cColor, p.vNorm, half4(cPix.rgb, cPix.a * cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, half4(cPix.rgb, 0), fVO);

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  //fog calculation needed for 3.0 shaders
  //o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
               
             
  //if(p.vFace > 0) o.cColor = 1;                                            
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
      
  return o;
}


PS_OUTPUT PS_Embel_AlphaTestLOD(VS_OUTPUT_ALPHATEST_LOD p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);

  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
  
  o.cColor = CalcAmbDiff(cMa, half4(cMd.rgb, cPix.a * cMd.a), 
                         cAmbientLight, cSunColor, cPix,
                         fBacklightStrength, p.vNorm, vSunDirection, fVO);
  
  OverridePixelLight(o.cColor, p.vNorm, half4(cPix.rgb, cPix.a * cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, half4(cPix.rgb, 0), fVO);

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  return o;
}



PS_OUTPUT PS_Embel(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix;
  half4 vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    //fVO *= CalcShadowShadowBufferPCF(sShadowMap, p.vShaC.xy, p.vShaC.z);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  cPix.rgb *= vNorm.a;
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);

  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, cPix, fVO);

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);                             
                                               
  return o;
}

PS_OUTPUT PS_Embel_HO(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix;
  half4 vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    //fVO *= CalcShadowShadowBufferPCF(sShadowMap, p.vShaC.xy, p.vShaC.z);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  cPix.rgb *= vNorm.a;
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);

  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, cPix, fVO);
  o.cColor.a *= p.vVOC.w;

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);                             
                                               
  return o;
}

PS_OUTPUT PS_Embel_NoDarkMap(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix;
  half4 vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    //fVO *= CalcShadowShadowBufferPCF(sShadowMap, p.vShaC.xy, p.vShaC.z);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));

  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);

  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, cPix, fVO);

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);    
    
  return o;
}

PS_OUTPUT PS_Embel_NoDarkMap_HO(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix;
  half4 vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    //fVO *= CalcShadowShadowBufferPCF(sShadowMap, p.vShaC.xy, p.vShaC.z);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));

  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);

  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.a *= p.vVOC.w;
  o.cColor.rgb += DecodeLight(p.cLight, cPix, fVO);

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);    
    
  return o;
}

PS_OUTPUT PS_Embel_NoDarkMapLOD(VS_OUTPUT_LOD p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix;
  half4 vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
    
  o.cColor = CalcAmbDiff(cMa, half4(cMd.rgb, cPix.a * cMd.a), 
                         cAmbientLight, cSunColor, cPix,
                         fBacklightStrength, p.vNorm, vSunDirection, fVO);

  OverridePixelLight(o.cColor, p.vNorm, half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, half4(cPix.rgb, 0), fVO);

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
                                               
  return o;
}


PS_OUTPUT PS_Embel_Env(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  half3 cEnv;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  cEnv = GetEnvironmentColor(sEnv, p.vHalfPos, vNorm, vWorldCamera, cMs);

  half fNdotL = dot(vSunDirection, vNorm);
  o.cColor.rgb = cAmbientLight * cMa * CalcBacklightMultiplier(fBacklightStrength, fNdotL) + cSunColor * cMd.rgb * saturate(fNdotL) * fVO;
  o.cColor.rgb *= cPix.rgb * vNorm.a;
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, half4(cPix.rgb, 0), fVO);
  o.cColor.a = cMd.a;
  o.cColor = BlendEnvironment(o.cColor, cEnv, cPix.a);
  
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  
  return o;
}

PS_OUTPUT PS_Embel_Crystal(VS_OUTPUT_CRYSTAL p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
//  half3 cEnv;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
//  cEnv = GetEnvironmentColor(sEnv, p.vHalfPos, vNorm, vWorldCamera, cMs);

  float3 vCam;
  vCam = normalize(vWorldCamera - p.vHalfPos);

  half fNdotL = dot(vSunDirection, vNorm);
  half4 cDiff;
  cDiff.rgb = cAmbientLight * cMa * CalcBacklightMultiplier(fBacklightStrength, fNdotL) + cSunColor * cMd.rgb * saturate(fNdotL) * fVO + vNorm.a;
  cDiff.rgb *= cPix.rgb;
  OverridePixelLight(cDiff, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  cDiff.rgb += DecodeLight(p.cLight.xyz, cPix, fVO);

#if _COMPILE_PIXEL_SPECULAR_ == 1
  half  fHdotN = dot(vNorm, CalcHalfway(p.vHalfPos, vSunDirection, vWorldCamera));
  half  ks = fVO * pow(saturate(fHdotN), fShininess) * saturate(4 * fNdotL); // Blinn highlights
#if _COMPILE_CAMERA_SPECULAR_ == 1  
  half fCamDotN = saturate(dot(vCam.xyz, vNorm.xyz));
  half  ks1 = fCameraSpecular * pow(saturate(fCamDotN), fShininess) * saturate(4 * fCamDotN); // Blinn highlights
#else
  half ks1 = 0;
#endif  
//  half  hFacing = 1.0 - max(fCamDotN, 0);
//  half  hFresnel = pow(hFacing, fFresnelPower) * cPix.a;
  half3 cSpec = (ks + ks1).rrr * cSunSpecColor * cPix.a;
//  half  fSpecBrightness = dot(cSpec, vLuma);

//  half3 cEnvSpec = lerp(cEnv, cSpec, fSpecBrightness);
  //cOut.a = max(hFresnel, ks * fSpecBrightness);
  //o.cColor.rgb = lerp(cDiff.rgb, cEnvSpec, hFresnel + fSpecBrightness /** 0.5*/);
  o.cColor.rgb = cDiff.rgb /*+ cEnv * cPix.a*/ + cSpec;
#else
  o.cColor.rgb = cDiff.rgb;  
#endif  
  o.cColor.a = 1; 

  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  
  return o;

//  o.cColor = BlendEnvironment(o.cColor, cEnv, cPix.a * hFresnel);
  /*
  half2 t;
  t.x = p.cLight.w;
  t.y = p.cLight.w;
  half3 cGlowGradient = tex2D(sGlowGradient, t.xy);
  o.cColor.rgb = lerp(o.cColor, cGlowGradient, p.cLight.w * vNorm.a);
  */
  
  //fCamDotN *= fCamDotN * fCamDotN * fCamDotN * fCamDotN * fCamDotN * fCamDotN * fCamDotN * fCamDotN;
/*
  fCamDotN = pow(fCamDotN, 9);
  half2 t;
  t.x = fCamDotN * vNorm.a;
  t.y = fCamDotN * vNorm.a;
  half3 cGlowGradient = tex2D(sGlowGradient, t.xy);
  o.cColor.rgb = lerp(o.cColor, cGlowGradient, fCamDotN * vNorm.a);
*/  
  
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  
  return o;
}

PS_OUTPUT PS_Embel_Water(VS_OUTPUT_WATER p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  half3 cEnv;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  cEnv = GetEnvironmentColor(sEnv, p.vHalfPos, vNorm, vWorldCamera, cMs);

  half fNdotL = dot(vSunDirection, vNorm);
  o.cColor.rgb = cAmbientLight * cMa * CalcBacklightMultiplier(fBacklightStrength, fNdotL) + cSunColor * cMd.rgb * saturate(fNdotL) * fVO;
  o.cColor.rgb *= cPix.rgb;
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, half4(cPix.rgb, 0), fVO);
  o.cColor.a = cMd.a * vNorm.a;
  o.cColor *= p.cColor;
  o.cColor = BlendEnvironment(o.cColor, cEnv, cPix.a);
  
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  
  return o;
}

PS_OUTPUT PS_Embel_Env_Glow(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  half3 cEnv;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  cEnv = GetEnvironmentColor(sEnv, p.vHalfPos, vNorm, vWorldCamera, cMs);

  half fNdotL = dot(vSunDirection, vNorm);
  o.cColor.rgb = cAmbientLight * cMa * CalcBacklightMultiplier(fBacklightStrength, fNdotL) + cSunColor * cMd.rgb * saturate(fNdotL) * fVO;
  o.cColor.rgb *= cPix.rgb;
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);  
  o.cColor.rgb += DecodeLight(p.cLight.xyz, half4(cPix.rgb, 0), fVO);
  o.cColor.a = cMd.a;
  o.cColor = BlendEnvironment(o.cColor, cEnv, cPix.a);
  
  o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a);
  
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  
  return o;
}

PS_OUTPUT PS_Embel_Glow(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
    //fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC.xy, p.vShaC.z);
  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));
  half fNdotL = dot(vSunDirection, vNorm);
  o.cColor.rgb = cAmbientLight * cMa * CalcBacklightMultiplier(fBacklightStrength, fNdotL) + cSunColor * cMd.rgb * saturate(fNdotL) * fVO;
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, half4(cPix.rgb, 0), fVO);
  cPix.a *= fGlowPower;
  o.cColor.a = cMd.a;
  cPix.rgb *= vNorm.a;
  o.cColor = CalcGlow(o.cColor, cPix, cMe, fGlowAlpha);
  
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;

  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);  
  
  return o;
}


PS_OUTPUT PS_Embel_Glow_Spec(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);

  vNorm.xyz = FixNorm(vNorm.xyz);
  vNorm.xyz = normalize(mul(vNorm.xyz, p.mTan));
  
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
                           
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, cPix, fVO);

  o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a * fGlowPower);
    
  if (bFogOfWar)
    o.cColor.rgb *= fFogOfWar;
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

PS_OUTPUT PS_Embel_Glow_Spec_HO(VS_OUTPUT p, uniform bool bShadows, uniform bool bExplicitFog, uniform bool bFogOfWar)
{
  PS_OUTPUT o;
  half4 cPix, vNorm;
  half fVO;
  cPix = tex2D(sBase, p.vTexC);
  vNorm = tex2D(sNormal, p.vTexC);
  fVO = CalcVO(sOcclusion, p.vVOC.xyz);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);

  vNorm.xyz = FixNorm(vNorm.xyz);
  vNorm.xyz = normalize(mul(vNorm.xyz, p.mTan));
  
  o.cColor = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                             cAmbientLight, cSunColor, cSunSpecColor, cPix,
                             fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
                           
  OverridePixelLight(o.cColor, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  o.cColor.a *= p.vVOC.w;                           
  o.cColor.rgb += DecodeLight(p.cLight, cPix, fVO);

  o.cColor.rgb = lerp(o.cColor, cMe * cPix, vNorm.a * fGlowPower);
    
  if (bFogOfWar)
    o.cColor.a *= saturate((fFogOfWar - 0.5) * 2);
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
  return o;
}

#define EMBEL_TECH(t, d, pub, impa, rs, p)\
  technique t\
  <\
    string shadername = #t;\
    string description = d;\
    int Implementation = 0;\
    string NBTMethod = "NDL";\
    bool UsesNIRenderState = rs;\
    bool UsesNILightState = false;\
    bool bPublic = pub;\
    bool ImplicitAlpha = impa;\
  >\
  {\
    p\
  }

#define EMBEL_STATES\
  AlphaBlendEnable = false;\
  AlphaTestEnable = false;\
  ColorWriteEnable = CWEVALUE;\
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
  
#define EMBEL_STATES_ALPHATEST\
    AlphaBlendEnable = false;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaRef = 32;\
    AlphaFunc = greater;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = false;\
    CullMode = NONE;\
    StencilEnable = false;\
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

#define EMBEL_STATES_ALPHABLEND\
    AlphaBlendEnable = true;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaRef = 0;\
    CullMode = CW;\
    AlphaFunc = greater;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = false;\
    StencilEnable = false;\
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

#define EMBEL_STATES_WATER\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = true;\
    StencilEnable = false;\
    CullMode = none;\
    FogEnable = true


#define EMBEL_PASS(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog,fow)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(pos,sha);\
    PixelShader = compile ps_ver ps(sha,fog,fow);\
  }
  
#define TINT_PASS_EMBEL(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog,fow)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(pos,sha);\
    PixelShader = compile ps_ver ps(sha,fog,fow);\
  }\
  TINT_PASS_OBJECT

#define EMBEL_TECHTINT(t,d,pub,impa,rs,ds,vs_ver,vs,ps_ver,ps,pos,sha,fog,fow)\
  EMBEL_TECH(t,d,pub,impa,rs,EMBEL_PASS(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog,fow))\
  EMBEL_TECH(t##_Tint,"Internal technique, do not use.",false,impa,rs,TINT_PASS_EMBEL(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog,fow))

#define EMBEL_TECHNIQUE(t,d,impa,rs,ds,vs_ver,vs,ps_ver,ps,pos,fow)\
  EMBEL_TECHTINT(t,d,true,impa,rs,ds,vs_ver,vs,ps_ver,ps,pos,false,false,fow)\
  EMBEL_TECHTINT(t##_Shadows,"Internal technique, do not use.",false,impa,rs,ds,vs_ver,vs,ps_ver,ps,pos,true,false,fow)
  

EMBEL_TECHNIQUE(_Embel_Spec_Normal, "Base texture, normal map, VOE and specular.",
                false, false, EMBEL_STATES, _VS2X_, VS_Embel, _PS2X_, PS_Embel_NoDarkMap, false, true)
EMBEL_TECHNIQUE(_Embel_Spec_Normal_HO, "Base texture, normal map, VOE and specular.",
                true, false, EMBEL_STATES_ALPHABLEND, _VS2X_, VS_Embel_HO, _PS2X_, PS_Embel_NoDarkMap_HO, false, true)                
EMBEL_TECHNIQUE(_Embel_Spec, "Base texture, VOE and specular.",
                false, false, EMBEL_STATES, _VS2X_, VS_EmbelLOD, _PS2X_, PS_Embel_NoDarkMapLOD, false, true)
EMBEL_TECHNIQUE(_Embel_Spec_Normal_Dark, "Base texture, normal map, VOE and specular, alpha in the normal map is a darkmap.",
                false, false, EMBEL_STATES, _VS2X_, VS_Embel, _PS2X_, PS_Embel, false, true)
EMBEL_TECHNIQUE(_Embel_Spec_Normal_Dark_HO, "Base texture, normal map, VOE and specular, alpha in the normal map is a darkmap.",
                true, false, EMBEL_STATES_ALPHABLEND, _VS2X_, VS_Embel_HO, _PS2X_, PS_Embel_HO, false, true)
EMBEL_TECHNIQUE(_Embel_Env_Normal_Dark, "Base texture, normal map, VOE and environment map, alpha in the normal map is a darkmap.",
                false, false, EMBEL_STATES, _VS2X_, VS_Embel, _PS2X_, PS_Embel_Env, true, true)
EMBEL_TECHNIQUE(_Embel_Glow_Normal_Dark, "Base texture, normal map, VOE and glow, alpha in base texture is a glowmap, alpha in the normal map is a darkmap.",
                false, false, EMBEL_STATES, _VS2X_, VS_Embel, _PS2X_, PS_Embel_Glow, true, true)
EMBEL_TECHNIQUE(_Embel_Glow_Spec, "Base texture, normal map, specular, VOE and glow, alpha in normal map is a glowmap",
                false, false, EMBEL_STATES, _VS2X_, VS_Embel, _PS2X_, PS_Embel_Glow_Spec, false, true)
EMBEL_TECHNIQUE(_Embel_Glow_Spec_HO, "Base texture, normal map, specular, VOE and glow, alpha in normal map is a glowmap",
                true, false, EMBEL_STATES_ALPHABLEND, _VS2X_, VS_Embel_HO, _PS2X_, PS_Embel_Glow_Spec_HO, false, true)
EMBEL_TECHNIQUE(_Embel_Env_Glow, "Base texture, normal map, VOE and environment map, alpha in the normal map is a glowmap.",
                false, false, EMBEL_STATES, _VS2X_, VS_Embel, _PS2X_, PS_Embel_Env_Glow, true, true)

                
EMBEL_TECHNIQUE(_Embel_AlphaTest, "Base texture, VOE, and alpha in base map is transparency (alpha test).",
                false, false, EMBEL_STATES_ALPHATEST, _VS2X_, VS_Embel_AlphaTest, _PS2X_, PS_Embel_AlphaTest, true, true)
EMBEL_TECHNIQUE(_Embel_AlphaBlend, "Base texture, VOE, and alpha in base map is transparency (alpha blend).",
                true, false, EMBEL_STATES_ALPHABLEND, _VS2X_, VS_Embel_AlphaTest, _PS2X_, PS_Embel_AlphaTest, true, true)
EMBEL_TECHNIQUE(_Embel_Water, "Base texture, normal map, VOE and environment map, alpha in the base map is gloss, alpha in the normal map is transparency.",
                true, true, EMBEL_STATES_WATER, _VS2X_, VS_Embel_Water, _PS2X_, PS_Embel_Water, true, true)


EMBEL_TECHNIQUE(_Embel_Crystal, "Base texture, normal map, VOE and glow, alpha in base texture is a glowmap, alpha in the normal map is a darkmap.",
                false, false, EMBEL_STATES, _VS2X_, VS_Embel_Crystal, _PS2X_, PS_Embel_Crystal, true, true)
