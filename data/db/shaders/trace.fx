// Bullet traces shader

#include "Utility.fxh"

// Supported maps:
texture BaseMap  <string NTM = "base";>;

// Transformations:
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
float4x4  mWorldView     : WORLDVIEW;
float4x4  mViewTrans     : VIEWTRANSPOSE;
float4x4  mViewProj      : VIEWPROJECTION;

#define MAX_TRACES     64
#define MAX_FLASHES    32
#define MAX_SHOTS      32
#define MAX_BILLBOARDS 32

// Both ends of a single trace reside in vTracePoints[i] and vTracePoints[i+1]
// .xyz is position, .w is the magnitude of the velocity of the point along the trace line
float4    vTracePoints[MAX_TRACES * 2] : ATTRIBUTE;
float     fTime: ATTRIBUTE;
float     fWidthScale: ATTRIBUTE;

float4    mFlashWorld[MAX_FLASHES * 4] : ATTRIBUTE;

float4    vShotPoints[MAX_SHOTS * 4] : ATTRIBUTE;

float4    vBillboardPoints[MAX_BILLBOARDS * 1] : ATTRIBUTE;

struct VS_INPUT {
  float4 vPos  : POSITION;
  half2 vTexC  : TEXCOORD;
  half  fIndex : TEXCOORD1;
};

struct VS_OUTPUT {
  float4 vPos       : POSITION;
  half2  vTexC      : TEXCOORD;
  half   fFog       : FOG;
};

struct VS_OUTPUT_SHOT {
  float4 vPos       : POSITION;
  half2  vTexC      : TEXCOORD;
  half4  cColor     : TEXCOORD1;
  half   fFog       : FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

VS_OUTPUT VS_Trace(VS_INPUT v)
{
  VS_OUTPUT o;

  float3 vX, vY, vZ, vZNorm, pt1, pt2;
  float2 vDist, vCrossScale;
  float fCrossScale;

  v.fIndex = 2 * v.fIndex;
  vZNorm = normalize(vTracePoints[v.fIndex + 1].xyz - vTracePoints[v.fIndex].xyz);
  pt1 = vTracePoints[v.fIndex].xyz + fTime * vTracePoints[v.fIndex].w * vZNorm;
  pt2 = vTracePoints[v.fIndex + 1].xyz + fTime * vTracePoints[v.fIndex + 1].w * vZNorm;
  vZ = pt2 - pt1;
  if (abs(vZ.x) > abs(vZ.z))
    vX = float3(0, 0, 1);
  else
    vX = float3(1, 0, 0);
  // the near and the far end of the trace lines have to have equal width -> we effectively turn the perspective projection to parallel so we can draw lines with uniform width across the scene
  vDist = float2(distance(vWorldCamera, pt1), distance(vWorldCamera, pt2));
  vDist = max(vDist, 2000);
  vCrossScale = 4 * vDist / 5000;
  fCrossScale = lerp(vCrossScale.x, vCrossScale.y, saturate(v.vPos.z));
  fCrossScale *= fWidthScale;

//  vZNorm = normalize(vZ);  - we already have the unit velocity vector in this variable
  vX = normalize(vX - dot(vZNorm, vX) * vZNorm) * fCrossScale;
  vY = cross(vZNorm, vX);
  
//  vY = normalize(vY) * fCrossScale;  - this is already the case
  
  float4x3 mToWorld = float4x3(vX, vY, vZ, pt1);
  float3 vWorld = mul(v.vPos, mToWorld);

  o.vPos = mul(half4(vWorld, 1), mViewProj);
  o.vTexC = v.vTexC;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);

  return o;
}

VS_OUTPUT VS_Flash(VS_INPUT v)
{
  VS_OUTPUT o;
  
  v.fIndex *= 4;
  float4x4 mToWorld = float4x4(half4(mFlashWorld[v.fIndex].xyz, 0), 
                               half4(mFlashWorld[v.fIndex + 1].xyz, 0), 
                               mFlashWorld[v.fIndex + 2], 
                               mFlashWorld[v.fIndex + 3]);
  float3 vWorld = mul(v.vPos, mToWorld);
  o.vPos = mul(half4(vWorld, 1), mViewProj);
  float fFrames, fCurFrame;
  fFrames = mFlashWorld[v.fIndex].w;
  fCurFrame = mFlashWorld[v.fIndex + 1].w;
  o.vTexC = v.vTexC;
  o.vTexC.y = (o.vTexC.y + fCurFrame) / fFrames;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

VS_OUTPUT_SHOT VS_Shot(VS_INPUT v)
{
  VS_OUTPUT_SHOT o;
  half4 vPos;
  float3 vX, vY, vZ;
  float fB;
  float fV1, fV2, fS1, fT2lag, fWidth, fTbase;
  float fT, fStart, fEnd;

  v.fIndex *= 4;
  vZ = vShotPoints[v.fIndex + 1] - vShotPoints[v.fIndex];
  vX = vWorldCamera - vShotPoints[v.fIndex]/* + vShotPoints[v.fIndex + 1]) / 2*/;
  vY = cross(vZ, vX);
//  vX = cross(vY, vZ);
  fB = - dot(vX, vZ) / dot(vZ, vZ);
  vX = vX + fB * vZ;
  vY = normalize(vY);
  vX = normalize(vX);
  
  fV1 = vShotPoints[v.fIndex].w;
  fV2 = vShotPoints[v.fIndex + 1].w;
  fS1 = vShotPoints[v.fIndex + 2].x;
  fT2lag = vShotPoints[v.fIndex + 2].y;
  fWidth = vShotPoints[v.fIndex + 2].z;
  fTbase = vShotPoints[v.fIndex + 2].w;
  
  fT = fTime - fTbase;
  fStart = saturate(fS1 + fT * fV1);
  fEnd = saturate((fT - fT2lag) * fV2);
    
  o.vPos.xyz = vShotPoints[v.fIndex] + vX * v.vPos.x + vY * fWidth * v.vPos.y + vZ * lerp(fEnd, fStart, v.vPos.z);
  o.vPos.w = 1;
  vPos = mul(o.vPos, mWorldView);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.cColor = vShotPoints[v.fIndex + 3];
  o.fFog = CalcFog(length(vPos.xyz), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

VS_OUTPUT VS_Billboard(VS_INPUT v)
{
  VS_OUTPUT o;
  
  float fAngle = 0; /*vBillboardPoints[v.fIndex].w;*/
  float fScale = vBillboardPoints[v.fIndex].w;
  float2x2 mPlanarRot = float2x2(float2(cos(fAngle),  sin(fAngle)), 
                                 float2(sin(fAngle), -cos(fAngle)));
  float2 vRotPos;
  vRotPos = mul(v.vPos, mPlanarRot);

  float4 vPos; 
  vPos.xyz = vBillboardPoints[v.fIndex] + 
             vRotPos.x * normalize(mViewTrans[0].xyz) * fScale +
             vRotPos.y * normalize(mViewTrans[1].xyz) * fScale -
             v.vPos.z  * normalize(mViewTrans[2].xyz) * fScale;
  vPos.w = 1;
  
  o.vPos = mul(vPos, mViewProj);
               
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.fFog = CalcFog(length(mul(vPos, mWorldView)), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};

PS_OUTPUT PS_Trace(const VS_OUTPUT p)
{
  PS_OUTPUT o;
  half4 cPix;
  
  cPix = tex2D(sBase, p.vTexC);
  o.cColor = cPix * half4(cMe, cMd.a);
  
  return o;
}

PS_OUTPUT PS_Flash(const VS_OUTPUT p)
{
  PS_OUTPUT o;
  
  o.cColor = tex2D(sBase, p.vTexC);
  o.cColor *= half4(cMe, cMd.a);
  
  return o;
}

PS_OUTPUT PS_Shot(const VS_OUTPUT_SHOT p)
{
  PS_OUTPUT o;
  half4 cPix;
  
  cPix = tex2D(sBase, p.vTexC);
  o.cColor = cPix * half4(cMe, cMd.a) * p.cColor;
  
  return o;
}

PS_OUTPUT PS_Billboard(const VS_OUTPUT p)
{
  PS_OUTPUT o;
  
  o.cColor = tex2D(sBase, p.vTexC);
  o.cColor *= half4(cMe, cMd.a);
  
  return o;
}

technique _Trace
<
  string shadername = "_Trace";
  int implementation = 0;
  string description = "Bullet trace shader. Base texture with additive blend.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 32;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
    CullMode = none;
  
    VertexShader = compile vs_1_1 VS_Trace();
    PixelShader = compile ps_2_0 PS_Trace();
  }
}

technique _Flash
<
  string shadername = "_Flash";
  int implementation = 0;
  string description = "Muzzle flash shader. Base texture with emissive alpha blend.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
    CullMode = none;
  
    VertexShader = compile vs_1_1 VS_Flash();
    PixelShader = compile ps_2_0 PS_Flash();
  }
}


technique _Flash_Additive
<
  string shadername = "_Flash_Additive";
  int implementation = 0;
  string description = "Muzzle flash shader. Base texture with additive alpha blend.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
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
    ZWriteEnable = false;
    CullMode = none;
  
    VertexShader = compile vs_1_1 VS_Flash();
    PixelShader = compile ps_2_0 PS_Flash();
  }
}

technique _Shot
<
  string description = "Instant shot shader. Base texture with additive blend.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 32;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = /*true*/ false;
    CullMode = none;
  
    VertexShader = compile vs_1_1 VS_Shot();
    PixelShader = compile ps_2_0 PS_Shot();
  }
}

technique _Billboard
<
  string description = "Instanced billboard shader. Base texture only.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool TransparentRenderOnce = true;
  bool bPublic = true;
>
{
  pass P0
  {
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    CullMode = none;  
/*
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 1;
*/    
    VertexShader = compile vs_1_1 VS_Billboard();
    PixelShader = compile ps_2_0 PS_Billboard();
  }
}
