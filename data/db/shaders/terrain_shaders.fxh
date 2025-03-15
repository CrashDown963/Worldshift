#ifndef __TERRAIN_SHADERS_FXH
#define __TERRAIN_SHADERS_FXH

////////////////////////////////////////////////////////////////////////////////
// Terrain shaders
//
// Features:
// o Base texture map
// o Normal map (except in the simplest material, _Terrain)
// o Texture transformations for moving textures
// o Per-pixel lighting from one directional light source (the sun) + virtual
//   back light from the opposite direction.
// o The lighting options are:
//   - diffuse lighting + masked specular lighting
//   - diffuse lighting / specular lighting + environment mapping
//   - diffuse lighting / glow effect
//   The mask is in the alpha channel of the base texture. The environment map
//   is shader map #0.
// o Per-vertex ambient occlusion, coded in vertex red channel
// o Volumetric tinting for underwater terrain
// o The terrain can receive shadows (optional)

#include "Utility.fxh"

#ifdef COMPILE_DECALS
  #define ADDRESS_MODE     Clamp
  #undef  COMPILE_DECALS
  #define COMPILE_DECALS   true
#else
  #define ADDRESS_MODE     Wrap
  #define COMPILE_DECALS   false
#endif

half fTerrainBacklightStrength: GLOBAL = 0.5;

// Supported maps:
texture BaseMap   <string NTM = "base";   int NTMIndex = 0;>;
texture NormalMap <string NTM = "bump";   int NTMIndex = 0;>;
texture EnvMap    <string NTM = "shader"; int NTMIndex = 0;>;
texture ShadowMap    <string NTM = "shader"; int NTMIndex = 1; bool hidden = true;>;
texture BaseMap2  <string NTM = "shader"; int NTMIndex = 5;>;

half  fDecalFoWDarken  : ATTRIBUTE <bool hidden = true;> = 1.0;

half  fGlowPower       : ATTRIBUTE <string UIWidget = "slider"; float UIMin = 0.0; float UIMax = 1.0;> = 1.0;
half  fGlowAlpha       : ATTRIBUTE <string UIWidget = "slider"; float UIMin = 0.0; float UIMax = 1.0;> = 1.0;
half  fCoatingThickness: ATTRIBUTE <string UIWidget = "slider"; float UIMin = 0.0; float UIMax = 1.0;> = 1.0;
half4 cCoatingColor    : ATTRIBUTE <bool color = true;> = { 0.8, 0.8, 1.0, 1.0 };

half  fBumpScale       : ATTRIBUTE = 0.05;

// Transformations:
float4x4 mInvWorld      : INVWORLD;
float4x4 mView          : VIEW;
float4x4 mWorldViewProj : WORLDVIEWPROJECTION;
//float4x4 mShadowProj    : GLOBAL;


//float4x4  mShadowLightTrans   : GLOBAL;
//float4x4  mShadowAfterLightTrans   : GLOBAL;
//float     fShadowZRangeMultiplier : GLOBAL;
float     fBlendAlpha : ATTRIBUTE;
float     fGlowMin: ATTRIBUTE;
float     fGlowMax: ATTRIBUTE;
float     fGlowTime: ATTRIBUTE;


// Samplers:
sampler2D sBaseMap = sampler_state
{
  texture = <BaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = ADDRESS_MODE; AddressV = ADDRESS_MODE;
};

sampler2D sNormalMap = sampler_state
{
  texture = <NormalMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = ADDRESS_MODE; AddressV = ADDRESS_MODE;
};

samplerCUBE sEnvMap = sampler_state
{
  texture = <EnvMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = ADDRESS_MODE; AddressV = ADDRESS_MODE;
};

sampler2D sShadowMap = sampler_state
{
  texture = <ShadowMap>;
  SHADOW_SAMPLER_STATES;
};

sampler2D sBaseMap2 = sampler_state
{
  texture = <BaseMap2>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = ADDRESS_MODE; AddressV = ADDRESS_MODE;
};


// Vertex formats:

struct VS_INPUT
{
  float4 vPos  : POSITION; 
  half4  cDiff : COLOR0;
  half3  vNorm : NORMAL; 
  half2  vTexC : TEXCOORD0;
};

struct VS_INPUT_NORMALS
{
  float4 vPos  : POSITION; 
  half4  cDiff : COLOR0;
  half3  vNorm : NORMAL; 
  half3  vBin  : BINORMAL; 
  half3  vTan  : TANGENT; 
  half2  vTexC : TEXCOORD0;
};


////////////////////////////////////////////////////////////////////////////////
// Helper functions:
//
half GetAlpha(half4 cTexel, half4 cVertColor)
{
  if (COMPILE_DECALS) return cTexel.a;
  else 
  {
#if _SHADER_DETAIL_ <= 1
    half v = dot(cTexel.rgb, half3(0.333, 0.333, 0.333));
    v = cTexel.a;
    //v = saturate(lerp(-0.5, 1.5, v));
    v = v * v * (3 - 2 * v);
    
    //v *= 0.5;
    //return saturate(cVertColor.a * 2 + v);
    
    //half p = (4.5 * v - 0.75) * v + 0.25;
    half p = (v + 0.5) * v + 0.5;
    //return cVertColor.a; // Bypass smart blending
    return pow(cVertColor.a, p);
#else
    return cVertColor.a;    
#endif    
  }
}

half3 GetFoWColor(half4 cVertex)
{
  /*if (COMPILE_DECALS) return fDecalFoWDarken.rrr;
  else*/ return cVertex.bbb;
}

half4 AddGloss(half4 cTexel, half4 vNorm)
{
  if (COMPILE_DECALS) return half4(cTexel.rgb, vNorm.a);
  else return cTexel;
}

half3 CalcAD(half4 cTexel, half3 N, half3 L, half fShadow = 1)
{
  half3 cRes;
  half  NdotL = dot(N, L);

  // Ambient light + virtual back light:
  half ka = CalcBacklightMultiplier(fTerrainBacklightStrength, NdotL);
    
  // Diffuse lighting:
  half kd = saturate(NdotL) * fShadow;

  // The parentheses below are VERY important!
  cRes = cTexel.rgb *
         (ka.rrr * (cMa * cAmbientLight) +
          kd.rrr * (cMd * cSunColor));    

  return cRes;
}

half3 CalcADS(half4 cTexel, half3 H, half3 N, half3 L, half fShadow)
{
  half3 cRes;
  half4 fHack; // = saturate(N.H, N.L, 4N.L, -N.L)
  half ks;
  
#if _COMPILE_PIXEL_SPECULAR_ == 1
  fHack.x     = dot(N, H);
#else  
  fHack.x     = 0;
#endif
  fHack.yzw   = dot(N, L);
  fHack       *= half4(1.0, 1.0, 4.0, -1.0);
  fHack       = saturate(fHack);

  // Ambient light [+ virtual back light]:
#if _COMPILE_BACKLIGHT_ == 1  
  half ka = 1.0 + fTerrainBacklightStrength * fHack.w;
#else
  half ka = 1;
#endif
      
  // Diffuse lighting:
  half kd = fHack.y * fShadow;

#if _COMPILE_PIXEL_SPECULAR_ == 1
  // Specular lighting (Blinn):
  ks = pow(fHack.x, fShininess) * fHack.z * fShadow * cTexel.a;
#else
  ks = 0;
#endif

  // The parentheses below are VERY important!
  cRes = cTexel.rgb *
         (ka.rrr * (cMa * cAmbientLight) +
          kd.rrr * (cMd * cSunColor)) +
         (ks.rrr * (cMs * cSunSpecColor));
  
  return cRes;
}

half3 AddEmittance(half3 cRes, half4 cTexel, half4 cEmittance = 0, uniform bool bSimple = true)
{
  if (bSimple) 
    cRes.rgb = lerp(cRes.rgb, cTexel.rgb, cTexel.a * cMe.r);  
  else {
    half3 cGlow = lerp(cTexel, cEmittance, fGlowAlpha);
    cRes.rgb = lerp(cRes.rgb, cGlow, cEmittance.a * fGlowPower);  
  }
  return cRes;
}

/*
float2 CalcShadowMapUV(const float4 vPos)
{
  float4 tmp = mul(vPos, mShadowProj);
  tmp /= tmp.w;
  return tmp;
}
 */
half3 CalcLightVector(const half3 vBin, const half3 vTan, const half3 vNorm, const half cFactor)
{
  float3x3 mTangent = float3x3(vTan, vBin, vNorm);
  return mul(mTangent, vSunDirection) * cFactor;
}

void FixVertexColor(in out half4 cDiff)
{
#if _COMPILE_VO_ != 1
  cDiff.r = 1;
#endif
}

////////////////////////////////////////////////////////////////////////////////
// Vertex shaders:
//

// Simplest material - no NM, basic lighting (diff + spec from sun & backlight):
void vsSimple(const VS_INPUT In,
              out float4 vPos:   POSITION,
              out half4  cDiff:  COLOR0,
              out half3  cLights:COLOR1,
              out half   hFog:   FOG,
              out half2  vTexC:  TEXCOORD0,
              out half3  vNorm:  TEXCOORD1,
              out half3  vHalf:  TEXCOORD2,
              out float4 vShaC:  TEXCOORD3,
              uniform bool bShadows)
{
  vPos      = mul(In.vPos, mWorldViewProj);
  cDiff     = In.cDiff;
  vTexC     = mul(half4(In.vTexC, 0, 1), mTexBase);
  vNorm     = In.vNorm;
  vHalf     = normalize(normalize(vWorldCamera - In.vPos) + vSunDirection);
  cLights   = CalcAdditionalLights(In.vPos, In.vNorm);
  cLights   = EncodeLight(cLights, CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, vNorm, vSunDirection));
  hFog      = CalcFog(distance(In.vPos, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth) * GetEdgenessAlpha(In.vPos);
  CalcVertAmbDiff(vNorm, cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, vNorm, vSunDirection);
  
  if (bShadows)
    CalcShadowBufferTexCoords(In.vPos, vShaC);
  else
    vShaC = 0.0;
}



// Selection decals (vertex diffuse + backlight)
void vsSelection(const VS_INPUT In,
                 out float4 vPos : POSITION,
                 out half4  cDiff: TEXCOORD2,
                 out half3  cAmb : TEXCOORD4,
                 out half2  vTexC: TEXCOORD0,
                 out half3  vNorm: TEXCOORD1,
                 out half   fFog : FOG,
                 out float4 vShaC: TEXCOORD3,
                 uniform bool bShadows)
{
  vPos = mul(In.vPos, mWorldViewProj);
  half fNdotL = dot(vSunDirection, In.vNorm);
  cAmb = cAmbientLight * cMa * CalcBacklightMultiplier(fTerrainBacklightStrength, fNdotL) + cMe;
  cDiff = In.cDiff;
  FixVertexColor(cDiff);
  cDiff.rgb = cAmb + cSunColor * cMd.rgb * cDiff.r * saturate(fNdotL);
  cDiff.a = cMd.a;
  vNorm = In.vNorm;
  vTexC = mul(half4(In.vTexC, 0, 1), mTexBase);
  fFog = CalcFog(distance(In.vPos, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);

  if (bShadows)
    CalcShadowBufferTexCoords(In.vPos, vShaC);
  else
    vShaC = 0.0;
}

void RestoreNBT(in float3 N, out float3 B, out float3 T)
{
  // Terrain textures are y-flipped because of some kind of legacy issue :-/
  half3 H = cross(N, float3(0, 1, 0));
  B = COMPILE_DECALS ? cross(H, N): cross(N, H);
  T = COMPILE_DECALS ? cross(B, N): cross(N, B);
}


// Normal map, basic lighting (specular lighting is masked by base alpha):
void vsNormals(const VS_INPUT_NORMALS In, 
               out float4 vPos:    POSITION,
               out half4  cDiff:   COLOR0,
               out half4  cLightsFog: COLOR1,
               out half   hFog:    FOG,
               out half2  vTexC:   TEXCOORD0,
               out half3  vLight:  TEXCOORD1,
               out half3  vHalf:   TEXCOORD2,
               out float4 vShaC:   TEXCOORD3,
               out half3  cDiffLight: TEXCOORD4,
               uniform bool bShadows)
{
  //half3 vBin, vTan;
  //RestoreNBT(In.vNorm, vBin, vTan);
  float3x3 mTangent = TransformTangentSpace(half3x3(In.vTan, In.vBin, In.vNorm), true);
  
  vPos      = mul(In.vPos, mWorldViewProj);
  cDiff     = In.cDiff;
  vTexC     = mul(half4(In.vTexC, 0, 1), mTexBase);
  vLight    = vSunDirection;
  vHalf     = CalcHalfway(In.vPos, vSunDirection, vWorldCamera);
#if _COMPILE_NORMAL_MAP_ == 1  
  vLight    = mul(mTangent, vLight);
  vHalf     = mul(mTangent, vHalf);
  cDiffLight = 0;
#endif  
  CalcVertAmbDiff(cDiffLight, cMa, cMd, cAmbientLight, cSunColor, fTerrainBacklightStrength, mTangent[2], vSunDirection);
  cLightsFog.rgb = CalcAdditionalLights(In.vPos, In.vNorm);
  cLightsFog.rgb = EncodeLight(cLightsFog.rgb, CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, mTangent[2], vSunDirection));
  hFog      = CalcFog(distance(In.vPos, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth) * GetEdgenessAlpha(In.vPos);

  cLightsFog.a = hFog;
  
  if (bShadows)
    CalcShadowBufferTexCoords(In.vPos, vShaC);
  else
    vShaC = 0.0;
}

// Steep parallax, basic lighting (specular lighting is masked by base alpha):
void vsParallax(const VS_INPUT_NORMALS In, 
                out float4 vPos:   POSITION,
                out half4  cDiff:  COLOR0,
                out half   hFog:   FOG,
                out half2  vTexC:  TEXCOORD0,
                out half3  vLight: TEXCOORD1,
                out half3  vCam:   TEXCOORD2,
                out half3  vHalf:  TEXCOORD3,
                out float4 vShaC:  TEXCOORD4,
                out half3  cDiffLight: TEXCOORD5,
                uniform bool bShadows)
{
  //half3 vBin, vTan;
  //RestoreNBT(In.vNorm, vBin, vTan);
  float3x3 mTangent = TransformTangentSpace(half3x3(In.vTan, In.vBin, In.vNorm), true);

  vPos      = mul(In.vPos, mWorldViewProj);
  cDiff     = In.cDiff;
  vTexC     = In.vTexC;
  vLight    = vSunDirection;
  vCam      = normalize(vWorldCamera - In.vPos.xyz);
#if _COMPILE_NORMAL_MAP_ == 1  
  vLight    = mul(mTangent, vLight);
  vCam      = mul(mTangent, vCam);
  cDiffLight = 0;
#endif  
  CalcVertAmbDiff(cDiffLight, cMa, cMd, cAmbientLight, cSunColor, fTerrainBacklightStrength, mTangent[2], vSunDirection);
  vHalf     = normalize(vLight + vCam);
  hFog      = CalcFog(distance(In.vPos, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth) * GetEdgenessAlpha(In.vPos);
  
  if (bShadows)
    CalcShadowBufferTexCoords(In.vPos, vShaC);
  else
    vShaC = 0.0;
}



// Normal map, environment mapping (EM & spec. lighting are masked by base alpha):
void vsEnvironment(const VS_INPUT_NORMALS In, 
                   out float4  vPos:   POSITION,
                   out half4   cDiff:  COLOR0,
                   out half4   cLightsFog:  COLOR1,
                   out half    hFog:   FOG,
                   out half2   vTexC:  TEXCOORD0,
                   out float3x3 mTan:  TEXCOORD1,
                   out half3   vHalf:  TEXCOORD4,
                   out half3   vCam:   TEXCOORD5,
                   out float4  vShaC:  TEXCOORD6,
                   uniform bool bShadows)
{
  //half3 vBin, vTan;
  //RestoreNBT(In.vNorm, vBin, vTan);
  mTan   = TransformTangentSpace(half3x3(In.vTan, In.vBin, In.vNorm), false);
  CalcVertAmbDiff(mTan[0], cMa, cMd, cAmbientLight, cSunColor, fTerrainBacklightStrength, mTan[2], vSunDirection);

  vPos   = mul(In.vPos, mWorldViewProj);
  cDiff  = In.cDiff;
  vTexC  = mul(half4(In.vTexC, 0, 1), mTexBase);
  vCam   = normalize(vWorldCamera - In.vPos);
  //vLight = mul(mTan, vSunDirection) * In.cDiff.r;
  //vLight = vSunDirection * In.cDiff.r;
  vHalf  = normalize(vSunDirection + vCam);
  cLightsFog.rgb = CalcAdditionalLights(In.vPos, In.vNorm);
  cLightsFog.rgb = EncodeLight(cLightsFog.rgb, CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, mTan[2], vSunDirection));

  hFog   = CalcFog(distance(In.vPos, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth) * GetEdgenessAlpha(In.vPos);
  
  cLightsFog.a = hFog;
  
  if (bShadows)
    CalcShadowBufferTexCoords(In.vPos, vShaC);
  else
    vShaC = 0.0;
}



////////////////////////////////////////////////////////////////////////////////
// Pixel shaders:
//

// Simplest material - no NM, basic lighting (diff + spec from sun & backlight):
void psSimple(in half4  cDiff:   COLOR0,
              in half3  cLights: COLOR1,
              in half2  vTexC:   TEXCOORD0,
              in half4  N:       TEXCOORD1,
              in half3  H:       TEXCOORD2,
              in float4 vShaC:   TEXCOORD3,
              in  half  hFog:    FOG,
              out half4 cOut:    COLOR0,
              uniform bool bShadows,
              uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);
    //cDiff.r *= CalcShadowShadowBufferPCF(sShadowMap, vShaC.xy, vShaC.z);

  half4 cTex = tex2D(sBaseMap, vTexC);
  cOut.rgb = CalcADS(AddGloss(cTex, N), H, N, vSunDirection, cDiff.r);
  OverridePixelLight(cOut, N, cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLights, AddGloss(cTex, N), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = GetAlpha(cTex, cDiff);
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);  
}



// Selection decals
void psSelection(in half4  cDiff: TEXCOORD2,
                 in half3  cAmb : TEXCOORD4,
                 in half2  vTexC: TEXCOORD0,
                 in half3  vNorm: TEXCOORD1, 
                 in float4 vShaC: TEXCOORD3, 
                 in half   hFog : FOG,
                 out half4 cOut : COLOR0,
                 uniform bool bShadows,
                 uniform bool bExplicitFog)
{
  half4 cTex = tex2D(sBaseMap, vTexC);

  if (bShadows)
  {
    half fShadow = CalcShadowShadowBuffer(sShadowMap, vShaC);
    cOut.rgb = lerp(cAmb, cDiff.rgb, fShadow) * cTex;
    cOut.a = cTex.a * cDiff.a;
//    cOut.a *= SlopedStep(0.2, 0.8, dot(vNorm, half3(0, 0, 1)));
  }
  else
  {
    cOut = cTex * cDiff;
    //cOut.a *= pow(dot(vNorm, half3(0, 0, 1)) / 2 + 0.5, 8);
  }
 
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}



// Normal map, diffuse lighting:
void psNormalsDiffuse(in half4  cDiff:   COLOR0,
                      in half3  cLights: COLOR1,
                      in half2  vTexC:   TEXCOORD0,
                      in half3  L:       TEXCOORD1,
                      in half3  H:       TEXCOORD2,
                      in float4 vShaC:   TEXCOORD3,
                      in  half  hFog:    FOG,
                      out half4 cOut:    COLOR0,
                      uniform bool bShadows,
                      uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 N = tex2D(sNormalMap, vTexC); // Normal (xyz) and blending mask (w)
  half4 cTex = tex2D(sBaseMap, vTexC);
  N.xyz = FixNorm(N.xyz);
  cOut.rgb = CalcAD(cTex, N.xyz, L, cDiff.r);
  OverridePixelLight(cOut, L, cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLights, half4(cTex.rgb, 0), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  if (!COMPILE_DECALS)
    cOut.a = GetAlpha(N, cDiff);
  else
    cOut.a = cTex.a;
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}

// Normal map, diffuse lighting and per pixel fog for use with premultiplied alpha textures:
void psNormalsDiffuseFog(in half4  cDiff:      COLOR0,
 												 in half4  cLightsFog:    COLOR1,
 												 in half2  vTexC:      TEXCOORD0,
												 in half3  L:          TEXCOORD1,
												 in half3  H:          TEXCOORD2,
												 in float4 vShaC:      TEXCOORD3,
												 in half3  cDiffLight: TEXCOORD4,
												 //in  half  hFog:    FOG,
												 out half4 cOut:       COLOR0,
												 uniform bool bShadows,
												 uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half3 N = FixNorm(tex2D(sNormalMap, vTexC));
  half4 cTex = tex2D(sBaseMap, vTexC);
  cTex.rgb *= cMd.a;
  cOut.rgb = CalcAD(cTex, N, L, cDiff.r);
  OverridePixelLight(cOut, cDiffLight, cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLightsFog.rgb, half4(cTex.rgb, 0), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = cTex.a * cMd.a; // GetAlpha(cTex, cDiff) * cMd.a; // GetAlpha doesn’t make sense for decals
  // Blend the fog explicitly so the pre-multiplied alpha does not mess it up
  cOut.rgb = cOut.rgb * cLightsFog.a + cFogColor * (1 - cLightsFog.a) * cOut.a;
} 

// Diffuse lighting and per pixel fog for use with premultiplied alpha textures:
void psDiffuseFog(in half4  cDiff:      COLOR0,
 												 in half4  cLightsFog:    COLOR1,
 												 in half2  vTexC:      TEXCOORD0,
												 in half3  L:          TEXCOORD1,
												 in half3  H:          TEXCOORD2,
												 in float4 vShaC:      TEXCOORD3,
												 in half3  cDiffLight: TEXCOORD4,
												 //in  half  hFog:    FOG,
												 out half4 cOut:       COLOR0,
												 uniform bool bShadows,
												 uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half3 N = half3(0, 0, 1);
  half4 cTex = tex2D(sBaseMap, vTexC);
  if (bExplicitFog) // multiply material alpha in the rgb so it stays correctly premultiplied
    cTex.rgb *= cMd.a;
  cOut.rgb = CalcAD(cTex, N, L, cDiff.r);
  OverridePixelLight(cOut, cDiffLight, cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLightsFog.rgb, half4(cTex.rgb, 0), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = cTex.a; // GetAlpha(cTex, cDiff); // GetAlpha doesn’t make sense for decals
  if (bExplicitFog) {
    cOut.a *= cMd.a;
		// Blend the fog explicitly so the pre-multiplied alpha does not mess it up
		cOut.rgb = cOut.rgb * cLightsFog.a + cFogColor * (1 - cLightsFog.a) * cOut.a;
	}
} 

// Normal map, basic lighting (specular lighting is masked by base alpha):
void psNormals(in half4  cDiff:   COLOR0,
               in half3  cLights: COLOR1,
               in half2  vTexC:   TEXCOORD0,
               in half3  L:       TEXCOORD1,
               in half3  H:       TEXCOORD2,
               in float4 vShaC:   TEXCOORD3,
               in half3  cDiffLight: TEXCOORD4,
               in  half  hFog:    FOG,
               out half4 cOut:    COLOR0,
               uniform bool bShadows,
               uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

//  H = normalize(H);
  float4 N = tex2D(sNormalMap, vTexC);
  N.xyz = FixNorm(N);
/*  float fSign = sign(N.x);
  float fAbsX = sqrt(1.0 - N.y * N.y - N.z * N.z);
  if (N.x > 0)
    N.x = fAbsX;
  else
    N.x = -fAbsX;*/
  //N.z = sqrt(1.0 - N.x * N.x - N.y * N.y);
  half4 cTex = tex2D(sBaseMap, vTexC);
  cOut.rgb = CalcADS(AddGloss(cTex, N), H, N, L, cDiff.r);
  OverridePixelLight(cOut, cDiffLight, cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLights, AddGloss(cTex, N), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  if (!COMPILE_DECALS)
    cOut.a = GetAlpha(N, cDiff);
  else
    cOut.a = cTex.a;
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}


void psNormalsFog(in half4  cDiff:   COLOR0,
               in half4  cLightsFog: COLOR1,
               in half2  vTexC:   TEXCOORD0,
               in half3  L:       TEXCOORD1,
               in half3  H:       TEXCOORD2,
               in float4 vShaC:   TEXCOORD3,
               in half3  cDiffLight: TEXCOORD4,
               //in  half  hFog:    FOG,
               out half4 cOut:    COLOR0,
               uniform bool bShadows,
               uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  float4 N = tex2D(sNormalMap, vTexC);
  N.xyz = FixNorm(N);

  half4 cTex = tex2D(sBaseMap, vTexC);
  if (bExplicitFog) // multiply material alpha in the rgb so it stays correctly premultiplied
    cTex.rgb *= cMd.a;  
  cOut.rgb = CalcADS(AddGloss(cTex, N), H, N, L, cDiff.r);
  OverridePixelLight(cOut, cDiffLight, cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLightsFog, AddGloss(cTex, N), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = cTex.a;
  
  if (bExplicitFog)
  {
    cOut.a *= cMd.a;
		// Blend the fog explicitly so the pre-multiplied alpha does not mess it up
		cOut.rgb = cOut.rgb * cLightsFog.a + cFogColor * (1 - cLightsFog.a) * cOut.a;
  }
}


// Normal map, diffuse lighting only (decals only):
void psLighting(in half4  cDiff:   COLOR0,
                in half3  cLights: COLOR1,
                in half2  vTexC:   TEXCOORD0,
                in half3  L:       TEXCOORD1,
                in half3  H:       TEXCOORD2,
                in float4 vShaC:   TEXCOORD3,
                in half3  cDiffLight: TEXCOORD4,
                in  half  hFog:    FOG,
                out half4 cOut:    COLOR0,
                uniform bool bShadows,
                uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 N = tex2D(sNormalMap, vTexC);
  N.xyz = FixNorm(N);
  half3 cOldLight, cLight;
  cOldLight = CalcAD(1, half3(0, 0, 1), L, cDiff.r);
  cLight = CalcAD(1, N, L, cDiff.r);
  cOut.rgb = cLight / cOldLight;
  cOut.rgb = lerp(1, cOut.rgb, N.a); 
  cOut.rgb += DecodeLight(cLights, half4(1, 1, 1, N.a), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = N.a * cMd.a;
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}



// Steep parallax, basic lighting (specular lighting is masked by base alpha):
void psParallax(in half4  cDiff:   COLOR0,
                in half4  cLights: COLOR1,
                in half2  vTexC:   TEXCOORD0,
                in half3  L:       TEXCOORD1,
                in half3  V:       TEXCOORD2,
                in half3  H:       TEXCOORD3,
                in float4 vShaC:   TEXCOORD4,
                in  half  hFog:    FOG,
                out half4 cOut:    COLOR0,
                uniform bool bShadows,
                uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 N;
  half3 vParaTex;
  CalcSteepParallax(V, sNormalMap, vTexC, fBumpScale, vParaTex, N);
  N.xyz = FixNorm(N);
  half4 cTex = tex2D(sBaseMap, vParaTex.xy);
  cOut.rgb = CalcADS(AddGloss(cTex, 1), H, N.xyz, L, cDiff.r);
  cOut.rgb += DecodeLight(cLights, AddGloss(cTex, 1), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = GetAlpha(tex2D(sBaseMap, vTexC), cDiff);

  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}



// Normal map, environment mapping (EM & spec. lighting are masked by base alpha):
void psEnvironment(in half4   cDiff:   COLOR0,
                   in half3   cLights: COLOR1,
                   in half2   vTexC:   TEXCOORD0,
                   in half3x3 mTan:    TEXCOORD1,
                   in half3   H:       TEXCOORD4,
                   in half3   V:       TEXCOORD5,
                   in float4  vShaC:   TEXCOORD6,
                   in  half  hFog:    FOG,
                   out half4  cOut:    COLOR0,
                   uniform bool bShadows,
                   uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  half4 cTex = tex2D(sBaseMap, vTexC);
  
  half4 Nt = tex2D(sNormalMap, vTexC);
  Nt.xyz = normalize(FixNorm(Nt));
  half3 Nw = mul(mTan, Nt);
  
  cOut.rgb = CalcAD(cTex, Nw, vSunDirection, true);
  OverridePixelLight(cOut, mTan[0], cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLights, half4(cTex.rgb, 0), cDiff.r);
#if _COMPILE_ENV_MAP_ == 1
  half4 cEnv = texCUBE(sEnvMap, reflect(V, Nw));
  cOut.rgb = lerp(cOut.rgb, cEnv.rgb, AddGloss(cTex, Nt).a);
#endif  
  cOut.rgb *= GetFoWColor(cDiff);
  if (!COMPILE_DECALS)
    cOut.a = GetAlpha(Nt, cDiff);
  else
    cOut.a = cTex.a;   
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}

// Normal map, environment mapping (EM & spec. lighting are masked by base alpha):
void psEnvironmentFog(in half4   cDiff:   COLOR0,
                   in half4   cLightsFog: COLOR1,
                   in half2   vTexC:   TEXCOORD0,
                   in half3x3 mTan:    TEXCOORD1,
                   in half3   H:       TEXCOORD4,
                   in half3   V:       TEXCOORD5,
                   in float4  vShaC:   TEXCOORD6,
                   //in  half  hFog:    FOG,
                   out half4  cOut:    COLOR0,
                   uniform bool bShadows,
                   uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  half4 cTex = tex2D(sBaseMap, vTexC);
  
  half4 Nt = tex2D(sNormalMap, vTexC);
  Nt.xyz = normalize(FixNorm(Nt));
  half3 Nw = mul(mTan, Nt);
  
  cTex.rgb *= cMd.a;
  cOut.rgb = CalcAD(cTex, Nw, vSunDirection, true);
  OverridePixelLight(cOut, mTan[0], cTex, cDiff.r);
  cOut.rgb += DecodeLight(cLightsFog.rgb, half4(cTex.rgb, 0), cDiff.r);
#if _COMPILE_ENV_MAP_ == 1  
  half4 cEnv = texCUBE(sEnvMap, reflect(V, Nw));
  cOut.rgb = lerp(cOut.rgb, cEnv.rgb, AddGloss(cTex, Nt).a);
#endif  
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = cTex.a * cMd.a; // GetAlpha(cTex, cDiff) * cMd.a; // GetAlpha doesn’t make sense for decals
  
//  if (bExplicitFog)
//    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    

  cOut.rgb = cOut.rgb * cLightsFog.a + cFogColor * (1 - cLightsFog.a) * cOut.a;
}



// Basic lighting w/o specular, glow (masked by base alpha):
void psGlow(in half4  cDiff:   COLOR0,
            in half3  cLights: COLOR1,
            in half2  vTexC:   TEXCOORD0,
            in half4  N:       TEXCOORD1,
            in float4 vShaC:   TEXCOORD3,
            in  half  hFog:    FOG,
            out half4 cOut:    COLOR0,
            uniform bool bShadows,
            uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 cTex = tex2D(sBaseMap, vTexC);
  half3 vOrgNorm = N.xyz;
  N.xyz = normalize(N.xyz);
  cOut.rgb = CalcAD(AddGloss(cTex, N), N, vSunDirection, cDiff.r);
  OverridePixelLight(cOut, vOrgNorm, cTex, cDiff.r);
  cOut.rgb = AddEmittance(cOut.rgb, AddGloss(cTex, N));
  cOut.rgb += DecodeLight(cLights, half4(cTex.rgb, 0), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = GetAlpha(cTex, cDiff);
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}



// Normal map, basic lighting w/o specular, glow (masked by base alpha):
void psGlowNormals(in half4  cDiff:   COLOR0,
                   in half3  cLights: COLOR1,
                   in half2  vTexC:   TEXCOORD0,
                   in half3  L:       TEXCOORD1,
                   in half3  H:       TEXCOORD2,
                   in float4 vShaC:   TEXCOORD3,
                   in half3  cDiffLight: TEXCOORD4,
                   in  half  hFog:    FOG,
                   out half4 cOut:    COLOR0,
                   uniform bool bShadows,
                   uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 N = tex2D(sNormalMap, vTexC);
  N.xyz = FixNorm(N);
  half4 cTex = tex2D(sBaseMap, vTexC);
  cOut.rgb = CalcAD(AddGloss(cTex, N), N, L, cDiff.r);
  OverridePixelLight(cOut, cDiffLight, cTex, cDiff.r);
  cOut.rgb = AddEmittance(cOut.rgb, AddGloss(cTex, N));
  cOut.rgb += DecodeLight(cLights, half4(cTex.rgb, 0), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  if (!COMPILE_DECALS)
    cOut.a = GetAlpha(N, cDiff);
  else
    cOut.a = cTex.a;
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
}


// Normal map, basic lighting w/o specular, glow (masked by base alpha):
void psGlowNormalsFog(in half4  cDiff:   COLOR0,
                      in half4  cLightsFog: COLOR1,
                      in half2  vTexC:   TEXCOORD0,
                      in half3  L:       TEXCOORD1,
                      in half3  H:       TEXCOORD2,
                      in float4 vShaC:   TEXCOORD3,
                      in half3  cDiffLight: TEXCOORD4,
                      in  half  hFog:    FOG,
                      out half4 cOut:    COLOR0,
                      uniform bool bShadows,
                      uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 N = tex2D(sNormalMap, vTexC);
  N.xyz = FixNorm(N);
  half4 cTex = tex2D(sBaseMap, vTexC);
  cTex.rgb *= cMd.a;
  cOut.rgb = CalcAD(AddGloss(cTex, N), N, L, cDiff.r);
  OverridePixelLight(cOut, cDiffLight, cTex, cDiff.r);
  cOut.rgb = AddEmittance(cOut.rgb, AddGloss(cTex, N));
  cOut.rgb += DecodeLight(cLightsFog.rgb, half4(cTex.rgb, 0), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = cTex.a * cMd.a; // GetAlpha(cTex, cDiff) * cMd.a; // GetAlpha doesn’t make sense for decals
  
//  if (bExplicitFog)
//    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    

  cOut.rgb = cOut.rgb * cLightsFog.a + cFogColor * (1 - cLightsFog.a) * cOut.a;
}

// Normal map, 2 base textures, lighting w/ specular, glow (masked by base texture 2 alpha):
void psMoltenSpot(in half4  cDiff:      COLOR0,
                  in half4  cLightsFog: COLOR1,
                  in half2  vTexC:      TEXCOORD0,
                  in half3  L:          TEXCOORD1,
                  in half3  H:          TEXCOORD2,
                  in float4 vShaC:      TEXCOORD3,
                  in half3  cDiffLight: TEXCOORD4,
                  in  half  hFog:       FOG,
                  out half4 cOut:       COLOR0,
                  uniform bool bShadows,
                  uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 N = tex2D(sNormalMap, vTexC);
  N.xyz = FixNorm(N);
  half4 cTex = tex2D(sBaseMap, vTexC);
  half4 cTex2 = tex2D(sBaseMap2, vTexC);
  cTex.rgb = lerp(cTex.rgb, cTex2.rgb, fBlendAlpha);
  cOut.rgb = CalcADS(AddGloss(cTex, N), H, N, L, cDiff.r);
  OverridePixelLight(cOut, cDiffLight, cTex, cDiff.r);
  cOut.rgb = AddEmittance(cOut.rgb, AddGloss(cTex, N), half4(cMe * cTex.a, cTex2.a * (1 - fBlendAlpha)), false);
  cOut.rgb += DecodeLight(cLightsFog, AddGloss(cTex, N), cDiff.r);
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = cTex.a; // GetAlpha(cTex, cDiff); // GetAlpha doesn’t make sense for decals
  cOut *= cMd.a;
  
//  if (bExplicitFog)
//    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
  cOut.rgb = cOut.rgb * cLightsFog.a + cFogColor * (1 - cLightsFog.a) * cOut.a;
}

// Molten Area shader - base map and a glow phase displacement mask in the base alpha. Additive blending.
void psMoltenArea(in half4  cDiff:      COLOR0,
                  in half4  cLightsFog: COLOR1,
                  in half2  vTexC:      TEXCOORD0,
                  in half3  L:          TEXCOORD1,
                  in half3  H:          TEXCOORD2,
                  in float4 vShaC:      TEXCOORD3,
                  in  half  hFog:       FOG,
                  out half4 cOut:       COLOR0,
                  uniform bool bShadows,
                  uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  half4 cTex = tex2D(sBaseMap, vTexC);

  half fGlow = lerp(fGlowMin, fGlowMax, sin((cTex.a + fGlowTime) * 2 * PI));

  cOut.rgb = cTex.rgb * cMe * fGlow;
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = cMd.a; // GetAlpha(cMd, cDiff); // GetAlpha doesn’t make sense for decals
}

// Normal map, clear coating, no pigment map (EM & spec. lighting are masked by base alpha):
void psDeepIce(in half4   cDiff:   COLOR0,
               in half3   cLights: COLOR1,
               in half2   vTexC:   TEXCOORD0,
               in half3x3 mTan:    TEXCOORD1,
               in half3   H:       TEXCOORD4,
               in half3   V:       TEXCOORD5,
               in float4  vShaC:   TEXCOORD6,
               in  half  hFog:    FOG,
               out half4  cOut:    COLOR0,
               uniform bool bShadows,
               uniform bool bExplicitFog)
{
  FixVertexColor(cDiff);
  if (bShadows)
    cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC);
    //cDiff.r *= CalcShadowShadowBuffer(sShadowMap, vShaC.xy, vShaC.z);

  half4 N = tex2D(sNormalMap, vTexC);
  half3 H1 = -cross(H, cross(H, V));
  N.xyz = mul(FixNorm(N.xyz), mTan);
  
  V = normalize(V);

  half LdotN = dot(normalize(vSunDirection), N);
  half HdotN = dot(normalize(H), N);
  half H1dotN = dot(normalize(H1), N);
  half VdotN = dot(V, N);
  
  half  hFacing = 1.0 - max(VdotN, 0);
  half  hFresnel = pow(hFacing, 3.0); // 6.0 for ice?
  
  half ka = CalcBacklightMultiplier(fTerrainBacklightStrength, LdotN);
  half kd = saturate(LdotN) * cDiff.r;
  half ks = pow(saturate(HdotN), fShininess) * saturate(4 * LdotN) * cDiff.r * hFacing * N.a;
  half ks1 = pow(saturate(H1dotN), fShininess) * saturate(-4 * LdotN) * hFacing * N.a;

  //ks = pow(ks, fShininess);

  half4 cTex  = half4(0.0, 0.25, 0.15, 1.0);
  half3 cSurf = lerp(cMd.rgb, cCoatingColor.rgb, hFacing); //hFacing * cCoatingColor.a * lerp(fCoatingThickness, 1, hFacing)
  
  cOut.rgb  = cSurf *
              (ka.rrr * (cMa * cAmbientLight) +
               kd.rrr * (cMd * cSunColor));
               
  //cOut.rgb  = ka * cMa * cAmbientLight;
  //cOut.rgb += kd * cMd * cSunColor * cDiff.r;
  cOut.rgb = cSurf;
  
  cOut.rgb += ks.rrr * (cMs * cSunSpecColor);
  cOut.rgb += ks1.rrr * (cMs * cAmbientLight);

  //cOut.rgb = lerp(cOut.rgb, cEnv, hFresnel * AddGloss(cTex, N).a);
#if _COMPILE_ENV_MAP_ == 1
  half3 cEnv  = texCUBE(sEnvMap, reflect(-V, N));
        cEnv  *= (1.0 + cEnv.ggg);
  cOut.rgb = lerp(cOut.rgb, cEnv, hFresnel * N.aaa);
#endif  
  //cOut.rgb += cEnv * hFresnel.rrr * N.aaa;
  //cOut.rgb = step(0.075, N.aaa);
  //cOut.rgb = cEnv;
  cOut.rgb *= GetFoWColor(cDiff);
  cOut.a = GetAlpha(1, cDiff);
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, hFog);    
  
}

#endif