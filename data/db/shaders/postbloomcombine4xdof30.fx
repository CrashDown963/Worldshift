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

float TRUE_OFF_WIDTH : GLOBAL = 1024.0f;
float TRUE_OFF_HEIGHT : GLOBAL = 768.0f;

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

  texelSize.x = 1.0 / TRUE_OFF_WIDTH;
  texelSize.y = 1.0 / TRUE_OFF_HEIGHT;


  o.Position = mul(Position, mWorldViewProj);

  // don't want bilinear filtering on original scene:
  o.TexCoord0 = TexCoord;
  o.TexCoord1 = texelSize;
  return o;
}

half4 PS_CombineDOF3_0(VS_OUTPUT In) : COLOR0
{
  #define kernel 7    
  /*
  const half weightsblur[kernel][kernel] = {
    {1, 2, 3, 3, 3, 2, 1},
    {2, 3, 6, 7, 6, 3, 2},
    {3, 6, 9, 11, 9, 6, 3},
    {3, 7, 11, 12, 11, 7, 3},
    {3, 6, 9, 11, 9, 6, 3},
    {2, 3, 6, 7, 6, 3, 2},
    {1, 2, 3, 3, 3, 2, 1},
  };	*/
const half weightsblur[kernel][kernel] = {
  {1, 1.7, 3, 3.464, 3, 1.7, 1},
  {1.7, 3, 5.1, 5.8888, 5.1, 3, 1.7},
  {3, 5.1, 9, 10.392, 9, 5.1, 3},
  {3.464, 5.8888, 10.392, 12, 10.392, 5.8888, 3.464},
  {3, 5.1, 9, 10.392, 9, 5.1, 3},
  {1.7, 3, 5.1, 5.8888, 5.1, 3, 1.7},
  {1, 1.7, 3, 3.464, 3, 1.7, 1},
  };

  const half weightsnonblur[kernel][kernel] = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 12, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0}
    };	

  half4 orig = tex2D(g_samOriginal, In.TexCoord0);
  
  //float weight = 12;
  //float4 sum = 12 * orig;
  //float sumDOF = 0;
  float weight = 0;
  float4 sum = 0;

  
  
  for(int i = 0; i < kernel; i++)
    for(int j = 0; j < kernel; j++)
    {
      float2 texelcoord;
      texelcoord.x = In.TexCoord0.x + (i - kernel / 2) * In.TexCoord1.x;
      texelcoord.y = In.TexCoord0.y + (j - kernel / 2) * In.TexCoord1.y;
      
      half4 curtexel = tex2D(g_samOriginal, texelcoord);
      float w = lerp(weightsnonblur[i][j], weightsblur[i][j], curtexel.a);
      //float w = weightsblur[i][j] * curtexel.a;
      sum += w * curtexel;
      weight += w;
    }
    
  half4 blur2 = sum / weight;
  //return blur2;
	half4 blur = tex2D(g_samSrcColor, In.TexCoord0);
	return SceneIntensity*blur2 + GlowIntensity*blur + HighlightIntensity*blur.a;
}


technique PostBloomCombine4xDOF30
<
  string shadername = "PostBloomCombine4xDOF30";
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
		
  
    //VertexShader = compile vs_1_1 VS_Combine();
    //PixelShader = compile _PS2X_ PS_CombineDOF3_0();
    
    VertexShader = compile vs_3_0 VS_Combine();
    PixelShader = compile ps_3_0 PS_CombineDOF3_0();
    
  }
}



