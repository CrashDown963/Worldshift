#include "utility.fxh"

// Galaxy shaders

texture BaseMap   <string NTM = "base";   int NTMIndex = 0;>;
//half  fBrightness      : GLOBAL = 1.0;

// Samplers:
sampler2D sBaseMap = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = Wrap; AddressV = Wrap;
};


// Time:
float    fTime          : GLOBAL = 1.0f;

// Camera position:
//float3 vWorldCamera         : GLOBAL = { 100.0, 100.0, 100.0 };


// Transformations:
//float4x4  mWorld            : WORLD;
float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;


struct VS_RAIN_INPUT {
  float4  vPos    : POSITION;
  half3   vNormal : NORMAL;     //x -> Phase, y -> Scale, z -> Size (from 0 to 1)
  half2   vTexC   : TEXCOORD;
  half4   cDiff   : COLOR0;
};

struct VS_RAIN_OUTPUT {
  float4  vPos  : POSITION;
  half2   vTexC : TEXCOORD;
  half4   cDiff   : COLOR0;
};

VS_RAIN_OUTPUT VS_Rain(VS_RAIN_INPUT v)
{
  VS_RAIN_OUTPUT o;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.cDiff.a = lerp(0.0f, 1.0f, min(distance(mul(v.vPos, mWorld), vWorldCamera), 5000.0f) / 5000.0f);
  o.cDiff.rgb = 1.0f;
  o.vTexC = v.vTexC;
  return o;
}

void PS_Rain(VS_RAIN_OUTPUT In, out half4 cOut: COLOR0)
{
  cOut = tex2D(sBaseMap, In.vTexC);
  //cOut.rgb = 1.0f;
  //cOut.rgb = 0.3 + (1 - In.cDiff.a);
  //cOut.r = cOut.b = 1.0f;
  //cOut.g = 0.0f;
  //cOut.gb = 0.0f;
  //cOut.a *= 0.1f;
  //cOut.a *= 1.0f * (1 - In.cDiff.a);
  //cOut.a *= 0.5f * (1 - In.cDiff.a);
  cOut.a *= 0.2f * In.cDiff.a;
  //cOut.a *= ;
}

technique Rain
<
  string shadername = "Rain";
  int implementation = 0;
  string description = "Rain implementation.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    CullMode = None;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 1;
    ColorWriteEnable = RED|GREEN|BLUE|ALPHA;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
    VertexShader = compile vs_1_1 VS_Rain();
    PixelShader = compile ps_2_0 PS_Rain();
  }
}