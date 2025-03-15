// Various effects shader

#include "Utility.fxh"

// Supported maps:
texture BaseMap  <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;
texture EnvMap   <string NTM = "shader"; int NTMIndex = 0; string name = "";>;
texture NoiseMap <string NTM = "shader"; int NTMIndex = 2; string name = ""; bool hidden = true;>;
texture CaustMap <string NTM = "shader"; int NTMIndex = 4; string name = ""; bool hidden = true;>;

// Transformations:
half4x4  mWorldView      : WORLDVIEW;
float4x4 mWorldViewProj  : WORLDVIEWPROJECTION;
half4x4  mInvWorldTrans  : INVWORLDTRANSPOSE /*WorldInverseTranspose*/;
half4x4  mInvWorld       : INVWORLD;
half4x4  mWorldTrans     : WORLDTRANSPOSE;
half4x4  mInvView        : INVVIEW;


// Lightning parameters
half  fLightFallOff         : ATTRIBUTE = 0.04;
half  fLightAmbient         : ATTRIBUTE = 0.3;
half  fLightAmbientHeight   : ATTRIBUTE = 7;
half  fLightStrength        : ATTRIBUTE = 100.0;
half  fLightFrequency       : ATTRIBUTE = 1.0;
half  fLightOversample      : ATTRIBUTE = 1.0;
half  fLightHeight          : ATTRIBUTE = 0.9;
half  fLightHorizontalScale : ATTRIBUTE = 1.0;
half  fLightUnifyLength     : ATTRIBUTE = 0.0;
half  fLightBlendScale      : ATTRIBUTE = 0.1;

float fTime                 : ATTRIBUTE <bool hidden = true;> = 0.0;

// Corona parameters
half3   vCoronaDirection : ATTRIBUTE <bool hidden = true;> = { 0, 0, 1 };
float3  vCoronaPosition  : ATTRIBUTE <bool hidden = true;> = { 1000, 1000, 1000 };

struct VS_INPUT {
  float4 vPos: POSITION;
  half2  vTexC: TEXCOORD;
};

struct VS_SKIN_INPUT {
  float4 vPos         : POSITION;
  half4  vBlendIndices: BLENDINDICES;
  WEIGHTTYPE  vBlendWeights: BLENDWEIGHT;
  half2  vTexC        : TEXCOORD;
  half3  vNorm        : NORMAL;
};

struct VS_OUTPUT {
  float4 vPos: POSITION;
  half2  vTexC: TEXCOORD;
  half   fFog: FOG;
};

struct VS_SKIN_OUTPUT {
  float4 vPos: POSITION;
  half2  vTexC: TEXCOORD;
  half   fFresnel: TEXCOORD1;
//  half3  vNorm: NORMAL;
  half   fFog: FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

VS_OUTPUT VS_Simple(VS_INPUT v, uniform bool bFog)
{
  VS_OUTPUT o;
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  if (bFog)
    o.fFog = CalcFog(length(mul(v.vPos, mWorldView)), fNearPlane, fFogFarPlane, fFogDepth);
  else 
    o.fFog = 1.0;
  return o;
}

float fInverseFresnel: ATTRIBUTE = 0;

VS_SKIN_OUTPUT VS_Simple_Skin(VS_SKIN_INPUT v, uniform int iBonesPerVertex)
{
  VS_SKIN_OUTPUT o;
  
  float4 vSkinPos;
  float4x3 mBlendedBone;
  float3 vWorld, vCam;
  half3 vNorm;

  mBlendedBone = GetBlendMatrix(v.vBlendIndices, v.vBlendWeights, iBonesPerVertex);
  vSkinPos.xyz = mul(v.vPos, mBlendedBone);
  vSkinPos.w = 1.0;
  o.vPos = mul(vSkinPos, mSkinWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);;
  vWorld = mul(vSkinPos, mSkinWorld);
  vNorm = v.vNorm;
  // Transfer normals to skin space, then to world
  vNorm = mul(vNorm, (float3x3) mBlendedBone);
  vNorm = mul(vNorm, (half3x3) mInvSkinWorldTrans);
  vNorm = normalize(vNorm);
  vCam = normalize(vWorldCamera - vWorld);
  o.fFresnel = saturate(dot(vCam, vNorm));
  o.fFresnel = lerp(1 - o.fFresnel, o.fFresnel, fInverseFresnel);

  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
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


half SampleNoise(half fX)
{
  half2 vTexC;
  fX = fX * fLightHorizontalScale;
  vTexC.x = fX;
  vTexC.y = fTime + fLightOversample * fX; // sample the noise texture at an odd angle so we can sample it many times without repetitions
  return tex2D(sNoise, vTexC).g;
//  return abs(fX - 0.5) * 2;
}

PS_OUTPUT PS_Lightning(VS_OUTPUT p)
{
  PS_OUTPUT o;
  half fVal, fDist;

  fVal = SampleNoise(p.vTexC.x);

  // make the sampled noise value blend with a constant value towards the ends of the u tex coordinate range
  fDist = max(-p.vTexC.x, p.vTexC.x - 1);
  if (fLightUnifyLength > 0)
    fDist = saturate((fLightUnifyLength + fDist) / fLightUnifyLength);
  else 
    fDist = 0;
  fVal = lerp(fVal, 0.5, fDist * fDist);    
  
  fVal = abs(fVal - p.vTexC.y);
  
  float fGlow = 1.0 - pow(fVal * fLightHeight, fLightFallOff);

  float fAmbGlow = fLightAmbient * (1 - fLightAmbientHeight * fVal);
//  o.cColor = (fLightStrength * fGlow * fGlow + fAmbGlow) * cMd;
  fGlow = fLightStrength * fGlow * fGlow + fAmbGlow;
  o.cColor.rgb = lerp(cMd, cMe, fGlow * fLightBlendScale);
  o.cColor.a = cMd.a * saturate(fGlow);
  return o;
}

half4 PS_Corrona(half2 vTexC: TEXCOORD): COLOR
{
  half4 cTex, cColor;
  float fGlow;
  
  cTex = tex2D(sBase, vTexC);
  float3 vPlaneNormal = normalize(vWorldCamera - vCoronaPosition);
  fGlow = dot(vPlaneNormal, vCoronaDirection);
//  fGlow = pow(fGlow, fShininess);
  if (fGlow > 0) { // pow function is buggy in pre-shader on some systems.
    // the following code is a taylor series implementation for fGlow = pow(fGlow, fShininess);
    float f = fShininess;
    float g = fGlow;
    fGlow = 1 + f * (g - 1) + (f * (f - 1) * (g - 1) * (g - 1)) / 2 + (f * (f - 1) * (f - 2) * (g - 1) * (g - 1) * (g - 1)) / 6;
  } else fGlow = 0;
  cColor = cTex * cMd * fGlow;
  
  return cColor;
}

PS_OUTPUT PS_Teleport(VS_SKIN_OUTPUT p)
{
  PS_OUTPUT o;
  
  half4 cGradient;
  cGradient = tex2D(sBase, p.vTexC);
  o.cColor.rgb = cMe;
  o.cColor.a = p.fFresnel * cGradient.a * cMd.a;
  
  return o;
}

technique _Effect_Lightning
<
  string shadername = "_Effect_Lightning";
  int implementation = 0;
  string description = "Lightning effect shader with procedural texture. Must have a noise map attached.";
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
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = true;
  
    VertexShader = compile vs_1_1 VS_Simple(true);
    PixelShader = compile ps_2_0 PS_Lightning();
  }
}

technique _Effect_Corrona
<
  string shadername = "_Effect_Corrona";
  int implementation = 0;
  string description = "Corrona effect shader with additive color blending.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = One;
    DestBlend = One;
    AlphaTestEnable = false;
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Simple(false);
    PixelShader = compile ps_2_0 PS_Corrona();
  }
}

technique _Effect_Teleport
<
  string shadername = "_Effect_Teleport";
  int implementation = 0;
  string description = "Building teleport shader. Skinned, emissive color only, alpha in the texture is opacity.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  int BonesPerPartition = BONES_PER_PARTITION;
  bool ImplicitAlpha = false;
  bool bPublic = true;
>
{
  pass P0
  {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
*/    
    ColorWriteEnable = CWEVALUEFULL;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Simple_Skin(4);
    PixelShader = compile ps_2_0 PS_Teleport();
  }
}
