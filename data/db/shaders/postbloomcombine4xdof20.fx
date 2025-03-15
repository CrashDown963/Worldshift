#include "Utility.fxh"

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

float HighlightThreshold : GLOBAL = 0.9f;


float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;

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
  o.TexCoord0 = TexCoord;
  o.TexCoord1 = texelSize;
  return o;
}

half4 PS_CombineDOF2_0(VS_OUTPUT In) : COLOR0
{
	half4 blur = tex2D(g_samSrcColor, In.TexCoord0);
	//return (SceneIntensity + GlowIntensity) * blur + HighlightIntensity * highlights(blur);
	return blur;
}

technique PostBloomCombine4xDOF20
<
  string shadername = "PostBloomCombine4xDOF20";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass p0
  <
    float fScaleX = 1.0f;
    float fScaleY = 1.0f;
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
    PixelShader = compile _PS2X_ PS_CombineDOF2_0();
  }
}
