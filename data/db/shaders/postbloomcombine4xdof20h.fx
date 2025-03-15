#include "Utility.fxh"

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

float OFF_WIDTH : GLOBAL = 1024.0f;
float OFF_HEIGHT : GLOBAL = 768.0f;

float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;

struct VS_OUTPUT
{
   	float4 Position   : POSITION;
    float2 TexCoord0  : TEXCOORD0;
    float2 TexCoord1  : TEXCOORD1;
};

float downsampleScale : GLOBAL = 0.25f; 

VS_OUTPUT VS_Combine(float4 Position : POSITION, 
				  float2 TexCoord : TEXCOORD0)
{
  VS_OUTPUT o;

  float2 texelSize;
  texelSize.x = 1 / OFF_WIDTH;
  texelSize.y = 1 / OFF_HEIGHT;
  //texelSize.x = downsampleScale / OFF_WIDTH;
  //texelSize.y = downsampleScale / OFF_HEIGHT;
  //texelSize.x = 1.0 / 1280;
  //texelSize.y = 1.0 / 1024;

  o.Position = mul(Position, mWorldViewProj);
  o.TexCoord0 = TexCoord;
  o.TexCoord1 = texelSize;
  return o;
}

half4 PS_CombineDOF2_0(VS_OUTPUT In) : COLOR0
{
/*
  #define kernel 9    
  
  const half weightsblur[kernel] = 
    {1, 3, 7, 11, 0, 11, 7, 3, 1};
*/    
  #define kernel 7
  
  const half weightsblur[kernel] = 
    //{3, 7, 11, 0, 11, 7, 3};
    //{3, 4, 5, 0, 5, 4, 3};
    {1, 1.7, 3, 0, 3, 1.7, 1};
    //{1, 2, 4, 6, 9, 0, 9, 6, 4, 2, 1};
    //{4.5, 12, 21, 25.2, 21, 12, 4.5};
/*  
  const half weightsnonblur[kernel] = 
    {0., 0, 0, 25.2, 0, 0, 0};    
  */  
  half4 orig = tex2D(g_samSrcColor, In.TexCoord0);
  float weight = 3.464;
  float4 sum = 3.464 * orig;  
  //float weight = 12;
  //float4 sum = 12 * orig; 
  
  //float weight = 0;
  //float4 sum = 0;
  
  

/*
  #define kernel 7
  const half weightsblur[kernel] = 
    {0.05, 0.1, 0.2, 0, 0.2, 0.1, 0.05};
    

  float weight = 0.3;
  float4 sum = 0.3 * tex2D(g_samSrcColor, In.TexCoord0);
  */
      
  for(int i = 0; i < kernel; i++) {
      float2 texelcoord;
      texelcoord.x = In.TexCoord0.x + (i - kernel / 2) * In.TexCoord1.x;
      texelcoord.y = In.TexCoord0.y;
      half4 curtexel = tex2D(g_samSrcColor, texelcoord);
      //float w = curtexel.a * weightsblur[i] < 0.0001 ? 0 : sqrt(curtexel.a * weightsblur[i]);
      float w = curtexel.a * weightsblur[i];
      //float w = lerp(weightsblur[i], weightsnonblur[i], 1 - curtexel.a);
      
      sum += w * curtexel;
      weight += w;
  }
  
  
  orig.rgb = sum.rgb / weight;
  return orig;
}


technique PostBloomCombine4xDOF20H
<
  string shadername = "PostBloomCombine4xDOF20H";
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
