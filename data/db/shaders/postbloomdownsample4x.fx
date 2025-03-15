#include "utility.fxh"

texture g_txScene <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;

sampler2D g_samSrcColor =
sampler_state
{
    Texture = <g_txScene>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = none;
    RESET_BIAS;  
};

float HighlightThreshold : GLOBAL = 0.9f;
float OFF_WIDTH : GLOBAL = 1024.0f;
float OFF_HEIGHT : GLOBAL = 768.0f;
float downsampleScale : GLOBAL = 0.25f; 
float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;


struct VS_OUTPUT_DOWNSAMPLE
{
    float4 Position   : POSITION;
    float2 TexCoord[2]: TEXCOORD0;
};


half luminance(half3 c)
{
	return dot( c, float3(0.3, 0.59, 0.11) );
}

// this function should be baked into a texture lookup for performance
half highlights(half3 c)
{
	return smoothstep(HighlightThreshold, 1.0, luminance(c.rgb));
	//return pow(luminance(c.rgb), 20) * 1.5f;
}

VS_OUTPUT_DOWNSAMPLE VS_Downsample(float4 Position : POSITION,
								   float2 TexCoord : TEXCOORD0)
{
	VS_OUTPUT_DOWNSAMPLE o;
	
	float2 texelSize;
	texelSize.x = 2 / OFF_WIDTH;
	texelSize.y = 2 / OFF_HEIGHT;
	
	//float2 s = float2(0.5f, 0.5f);
	float2 s = TexCoord;
	//OUT.Position = Position;
	
	o.Position = mul(Position, mWorldViewProj);
	o.TexCoord[0] = s - 0.5 * texelSize;
	o.TexCoord[1] = texelSize;
	return o;
}

half4 PS_Downsample( VS_OUTPUT_DOWNSAMPLE In) : COLOR 
{
	float4 c = 0;
	
  for(int i = 0; i < 4; i++) {
    for(int j = 0; j < 4; j++) {
      float2 s;
      s.x = In.TexCoord[0].x + i * In.TexCoord[1].x;
      s.y = In.TexCoord[0].y + j * In.TexCoord[1].y;
      c += tex2D(g_samSrcColor, s);
    }
  }
  
  c /= 16.0f;
	
	// box filter
	//c = tex2D(g_samSrcColor, In.TexCoord[0]);     //0, 0
	//c += tex2D(g_samSrcColor, In.TexCoord[0] + In.TexCoord[1]);    //2, 0
	//c += tex2D(g_samSrcColor, In.TexCoord[0] + In.TexCoord[2]);    //2, 2
	//c += tex2D(g_samSrcColor, In.TexCoord[0] + In.TexCoord[3]);    //0, 2
	
	//c += tex2D(g_samSrcColor, In.TexCoord[0] - In.TexCoord[1]);    //2, 0
	//c += tex2D(g_samSrcColor, In.TexCoord[0] - In.TexCoord[2]);    //2, 2
	//c += tex2D(g_samSrcColor, In.TexCoord[0] - In.TexCoord[3]);    //0, 2
	
	
	
	//c /= 4.0f;

	// store hilights in alpha
	c.a = highlights(c.rgb);

	return c;
}

technique PostBloomDownSample4x
<
  string shadername = "PostBloomDownSample4x";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass p0
  <
    float fScaleX = 0.25; 
    float fScaleY = 0.25;
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

    VertexShader = compile vs_2_0 VS_Downsample();
    //VertexShader = null;
    PixelShader = compile ps_2_0 PS_Downsample();
    ZEnable = false;
  }
}