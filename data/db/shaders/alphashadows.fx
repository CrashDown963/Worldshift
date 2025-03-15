////////////////////////////////////////////////////////////////////////////////
// alpha tested shadows shader
////////////////////////////////////////////////////////////////////////////////

#include "utility.fxh"

//#define BONES_PER_PARTITION 40

texture BaseMap <string NTM = "base"; int NTMIndex = 0;>;

float4 cShadow : GLOBAL <bool color = true;> = {0.0, 0.0, 0.0, 1};

// Transformations:
float4x4  mWorldViewProj      : WORLDVIEWPROJECTION;
//float4x4  mWorld              : WORLD;
float4x4  mView               : VIEW;
float4x4  mProj               : PROJ;
//float4x4  mSkinWorldViewProj  : SKINWORLDVIEWPROJ;

//float4x4  mShadowLightTrans   : GLOBAL;
//float4x4  mShadowAfterLightTrans   : GLOBAL;

float4x4  mShadowTestView   : GLOBAL;
float4x4  mShadowTestProj   : GLOBAL;

//float     fShadowZRangeMultiplier : GLOBAL;

//Animation
//float     fTime          : TIME;
float fTime          : GLOBAL = 1.0f;
float fShadowsZOffset : GLOBAL = 0.0001f;


//float4x3  mBone[BONES_PER_PARTITION] : BONEMATRIX4;


////#define Z_OFFSET 0.0002f
//#define Z_OFFSET (0.0001f)

void VS(in float4 vPos: POSITION, 
        in float2 vTexC: TEXCOORD,
        out float4 oPos: POSITION, 
        //out float oLightSpacePosZ: TEXCOORD)
        out float4 oLightSpacePos: TEXCOORD)
{
  float4 LightSpacePos = mul(vPos, mWorldViewProj);
  oPos = mul(LightSpacePos, mShadowAfterLightTrans);
  
  //oLightSpacePosZ = (oPos.z / oPos.w)  + Z_OFFSET;
  //oPos.z += (Z_OFFSET*oPos.w);

  oLightSpacePos = LightSpacePos;  
}


void VS_Leaves(in float4 vPos: POSITION, 
               in float4 cDiff: COLOR,
               in float2 vTexC: TEXCOORD,
               out float4 oPos: POSITION, 
               out float2 oTexC: TEXCOORD,
               //out float oLightSpacePosZ: TEXCOORD)
               out float4 oLightSpacePos: TEXCOORD1)
{  
  float4 animatedPos;
  animatedPos.xyz = AnimateLeavesVertex(fTime, vPos.xyz, cDiff.r, cDiff.g);
  animatedPos.w = vPos.w;

  float4 LightSpacePos = mul(animatedPos, mWorldViewProj);
  oPos = mul(LightSpacePos, mShadowAfterLightTrans);
  
  //oLightSpacePosZ = (oPos.z / oPos.w)  + Z_OFFSET;
  //oPos.z += (Z_OFFSET*oPos.w);

  oLightSpacePos = LightSpacePos;  
  oTexC = vTexC;
}

void VS_Trunk(in float4 vPos: POSITION, 
               in float4 cDiff: COLOR,
               in float2 vTexC: TEXCOORD,
               out float4 oPos: POSITION, 
               //out float oLightSpacePosZ: TEXCOORD)
               out float4 oLightSpacePos: TEXCOORD)
{  
  float4 animatedPos;
  animatedPos.xyz = AnimateTrunkVertex(fTime, vPos.xyz, cDiff.r, cDiff.g);
  animatedPos.w = vPos.w;

  float4 LightSpacePos = mul(animatedPos, mWorldViewProj);
  oPos = mul(LightSpacePos, mShadowAfterLightTrans);
  
  //oLightSpacePosZ = (oPos.z / oPos.w)  + Z_OFFSET;
  //oPos.z += (Z_OFFSET*oPos.w);

  oLightSpacePos = LightSpacePos;  
}

void VS1(in float4 vPos: POSITION, 
        in float2 vTexC: TEXCOORD,
        out float4 oPos: POSITION, 
        out float2 oTexC: TEXCOORD,
        //out float oLightSpacePosZ: TEXCOORD1
        out float4 oLightSpacePos: TEXCOORD1)
{
  float4 LightSpacePos = mul(vPos, mWorldViewProj);
  oPos = mul(LightSpacePos, mShadowAfterLightTrans);
  
  //oLightSpacePosZ = (oPos.z / oPos.w)  + Z_OFFSET;
  //oPos.z += (Z_OFFSET*oPos.w);
  
  oLightSpacePos = LightSpacePos;
  oTexC = vTexC;
}

/*
void VS1(in float4 vPos: POSITION, 
         in half2 vTexC: TEXCOORD, 
         out float4 oPos: POSITION, 
         out half2 oTexC: TEXCOORD)
{
  oPos = mul(vPos, mWorldViewProj);
  oTexC = vTexC;
}
*/
void VS_Skin(in float4 vPos: POSITION, 
             in half4 vBlendIndices: BLENDINDICES, 
             in WEIGHTTYPE vBlendWeights: BLENDWEIGHT, 
             out float4 oPos: POSITION, 
             uniform int iBonesPerVertex,
             //out float oLightSpacePosZ: TEXCOORD
             out float4 oLightSpacePos: TEXCOORD)
{
  float4x3 mRes;
  mRes = GetBlendMatrix(vBlendIndices, vBlendWeights, iBonesPerVertex);
  oPos.xyz = mul(vPos, mRes);
  oPos.w = 1.0;
  oPos = mul(oPos, mSkinWorldViewProj);
  
  //oLightSpacePosZ = oPos.z + Z_OFFSET;
  
  oLightSpacePos = oPos;
  
  oPos = mul(oPos, mShadowAfterLightTrans);
  
//  oLightSpacePosZ = (oPos.z / oPos.w)  + Z_OFFSET;
//  oPos.z += (Z_OFFSET*oPos.w);
}



sampler2D sBaseMap = sampler_state
{
  Texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Point;
  AddressU = Wrap; AddressV = Wrap;
  MAxAnisotropy = 1;
  MipMapLODBias = <iMipMapLODBias>;
//  AddressU = Clamp; AddressV = Clamp;
};

struct PS_OUTPUT
{
    float4 Color : COLOR0;
    float  Depth  : DEPTH;
};


PS_OUTPUT PS(/*in float vLightSpacePosZ: TEXCOORD*/ in float4 vLightSpacePos: TEXCOORD)//: COLOR0
{
  /*
  float4 tmp;
  tmp.r = saturate(vLightSpacePosZ);
  tmp.g = saturate(vLightSpacePosZ);
  tmp.b = saturate(vLightSpacePosZ);
  tmp.a = 1.0f;
  */
  PS_OUTPUT p;

  float4 tmp;
  
  tmp.r = vLightSpacePos.z / vLightSpacePos.w;
  tmp.r = (tmp.r * 0.5f) + 0.5f;
  tmp.r = tmp.r + fShadowsZOffset;
  tmp.a = 1.0f;
  
  //tmp.r = saturate(tmp.r);
  tmp.g = tmp.r;
  tmp.b = tmp.r;
  
  p.Color = tmp;
  p.Depth = tmp.r;
  
  return p;
}


PS_OUTPUT PS1(in float2 vTexC: TEXCOORD, in float4 vLightSpacePos: TEXCOORD1 /*, in float vLightSpacePosZ: TEXCOORD1*/) //: COLOR0
{
  /*
  float4 cBase = tex2D(sBaseMap, vTexC);
  cBase.r = saturate(vLightSpacePosZ);
  cBase.g = saturate(vLightSpacePosZ);
  cBase.b = saturate(vLightSpacePosZ);
  return cBase;
  */
  
  PS_OUTPUT p;

  float4 tmp;
  tmp.a = tex2D(sBaseMap, vTexC).a;
  
  tmp.r = vLightSpacePos.z / vLightSpacePos.w;
  tmp.r = (tmp.r * 0.5f) + 0.5f;
  tmp.r = tmp.r + fShadowsZOffset;
  
  //tmp.r = saturate(tmp.r);
  tmp.g = tmp.r;
  tmp.b = tmp.r;
  
  p.Color = tmp;
  p.Depth = tmp.r;
  
  return p;  
}

#undef Z_OFFSET

technique AlphaShadows
<
  string shadername = "AlphaShadows";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = false;
    AlphaTestEnable = false;
    AlphaRef = 128;
    AlphaFunc = greater;
    StencilEnable = false;
    CullMode = CW;
    //CullMode = none;
    ColorWriteEnable = 0;
    
    VertexShader = compile vs_1_1 VS();
    PixelShader =  compile ps_2_0 PS();
  }
}


technique AlphaShadowsCliffs
<
  string shadername = "AlphaShadowsCliffs";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = false;
    AlphaTestEnable = false;
    AlphaRef = 128;
    AlphaFunc = greater;
    StencilEnable = false;
    CullMode = CW;
    //CullMode = none;
    ColorWriteEnable = 0;
    
    VertexShader = compile vs_1_1 VS();
    PixelShader =  compile ps_2_0 PS();
  }
}

technique AlphaShadowsLeaves
<
  string shadername = "AlphaShadowsLeaves";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = true;
    AlphaBlendEnable = false;
    AlphaRef =  32;
    AlphaFunc = greater;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    StencilEnable = false;
    CullMode = CW;
    //CullMode = none;
    ColorWriteEnable = 0;
    
    //VertexShader = compile vs_1_1 VS1();
    VertexShader = compile vs_1_1 VS_Leaves();
    PixelShader =  compile ps_2_0 PS1();
   }
}


technique AlphaShadowsTrunk
<
  string shadername = "AlphaShadowsTrunk";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = false;
    AlphaTestEnable = false;
    AlphaRef = 128;
    AlphaFunc = greater;
    StencilEnable = false;
    CullMode = CW;
  //  CullMode = none;
    ColorWriteEnable = 0;
    
    VertexShader = compile vs_1_1 VS_Trunk();
    PixelShader =  compile ps_2_0 PS();
  }
}


technique AlphaShadows1
<
  string shadername = "AlphaShadows1";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = true;
    AlphaBlendEnable = false;
//    AlphaRef = 128;
    AlphaFunc = greater;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    StencilEnable = false;
    CullMode = CW;
//    CullMode = none;
    ColorWriteEnable = 0;
    
    //VertexShader = compile vs_1_1 VS1();
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile ps_2_0 PS1();
   }
}

technique AlphaShadowsTest
<
  string shadername = "AlphaShadowsTest";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = true;
    AlphaBlendEnable = false;
    AlphaRef =  72;
    AlphaFunc = greater;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    StencilEnable = false;
    CullMode = CW;
//    CullMode = none;
    ColorWriteEnable = 0;
    
    //VertexShader = compile vs_1_1 VS1();
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile ps_2_0 PS1();
   }
}

technique AlphaShadowsSkin
<
  string shadername = "AlphaShadowsSkin";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  int BonesPerPartition = BONES_PER_PARTITION;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = false;
    AlphaBlendEnable = false;
    AlphaRef = 128;
    AlphaFunc = greater;
    StencilEnable = false;
    CullMode = CW;
    //CullMode = none;
    ColorWriteEnable = 0;
    
    VertexShader = compile vs_1_1 VS_Skin(4);
    PixelShader =  compile ps_2_0 PS();
  }
}
