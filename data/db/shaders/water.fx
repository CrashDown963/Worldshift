////////////////////////////////////////////////////////////////////////////////
// Water surface shaders
//
// Features:
// o Strictly horizontal surfaces only, at arbitrary z
// o Low frequency waves simulated by per-vertex perturbation of tangent space
// o High frequency waves simulated by averaging moving normal maps
// o Reflected environment cubemap or projective local reflection/refraction
// o One parallel light source, specular highlights
// o Heuristics to make the water better visible at high viewing angles

#include "Utility.fxh"

// Supported maps:
texture BaseMap       <string NTM = "base";   int NTMIndex = 0;>;
//texture NormalMap     <string NTM = "bump";   int NTMIndex = 0;>;
texture NormalMap     <string NTM = "shader"; int NTMIndex = 0;>;
texture EnvirMap      <string NTM = "shader"; int NTMIndex = 1;>;
texture FresnelMap    <string NTM = "shader"; int NTMIndex = 2;>;
texture ReflectionMap <string NTM = "shader"; int NTMIndex = 3;>;
texture RefractionMap <string NTM = "shader"; int NTMIndex = 4;>;
texture ShadowMap     <string NTM = "shader"; int NTMIndex = 5;>;
//texture WaterMaskMap  <string NTM = "shader"; int NTMIndex = 6;>;
texture OffscreenMap  <string NTM = "shader"; int NTMIndex = 7;>;

// Transformations:
float4x4 mInvWorld      : INVWORLD;
float4x4 mView          : VIEW;
float4x4 mWorldViewProj : WORLDVIEWPROJECTION;
float4x4 mWorldView     : WORLDVIEW;
float4x4 mProj          : PROJECTION;
float4x4 mShadowProj    : GLOBAL;

// Time:
//float    fTime          : TIME;
float fTime          : GLOBAL = 1.0f;

//float    fWaterLevel    : ATTRIBUTE;
//float3    cWaterTint     : ATTRIBUTE <bool color = true;>;
//float3    cWaterSurface  : ATTRIBUTE <bool color = true;>;

static const half3 vUp = { 0.0, 0.0, 1.0 };

// Samplers:

sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = Wrap; AddressV = Wrap;
};

sampler2D sNormal = sampler_state
{
  texture = <NormalMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = Wrap; AddressV = Wrap;
};

sampler3D sNorm3D = sampler_state
{
  texture = <NormalMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = None;
  RESET_BIAS;  
  AddressU = Wrap; AddressV = Wrap;
};

samplerCUBE sEnvironment = sampler_state
{
  texture = <EnvirMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = Wrap; AddressV = Wrap;
};

sampler sFresnel = sampler_state
{
  Texture = <FresnelMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = None;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
};

sampler sReflection = sampler_state
{
  Texture = <ReflectionMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = None;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
};

sampler sRefraction = sampler_state
{
  Texture = <RefractionMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = None;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
};

sampler2D sShadowMap = sampler_state
{
  texture = <ShadowMap>;
  SHADOW_SAMPLER_STATES;
};
/*
sampler2D sWaterMask = sampler_state
{
  texture = <WaterMaskMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = none;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
};
*/
sampler2D sOffscreen = sampler_state
{
  texture = <OffscreenMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = none;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
};

// Vertex formats:

struct VS_INPUT
{
  float4 vPos  : POSITION;
  half4  cPxDt : COLOR0;
  half3  vData : NORMAL;
  float2 vNorC : TEXCOORD0;
};

struct VS_OUTPUT
{
  float4 vPos  : POSITION;
  half4  cDiff : COLOR0;
  half4  cPxDt : COLOR1;
  half   hFog  : FOG;
  float3 vWPos : TEXCOORD0;
  float4 vNorC : TEXCOORD1;
  half4  vData : TEXCOORD2;
  half3  vHalf : TEXCOORD3;
  float4 vSPos : TEXCOORD4; // Screen space position, for the projective local reflection
};

struct VS_OUTPUT_MASK
{
  float4 vPos  : POSITION;
};

////////////////////////////////////////////////////////////////////////////////
// Shader functions:
//

// Vertex shaders:
static const half bumpScale = 0.1;
static const half2 bumpSpeed = {-0.05, 0.0};
static const half fFakeRippleFactor = 0.03;

void vsLiquid(const VS_INPUT In, out VS_OUTPUT Out, out float4 vShaC: TEXCOORD7, uniform bool bShadows)
{ //fTime = 0.5;
  
  Out.cPxDt.gba = 0.0;
  Out.cPxDt.r   = In.cPxDt.r;                   // r = shadow
  
  //Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.vPos      = mul(In.vPos, mWorldViewProj);
  Out.hFog      = 1.0f;

  // Two normal maps shifting across each other to form direction-neutral bumpy waves:
  //Out.vNorC.xy  = In.vPos.xy * 0.0021 + fTime * bumpSpeed;          // Coarser
  //Out.vNorC.zw  = In.vPos.xy * 0.0046 - fTime * bumpSpeed;          // Finer, moving against the coarse one

  // Two animated normal maps, no uv-shifting is necessary:
  Out.vNorC.xy  = In.vPos.xy / 237.31;
  Out.vNorC.zw  = In.vPos.xy / 913.0;
  
  //Out.vNorC.zw  = mul(In.vData.xy, mWorldView);
  Out.vData.xyz = float3(0, 0, 1);                // Per-vertex normal, used when smoothing the NM
  Out.vData.w   = saturate(In.vData.z / 100.0);   // Depth factor, used to smooth the NM near shores
  Out.vHalf     = CalcHalfway(In.vPos, vSunDirection, vWorldCamera);
  Out.vSPos.xy  = Out.vPos.xy;
  Out.vSPos.xy  = Out.vPos.xy * 0.5 / Out.vPos.w + 0.5;
  Out.vSPos.xy  = 1 - Out.vSPos.xy;
  //Out.vSPos.x   += 0.0025; // Heuristics to reduce sky-colored artifacts along the water/shore intersection.
  //Out.vSPos.y   += 0.005;  // Of course, this produces *other* artifacts elsewhere, but, hey, who's perfect?
  Out.vSPos.z   = Out.vPos.w;
  Out.vSPos.w   = 1 - CalcFog(distance(In.vPos, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth) * GetEdgenessAlpha(In.vPos);
  //Out.vSPos.w   = Out.vPos.w;

  Out.cDiff.rgb = In.cPxDt.a * 2; // No ‘fog of war’ state for the water, just black or normal (0.5+ becomes 1)
  Out.cDiff.a   = 1;
  Out.vWPos.xyz = In.vPos.xyz;
  
  if (bShadows)
    CalcShadowBufferTexCoords(In.vPos, vShaC);
  else
    vShaC = 0.0;
}



void psLiquid(in VS_OUTPUT In, in float4 vShaC: TEXCOORD7, out half4 cOut: COLOR0,
              uniform bool bRealReflection, uniform bool bShadows, uniform bool bRefraction)
{
  //half3 vN1		  = tex2D(sNormal, In.vNorC.xy); // 'Neutrally' moving water, for
  //half3 vN2		  = tex2D(sNormal, In.vNorC.zw); // the middle of the basin

  fTime /= 1.5;

  half3 vN1		  = tex3D(sNorm3D, float3(In.vNorC.xy, fTime));        // Animated normal map, finer
  half3 vN2		  = tex3D(sNorm3D, float3(In.vNorC.zw, fTime * 0.25)); // Animated normal map, coarser

  half3 vCam = normalize(vWorldCamera - In.vWPos);

  vN1 = FixNorm(vN1);
  vN2 = FixNorm(vN2);
  
  //In.vSPos.xy = (In.vSPos.xy * 0.5) / In.vSPos.z + 0.5;
  //In.vSPos.xy = 1 - In.vSPos.xy;

  half3 vNormal = normalize(lerp(vUp, vN1 + vN2, lerp(0.4, 1.0, In.vData.w)));
#if _SHADER_DETAIL_ >= 2 
  vNormal = vN2;
#endif  
  half2 vOffset = vNormal.xy;
  
  half  HdotN   = dot(normalize(In.vHalf), vNormal);
  half  VdotN   = dot(normalize(vCam), vNormal);
  half  LdotN   = dot(normalize(vSunDirection), vNormal);
  
  half3 vRefl = reflect(-vCam, vNormal); vRefl.z = abs(vRefl.z);
  
  half  RdotN   = dot(vRefl, vNormal);
  half  hFresnel= lerp(0.2, 1.0, tex1D(sFresnel, RdotN));
  
  half  hFacing = 1.0 - max(VdotN, 0);
  //half  hFresnel = pow(hFacing, 7.0);
  
//  hFresnel = hFresnel < 0.5? pow((2 * hFresnel), 5) / 2: 1 - (pow(2 * (1.0 - hFresnel), 5));
  
  // Modify the Fresnel term to improve the surface visibility at high angles
  hFresnel = lerp(pow(hFacing, 0.9), hFresnel, hFacing);
//  hFresnel = lerp(pow(hFacing, 0.95), hFresnel, hFacing);
//  hFresnel = pow(hFresnel, 0.6);
  half fShadow = In.cPxDt.r;
  
  if (bShadows)
  {
    half4 temp = vShaC;
    temp.xy += vOffset.xy * fFakeRippleFactor;
    fShadow *= CalcShadowShadowBuffer(sShadowMap, temp);
  }

  // Specular higlights, Blinn’s formula: ks = N.H ^ hSpecSharpness * clamp(4N.H, 0, 1)
  half hSpecSharpness = 700; 
  half hSpecDim = 1.0;

  half  ks = fShadow * pow(saturate(HdotN), hSpecSharpness) * saturate(4 * LdotN);
  half3 cSpec = ks.rrr * cSunSpecColor * hSpecDim;
  half  fSpecBrightness = dot(cSpec, vLuma);

  // Reflection – cube map (= sky only) or mirror
  half4 cCubeMapRefl = texCUBE(sEnvironment, vRefl) * fBrightness;
  half4 cMirrorRefl = tex2D(sReflection, In.vSPos + vOffset.xy * fFakeRippleFactor/*In.vSPos.z*/);
  half3 cRefl = bRealReflection? cMirrorRefl.rgb: cCubeMapRefl.rgb;
  
  // Fake HDR in the output color: Fresnel term doesn't affect specular highlights
  // (the sun is considered bright enough to be reflected even in the normal direction)

//  cOut.rgb = lerp(cRefl, cSpec, fSpecBrightness);

  cOut.rgb = pow(cRefl, 8) + cSpec;

  //cOut.a = max(hFresnel, ks * fSpecBrightness);
  cOut.a = hFresnel /*+ fSpecBrightness * 0.5*/;
 
  cOut.rgb *= In.cDiff.r;
  cOut.a = lerp(1, cOut.a, In.cDiff.r);

  //cOut.a = lerp(cOut.a, 1.0, In.vSPos.w);

  if (bRefraction) {
    half2 vSPos = In.vSPos.xy;
    //vSPos.x -= 0.0025;
    //vSPos.y -= 0.005;
    half4 cPixBelow;
    cPixBelow = tex2D(sOffscreen, half2(1 - vSPos.x, vSPos.y) + vOffset.xy * fFakeRippleFactor);
    
    if(cPixBelow.a != 0) 
      cPixBelow = tex2D(sOffscreen, half2(1 - vSPos.x, vSPos.y));
 
    cOut.rgb = lerp(cPixBelow, cRefl, hFresnel) + cSpec;
    cOut.rgb *= In.cDiff.rgb;
    cOut.rgb = lerp(cOut.rgb, cFogColor, In.vSPos.w);
  }
  else
  {
	  half fInvA = 1 - cOut.a;
	  half fFog = In.vSPos.w;
	  half fInvFog = 1 - fFog;
	  half fNewA = 1 - fInvFog * fInvA;
	  cOut.rgb = (cOut.a * fInvFog * cOut.rgb + fFog * cFogColor) / fNewA;
	  cOut.a = fNewA;
  }
  
  //cOut.rgb = In.cPxDt.g;
  //cOut.rgb = In.vNorC.zww;
  //cOut.rgb = vOffset.xyy;
  //cOut.a = 1;
}

//////////////////////////////////////
//water mask shaders

void vsLiquidMask(const VS_INPUT In, out VS_OUTPUT_MASK Out)
{
  Out.vPos = mul(In.vPos, mWorldViewProj);
}


void psLiquidMask(out half4 cOut: COLOR0)
{
  cOut.r = 1;
  cOut.g = 1;
  cOut.b = 1;
  cOut.a = 0;
}



////////////////////////////////////////////////////////////////////////////////
// Techniques:
//

#define LIQUID_TECHNIQUE(T, bLocalReflection, bShadows, bNoRefraction)\
technique T\
<\
  string shadername = #T;\
  int implementation = 0;\
  string NBTMethod = "NDL";\
  bool UsesNIRenderState = false;\
  bool UsesNILightState = false;\
>\
{\
  pass P0\
  {\
    VertexShader     = compile _VS2X_ vsLiquid(bShadows);\
    PixelShader      = compile _PS2X_ psLiquid(bLocalReflection, bShadows, !bNoRefraction);\
    FogEnable        = bNoRefraction;\
    ZEnable          = true;\
    ZWriteEnable     = true;\
    StencilEnable    = false;\
    AlphaTestEnable  = false;\
    AlphaBlendEnable = bNoRefraction;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = Red|Green|Blue|Alpha;\
  }\
}

LIQUID_TECHNIQUE(Water,               true,  false, false)
LIQUID_TECHNIQUE(Water_Shadows,       true,  true,  false)
LIQUID_TECHNIQUE(WaterNoRef,          false,  false, false)
LIQUID_TECHNIQUE(WaterNoRef_Shadows,  false,  true,  false)
LIQUID_TECHNIQUE(SimpleWater,         false, false, true)
LIQUID_TECHNIQUE(SimpleWater_Shadows, false, true,  true)


technique WaterMask
<
  string shadername = "WaterMask";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = false;
    AlphaBlendEnable = false;
    StencilEnable = false;
    CullMode = CW;
    ColorWriteEnable = Alpha;
    //ColorWriteEnable = 0;
    
    VertexShader = compile vs_1_1 vsLiquid(false);  //no sea waves
    PixelShader =  compile ps_2_0 psLiquidMask();

    //VertexShader = compile _VS2X_ vsLiquid(false, true);  //no sea waves
    //PixelShader =  compile _PS2X_ psLiquid(true, false, true, false);
    
  }
}
