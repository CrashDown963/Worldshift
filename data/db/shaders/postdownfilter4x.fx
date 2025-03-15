#include "utility.fxh"

texture g_txScene <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;

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

float2 PixelCoordsDownFilter[16] =
{
    { 1.5,  -1.5 },
    { 1.5,  -0.5 },
    { 1.5,   0.5 },
    { 1.5,   1.5 },

    { 0.5,  -1.5 },
    { 0.5,  -0.5 },
    { 0.5,   0.5 },
    { 0.5,   1.5 },

    {-0.5,  -1.5 },
    {-0.5,  -0.5 },
    {-0.5,   0.5 },
    {-0.5,   1.5 },

    {-1.5,  -1.5 },
    {-1.5,  -0.5 },
    {-1.5,   0.5 },
    {-1.5,   1.5 },
};

float2 TexelCoordsDownFilter[16]
<
    string ConvertPixelsToTexels = "PixelCoordsDownFilter";
>;

float4 DownFilter( in float2 Tex : TEXCOORD0 ) : COLOR0
{
//return tex2D(g_samSrcColor, Tex);
    float4 Color = 0;

    for (int i = 0; i < 16; i++)
    {
        Color += tex2D(g_samSrcColor, Tex + TexelCoordsDownFilter[i].xy);
    }

    return Color / 16;
}

technique PostDownFilter4x
<
  string shadername = "PostDownFilter4x";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass p0
  <
    float fScaleX = 0.25f;
    float fScaleY = 0.25f;
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
    PixelShader = compile ps_2_0 DownFilter();
  }
}

