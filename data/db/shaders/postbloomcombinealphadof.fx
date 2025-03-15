#include "Utility.fxh"

//texture g_txDOF <string NTM = "shader"; int NTMIndex = 0; string name = "";>;
texture BaseMap  <string NTM = "base";   int NTMIndex = 0; string name = "tiger\\tiger.bmp";>;

sampler2D g_samDOF = sampler_state 
{
    Texture = <BaseMap>;
    AddressU = Clamp;
    AddressV = Clamp;
    MinFilter = Point;
    MagFilter = Point;
    MipFilter = None;
    RESET_BIAS;  
};

float4x4  mWorldViewProj    : WORLDVIEWPROJECTION;
half fNearDOFFocus : GLOBAL = 0.05f;
half fFarDOFFocus : GLOBAL = 0.12f;

struct VS_OUTPUT
{
   	float4 Position   : POSITION;
    float2 TexCoord0  : TEXCOORD0;
};


VS_OUTPUT VS_Combine(float4 Position : POSITION, 
				  float2 TexCoord : TEXCOORD0)
{
  VS_OUTPUT o;

  float2 texelSize;
  o.Position = mul(Position, mWorldViewProj);
  o.TexCoord0 = TexCoord;
  return o;
}



half4 PS_CombineDOF(VS_OUTPUT In) : COLOR0
{
  //return 1;
  
  half4 tmp = tex2D(g_samDOF, In.TexCoord0);
  
  if(tmp.r > fFarDOFFocus)
  {
    tmp.r = (tmp.r - fFarDOFFocus) / (1 - fFarDOFFocus);
    tmp.r = sqrt(tmp.r);
  }
  else if(tmp.r < fNearDOFFocus)
    tmp.r = (fNearDOFFocus - tmp.r) / (fNearDOFFocus);
  else tmp.r = 0;  
  
  return tmp.rrrr;
  //return tex2D(g_samDOF, In.TexCoord0).rrrr;
}


technique PostBloomCombineAlphaDOF
<
  string shadername = "PostBloomCombineAlphaDOF";
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
		ColorWriteEnable = Alpha;
		
  
    VertexShader = compile vs_1_1 VS_Combine();
    PixelShader = compile _PS2X_ PS_CombineDOF();
    
    //VertexShader = compile vs_3_0 VS_Combine();
    //PixelShader = compile ps_3_0 PS_CombineDOF();
    
  }
}
