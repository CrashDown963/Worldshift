#include "utility.fxh"

texture g_txScene <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;
//half fBrightness: GLOBAL = 1.5f;

sampler2D g_samScene =
sampler_state
{
    Texture = <g_txScene>;
    AddressU = Wrap;
    AddressV = Wrap;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
    RESET_BIAS;  
};

float4 PixNoLight( float2 Tex : TEXCOORD0 ) : COLOR
{
    return tex2D(g_samScene, Tex) * fBrightness;
}

technique PostBrightness
<
  string shadername = "PostBrightness";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass p0
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
    PixelShader = compile ps_2_0 PixNoLight();
  }
}

