#ifndef __UTILITY_FXH
#define __UTILITY_FXH

// Common shader map indices: ----------------------------------------
// 0 - environment map
// 1 - projected shadows map
// 2 - noise
// 3 - blending mask (used to blend all terrain splats) / misc masks texture for non-terrain shaders (a - player color, r - glow mask, b - dark mask, g - opacity)
// 4 - caustics map / zpass map / vision map
// 5 - second base texture
// 6 - volumetric occlusion map
// 7 - offscreen copy map (for frame distortion effects)

// Utility constants -------------------------------------------------

#define PI  3.1415926

#define CWEVALUE (RED | GREEN | BLUE)

#define CWEVALUEFULL (RED | GREEN | BLUE | ALPHA)

#define BONES_PER_PARTITION   40
#define MAX_LIGHTS            4

static const float3 vLuma = {0.3f, 0.59f, 0.11f};


// Common globals provided by the runtime ----------------------------

// Wind:
half      fWindPower: GLOBAL = 1.0f;
half3     vWindDirection: GLOBAL = { 0.0f, 0.0f, 0.0f };


// Camera params:
half fNearPlane         : GLOBAL;
half fFarPlane          : GLOBAL;
float3 vWorldCamera     : GLOBAL /*CAMERAPOSITION*/ = { 0.0f, 0.0f, 0.0f };
  
// Fog:
half  fFogDepth         : GLOBAL;
half  fFogFarPlane      : GLOBAL;
half3 cFogColor         : FOGCOLOR <bool color = true;> = { 1.0f, 1.0f, 1.0f };

// World:
float3 vMapDimMin       : GLOBAL;  // Minimum of map dimentions in world units
float3 vMapDimMax       : GLOBAL;  // Maximum of map dimentions in world units
float fVOCoordScale     : GLOBAL;  // VO tex coords scaler (needed for maps with non power of 2 sizes)


// Lighting:
half3 vSunDirection     : GLOBAL /*LIGHTDIRECTION*/ <string UIDirectional = "Light Direction";> = { 0.577, 0.577, 0.577 };
half3 cSunColor         : GLOBAL /*LIGHTDIFFUSE  */ <bool color = true;> = { 1.0f, 1.0f, 1.0f };
half3 cAmbientLight     : GLOBAL /*LIGHTAMBIENT  */ <bool color = true;> = { 1.0f, 1.0f, 1.0f };
half3 cSunSpecColor     : GLOBAL /*LIGHTSPECULAR */ <bool color = true;> = { 1.0f, 1.0f, 1.0f };
half  fBrightness       : GLOBAL = 1.0;
half  fSkyBrightness    : GLOBAL = 1.0;
half  fBacklightStrength: GLOBAL = 0.5;
half  fRimlightStrength : GLOBAL = 10.0;
half  fCameraSpecular   : GLOBAL = 1.0;

// Additional per-object lights:
int    LightCount                   : ATTRIBUTE <bool hidden = true;> = MAX_LIGHTS; // Count of active lights
float4 LightPositions   [MAX_LIGHTS]: ATTRIBUTE <bool hidden = true;>; // In world coordinates
float4 LightDirections  [MAX_LIGHTS]: ATTRIBUTE <bool hidden = true;>; // Applicable for spot lights only, w component contains the max distance the light affects
half4  LightColors      [MAX_LIGHTS]: ATTRIBUTE <bool hidden = true;>; // RGB, used for per-vertex diffuse lighting, w component used to convert the light to ambient instead of directional
float4 LightAttenuations[MAX_LIGHTS]: ATTRIBUTE <bool hidden = true;>; // Constant, linear, and quadratic att., dimmer
float4 LightSpotParams  [MAX_LIGHTS]: ATTRIBUTE <bool hidden = true;>; // Spot angle, spot exponent

// Auras:
half3 cAuraFriendly     : GLOBAL = { -15 / 255, -30 / 255, -15 / 255 };
half3 cAuraHostile      : GLOBAL = { -15 / 255, -30 / 255, -15 / 255 };

// Material properties:
half3 cMa               : MATERIALAMBIENT  = { 0.5, 0.5, 0.5 };
half4 cMd               : MATERIALDIFFUSE  = { 0.5, 0.5, 0.5, 1.0 };
half3 cMs               : MATERIALSPECULAR = { 0.0, 0.0, 0.0 };
half  fShininess        : MATERIALPOWER    = 1.0;
half3 cMe               : MATERIALEMISSIVE = { 0.0, 0.0, 0.0 };

//half  fBumpScale       : ATTRIBUTE = 0.05;

// Texture transform matrices
half4x4 mTexBase        : TEXTRANSFORMBASE;
half4x4 mTexBaseTrans   : TEXTRANSFORMBASETRANSPOSE;

// Skin and bone transformations:
#define WEIGHTTYPE   half3
float4x4  mSkinWorldViewProj  : SKINWORLDVIEWPROJ;
half4x4   mInvSkinWorldTrans  : INVSKINWORLDTRANS <bool hidden = true;>;
float4x4  mSkinWorld          : SKINWORLD <bool hidden = true;>;
// force_used annotation is an override that tells the buggy Gamebryo that in the shaders pointed in the anno text this parameter is USED, no matter what buggy DirectX says about it. Shaders names are prefixes and can be comma separated.
float4x3  mBone[BONES_PER_PARTITION] : BONEMATRIX4 <string force_used = "_Embel_Item_Skin";>;

//shadows
//float4x4  mShadowLightTrans   : GLOBAL;
float4x4  mShadowCombinedTrans   : GLOBAL;
float4x4  mShadowAfterLightTrans   : GLOBAL;

// HUFX settings
int iFaction :  ATTRIBUTE <bool hidden = true;> = 0;  // 0 means stencil states are off; > 0 specifies a faction
int iOccluder : ATTRIBUTE <bool hidden = true;> = 1;  // 0 - HUFX occluder states off; != 0 - HUFX occluder states on

// Visual detail options
int iMinFilter     : GLOBAL = 3;     // Anisotropic filtering by default
int iMaxAnisotropy : GLOBAL = 4;
int iMipMapLODBias : GLOBAL = 0;

#define _TEXTURE_FOG_ 1

#ifndef _SHADER_DETAIL_
#define _SHADER_DETAIL_ 0
#endif

#ifndef _VS2X_
#define _VS2X_ vs_2_a
#endif

#ifndef _PS2X_
#define _PS2X_ ps_2_a
#endif

// detail level defines
//#undef _SHADER_DETAIL_
//#define _SHADER_DETAIL_ 3

#if _SHADER_DETAIL_ >= 1
	#define _COMPILE_VO_ 0
	#define _COMPILE_LOCAL_LIGHTS_ 0
	#define _COMPILE_CAMERA_SPECULAR_ 0
#endif	
#if _SHADER_DETAIL_ >= 2
	#define _COMPILE_ENV_MAP_ 0
	#define _COMPILE_BACKLIGHT_ 0
	#define _COMPILE_PIXEL_SPECULAR_ 0
#endif	
#if _SHADER_DETAIL_ >= 3
	#define _COMPILE_NORMAL_MAP_ 0
#endif

#ifndef _COMPILE_VO_
#define _COMPILE_VO_ 1
#endif

#ifndef _COMPILE_LOCAL_LIGHTS_
#define _COMPILE_LOCAL_LIGHTS_ 1
#endif

#ifndef _COMPILE_CAMERA_SPECULAR_
#define _COMPILE_CAMERA_SPECULAR_ 1
#endif

#ifndef _COMPILE_ENV_MAP_
#define _COMPILE_ENV_MAP_ 1
#endif

#ifndef _COMPILE_BACKLIGHT_
#define _COMPILE_BACKLIGHT_ 1
#endif

#ifndef _COMPILE_PIXEL_SPECULAR_
#define _COMPILE_PIXEL_SPECULAR_ 1
#endif

#ifndef _COMPILE_NORMAL_MAP_
#define _COMPILE_NORMAL_MAP_ 1
#endif

#ifndef _COMPILE_ATI_SHADOWS_
#define _COMPILE_ATI_SHADOWS_ 0
#endif

// Textures and samplers -----------------------------------------

#if _COMPILE_ATI_SHADOWS_ != 1
#define SHADOW_SAMPLER_STATES   MinFilter = Linear; MagFilter = Linear; MipFilter = None; \
                                MipMapLODBias = 0;                                        \
                                AddressU = Clamp; AddressV = Clamp
#define RESET_BIAS              MipMapLODBias = 0
#else
#define SHADOW_SAMPLER_STATES   MinFilter = Point; MagFilter = Point; MipFilter = None;       \
                                MipMapLODBias = 0x34544547;                                   \
                                AddressU = Clamp; AddressV = Clamp
//#define RESET_BIAS              MipMapLODBias = 'G' | ('E' << 8) | ('T' << 16) | ('1' << 24)
#define RESET_BIAS              MipMapLODBias = 0
#endif


// Utility shared functions for all shaders ----------------------

half SlopedStep(half fMin, half fMax, half fX)  // Does the same as smoothstep except it interpolates linearly
{
  return saturate((fX - fMin) / (fMax - fMin));
}

half CalcFog(const half fDepth, const half fNearPlane, const half fFarPlane, const half fFogDepth)
{
  half fFog, fStart;
  
//  fFog = saturate(lerp(1, (vViewZ - fNearPlane) / (fFarPlane - fNearPlane), 1 / fFogDepth));
//  fFog = saturate(((vViewZ - fNearPlane) / (fFarPlane - fNearPlane) + fFogDepth - 1.0) / fFogDepth);
//  fFog = 1.0 - fFog * fFog;
  fFog = saturate((fFogFarPlane - fDepth) / ((fFogFarPlane - fNearPlane) * fFogDepth));
  
  return fFog;
}

half3 CalcVOCoords(float3 vWorld, float3 vMapDimMin, float3 vMapDimMax)
{
#if _COMPILE_VO_ == 1
  half3 v = (vWorld - vMapDimMin) / (vMapDimMax - vMapDimMin);
  v.xy *= fVOCoordScale;
  return v;
  //return (vWorld - vMapDimMin) / (vMapDimMax - vMapDimMin);
#else
  return 0;
#endif
}

#if _TEXTURE_FOG_ == 1
half3 CalcVOFogCoords(float3 vWorld, float3 vMapDimMin, float3 vMapDimMax)
{
  half3 v = (vWorld - vMapDimMin) / (vMapDimMax - vMapDimMin);
  v.xy *= fVOCoordScale;
  return v;
}
#else
#define CalcVOFogCoords CalcVOCoords
#endif

void SetTextureVision(in out half fVision, sampler2D sVision, half2 vCoords)
{
#if _TEXTURE_FOG_ == 1
  vCoords.xy /= fVOCoordScale;
  fVision = tex2D(sVision, vCoords).a;
#endif
}

half Line(half fX, half fX1, half fX2, half fY1, half fY2)
{
  return (fY1 * (fX - fX2) + fY2 * (fX1 - fX)) / (fX1 - fX2);
}

half2 Line2(half2 vX, half2 vX1, half2 vX2, half2 vY1, half2 vY2)
{
  return vY1 + (vX - vX1) * (vY2 - vY1) / (vX2 - vX1);
}


// These are the constraints for the following function:
// VO(vSample.x) = 0
// VO(vSample.y) = 1
// VO(vSample.z) = vSample.w
half CalcVO(sampler2D sOcclusion, half3 vCoord)
{
#if _COMPILE_VO_ == 1
//  half fVO, fHeight;
  half4 vSample = tex2D(sOcclusion, vCoord.xy);
/*  fHeight = vCoord.z;
  if (fHeight < vSample.z)
    fVO = Line(fHeight, vSample.x, vSample.z, 0, vSample.w);
  else 
    fVO = Line(fHeight, vSample.z, vSample.y, vSample.w, 1);
*/    
  half2 vVO;
  half fVO;
  vVO = Line2(vCoord.zz, vSample.xy, vSample.zz, half2(0, 1), vSample.ww);
  if (vCoord.z < vSample.z)
    fVO = vVO.x;
  else 
    fVO = vVO.y;
    
  return saturate(fVO);
#else
  return 1;
#endif
}

half CalcVO1(sampler2D sOcclusion, half3 vCoord)
{
  //return tex3D(sOcclusion, vCoord).a;
  return tex2D(sOcclusion, vCoord).a;
}

half3 CalcReflection(float3 vPos, half3 vNormal, float3 vCamera)
{
  return reflect((half3) normalize(vPos - vCamera), vNormal);
}

half3 CalcHalfway(float3 vPos, half3 vLight, float3 vCamera)
{
  return normalize((half3) normalize(vCamera - vPos) + vLight);
}

//Gram-Schmidt orthogonalization (orthonormalization actually)
void Orthogonalize(in out float3 vX, in out float3 vY, in out float3 vZ)
{
  vX = normalize(vX);
  vY = normalize(vY - dot(vY, vX) * vX);
  vZ = normalize(vZ - dot(vZ, vX) * vX - dot(vZ, vY) * vY);
}

half3x3 TransformTangentSpace(in half3x3 mTan, bool bNormalize = false)
{
#if _COMPILE_NORMAL_MAP_ == 1
  half2x2 mTexRot;
  
  mTexRot = half2x2(mTexBaseTrans[0].xy, mTexBaseTrans[1].xy);
  if (bNormalize) {
    mTexRot[0] = normalize(mTexRot[0]);
    mTexRot[1] = normalize(mTexRot[1]);
  }
  (half2x3) mTan = mul(mTexRot, (half2x3) mTan);
#else
  // do nothing?
#endif  
  return mTan;
}

// mTexRotTrans is assumed to be already transposed rotation matrix
half3x3 TransformTangentSpaceMat(in half3x3 mTan, in half2x2 mTexRotTrans, bool bNormalize = false)
{
  if (bNormalize) {
    mTexRotTrans[0] = normalize(mTexRotTrans[0]);
    mTexRotTrans[1] = normalize(mTexRotTrans[1]);
  }
  (half2x3) mTan = mul(mTexRotTrans, (half2x3) mTan);
  return mTan;
}

half3x3 CalcTangentSpace(half3 vNorm, half3 vBin, half3 vTan, half3x3 mXForm, uniform bool bTexXForm = false)
{
	half3x3 mTan;
#if _COMPILE_NORMAL_MAP_ == 1
  mTan = half3x3(vTan, vBin, vNorm);
  if (bTexXForm)
    mTan = TransformTangentSpace(mTan);
  mTan = mul(mTan, mXForm);
  mTan[0] = normalize(mTan[0]);
  mTan[1] = normalize(mTan[1]);
  mTan[2] = normalize(mTan[2]);
#else
  mTan[0] = half3(1, 0, 0);
  mTan[1] = half3(0, 1, 0);
  mTan[2] = mul(vNorm, mXForm);
  mTan[2] = normalize(mTan[2]);
#endif  
  return mTan;
}

half3 CalcAdditionalLights(float3 vPos, half3 vNorm)
{
#if _COMPILE_LOCAL_LIGHTS_ == 1
  half3 cLightSum = 0.0;
  
  for (int i = 0; i < LightCount; i++)
  {
    half3 L = normalize(LightPositions[i] - vPos);
    half NdotL = saturate(dot(vNorm, L) + LightColors[i].w);
    float d = distance(LightPositions[i], vPos);
    float fMaxDist = LightDirections[i].w;
    //float fAttenuation = dot(LightAttenuations[i], float3(1.0, d, d * d));
    //float fSpot = pow(saturate((dot(L, -LightDirections[i]) -  LightSpotParams[i].x) / (1.0 - LightSpotParams[i].x)),
    //                  LightSpotParams[i].y);
    //half3 cLight = (LightColors[i] * NdotL * LightAttenuations[i].w) / fAttenuation;
    //cLight *= SlopedStep(fMaxDist, 0.9 * fMaxDist, d);
    
    //cLight *= lerp(1.0, fSpot, LightSpotParams[i].z);

    float fAttenuation = LightColors[i].w? smoothstep(fMaxDist, 0.9 * fMaxDist, d): saturate(1.0 - d / fMaxDist);
    float fSpot = pow(saturate((dot(L, -LightDirections[i]) -  LightSpotParams[i].x) / (1.0 - LightSpotParams[i].x)),
                      LightSpotParams[i].y);
    half3 cLight = LightColors[i] * NdotL * LightAttenuations[i].w * fAttenuation;
    cLight *= lerp(1.0, fSpot, LightSpotParams[i].z);
    
    cLightSum += cLight;
  }
  return cLightSum;
#else
  return 0;
#endif  
}

half3 EncodeLight(in half3 cLight, in half3 cSpecular)
{
#if _COMPILE_LOCAL_LIGHTS_ == 1
  return (cLight + 4) / 8;
#elif _COMPILE_PIXEL_SPECULAR_ != 1
	return (cSpecular + 1) / 2;
#else
  return 0;	
#endif  
}

half3 DecodeLight(in half3 cLight, in half4 cTex, in half fShadow)
{
#if _COMPILE_LOCAL_LIGHTS_ == 1
  return (cLight * 8 - 4) * cTex.rgb;
#elif _COMPILE_PIXEL_SPECULAR_ != 1
	return (cLight * 2 - 1) * (cTex.a * fShadow);
#else
  return 0;	
#endif
}

half CalcBacklightMultiplier(half fBacklight, half fNdotL)
{
#if _COMPILE_BACKLIGHT_ == 1
	return (1 + fBacklight * saturate(-fNdotL));
#else
	return 1;
#endif
}

half4 CalcAmbDiff(half3 cAmbColor, half4 cDiffColor, 
                  half3 cAmbLight, half3 cDiffLight, half4 cTexel,
                  half fBacklight, half3 vNorm, half3 vLight, half fShadow=1)
{
  half fNdotL = dot(vNorm, vLight);
  half4 cRes;
  
  cRes.rgb = cAmbColor * cAmbLight;
  cRes.rgb *= CalcBacklightMultiplier(fBacklight, fNdotL);
  cRes.rgb += cDiffColor * cDiffLight * saturate(fNdotL) * fShadow;
  cRes.rgb *= cTexel.rgb;
  cRes.a = cDiffColor.a;
  
  return cRes;
}

half3 CalcSpec(half3 cSpecColor, half3 cSpecLight, half fSpecPower, 
               half3 vHalf, half3 vNorm, half3 vLight, half fShadow=1)
{
#if _COMPILE_PIXEL_SPECULAR_ != 1
  half fNdotL, fSpec;
  half3 cRes;
  
  fNdotL = dot(vNorm, vLight);
  fSpec = pow(saturate(dot(vNorm, vHalf)), fSpecPower) * saturate(4 * fNdotL);
  cRes = cSpecColor * cSpecLight * (fSpec * fShadow);
  return cRes;
#else
  return 0;
#endif  
}

void CalcVertAmbDiff(in out half3 cOut, half3 cAmbColor, half3 cDiffColor, 
                     half3 cAmbLight, half3 cDiffLight,
                     half fBacklight, half3 vNorm, half3 vLight, half fShadow=1)
{
#if _COMPILE_NORMAL_MAP_ == 0
  half fNdotL = dot(vNorm, vLight);
  
  cOut.rgb = cAmbColor * cAmbLight;
  cOut.rgb *= CalcBacklightMultiplier(fBacklight, fNdotL);
  cOut.rgb += cDiffColor * cDiffLight * saturate(fNdotL) * fShadow;
#endif
}

void OverridePixelLight(in out half4 cOut, half3 cVertDiff, half4 cTex, half fShadow)
{
#if _COMPILE_NORMAL_MAP_ == 0
  cOut = cTex;
  cOut.rgb *= cVertDiff;
  half fShadowedCoef = dot(vLuma, cAmbientLight) / dot(vLuma, (cAmbientLight + dot(half3(0, 0, 1), vSunDirection) * cSunColor));
  cOut.rgb *= lerp(fShadowedCoef, 1, fShadow);
#endif
}

half4 CalcAmbDiffSpec(half3 cAmbColor, half4 cDiffColor, half3 cSpecColor, half fSpecPower, 
                      half3 cAmbLight, half3 cDiffLight, half3 cSpecLight, half4 cTexel,
                      half fBacklight, half3 vHalf, half3 vNorm, half3 vLight, half fShadow=1)
{
  half fNdotL;
  half4 cRes;
  
  fNdotL = dot(vNorm, vLight);

  cRes.rgb = cAmbColor * cAmbLight;
  cRes.rgb *= CalcBacklightMultiplier(fBacklight, fNdotL);
  cRes.rgb += cDiffColor * cDiffLight * saturate(fNdotL) * fShadow;
  cRes.rgb *= cTexel.rgb;

#if _COMPILE_PIXEL_SPECULAR_ == 1
  half fSpec = pow(saturate(dot(vNorm, vHalf)), fSpecPower) * saturate(4 * fNdotL);
  // The parentheses on the next line are VERY important. Without them the calculation becomes a vector one and bugs.
  cRes.rgb += cSpecColor * cSpecLight * (fSpec * cTexel.a * fShadow);
#if _COMPILE_CAMERA_SPECULAR_ == 1
  // Only calculate camera specular if so specified
  half fSpec1;
  half3 vCam = normalize(reflect(vLight, vHalf));
  half fNdotV = -dot(vNorm, vCam);
  fSpec1 = pow(saturate(fNdotV), fSpecPower) * saturate(4 * fNdotV) * fCameraSpecular;
  cRes.rgb += cSpecColor * cAmbLight * (fSpec1 * cTexel.a);
#endif
#endif
  cRes.a = cDiffColor.a;
  return cRes;
}



half4 CalcAmbDiffSpecRim(half3 cAmbColor, half4 cDiffColor, half3 cSpecColor, half fSpecPower, 
                         half3 cAmbLight, half3 cDiffLight, half3 cSpecLight, half4 cTexel,
                         half fBacklight, half3 vCam, half3 vNorm, half3 vLight, half fShadow=1)
{
  half fNdotL, fSpec, fRim;
  half3 vHalf = normalize(vLight + vCam);
  half4 cRes;
  
  fNdotL = dot(vNorm, vLight);
  fSpec = pow(saturate(dot(vNorm, vHalf)), fSpecPower) * saturate(4 * fNdotL);
  
  fRim = saturate(1 - dot(vCam, vNorm));
  fRim *= fRim;
  fRim *= pow(saturate(1 + fNdotL), 3);
  fRim *= saturate(-dot(vCam, vLight));
  fRim *= fRimlightStrength;

  cRes.rgb = CalcBacklightMultiplier(fBacklight, fNdotL) * cAmbColor * cAmbLight;
  cRes.rgb += cDiffColor * cDiffLight * (fRim + saturate(fNdotL)) * fShadow;
  cRes.rgb *= cTexel.rgb;
  // The parentheses on the next line are VERY important. Without them the calculation becomes a vector one and bugs.
  cRes.rgb += cSpecColor * cSpecLight * (fSpec * cTexel.a * fShadow);
  cRes.a = cDiffColor.a;
  
  return cRes;
}


half4 CalcGlow(half4 cDiffColor, half4 cTexel, half3 cEmisColor, half fEmisAlpha)
{
  half3 cDiff, cTex, cEmis;
  half4 cRes;
  
  cDiff = cDiffColor.rgb * cTexel.rgb;
  cTex = lerp(cTexel, cEmisColor, fEmisAlpha);
  cEmis = cDiffColor.rgb * cTex + cTex;
  cRes.rgb = lerp(cDiff, cEmis, cTexel.aaa);
  cRes.a = cDiffColor.a;
  
  return cRes;
}

half3 GetEnvironmentColor(samplerCUBE sEnv, float3 vPos, half3 vNormal, float3 vCamera, half3 cEnvMat)
{
#if _COMPILE_ENV_MAP_ == 1
	half3 vRef, cEnv;
  vRef = CalcReflection(vPos, vNormal, vCamera);
  cEnv = texCUBE(sEnv, vRef);
  cEnv *= cEnvMat;
  return cEnv;
#else
	return 0;
#endif
}

half4 BlendEnvironment(half4 cDiff, half3 cEnv, half fWeight, uniform bool bCapBrightness = false)
{
#if _COMPILE_ENV_MAP_ == 1
  half4 cRes;
  if (bCapBrightness)
    cRes.rgb = cDiff.rgb + cEnv * fWeight * max(dot(cEnv, vLuma), 0.5);
  else 
    cRes.rgb = cDiff.rgb + cEnv * fWeight * dot(cEnv, vLuma);
  cRes.a = cDiff.a;
  return cRes;
#else
  return cDiff;
#endif
}

float4x3 GetBlendMatrix(in  half4      vBlendIndices: BLENDINDICES, 
                        in  WEIGHTTYPE vBlendWeights: BLENDWEIGHT,
                        uniform int iBonesPerVertex)
{
  float4x3 mRes;
  half4 vIndices;
  
  vIndices = vBlendIndices.zyxw * 255.01;  // Un-swizzle the indices and convert them to INT with a bit larger scale to offset rounding errors
//  vBlendWeights = vBlendWeights.zyx;
  if (iBonesPerVertex == 1) {
    mRes = mBone[vIndices.x];
  } else if (iBonesPerVertex == 4) {
    half vLastWeight = 1 - dot(vBlendWeights, half3(1, 1, 1));
    mRes = mBone[vIndices.x] * vBlendWeights.x;
    mRes += mBone[vIndices.y] * vBlendWeights.y;
    mRes += mBone[vIndices.z] * vBlendWeights.z;
//    mRes += mBone[vIndices.w] * vBlendWeights.w;
    mRes += mBone[vIndices.w] * vLastWeight;
  } else mRes = 0; // Other numbers of bones are not supported
  return mRes;  
}

float4x3 GetBlendMatrix1(in  half4   vBlendIndices: BLENDINDICES, 
                        in  half3   vBlendWeights: BLENDWEIGHT,
                        uniform int iBonesPerVertex)
{
  float4x3 mRes;
  half4 vIndices;
  
  vIndices = vBlendIndices.zyxw * 255.01;  // Un-swizzle the indices and convert them to INT with a bit larger scale to offset rounding errors
  if (iBonesPerVertex == 1) {
    mRes = mBone[vIndices.x];
  } else if (iBonesPerVertex == 4) {
    half vLastWeight = 1 - dot(vBlendWeights, half3(1, 1, 1));
    mRes = mBone[vIndices.x] * vBlendWeights.x;
    mRes += mBone[vIndices.y] * vBlendWeights.y;
    mRes += mBone[vIndices.z] * vBlendWeights.z;
    mRes += mBone[vIndices.w] * vLastWeight;
  } else mRes = 0; // Other numbers of bones are not supported
  return mRes;  
}

half CalcShadow(sampler2D sShadowMap, const float2 vShaC)
{
  return tex2D(sShadowMap, vShaC).r;
}


half GetEdgenessAlpha(float2 G)
{
  return saturate(min(min(G.x - vMapDimMin.x, vMapDimMax.x - G.x), min(G.y - vMapDimMin.y, vMapDimMax.y - G.y)) / 200.0f);
}

//called in pixel shaders

/*
// generic unfiltered shadow texture sampling
half CalcShadowShadowBuffer(sampler2D sShadowMap, const float2 vShaC, const float fZ)
{
  half hShadow = 1;
  float4 fTexZ = tex2D(sShadowMap, vShaC);
  if(fTexZ.r < fZ) 
    hShadow = 0;
  return hShadow;
}

half CalcShadowShadowBuffer1(sampler2D sShadowMap, const float3 vShaC, const float4 vShaCLight)
{
  float4 tc;
  //tc.x = (vShaC.x / vShaC.z) * 0.5f + 0.5f;
  //tc.y = -(vShaC.y / vShaC.z) * 0.5f + 0.5f;
  //tc.z = (vShaCLight.z / vShaCLight.w) * 0.5f + 0.5f;
  //tc.w = 1;
  
  tc.x = (vShaC.x / vShaC.z);
  tc.y = -(vShaC.y / vShaC.z);
  tc.z = (vShaCLight.z / vShaCLight.w);
  tc.w = 1;
  
  tc = tc * 0.5f + 0.5f;
  
  half hShadow = 1;
  float4 fTexZ = tex2D(sShadowMap, tc.xy);
  if(fTexZ.r < tc.z) 
    hShadow = 0;
  return hShadow;
}
*/


// nvidia hardware shadow texture sampling (pcf & stuff)
half CalcShadowShadowBuffer11(sampler2D sShadowMap, const float2 vShaC, const float fZ)
{
  float4 tc;
  tc.x = vShaC.x;
  tc.y = vShaC.y;
  tc.z = fZ;
  tc.w = 1;
  half hShadow = tex2Dproj(sShadowMap, tc).r;
  return hShadow;
}


half CalcShadowShadowBuffer(sampler2D sShadowMap, const float4 vShaC)
{ 
#if _COMPILE_ATI_SHADOWS_ > 0
  float4 tc;
  //tc.x = (vShaC.x / vShaC.w) * 0.5f + 0.5f;
  //tc.y = -(vShaC.y / vShaC.w) * 0.5f + 0.5f;
  //tc.z = vShaCLight.z * 0.5f + 0.5f;
  //tc.w = 1;
  
  tc.x = (vShaC.x / vShaC.w);
  tc.y = -(vShaC.y / vShaC.w);
  tc.z = vShaC.z;
  tc.w = 1;
  
  tc = tc * 0.5f + 0.5f;

#if _COMPILE_ATI_SHADOWS_ == 1  
  float4 res = tex2Dproj(sShadowMap, tc);
  res = (res > tc.z);
  half hShadow = (res.r + res.b + res.g + res.a) / 4;
  hShadow = res.r;
//  half hShadow = tex2Dproj(sShadowMap, tc).r;
#else 
  half hShadow = tex2D(sShadowMap, tc).r;
  hShadow = (hShadow > tc.z);
#endif
  return hShadow;
#else
  float4 tc;
  //tc.x = (vShaC.x / vShaC.w) * 0.5f + 0.5f;
  //tc.y = -(vShaC.y / vShaC.w) * 0.5f + 0.5f;
  //tc.z = vShaCLight.z * 0.5f + 0.5f;
  //tc.w = 1;
  
  tc.x = (vShaC.x / vShaC.w);
  tc.y = -(vShaC.y / vShaC.w);
  tc.z = vShaC.z;
  tc.w = 1;
  
  tc = tc * 0.5f + 0.5f;
  
  
  half hShadow = tex2Dproj(sShadowMap, tc).r;
  return hShadow;
#endif  
}

/*

//poisson filtered shadow sampling

#define TEXEL_OFFSET (1.0f / 2048.0f)

#define POISSON_SAMPLES_COUNT 12

half CalcShadowShadowBuffer(sampler2D sShadowMap, const float2 vShaC, const float fZ)
{

  float2 vPoissonSamples[POISSON_SAMPLES_COUNT] = 
  {
  {-0.326212f, -0.405805f},
  {-0.840144f, -0.07358f},
  {-0.695914f,  0.457137f},
  {-0.203345f,  0.620716f},
  { 0.96234f,  -0.194983f},
  { 0.473434f, -0.480026f},
  { 0.519456f,  0.767022f},
  { 0.185461f, -0.893124f},
  { 0.507431f,  0.064425f},
  { 0.89642f,   0.412458f},
  {-0.32194f,  -0.932615f},
  {-0.791559f, -0.597705f}
  };


  float2 vTexCoords[POISSON_SAMPLES_COUNT];
  
  float fScale = 3.0f*TEXEL_OFFSET;
   
  // Sample each of them checking whether the pixel under test is shadowed or not
  float fShadow;
  float fTotalSum = 0.0f;
  for( int i = 0; i < POISSON_SAMPLES_COUNT; i++ )
  {
    vTexCoords[i] = vShaC + vPoissonSamples[i]*fScale;
    
    float fTexZ = tex2D( sShadowMap, vTexCoords[i] ).r;

    fShadow = (fTexZ < fZ) ? 0.0f : 1.0f;
    fTotalSum += fShadow;
  }
  
  fTotalSum /= POISSON_SAMPLES_COUNT;
  return fTotalSum;
}
#undef TEXEL_OFFSET
*/
/*
//called in vertex shaders
//calculates shadow texture coordinates & vertex Z as seen from the light
void CalcShadowBufferUVZ1(in float4 vPos, out float2 vShaC, out float fZ)
{
  float4 tmp = mul(vPos, mShadowLightTrans);
  float4 vShadTexC = mul(tmp, mShadowAfterLightTrans);
  
  vShadTexC /= vShadTexC.w;

  vShadTexC.x = 0.5f * vShadTexC.x + (0.5f + (1.0f / 4096.0f));
  vShadTexC.y = -0.5f * vShadTexC.y + (0.5f + (1.0f / 4096.0f));
  vShaC = vShadTexC;

  fZ = vShadTexC.z;
}
*/

void CalcShadowBufferTexCoords(in float4 vPos, out float4 vShaC)
{
//  float4 tmp = mul(vPos, mShadowLightTrans);
//  float4 tmp1 = mul(tmp, mShadowAfterLightTrans);

  float4 tmp1 = mul(vPos, mShadowCombinedTrans);
  
  // maintain z in lightspace
  //vShaC.z = tmp.z;
  vShaC.z = tmp1.z;
  
  // the actual texture coordinates in the warped texture space 
  vShaC.x = tmp1.x;
  vShaC.y = tmp1.y;
  vShaC.w = tmp1.w;
}


half3 FixNorm(half3 vNorm)
{
//  return vNorm;
  return vNorm * 2 - 1;
}

void CalcSteepParallax(in half3 V, in sampler2D sNormal, in half2 vTex, in half fBumpScale, out half3 vParaTex, out half4 NB)
{
  //int iSteps = lerp(16, 8, V.z);
  int iSteps = 8;
  //float fBumpScale = 0.03;
//  float3 vOffset;  // xy - current uv in texture space; z - current height
  float3 vDelta;   // xy - delta uv in texture space; z - height step

  vParaTex.xy = vTex;
  vParaTex.z = 1.0;
  
  vDelta.xy = V.xy * fBumpScale / V.z;
  vDelta.z  = 1.0;
  vDelta    /= -iSteps;
  //vDelta.z  *= 2;
  
  NB = tex2D(sNormal, vTex);
  
  if (NB.a < vParaTex.z)
  {
    vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
    if (NB.a < vParaTex.z)
    {
      vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
      if (NB.a < vParaTex.z)
      {
        vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
        if (NB.a < vParaTex.z)
        {
          vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
          if (NB.a < vParaTex.z)
          {
            vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
            if (NB.a < vParaTex.z)
            {
              vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
              if (NB.a < vParaTex.z)
              {
                vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
                if (NB.a < vParaTex.z)
                {
                  vParaTex += vDelta;
                }
              }
            }
          }
        }
      }
    }
  }

  NB = tex2D(sNormal, vParaTex.xy);
}

void CalcSteepParallax30(in float3 V, in sampler2D sNormal, in float2 vTex, in half fBumpScale, out float3 vParaTex, out float4 NB)
{
  //int iSteps = lerp(30, 16, V.z);
  int iSteps = 45;
  //float fBumpScale = 0.03;
//  float3 vOffset;  // xy - current uv in texture space; z - current height
  float3 vDelta;   // xy - delta uv in texture space; z - height step

  vParaTex.xy = vTex;
  vParaTex.z = 1.0;
  
  vDelta.xy = V.xy * fBumpScale / V.z;
  vDelta.z  = 1.0;
  vDelta    /= -iSteps;
  //vDelta.z  *= 2;
  
  NB = tex2D(sNormal, vTex);
  
  for (int i = 0; i < iSteps; i++)  
  {
    if (NB.a < vParaTex.z)
    {
      vParaTex += vDelta; NB = tex2D(sNormal, vParaTex.xy);
    }
  }
  NB = tex2D(sNormal, vParaTex.xy);
}

float3x3 GetQuaternionMatrix(in float4 qRot)
{
  float3x3 mRot;
  float tx  = 2 * qRot.x;
  float ty  = 2 * qRot.y;
  float tz  = 2 * qRot.z;
  float twx = tx * qRot.w;
  float twy = ty * qRot.w;
  float twz = tz * qRot.w;
  float txx = tx * qRot.x;
  float txy = ty * qRot.x;
  float txz = tz * qRot.x;
  float tyy = ty * qRot.y;
  float tyz = tz * qRot.y;
  float tzz = tz * qRot.z;

  mRot[0] = float3(1-(tyy+tzz), txy+twz    , txz-twy    );
  mRot[1] = float3(txy-twz    , 1-(txx+tzz), tyz+twx    );
  mRot[2] = float3(txz+twy    , tyz-twx    , 1-(txx+tyy));
  
  return mRot;
}

float4 GetQuaternionAxisAngle(in float4 qRot)   // returned xyz contains axis vector, returned w contains the angle
{
  float4 vRes;
  float fLen = length(qRot.xyz);
  if (fLen < 0.0001)
    vRes = 0;
  else {
		vRes.w = 2 * acos(qRot.w);
		vRes.xyz = qRot.xyz / fLen;
  }
  return vRes;
}

// Trees vertex animation
//float3 AnimateVertex(float3 vPos, float fWeight)
//{
//  //Animate!
//  float fXPosPhase = vPos.x /** 1000.0f*/;
//  float fYPosPhase = vPos.y /** 1000.0f*/;
//  //float fTimeScale = fmod(fXPosPhase + fYPosPhase, 1.0f) + 0.5f; 
//  float fTimeScale = 4.5f;
//  float f = sin((fTime +  fXPosPhase + fYPosPhase) * fTimeScale);
//  vPos.xyz += fWindPower * vWindDirection * fWeight * f * 13.0f;
//  return vPos;
//}

float3 AnimateTrunkVertex(float fTime, float3 vPos, float fWeight, float fPhase)
{
fPhase = 0.0f;
  //Animate!
  float fTimeScale = 0.2f;
  float f = sin(fPhase * 2 * PI + fTime * fTimeScale);
  
  vPos.xyz += vWindDirection * fWeight * f * 40.0f;
  return vPos;
}

float3 AnimateLeavesVertex(float fTime, float3 vPos, float fWeight, float fPhase)
{
  float3 vPos2 = AnimateTrunkVertex(fTime, vPos, fWeight, fPhase);
  float fTimeScale = 0.5f; 
  
  //Animate!
  float2 fsincos;
  float2 fPosPhase = vPos.xy * 0.5f;
  
  sincos((fTime +  fPosPhase.x + fPosPhase.y) * fTimeScale, fsincos.x, fsincos.y);
  
  float3 vPos3;
  
  vPos3.xy = fWeight * fsincos.xy * 10.0f;
  vPos3.z = 0;
  
  vPos.xyz = vPos2 + vPos3;
  return vPos;
}

// Procedural texture generation (texture shaders) ----------------------

float4x4  mWorld         : WORLD;

void VS_TexGen(in  float4 iPos: POSITION, 
               out float4 oPos: POSITION,
               out float4 oTex: TEXCOORD)
{
  oPos = mul(iPos, mWorld);
  oPos.xy = sign(oPos.xy);
  oPos.z = oPos.z / oPos.w;
  oPos.w = 1;
  oTex.xy = (oPos.xy + 1) / 2;
  oTex.zw = oPos.zw;
}

#define TEXGEN_TECH(tech,ps)                              \
technique tech                                    \
<                                               \
  string shadername = #tech;                      \
  int implementation = 0;                       \
  string description = "Internal technique, do not use.";                       \
  string NBTMethod = "NDL";                     \
  bool UsesNIRenderState = false;               \
  bool UsesNILightState = false;                \
>                                               \
{                                               \
  pass P0 {                                     \
    CullMode = None;                            \
    AlphaBlendEnable = false;                   \
    AlphaTestEnable = false;                    \
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;    \
    DitherEnable = false;                       \
    StencilEnable = false;                      \
    FogEnable = false;                          \
    ZEnable = false;                            \
    ZFunc = always;                             \
    ZWriteEnable = false;                       \
    VertexShader = compile vs_2_0 VS_TexGen();  \
    PixelShader = compile ps_2_0 ps();          \
  }                                             \
}

// The following macro has to be redefined in the file that uses the texture shader and declares the technique for it, 
// because the HLSL preprocessor is buggy and will not properly expand a macro defined in an include file.
#define TEXGEN(ps) TEXGEN_TECH(_TexGen_##ps,ps)

#endif