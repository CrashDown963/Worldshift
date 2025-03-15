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
    MinFilter = Linear;
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


float OFF_WIDTH : GLOBAL = 1024.0f;
float OFF_HEIGHT : GLOBAL = 768.0f;

float downsampleScale : GLOBAL = 0.25f; 
float SceneIntensity : GLOBAL = 0.8f;
float GlowIntensity : GLOBAL = 0.3f;
float HighlightIntensity : GLOBAL = 0.9f;

float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;

struct VS_OUTPUT
{
   	float4 Position   : POSITION;
    float2 TexCoord0  : TEXCOORD0;
    float2 TexCoord1  : TEXCOORD1;
};


VS_OUTPUT VS_Combine(float4 Position : POSITION, 
				  float2 TexCoord : TEXCOORD0)
{
  VS_OUTPUT o;

  float2 texelSize;
  texelSize.x = 1 / OFF_WIDTH;
  texelSize.y = 1 / OFF_HEIGHT;

  o.Position = mul(Position, mWorldViewProj);

  // don't want bilinear filtering on original scene:
  o.TexCoord0 = TexCoord;
  //o.TexCoord1 = TexCoord + texelSize * 0.0375 / downsampleScale;
  //o.TexCoord1 = TexCoord + texelSize * 0.0375 /*/ downsampleScale*/;
  o.TexCoord1 = TexCoord;
  return o;
}

half4 PS_Combine(VS_OUTPUT In) : COLOR0
{
	half4 orig = tex2D(g_samOriginal, In.TexCoord0);
	half4 blur = tex2D(g_samSrcColor, In.TexCoord1);
	//return SceneIntensity*orig + GlowIntensity*blur + HighlightIntensity*blur.a;
	//return blur;
	return SceneIntensity*orig + GlowIntensity*blur + HighlightIntensity*blur.a;
	
	//return orig + blur * blur.a;
	//return orig + HighlightIntensity * blur.a;
	//return blur;
	//return orig;
}

technique PostBloomCombine4x
<
  string shadername = "PostBloomCombine4x";
  int implementation = 0;
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
		
  
    VertexShader = compile vs_1_1 VS_Combine();
    PixelShader = compile ps_2_0 PS_Combine();
  }
}

