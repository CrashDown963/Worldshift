#include "utility.fxh"

texture g_txSrcColor <string NTM = "base"; int NTMIndex = 0; string name = "";>;

sampler2D g_samSrcColor =
sampler_state
{
    Texture = <g_txSrcColor>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    RESET_BIAS;  
};


// blur filter weights
/*
const half _weights7[7]  : GLOBAL = {
	0.0,
	0.0,
	0.2,
	0.6,
	0.2,
	0.0,
	0.0,
};	
*/

float BlurWidth : GLOBAL = 2.0f;
float OFF_WIDTH : GLOBAL = 1024.0f;
float OFF_HEIGHT : GLOBAL = 768.0f;
float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;

struct VS_OUTPUT_BLUR

{
    float4 Position   : POSITION;
    float2 TexCoord[8]: TEXCOORD0;
};

// generate texcoords for blur
VS_OUTPUT_BLUR VS_Blur(float4 Position : POSITION, 
					   float2 TexCoord : TEXCOORD0)
{
    VS_OUTPUT_BLUR o = (VS_OUTPUT_BLUR)0;
    
	float2 texelSize;
	texelSize.x = BlurWidth / OFF_WIDTH;
	texelSize.y = BlurWidth / OFF_HEIGHT; 
	
	float2 direction = float2(1, 0);	
  float2 s = TexCoord - texelSize * (7 - 1) * 0.47 * direction; 
  for(int i = 0; i < 7; i++) {
		o.TexCoord[i] = s + texelSize * i * direction;
  }
    
	o.Position = mul(Position, mWorldViewProj);    
  return o;
}


half4 PS_Blur7(VS_OUTPUT_BLUR In) : COLOR0
{
    const half weights[7] = {
	    0.05,
	    0.1,
	    0.2,
	    0.3,
	    0.2,
	    0.1,
	    0.05,
    };
    

    half4 c = 0;
    // this loop will be unrolled by compiler
    for(int i = 0; i < 7; i++) {
    	c += tex2D(g_samSrcColor, In.TexCoord[i]) * weights[i];
   	}
    return c;
	
}

technique PostBloomGlowH
<
  string shadername = "PostBloomGlowH";
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
    
    VertexShader = compile vs_1_1 VS_Blur();
    PixelShader = compile ps_2_0 PS_Blur7();
  }
}