#ifndef __TINT_FXH
#define __TINT_FXH

// Required symbols - must be defined in the including file prior to using this .fxh header
/*
float3 vWorldCamera     : GLOBAL = { 100.0, 100.0, 100.0 };

float  fFarPlane        : GLOBAL = 0.0;
float  fNearPlane       : GLOBAL = 1000.0;

float fFogDepth        : GLOBAL <string UIWidget = "slider"; float UIMin = 0.0; float UIMax = 1.0;> = 0.0;
half3 cFogColor        : GLOBAL <bool color = true; string UIWidget = "color";>;

half3 vSunDirection    : GLOBAL <string UIWidget = "direction";> = { 0.577, -0.577, 0.577 };
half3 cSunColor        : GLOBAL <bool color = true; string UIWidget = "color";> = {1.0, 1.0, 1.0};
half3 cAmbientLight    : GLOBAL <bool color = true; string UIWidget = "color";> = {0.2, 0.2, 0.2};

float4x4 mWorld         : WORLD;
float4x4 mWorldViewProj : WORLDVIEWPROJECTION;
*/

//float     fTime          : TIME;
float      fTime          : GLOBAL = 1.0f;

float    fWaterLevel    : ATTRIBUTE <bool Hidden = true;> = 0.0f;
half3    cWaterTint     : ATTRIBUTE <bool color = true; string UIWidget = "color"; bool Hidden = true;> = {0.02f, 0.14f, 0.18f};
float  	 fTintDepth     : ATTRIBUTE <bool Hidden = true;> = 400.0f;
float    fCausticsDepth : ATTRIBUTE <bool Hidden = true;> = 100.0f;
float    fCausticsSize  : ATTRIBUTE <bool Hidden = true;> = 100.0f;

texture CaustMap <string bss_file = "DATA/Textures/CaustVolume.dds"; bool hidden = true; >;

sampler3D sCaustMap = sampler_state
{
  texture = <CaustMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = Wrap; AddressV = Wrap;
};

sampler2D sBaseTint = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = wrap; AddressV = wrap;
};

// Vertex formats
struct  VS_INPUT_TINT
{
  float4 vPos  : POSITION; 
  float2 vData : TEXCOORD1;
};

struct  VS_INPUT_TINT_ANIM
{
  float4 vPos  : POSITION; 
  float2 vData : TEXCOORD1;
  half2  cDiff: COLOR;       //.x -> weight, used for animation; .y -> phase
};


struct VS_INPUT_TINT_SKIN {
  float4 vPos         : POSITION;
  half4  vBlendIndices: BLENDINDICES;
  WEIGHTTYPE  vBlendWeights: BLENDWEIGHT;
};

struct  VS_INPUT_CAUSTICS
{
  float4 vPos  : POSITION; 
  float3 vNorm : NORMAL;
  float2 vData : TEXCOORD1;
};

struct VS_OUTPUT_TINT
{
  float4 vPos  : POSITION;
  half   hFog  : FOG;
  float4 vData : TEXCOORD0;
};

struct VS_OUTPUT_CAUSTICS
{
  float4 vPos  : POSITION;
  half4  cDiff : COLOR0;
  half3  vCaust: TEXCOORD0;
  float2 vData : TEXCOORD1;
};


float4 CalcTintData(const float3 vWorldPos, const float fWaterLevel, const float fTintFlag)
{
  float4 vData;

  vData.xyz = vWorldPos / fTintDepth;
  vData.w = fTintFlag;
  
  return vData;
}

void vsTintTerrain(const VS_INPUT_TINT In, out VS_OUTPUT_TINT Out, out half fRealFog: COLOR0)
{
  Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.hFog      = 1.0;
  Out.vData     = CalcTintData(In.vPos, fWaterLevel, In.vData.y);
  fRealFog      = 1.0 - CalcFog(distance(In.vPos, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  fRealFog      = pow(fRealFog, 0.3);
}

void vsTintObject(const VS_INPUT_TINT In, out VS_OUTPUT_TINT Out, out half fRealFog: COLOR0)
{
  Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.hFog      = 1.0;
  float3 vWorld = mul(In.vPos, mWorld);
  Out.vData     = CalcTintData(vWorld, fWaterLevel, 1);
  fRealFog      = 1.0f - CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  fRealFog      = pow(fRealFog, 0.3);
}

void vsTintObjectAnim(VS_INPUT_TINT_ANIM In, out VS_OUTPUT_TINT Out, out half fRealFog: COLOR0, uniform bool bTrunk)
{
  if (bTrunk)
	In.vPos.xyz = AnimateTrunkVertex(fTime, In.vPos.xyz, In.cDiff.r, In.cDiff.g);
  else
    In.vPos.xyz = AnimateLeavesVertex(fTime, In.vPos.xyz, In.cDiff.r, In.cDiff.g);
  Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.hFog      = 1.0;
  float3 vWorld = mul(In.vPos, mWorld);
  Out.vData     = CalcTintData(vWorld, fWaterLevel, 1);
  fRealFog      = 1.0f - CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  fRealFog      = pow(fRealFog, 0.3);
}

void vsTintObjectAlphatest(const VS_INPUT_TINT In, in float2 ptInTexC: TEXCOORD0,
                           out VS_OUTPUT_TINT Out, out float2 ptOutTexC: TEXCOORD2, 
                           out half fRealFog: COLOR0)
{
  Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.hFog      = 1.0;
  float3 vWorld = mul(In.vPos, mWorld);
  Out.vData     = CalcTintData(vWorld, fWaterLevel, 1);
  fRealFog      = 1.0f - CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  fRealFog      = pow(fRealFog, 0.3);
  ptOutTexC     = ptInTexC;
}

void vsTintObjectAlphatestAnim(VS_INPUT_TINT_ANIM In, in float2 ptInTexC: TEXCOORD0,
                               out VS_OUTPUT_TINT Out, out float2 ptOutTexC: TEXCOORD2, 
                               out half fRealFog: COLOR0, uniform bool bTrunk)
{
  if (bTrunk)
	In.vPos.xyz = AnimateTrunkVertex(fTime, In.vPos.xyz, In.cDiff.r, In.cDiff.g);
  else
    In.vPos.xyz = AnimateLeavesVertex(fTime, In.vPos.xyz, In.cDiff.r, In.cDiff.g);
  Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.hFog      = 1.0;
  float3 vWorld = mul(In.vPos, mWorld);
  Out.vData     = CalcTintData(vWorld, fWaterLevel, 1);
  fRealFog      = 1.0f - CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  fRealFog      = pow(fRealFog, 0.3);
  ptOutTexC     = ptInTexC;
}

void vsTintSkinned(const VS_INPUT_TINT_SKIN In, out VS_OUTPUT_TINT Out, uniform int iBonesPerVertex, out half fRealFog: COLOR0)
{
  float4 vSkinPos;
  float4x3 mBlendedBone;
  float3 vWorld;

  mBlendedBone  = GetBlendMatrix(In.vBlendIndices, In.vBlendWeights, iBonesPerVertex);
  vSkinPos.xyz  = mul(In.vPos, mBlendedBone);
  vSkinPos.w    = 1.0;
  Out.vPos      = mul(vSkinPos, mSkinWorldViewProj);
  vWorld        = mul(vSkinPos, mSkinWorld);
  Out.hFog      = 1.0f;
  Out.vData     = CalcTintData(vWorld, fWaterLevel, 1);
  fRealFog      = 1.0f - CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);;
  fRealFog      = pow(fRealFog, 0.3);
}

void vsCaustics(const VS_INPUT_CAUSTICS In, out VS_OUTPUT_CAUSTICS Out)
{
  Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.cDiff     = saturate(dot(vSunDirection, In.vNorm));
  Out.vCaust    = In.vPos / fCausticsSize;
  Out.vCaust.z  += fTime + (In.vPos.x + In.vPos.y) / (fCausticsSize * 0.76);
  Out.vData.x   = (fWaterLevel - In.vPos.z) / fCausticsDepth;  // Scaled depth
  Out.vData.y   = In.vData.y;                                  // Caustics flag
}

void psTint(VS_OUTPUT_TINT In, in half fRealFog: COLOR0, out half4 cOut: COLOR0, in float2 ptTexC: TEXCOORD2, uniform half fAlphaRef)
{
/*
  float t      = In.vData.y / In.vData.x; // t = CSz / CPz
  //float dtw    = lerp(min(1.0 - t, 1.0), max(t, 0.0), In.vData.x > 0);
  //float dtw    = lerp(saturate(1.0 - t), saturate(t), In.vData.x > 0);
  float dtw    = lerp(saturate(1.0 - t), 0, In.vData.x > 0);
  cOut.rgb     = cWaterTint * (cSunColor + cAmbientLight);
  
#ifdef COMPILE_DECALS
  if (COMPILE_DECALS)
    cOut.a = saturate(dtw * In.vData.z);
  else
    cOut.a = saturate(dtw * In.vData.z * (In.vData.w >= 0.9999));
#else
  cOut.a = saturate(dtw * In.vData.z);
#endif
*/

  float3 C = vWorldCamera / fTintDepth; // Camera position in tint-depth-equals-1 space
  float  w = fWaterLevel / fTintDepth;  // Water level z in tint-depth-equals-1 space
  
  int iSwap = C.z < In.vData.z;
  float3 T = iSwap? In.vData.xyz: C; // Top position of the view span - C or P, whichever is higher
  float3 B = iSwap? C: In.vData.xyz; // Bottom position of the view span - C or P, whichever is lower
  float  t = max(0, (w - B.z) / (T.z - B.z));
  float  d = t * distance(T, B);
  float  a = 1 - 1 / (d + 1);

  if (In.vData.z > w)
    a = 0;

  cOut.rgb = cWaterTint * (cSunColor + cAmbientLight);
  
#ifdef COMPILE_DECALS
  if (COMPILE_DECALS)
    cOut.a = a * (In.vData.w >= 0.9999);
  else
    cOut.a = a * (In.vData.w >= 0.9999);
#else
  cOut.a = a;
#endif

  if (fAlphaRef > 0.0)
    if (tex2D(sBaseTint, ptTexC.xy).a < fAlphaRef)
      cOut.a = 0.0; 

//  if (cOut.a > 0.0)
//    cOut.a = max(cOut.a, fRealFog);
}

void psCaustics(VS_OUTPUT_CAUSTICS In, out half4 cOut: COLOR0)
{
  half ai  = max(1.0 - In.vData.x, 0.0);
  half ao  = max(In.vData.x, 0.0) * 10.0;
  cOut.rgb = tex3D(sCaustMap, In.vCaust.xyz);
  cOut.a   = min(ai, ao);
  cOut.a   *= cOut.r;
  //cOut.a   *= cOut.a;
  cOut.a   = cOut.a * (In.vData.x > 0.0) * (In.vData.y >= 0.9999) * In.cDiff.r /*0.5*/;
}

// Technique macros
#define TINT_CAUSTICS_PASS(type)\
  pass Caustics\
  {\
    VertexShader     = compile vs_1_1 vsCaustics();\
    PixelShader      = compile ps_2_0 psCaustics();\
    FogEnable        = false;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = false;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = One;\
    ColorWriteEnable = CWEVALUE;\
  }\
  pass Tint\
  {\
    VertexShader     = compile vs_1_1 vsTint##type();\
    PixelShader      = compile ps_2_0 psTint(0.0);\
    FogEnable        = true;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = false;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
    DepthBias        = 0;\
    SlopeScaleDepthBias = 0;\
  }

#define TINT_PASS_TERRAIN\
  pass Tint\
  {\
    VertexShader     = compile vs_1_1 vsTintTerrain();\
    PixelShader      = compile ps_2_0 psTint(0.0);\
    FogEnable        = true;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = false;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
    DepthBias        = 0;\
    SlopeScaleDepthBias = 0;\
  }

#define TINT_PASS_OBJECT\
  pass Tint\
  {\
    VertexShader     = compile vs_1_1 vsTintObject();\
    PixelShader      = compile ps_2_0 psTint(0.0);\
    FogEnable        = true;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = false;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
    DepthBias        = 0;\
    SlopeScaleDepthBias = 0;\
  }

#define TINT_PASS_OBJECT_ANIM(Trunk)\
  pass Tint\
  {\
    VertexShader     = compile vs_1_1 vsTintObjectAnim(Trunk);\
    PixelShader      = compile ps_2_0 psTint(0.0);\
    FogEnable        = true;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = false;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
    DepthBias        = 0;\
    SlopeScaleDepthBias = 0;\
  }

#define TINT_PASS_OBJECT_ALPHATEST\
  pass Tint\
  {\
    VertexShader     = compile vs_1_1 vsTintObjectAlphatest();\
    PixelShader      = compile ps_2_0 psTint(31.0 / 255.0);\
    FogEnable        = true;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = true;\
    AlphaRef         = 32;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
    DepthBias        = 0;\
    SlopeScaleDepthBias = 0;\
  }

#define TINT_PASS_OBJECT_ALPHATEST_ANIM(Trunk)\
  pass Tint\
  {\
    VertexShader     = compile vs_1_1 vsTintObjectAlphatestAnim(Trunk);\
    PixelShader      = compile ps_2_0 psTint(31.0 / 255.0);\
    FogEnable        = true;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = true;\
    AlphaRef         = 32;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
    DepthBias        = 0;\
    SlopeScaleDepthBias = 0;\
  }

#define TINT_PASS_SKINNED_OBJECT\
  pass Tint\
  {\
    VertexShader     = compile vs_1_1 vsTintSkinned(4);\
    PixelShader      = compile ps_2_0 psTint(0.0);\
    FogEnable        = true;\
    StencilEnable    = false;\
    ZEnable          = true;\
    ZFunc            = LESSEQUAL;\
    ZWriteEnable     = false;\
    AlphaBlendEnable = true;\
    AlphaTestEnable  = false;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
    DepthBias        = 0;\
    SlopeScaleDepthBias = 0;\
  }
  
#endif
