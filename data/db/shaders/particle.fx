#include "Utility.fxh"

texture BaseMap  <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;
texture ZPassMap <string NTM = "shader"; int NTMIndex = 4; bool hidden = true;>;


float4x4 mViewTrans: VIEWTRANSPOSE;
float4x4 mViewProj: VIEWPROJ;
float4x4 mView: VIEW;

#define MAX_ALPHA_PARTICLES   48

float4 vParticleData[MAX_ALPHA_PARTICLES]: ATTRIBUTE;
float4 vColorData[MAX_ALPHA_PARTICLES]: ATTRIBUTE;
float4 qRotationData[MAX_ALPHA_PARTICLES]: ATTRIBUTE;

float4 vNormalData[MAX_ALPHA_PARTICLES]: ATTRIBUTE;

float fUseBrightness: ATTRIBUTE = 1.0;

void VS_Alpha(in  float4 vInPos        : POSITION, 
              in  float2 vInTexC       : TEXCOORD,
              in  float  fInIndex      : TEXCOORD1,
              out float4 vOutPos       : POSITION, 
              out float2 vOutTexC      : TEXCOORD,
              out float4 cOutColor     : TEXCOORD1,
              out float  fOutFog       : FOG,
              uniform bool bUseNormals)
{
  float4 vWorld;
  float fWorldScale = length(mWorld[0].xyz);  // get model scale from the world matrix
  float fScale = vParticleData[fInIndex].w * fWorldScale;
//  vWorld.xyz = vInPos.x * normalize(mViewTrans[0].xyz) * fScale + vInPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData[fInIndex].xyz, 1), mWorld).xyz;

/*  float3x3 mRot = GetQuaternionMatrix(qRotationData[fInIndex]);
  mRot = mul(mRot, mWorld);
  float3 vRotated = mul(float3(0, 0, 1), mRot);
  float2 vProjectedRot;
  vProjectedRot.x = dot(normalize(mViewTrans[0].xyz), vRotated);
  vProjectedRot.y = dot(normalize(mViewTrans[1].xyz), vRotated);
  vProjectedRot = normalize(vProjectedRot);
  // Now vProjectedRot.x = sin(rotangle), vProjectedRot.y = cos(rotangle)
  // And we rotate the incoming geometry by that rotangle
  float2x2 mPlanarRot = float2x2(vProjectedRot.yx, float2(vProjectedRot.x, -vProjectedRot.y));
*/  
  // extract the rotation angle from the rotation quaternion
  float fAngle = GetQuaternionAxisAngle(qRotationData[fInIndex]).w;
  float2x2 mPlanarRot = float2x2(float2(cos(fAngle),  sin(fAngle)), 
                                 float2(sin(fAngle), -cos(fAngle)));
  float2 vRotPos;
  vRotPos = mul(vInPos, mPlanarRot);
  vWorld.xyz = vRotPos.x * normalize(mViewTrans[0].xyz) * fScale + vRotPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData[fInIndex].xyz, 1), mWorld).xyz;

  vWorld.w = 1;
  vOutPos = mul(vWorld, mViewProj);
  
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);

  if (bUseNormals) {
    float fNdotL = dot(vNormalData[fInIndex], vSunDirection);
    cOutColor.rgb = CalcBacklightMultiplier(fBacklightStrength, fNdotL) * cMa * cAmbientLight;
    cOutColor.rgb += cMd * cSunColor * saturate(fNdotL);
  } else
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor;
  cOutColor.rgb += cMe * lerp(1, fBrightness, fUseBrightness);
  cOutColor.a = cMd.a;
  cOutColor *= vColorData[fInIndex];
  
  fOutFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
}

void VS_Alpha_Inst(in  float4 vInPos   : POSITION, 
                   in  float2 vInTexC  : TEXCOORD,
                   // Instance data follows
                   in  float4 vParticleData : TEXCOORD1,
                   in  float4 vColorData    : TEXCOORD2,
                   in  float4 qRotationData : TEXCOORD3,
                   in  float3 vNormalData   : TEXCOORD4,

                   out float4 vOutPos  : POSITION, 
                   out float2 vOutTexC : TEXCOORD,
                   out float4 cOutColor: TEXCOORD1,
                   out float  fOutFog  : FOG,
                   uniform bool bUseNormals)
{
  float4 vWorld;
  float fWorldScale = length(mWorld[0].xyz);  // get model scale from the world matrix
  float fScale = vParticleData.w * fWorldScale;
//  vWorld.xyz = vInPos.x * normalize(mViewTrans[0].xyz) * fScale + vInPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData.xyz, 1), mWorld).xyz;

/*
  float3x3 mRot = GetQuaternionMatrix(qRotationData.yzwx);  // swizzle the input data cause in Gamebryo quaternions are stored in [w x y z] format
  mRot = mul(mRot, mWorld);
  float3 vRotated = mul(float3(0, 0, 1), mRot);
  float2 vProjectedRot;
  vProjectedRot.x = dot(normalize(mViewTrans[0].xyz), vRotated);
  vProjectedRot.y = dot(normalize(mViewTrans[1].xyz), vRotated);
  vProjectedRot = normalize(vProjectedRot);
  // Now vProjectedRot.x = sin(rotangle), vProjectedRot.y = cos(rotangle)
  // And we rotate the incoming geometry by that rotangle
  float2x2 mPlanarRot = float2x2(vProjectedRot.yx, float2(vProjectedRot.x, -vProjectedRot.y));
*/
  // extract the rotation angle from the rotation quaternion
  float fAngle = GetQuaternionAxisAngle(qRotationData.yzwx).w; // swizzle the input data cause in Gamebryo quaternions are stored in [w x y z] format
  float2x2 mPlanarRot = float2x2(float2(cos(fAngle),  sin(fAngle)), 
                                 float2(sin(fAngle), -cos(fAngle)));
                                 
  float2 vRotPos;
  vRotPos = mul(vInPos, mPlanarRot);
  vWorld.xyz = vRotPos.x * normalize(mViewTrans[0].xyz) * fScale + vRotPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData.xyz, 1), mWorld).xyz;

  vWorld.w = 1;
  vOutPos = mul(vWorld, mViewProj);
  
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);

  if (bUseNormals) {
    float fNdotL = dot(vNormalData, vSunDirection);
    cOutColor.rgb = CalcBacklightMultiplier(fBacklightStrength, fNdotL) * cMa * cAmbientLight;
    cOutColor.rgb += cMd * cSunColor * saturate(fNdotL);
  } else 
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor;
  cOutColor.rgb += cMe * lerp(1, fBrightness, fUseBrightness);
  cOutColor.a = cMd.a;
  cOutColor *= vColorData;
  
  fOutFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
}

/////////// ZPass versions of the vertex shaders

void VS_Alpha_ZPass(in  float4 vInPos        : POSITION, 
                    in  float2 vInTexC       : TEXCOORD,
                    in  float  fInIndex      : TEXCOORD1,
                    out float4 vOutPos       : POSITION, 
                    out float2 vOutTexC      : TEXCOORD,
                    out float4 cOutColor     : TEXCOORD1,
                    out float4 oPosTex       : TEXCOORD2,
                    out float  fOutFog       : FOG,
                    uniform bool bUseNormals)
{
  float4 vWorld;
  float fWorldScale = length(mWorld[0].xyz);  // get model scale from the world matrix
  float fScale = vParticleData[fInIndex].w * fWorldScale;
//  vWorld.xyz = vInPos.x * normalize(mViewTrans[0].xyz) * fScale + vInPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData[fInIndex].xyz, 1), mWorld).xyz;

/*  float3x3 mRot = GetQuaternionMatrix(qRotationData[fInIndex]);
  mRot = mul(mRot, mWorld);
  float3 vRotated = mul(float3(0, 0, 1), mRot);
  float2 vProjectedRot;
  vProjectedRot.x = dot(normalize(mViewTrans[0].xyz), vRotated);
  vProjectedRot.y = dot(normalize(mViewTrans[1].xyz), vRotated);
  vProjectedRot = normalize(vProjectedRot);
  // Now vProjectedRot.x = sin(rotangle), vProjectedRot.y = cos(rotangle)
  // And we rotate the incoming geometry by that rotangle
  float2x2 mPlanarRot = float2x2(vProjectedRot.yx, float2(vProjectedRot.x, -vProjectedRot.y));
*/  
  // extract the rotation angle from the rotation quaternion
  float fAngle = GetQuaternionAxisAngle(qRotationData[fInIndex]).w;
  float2x2 mPlanarRot = float2x2(float2(cos(fAngle),  sin(fAngle)), 
                                 float2(sin(fAngle), -cos(fAngle)));
  float2 vRotPos;
  vRotPos = mul(vInPos, mPlanarRot);
  vWorld.xyz = vRotPos.x * normalize(mViewTrans[0].xyz) * fScale + vRotPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData[fInIndex].xyz, 1), mWorld).xyz;

  vWorld.w = 1;
  
  oPosTex = mul(vWorld, mView);
   
  vOutPos = mul(vWorld, mViewProj);
  
  oPosTex.x = vOutPos.x;
  oPosTex.y = vOutPos.y;
  oPosTex.w = vOutPos.w;
  
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);

  if (bUseNormals) {
    float fNdotL = dot(vNormalData[fInIndex], vSunDirection);
    cOutColor.rgb = CalcBacklightMultiplier(fBacklightStrength, fNdotL) * cMa * cAmbientLight;
    cOutColor.rgb += cMd * cSunColor * saturate(fNdotL);
  } else
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor;
  cOutColor.rgb += cMe * lerp(1, fBrightness, fUseBrightness);
  cOutColor.a = cMd.a;
  cOutColor *= vColorData[fInIndex];
  
  fOutFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
}

void VS_Alpha_Inst_ZPass(in  float4 vInPos   : POSITION, 
                         in  float2 vInTexC  : TEXCOORD,
                         // Instance data follows
                         in  float4 vParticleData : TEXCOORD1,
                         in  float4 vColorData    : TEXCOORD2,
                         in  float4 qRotationData : TEXCOORD3,
                         in  float3 vNormalData   : TEXCOORD4,

                         out float4 vOutPos  : POSITION, 
                         out float2 vOutTexC : TEXCOORD,
                         out float4 cOutColor: TEXCOORD1,
                         out float4 oPosTex  : TEXCOORD2,
                         out float  fOutFog  : FOG,
                         uniform bool bUseNormals)
{
  float4 vWorld;
  float fWorldScale = length(mWorld[0].xyz);  // get model scale from the world matrix
  float fScale = vParticleData.w * fWorldScale;
//  vWorld.xyz = vInPos.x * normalize(mViewTrans[0].xyz) * fScale + vInPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData.xyz, 1), mWorld).xyz;

/*
  float3x3 mRot = GetQuaternionMatrix(qRotationData.yzwx);  // swizzle the input data cause in Gamebryo quaternions are stored in [w x y z] format
  mRot = mul(mRot, mWorld);
  float3 vRotated = mul(float3(0, 0, 1), mRot);
  float2 vProjectedRot;
  vProjectedRot.x = dot(normalize(mViewTrans[0].xyz), vRotated);
  vProjectedRot.y = dot(normalize(mViewTrans[1].xyz), vRotated);
  vProjectedRot = normalize(vProjectedRot);
  // Now vProjectedRot.x = sin(rotangle), vProjectedRot.y = cos(rotangle)
  // And we rotate the incoming geometry by that rotangle
  float2x2 mPlanarRot = float2x2(vProjectedRot.yx, float2(vProjectedRot.x, -vProjectedRot.y));
*/
  // extract the rotation angle from the rotation quaternion
  float fAngle = GetQuaternionAxisAngle(qRotationData.yzwx).w; // swizzle the input data cause in Gamebryo quaternions are stored in [w x y z] format
  float2x2 mPlanarRot = float2x2(float2(cos(fAngle),  sin(fAngle)), 
                                 float2(sin(fAngle), -cos(fAngle)));
                                 
  float2 vRotPos;
  vRotPos = mul(vInPos, mPlanarRot);
  vWorld.xyz = vRotPos.x * normalize(mViewTrans[0].xyz) * fScale + vRotPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData.xyz, 1), mWorld).xyz;

  vWorld.w = 1;
  
  oPosTex = mul(vWorld, mView);
  
  vOutPos = mul(vWorld, mViewProj);
  
  oPosTex.x = vOutPos.x;
  oPosTex.y = vOutPos.y;
  oPosTex.w = vOutPos.w;  
  
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);

  if (bUseNormals) {
    float fNdotL = dot(vNormalData, vSunDirection);
    cOutColor.rgb = CalcBacklightMultiplier(fBacklightStrength, fNdotL) * cMa * cAmbientLight;
    cOutColor.rgb += cMd * cSunColor * saturate(fNdotL);
  } else 
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor;
  cOutColor.rgb += cMe * lerp(1, fBrightness, fUseBrightness);
  cOutColor.a = cMd.a;
  cOutColor *= vColorData;
  
  fOutFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
}

//////

float4 vCenters[MAX_ALPHA_PARTICLES]: ATTRIBUTE;

void VS_Smoke(in  float4 vInPos   : POSITION, 
              in  float2 vInTexC  : TEXCOORD,
              in  float  fInIndex : TEXCOORD1,
              out float4 vOutPos  : POSITION, 
              out float2 vOutTexC : TEXCOORD,
              out float4 cLight   : TEXCOORD1,
              out float  fOutFog  : FOG)
{
  float4 vWorld;
  float fWorldScale = length(mWorld[0].xyz);  // get model scale from the world matrix
  float fScale = vParticleData[fInIndex].w * fWorldScale;
//  vWorld.xyz = vInPos.x * normalize(mViewTrans[0].xyz) * fScale + vInPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData[fInIndex].xyz, 1), mWorld).xyz;

/*  float3x3 mRot = GetQuaternionMatrix(qRotationData[fInIndex]);
  mRot = mul(mRot, mWorld);
  float3 vRotated = mul(float3(0, 0, 1), mRot);
  float2 vProjectedRot;
  vProjectedRot.x = dot(normalize(mViewTrans[0].xyz), vRotated);
  vProjectedRot.y = dot(normalize(mViewTrans[1].xyz), vRotated);
  vProjectedRot = normalize(vProjectedRot);
  // Now vProjectedRot.x = sin(rotangle), vProjectedRot.y = cos(rotangle)
  // And we rotate the incoming geometry by that rotangle
  float2x2 mPlanarRot = float2x2(vProjectedRot.yx, float2(vProjectedRot.x, -vProjectedRot.y));
*/
  // extract the rotation angle from the rotation quaternion
  float fAngle = GetQuaternionAxisAngle(qRotationData[fInIndex]).w;
  float2x2 mPlanarRot = float2x2(float2(cos(fAngle),  sin(fAngle)), 
                                 float2(sin(fAngle), -cos(fAngle)));
  float2 vRotPos;
  vRotPos = mul(vInPos, mPlanarRot);
  vWorld.xyz = vRotPos.x * normalize(mViewTrans[0].xyz) * fScale + vRotPos.y * normalize(mViewTrans[1].xyz) * fScale + mul(half4(vParticleData[fInIndex].xyz, 1), mWorld).xyz;

  vWorld.w = 1;
  vOutPos = mul(vWorld, mViewProj);
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);

  float3 vNorm = normalize(vWorld - mul(half4(vCenters[fInIndex].xyz, 1), mWorld));
  float fNdotL = dot(vNorm, vSunDirection);
  cLight.rgb = CalcBacklightMultiplier(fBacklightStrength, fNdotL) * cMa * cAmbientLight;
  cLight.rgb += cMd * cSunColor * saturate(fNdotL);
  cLight.rgb += cMe * lerp(1, fBrightness, fUseBrightness);
  cLight.a = cMd.a;
  cLight *= vColorData[fInIndex];

  fOutFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
}


sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = 1;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};

sampler2D sZPassMap = sampler_state
{
  texture = <ZPassMap>;
  MinFilter = Point; MagFilter = Point; MipFilter = Point;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
};

void PS_Alpha(in  float2 vInTexC  : TEXCOORD,
              in  float4 cInColor : TEXCOORD1,
              in  float  fInFog   : FOG,
              out float4 cOut     : COLOR,
              uniform bool bExplicitFog)
{
  float4 cTex = tex2D(sBase, vInTexC);
  cOut = cTex * cInColor;
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, fInFog);
}


void PS_Alpha_ZPass(in  float2 vInTexC  : TEXCOORD,
                    in  float4 cInColor : TEXCOORD1,
                    in  float4 vPosTex  : TEXCOORD2,
                    in  float  fInFog   : FOG,
                    out float4 cOut     : COLOR,
                    uniform bool bExplicitFog)
{
  float4 cTex = tex2D(sBase, vInTexC);
  cOut = cTex * cInColor;
  
  
  float4 sample;
  float fZ = vPosTex.z;
  
  float2 texC;
  texC.x = (vPosTex.x / vPosTex.w)* 0.5f + 0.5f;
  texC.y = (-vPosTex.y / vPosTex.w)* 0.5f + 0.5f;
  sample = tex2D(sZPassMap, texC);  
  fZ = sample.r - fZ;
  
  if(fZ < 0) fZ = 0;
  if(fZ > 100) fZ = 100;
  
  cOut.a *= (fZ / 100);
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, fInFog);
}


void PS_Smoke(in  float2 vInTexC : TEXCOORD,
              in  float4 cLight  : TEXCOORD1,
              out float4 cOut    : COLOR)
{
  float4 cTex = tex2D(sBase, vInTexC);
  cOut = cTex * cLight;
}

//#define vs_1_1 vs_2_sw

technique _Part_Alpha 
<
  string description = "Particle shader with alpha blending & particle normals.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
//  string Streams = "POSITION=1, TEXCOORD1=1, TEXCOORD=1";  
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/    
    CullMode = none;
    

    VertexShader = compile _VS2X_ VS_Alpha(true);
    PixelShader  = compile _PS2X_ PS_Alpha(false);
  }
}

technique _Part_Alpha_Inst
<
  string description = "Particle shader with alpha blending & particle normals, instanced.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
  string Streams = "TEXCOORD1=1, TEXCOORD2=1, TEXCOORD3=1, TEXCOORD4=1";  // Annotation specifying which stream an input semantic belongs to
  string Sizes =   "TEXCOORD1=4, TEXCOORD2=4, TEXCOORD3=4, TEXCOORD4=3";  // Annotation specifying how many elements an item of a semantic has
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/    
    CullMode = none;
    

    VertexShader = compile vs_3_0 VS_Alpha_Inst(false);
    PixelShader  = compile ps_3_0 PS_Alpha(true);
  }
}


technique _Part_Alpha_Plain 
<
  string description = "Particle shader with alpha blending (without normals).";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
//  string Streams = "POSITION=1, TEXCOORD1=1";
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/  
    CullMode = none;
    

    VertexShader = compile _VS2X_ VS_Alpha(false);
    PixelShader  = compile _PS2X_ PS_Alpha(false);
  }
}


////////


technique _Part_Alpha_ZPass 
<
  string description = "Particle shader with alpha blending & particle normals.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
//  string Streams = "POSITION=1, TEXCOORD1=1, TEXCOORD=1";  
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/    
    CullMode = none;
    

    VertexShader = compile _VS2X_ VS_Alpha_ZPass(true);
    PixelShader  = compile _PS2X_ PS_Alpha_ZPass(false);
  }
}

technique _Part_Alpha_Inst_ZPass
<
  string description = "Particle shader with alpha blending & particle normals, instanced.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
  string Streams = "TEXCOORD1=1, TEXCOORD2=1, TEXCOORD3=1, TEXCOORD4=1";  // Annotation specifying which stream an input semantic belongs to
  string Sizes =   "TEXCOORD1=4, TEXCOORD2=4, TEXCOORD3=4, TEXCOORD4=3";  // Annotation specifying how many elements an item of a semantic has
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/    
    CullMode = none;
    

    VertexShader = compile vs_3_0 VS_Alpha_Inst_ZPass(false);
    PixelShader  = compile ps_3_0 PS_Alpha_ZPass(true);
  }
}


technique _Part_Alpha_Plain_ZPass 
<
  string description = "Particle shader with alpha blending (without normals).";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
//  string Streams = "POSITION=1, TEXCOORD1=1";
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/  
    CullMode = none;
    

    VertexShader = compile _VS2X_ VS_Alpha_ZPass(false);
    PixelShader  = compile _PS2X_ PS_Alpha_ZPass(false);
  }
}

////////////



technique _Part_Smoke
<
  string description = "Particle shader with alpha blending.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
//    FogColor = 0;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/    
    CullMode = none;

    VertexShader = compile vs_1_1 VS_Smoke();
    PixelShader  = compile ps_2_0 PS_Smoke();
  }
}