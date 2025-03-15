#include "utility.fxh"

texture g_txScene <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;
half fBloomBrightness: GLOBAL = 1.0f;
float Luminance: GLOBAL = 1.0f;

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

//-----------------------------------------------------------------------------
// Performs post-processing effect that converts a colored image to black and white.
//-----------------------------------------------------------------------------

//static const  float3 vLuma = {0.3f, 0.59f,   0.11f};

float4 BrightPassFilter( in float2 Tex : TEXCOORD0 ) : COLOR0
{
   float3 clrOrg = tex2D( g_samSrcColor, Tex);

   float fLuma = dot(clrOrg.rgb * fBloomBrightness, vLuma);

   fLuma = pow(fLuma, 14);

   return float4(clrOrg, fLuma * Luminance);

}

technique PostBrightPass
<
    string Parameter0 = "Luminance";
    float4 Parameter0Def = float4( 0.08f, 0, 0, 0 );
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
    PixelShader = compile ps_2_0 BrightPassFilter();
  }
}

