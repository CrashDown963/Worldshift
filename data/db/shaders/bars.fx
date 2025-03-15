// Bars shader

#include "Utility.fxh"

// Supported maps:
texture BaseMap  <string NTM = "base";>;

// Transformations:
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
float4x4  mWorldView     : WORLDVIEW;
float4x4  mViewTrans     : VIEWTRANSPOSE;
float4x4  mViewProj      : VIEWPROJECTION;

#define MAX_BARS     42

// Both ends of a single trace reside in vTracePoints[i] and vTracePoints[i+1]
// .xyz is position, .w is the magnitude of the velocity of the point along the trace line
float4    vBarsPoints[MAX_BARS * 3] : ATTRIBUTE;

/*
struct VS_INPUT {
  float4 vPos  : POSITION;
  half2 vTexC  : TEXCOORD;
  half2  fIndex : TEXCOORD1;
};
*/

struct VS_INPUT {
  float4 vPos  : POSITION;
  //half2  fIndex : TEXCOORD;
};


struct VS_OUTPUT {
  float4 vPos       : POSITION;
  half2  vTexC      : TEXCOORD;
  half4  cColor     : TEXCOORD1;
 // half   fFog       : FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

VS_OUTPUT VS_Bars(VS_INPUT v)
{
  VS_OUTPUT o;
  float4 vWorld;

  vWorld.x = vBarsPoints[v.vPos.z].x + v.vPos.x * vBarsPoints[v.vPos.z].w;
  vWorld.y = vBarsPoints[v.vPos.z].y + v.vPos.y * vBarsPoints[v.vPos.z + 1].w;
  vWorld.z = vBarsPoints[v.vPos.z].z;
  vWorld.w = 1;
  
  
  o.vPos = mul(vWorld, mWorld);
  o.vPos.xyz = o.vPos.xyz + vBarsPoints[v.vPos.z + 1].xyz;

  o.vPos = mul(o.vPos, mViewProj);
  o.vTexC.x = v.vPos.x;
  o.vTexC.y = v.vPos.y;
  o.cColor.rgba = vBarsPoints[v.vPos.z + 2].xyzw;
  
  return o;
}


sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};

PS_OUTPUT PS_Bars(const VS_OUTPUT p)
{
  PS_OUTPUT o;
  half4 cPix;
  
  cPix = tex2D(sBase, p.vTexC);
  o.cColor = cPix * p.cColor;

  return o;
}


technique _Bars
<
  string shadername = "_Bars";
  int implementation = 0;
  string description = "Bullet trace shader. Base texture with alpha.";
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
    AlphaTestEnable = false;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
    CullMode = none;
  
    VertexShader = compile vs_1_1 VS_Bars();
    PixelShader = compile ps_2_0 PS_Bars();
  }
}
