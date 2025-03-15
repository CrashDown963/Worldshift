#include "utility.fxh"

texture g_txScene <string NTM = "base"; int NTMIndex = 0; string name = "";>;
texture g_txOriginal <string NTM = "shader"; int NTMIndex = 0; string name = "";>;
half fBloomBrightness: GLOBAL = 1.0f;

sampler2D g_samSrcColor =
sampler_state
{
    Texture = <g_txScene>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
    RESET_BIAS;  
};

sampler2D g_samOriginal = sampler_state
{
    Texture = <g_txOriginal>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
    RESET_BIAS;  
};

float4 Combine( float2 Tex : TEXCOORD0,
                float2 Tex2 : TEXCOORD1 ) : COLOR0
{
    float4 clrOrg = tex2D( g_samOriginal, Tex ) * fBloomBrightness;
    float4 clrSrc = tex2D( g_samSrcColor, Tex );

   return clrOrg + clrSrc * clrSrc.a;
}

technique PostCombine4x
<
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass p0
  <
      float fScaleX = 4.0f;
      float fScaleY = 4.0f;
  >
  {
		CullMode = None;
		ZEnable = false;
		ZWriteEnable = false;
		FogEnable = false;
		SpecularEnable = false;
		AlphaBlendEnable = false;
		AlphaTestEnable = false;
		StencilEnable = false;
		ColorWriteEnable = Red | Green | Blue | Alpha;
    
    VertexShader = null;
    PixelShader = compile ps_2_0 Combine();
  }
}

