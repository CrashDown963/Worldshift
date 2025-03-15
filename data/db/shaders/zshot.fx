// zshot shaders

#include "Utility.fxh"



//#define BONES_PER_PARTITION 40

texture BaseMap <string NTM = "base"; int NTMIndex = 0;>;

float4 cShadow : GLOBAL <bool color = true;> = {0.0, 0.0, 0.0, 1};

// Transformations:
float4x4  mWorldViewProj      : WORLDVIEWPROJECTION;
//float4x4  mWorld              : WORLD;
float4x4  mView               : VIEW;
float4x4  mProj               : PROJ;
//float4x4  mSkinWorldViewProj  : SKINWORLDVIEWPROJ;

//Animation
//float     fTime          : TIME;
float fTime          : GLOBAL = 1.0f;


void VS(in float4 vPos: POSITION, 
        in float2 vTexC: TEXCOORD,
        out float4 oPos: POSITION, 
        out float4 oPosition: TEXCOORD)
{
  oPos = mul(vPos, mWorldViewProj);
  
  oPosition = oPos;  
}


void VS_Leaves(in float4 vPos: POSITION, 
               in float4 cDiff: COLOR,
               in float2 vTexC: TEXCOORD,
               out float4 oPos: POSITION, 
               out float2 oTexC: TEXCOORD,
               out float4 oPosition: TEXCOORD1)
{  
  float4 animatedPos;
  animatedPos.xyz = AnimateLeavesVertex(fTime, vPos.xyz, cDiff.r, cDiff.g);
  animatedPos.w = vPos.w;

  oPos = mul(animatedPos, mWorldViewProj);

  oPosition = oPos;  
  oTexC = vTexC;
}

void VS_Trunk(in float4 vPos: POSITION, 
               in float4 cDiff: COLOR,
               in float2 vTexC: TEXCOORD,
               out float4 oPos: POSITION, 
               //out float oLightSpacePosZ: TEXCOORD)
               out float4 oPosition: TEXCOORD)
{  
  float4 animatedPos;
  animatedPos.xyz = AnimateTrunkVertex(fTime, vPos.xyz, cDiff.r, cDiff.g);
  animatedPos.w = vPos.w;

  oPos = mul(animatedPos, mWorldViewProj);

  oPosition = oPos;  
}

void VS1(in float4 vPos: POSITION, 
        in float2 vTexC: TEXCOORD,
        out float4 oPos: POSITION, 
        out float2 oTexC: TEXCOORD,
        out float4 oPosition: TEXCOORD1)
{
  oPos = mul(vPos, mWorldViewProj);

  
  oPosition = oPos;
  oTexC = vTexC;
}

void VS_Skin(in float4 vPos: POSITION, 
             in half4 vBlendIndices: BLENDINDICES, 
             in WEIGHTTYPE vBlendWeights: BLENDWEIGHT, 
             out float4 oPos: POSITION, 
             uniform int iBonesPerVertex,
             out float4 oPosition: TEXCOORD)
{
  float4x3 mRes;
  mRes = GetBlendMatrix(vBlendIndices, vBlendWeights, iBonesPerVertex);
  oPos.xyz = mul(vPos, mRes);
  oPos.w = 1.0;
  oPos = mul(oPos, mSkinWorldViewProj);
  
  oPosition = oPos;
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


half4 PS(in float4 vPosition: TEXCOORD): COLOR
{
  half4 tmp;

  tmp.a = 1.0f;
  tmp.r = (vPosition.z - fNearPlane) / (fFarPlane - fNearPlane);
  
  tmp.g = tmp.r;
  tmp.b = tmp.r;

  return tmp;
}


half4 PS1(in float2 vTexC: TEXCOORD, in float4 vPosition: TEXCOORD1) : COLOR
{
  half4 tmp;
  tmp.a = tex2D(sBaseMap, vTexC).a;
  
  tmp.r = (vPosition.z - fNearPlane) / (fFarPlane - fNearPlane);
  
  tmp.g = tmp.r;
  tmp.b = tmp.r;

  return tmp;
}

////

half4 PS_DOF(in float4 vPosition: TEXCOORD): COLOR
{
  half4 tmp;

  tmp.a = 1.0f;
  tmp.r = (vPosition.z - fNearPlane) / (fFarPlane - fNearPlane);
  
  if(tmp.r > 0.12)
  {
    tmp.r = (tmp.r - 0.12) / (1 - 0.12);
    tmp.r = sqrt(tmp.r);
  }
  else if(tmp.r < 0.05)
    tmp.r = (0.05 - tmp.r) / (0.05);
  else tmp.r = 0;  
  
  tmp.g = tmp.r;
  tmp.b = tmp.r;

  return tmp;
}


half4 PS1_DOF(in float2 vTexC: TEXCOORD, in float4 vPosition: TEXCOORD1) : COLOR
{
  half4 tmp;
  tmp.a = tex2D(sBaseMap, vTexC).a;
  
  tmp.r = (vPosition.z - fNearPlane) / (fFarPlane - fNearPlane);
  
  if(tmp.r > 0.12)
  {
    tmp.r = (tmp.r - 0.12) / (1 - 0.12);
    tmp.r = sqrt(tmp.r);
  }
  else if(tmp.r < 0.05)
    tmp.r = (0.05 - tmp.r) / (0.05);
  else tmp.r = 0;  
  
  tmp.g = tmp.r;
  tmp.b = tmp.r;

  return tmp;
}

////

half4 PS_Occl(in float4 vPosition: TEXCOORD): COLOR
{
  float4 tmp;

  tmp.a = 1.0f;
  tmp.r = (vPosition.z - fNearPlane) / (fFarPlane - fNearPlane);
  
  uint asword = (uint)(tmp.r * 65535);
  tmp.r = (asword >> 8) / 255.0f;
  
  tmp.g = (asword & 255) / 255.0f;
  tmp.b = 0;

  return tmp;
}


half4 PS1_Occl(in float2 vTexC: TEXCOORD, in float4 vPosition: TEXCOORD1) : COLOR
{
  half4 tmp;
  tmp.a = tex2D(sBaseMap, vTexC).a;
  
  tmp.r = (vPosition.z - fNearPlane) / (fFarPlane - fNearPlane);
  
  uint asword = (uint)(tmp.r * 65535);
  tmp.r = (asword >> 8) / 255.0f;
  
  tmp.g = (asword & 255) / 255.0f;
  tmp.b = 0;

  return tmp;
}

////

technique ZShot
<
  string shadername = "ZShot";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS();
    PixelShader =  compile ps_2_0 PS();
  }
}


technique ZShotLeaves
<
  string shadername = "ZShotLeaves";
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
    ColorWriteEnable = CWEVALUEFULL;
    

    VertexShader = compile vs_1_1 VS_Leaves();
    PixelShader =  compile ps_2_0 PS1();
   }
}


technique ZShotTrunk
<
  string shadername = "ZShotTrunk";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS_Trunk();
    PixelShader =  compile ps_2_0 PS();
  }
}



technique ZShotAlphaTest
<
  string shadername = "ZShotAlphaTest";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile ps_2_0 PS1();
   }
}

technique ZShotAlphaBlend
<
  string shadername = "ZShotAlphaBlend";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = false;
    AlphaBlendEnable = true;
    AlphaRef =  72;
    AlphaFunc = greater;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    StencilEnable = false;
    CullMode = CW;
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile ps_2_0 PS1();
   }
}

technique ZShotSkin
<
  string shadername = "ZShotSkin";
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
    StencilEnable = false;
    CullMode = CW;
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS_Skin(4);
    PixelShader =  compile ps_2_0 PS();
  }
}


////////////////////// DOF techniques

technique ZShotDOF
<
  string shadername = "ZShotDOF";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS();
    PixelShader =  compile ps_2_0 PS_DOF();
  }
}


technique ZShotLeavesDOF
<
  string shadername = "ZShotLeavesDOF";
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
    ColorWriteEnable = CWEVALUEFULL;
    

    VertexShader = compile vs_1_1 VS_Leaves();
    PixelShader =  compile ps_2_0 PS1_DOF();
   }
}


technique ZShotTrunkDOF
<
  string shadername = "ZShotTrunkDOF";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS_Trunk();
    PixelShader =  compile ps_2_0 PS_DOF();
  }
}



technique ZShotAlphaTestDOF
<
  string shadername = "ZShotAlphaTestDOF";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile ps_2_0 PS1_DOF();
   }
}

technique ZShotAlphaBlendDOF
<
  string shadername = "ZShotAlphaBlendDOF";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = false;
    AlphaBlendEnable = true;
    AlphaRef =  72;
    AlphaFunc = greater;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    StencilEnable = false;
    CullMode = CW;
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile ps_2_0 PS1_DOF();
   }
}

technique ZShotSkinDOF
<
  string shadername = "ZShotSkinDOF";
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
    StencilEnable = false;
    CullMode = CW;
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS_Skin(4);
    PixelShader =  compile ps_2_0 PS_DOF();
  }
}


//////////////////// Occl techniques
/*
technique ZShotOccl
<
  string shadername = "ZShotOccl";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS();
    PixelShader =  compile _PS2X_ PS_Occl();
  }
}


technique ZShotLeavesOccl
<
  string shadername = "ZShotLeavesOccl";
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
    ColorWriteEnable = CWEVALUEFULL;
    

    VertexShader = compile vs_1_1 VS_Leaves();
    PixelShader =  compile _PS2X_ PS1_Occl();
   }
}


technique ZShotTrunkOccl
<
  string shadername = "ZShotTrunkOccl";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS_Trunk();
    PixelShader =  compile _PS2X_ PS_Occl();
  }
}



technique ZShotAlphaTestOccl
<
  string shadername = "ZShotAlphaTestOccl";
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
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile _PS2X_ PS1_Occl();
   }
}

technique ZShotAlphaBlendOccl
<
  string shadername = "ZShotAlphaBlendOccl";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaTestEnable = false;
    AlphaBlendEnable = true;
    AlphaRef =  72;
    AlphaFunc = greater;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    StencilEnable = false;
    CullMode = CW;
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS1();
    PixelShader =  compile _PS2X_ PS1_Occl();
   }
}

technique ZShotSkinOccl
<
  string shadername = "ZShotSkinOccl";
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
    StencilEnable = false;
    CullMode = CW;
    ColorWriteEnable = CWEVALUEFULL;
    
    VertexShader = compile vs_1_1 VS_Skin(4);
    PixelShader =  compile _PS2X_ PS_Occl();
  }
}
*/