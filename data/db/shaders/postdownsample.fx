#include "Utility.fxh"

texture BaseMap  <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;

sampler2D g_samBackbuf = sampler_state 
{
    Texture = <BaseMap>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
    RESET_BIAS;  
};


float TRUE_OFF_WIDTH : GLOBAL = 1024.0f;
float TRUE_OFF_HEIGHT : GLOBAL = 768.0f;
float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;


struct VS_OUTPUT_DOWNSAMPLE
{
    float4 Position   : POSITION;
    float2 TexCoord[2]: TEXCOORD0;
};


VS_OUTPUT_DOWNSAMPLE VS_Downsample(float4 Position : POSITION,
								   float2 TexCoord : TEXCOORD0)
{
  VS_OUTPUT_DOWNSAMPLE o;
	
  float2 texelSize;
  
  texelSize.x = 1.0 / TRUE_OFF_WIDTH;
  texelSize.y = 1.0 / TRUE_OFF_HEIGHT;

  o.Position = mul(Position, mWorldViewProj);

  o.TexCoord[0] = TexCoord;// - 0.5f * texelSize;
  o.TexCoord[1] = texelSize; 
  
  return o;
}


half4 PS_Downsample( VS_OUTPUT_DOWNSAMPLE In) : COLOR 
{
  float4 c = 0;
/*	
  for(int i = 0; i < 4; i++) {
    for(int j = 0; j < 4; j++) {
      float2 s;
      s.x = In.TexCoord[0].x + i * In.TexCoord[1].x;
      s.y = In.TexCoord[0].y + j * In.TexCoord[1].y;
      c += tex2D(g_samBackbuf, s);
    }
  }
  
  c /= 16.0f;
*/

  for(int i = 0; i < 3; i++) {
    for(int j = 0; j < 3; j++) {
      float2 s;
      s.x = In.TexCoord[0].x + (i-1) * In.TexCoord[1].x;
      s.y = In.TexCoord[0].y + (j-1) * In.TexCoord[1].y;
      c += tex2D(g_samBackbuf, s);
    }
  }
  
  c /= 9.0f;

  return c;
}



technique PostDownsample
<
  string shadername = "PostDownsample";
  int implementation = 0;
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass p0
  <
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
	ColorWriteEnable = Alpha | Red | Green | Blue;
		
  
    VertexShader = compile vs_1_1 VS_Downsample();
    PixelShader = compile _PS2X_ PS_Downsample();
  }
}
