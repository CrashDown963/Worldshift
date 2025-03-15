#include "utility.fxh"

texture g_txScene <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;
half g_Lightning: GLOBAL = 1.5f;

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

    float4 clrOut = tex2D(g_samScene, Tex);
    float4 clrOut2 = clrOut;
	float4 fLuma = {0.3f, 0.52f, 0.18f , 0.0f};
	float fDesaturate = 0.05f; 
    
    float4 clrA = pow(clrOut * 1.0f, (5.9f - g_Lightning * 4.5f)) * 16.0f;
    float4 clrB = pow(dot(clrOut * 1.0f, fLuma), (5.9f - g_Lightning * 4.5f)) * 16.0f; 
    
    clrOut = clrA * fDesaturate + clrB * (1.0f - fDesaturate);
    clrOut.b *= 1.3f;
    clrOut.r *= 0.9f;
    
    clrOut = g_Lightning * clrOut + (1 - g_Lightning) * clrOut2;
    
    //clrOut.r = 0;
    //clrOut.g = 0;
    //clrOut.b = 0;

    return clrOut;
}

technique PostLightning2
<
  string shadername = "PostLightning2";
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

    PixelShader = compile ps_2_0 PixNoLight();
    ZEnable = false;
  }
}

