#include "utility.fxh"

texture g_txSrcColor <string NTM = "base"; int NTMIndex = 0; string name = "";>;

sampler2D g_samSrcColor =
sampler_state
{
    Texture = <g_txSrcColor>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Linear;
    MipFilter = Linear;
    RESET_BIAS;  
};

static const int g_cKernelSize = 13;

float2 PixelKernel[g_cKernelSize] =
{
    { 0, -6 },
    { 0, -5 },
    { 0, -4 },
    { 0, -3 },
    { 0, -2 },
    { 0, -1 },
    { 0,  0 },
    { 0,  1 },
    { 0,  2 },
    { 0,  3 },
    { 0,  4 },
    { 0,  5 },
    { 0,  6 }
};

float2 TexelKernel[g_cKernelSize]
<
    string ConvertPixelsToTexels = "PixelKernel";
>;

static const float BlurWeights[g_cKernelSize] = 
{
    0.002216,
    0.008764,
    0.026995,
    0.064759,
    0.120985,
    0.176033,
    0.199471,
    0.176033,
    0.120985,
    0.064759,
    0.026995,
    0.008764,
    0.002216,
};

static float BloomScale = 1.0f;

float4 PostProcessPS( float2 Tex : TEXCOORD0 ) : COLOR0
{
    float4 clrOut = 0;

    for (int i = 0; i < g_cKernelSize; i++)
    {    
        clrOut += tex2D( g_samSrcColor, Tex + TexelKernel[i].xy ) * BlurWeights[i];
    }
 
    return clrOut;
}

technique PostBloomV
<
  string Parameter0 = "BloomScale";
  float4 Parameter0Def = float4( 1.5f, 0, 0, 0 );
  int Parameter0Size = 1;
  string Parameter0Desc = " (float)";
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
    PixelShader = compile ps_2_0 PostProcessPS();
  }
}
