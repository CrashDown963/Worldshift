#include "Utility.fxh"

// Supported maps:
texture BaseMap      <string NTM = "base";   int NTMIndex = 0;>;
texture NormalMap    <string NTM = "bump";   int NTMIndex = 0;>;
texture EnvMap       <string NTM = "shader";>;
texture ShadowMap    <string NTM = "shader"; int NTMIndex = 1; bool hidden = true;>;
texture OcclusionMap <string NTM = "shader"; int NTMIndex = 6; bool hidden = true;>;
texture VisionMap    <string NTM = "shader"; int NTMIndex = 4; bool hidden = true;>;

sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = <iMinFilter>; MagFilter = Linear; MipFilter = Linear;
  MaxAnisotropy = <iMaxAnisotropy>;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = wrap; AddressV = wrap;
};

sampler2D sNormal = sampler_state
{
  texture = <NormalMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = wrap; AddressV = wrap;
};

sampler2D sShadowMap = sampler_state
{
  texture = <ShadowMap>;
  SHADOW_SAMPLER_STATES;
};

sampler2D sOcclusion = sampler_state
{
  texture = <OcclusionMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp; AddressW = clamp;
};

sampler2D sVision = sampler_state
{
  texture = <VisionMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp; AddressW = clamp;
};

// Transformations:
half4x4   mWorldView     : WORLDVIEW;
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
half4x4   mInvWorldTrans : INVWORLDTRANSPOSE;

//float     fTime          : TIME;

#include "Tint.fxh"

struct VS_INPUT {
  float4 vPos : POSITION;
  half2  vTexC: TEXCOORD;
  half3  vNorm: NORMAL; 
  half3  vBin : BINORMAL; 
  half3  vTan : TANGENT; 
  half4  cDiff: COLOR;       //.x -> weight, used for animation; .y -> phase, .z -> vision
};

struct VS_INPUT_LOD {
  float4 vPos : POSITION;
  half2  vTexC: TEXCOORD;
  half3  vNorm: NORMAL; 
  half4  cDiff: COLOR;       //.x -> weight, used for animation; .y -> phase, .z -> vision
};

struct VS_OUTPUT {
  half3   cDiff    : COLOR0;
  float4  vPos     : POSITION;
  half4   vTexC    : TEXCOORD; // .xy - diffuse map, .zw - normal map
  half3   cLight   : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  half3x3 mTan     : TEXCOORD4;
  float4  vShaC    : TEXCOORD7;
  half    fFog     : FOG;
};

struct VS_OUTPUT_LOD {
  half3   cDiff    : COLOR0;
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half3   vNorm    : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  float4  vShaC    : TEXCOORD4;
  half3   cLight   : TEXCOORD5;
  half    fFog     : FOG;
};

struct VS_OUTPUT_TEST {
  half3   cDiff    : COLOR0;
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half3   vNorm    : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  half3   cLight   : TEXCOORD4;
  float4  vShaC    : TEXCOORD5;
  half    fFog     : FOG;
};

struct VS_OUTPUT_TEST_LOD {
  half3   cDiff    : COLOR0;
  float4  vPos     : POSITION;
  half2   vTexC    : TEXCOORD;
  half3   vNorm    : TEXCOORD1;
  half3   vVOC     : TEXCOORD2;
  float3  vHalfPos : TEXCOORD3;
  float4  vShaC    : TEXCOORD4;
  half3   cLight   : TEXCOORD5;
  half    fFog     : FOG;
};




VS_OUTPUT VS_Tree_Trunk(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT o;
  
  //o.vPos = mul(v.vPos, mWorldViewProj);
  
  //Animate Vertex  
  o.vPos.xyz = AnimateTrunkVertex(fTime, v.vPos.xyz, v.cDiff.r, v.cDiff.g);
  o.vPos.w = v.vPos.w;
  o.vTexC.xy = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.vTexC.zw = v.vTexC;
  
  //float3 vWorld = mul(v.vPos, mWorld);
  float3 vWorld = mul(o.vPos, mWorld);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld, vMapDimMin, vMapDimMax);

  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;

  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans, true);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);

  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;

  o.fFog   = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  o.cDiff  = v.cDiff;
  
  return o;
}



VS_OUTPUT_TEST VS_Tree_AlphaTest(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_TEST o;
  
  //o.vPos = mul(v.vPos, mWorldViewProj);
  
  //Animate Vertex  
  o.vPos.xyz = AnimateLeavesVertex(fTime, v.vPos.xyz, v.cDiff.r, v.cDiff.g);
  o.vPos.w = v.vPos.w;
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  
  //float3 vWorld = mul(v.vPos, mWorld);
  float3 vWorld = mul(o.vPos, mWorld);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld, vMapDimMin, vMapDimMax);

  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  
  o.vNorm = mul(v.vNorm.xyz, mInvWorldTrans);
  o.vNorm = normalize(o.vNorm);
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
    
  o.fFog   = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.vNorm), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.vNorm, vSunDirection));
  o.cDiff  = v.cDiff;
  CalcVertAmbDiff(o.vNorm, cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.vNorm, vSunDirection);
  
  return o;
}



VS_OUTPUT_LOD VS_TreeLOD(VS_INPUT_LOD v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_LOD o;
  
  //o.vPos = mul(v.vPos, mWorldViewProj);
  
  //Animate Vertex  
  o.vPos.xyz = AnimateTrunkVertex(fTime, v.vPos.xyz, v.cDiff.r, v.cDiff.g);
  o.vPos.w = v.vPos.w;
  
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  //float3 vWorld = mul(v.vPos, mWorld);
  float3 vWorld = mul(o.vPos, mWorld);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld, vMapDimMin, vMapDimMax);
  
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
    
  float3 vv;
  vv.xyz = v.vNorm;  
  
  o.vNorm = mul(vv, mInvWorldTrans);
  o.vNorm = normalize(o.vNorm);
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.vNorm), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.vNorm, vSunDirection));
  
  return o;
}



VS_OUTPUT_TEST_LOD VS_Tree_AlphaTestLOD(VS_INPUT_LOD v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_TEST_LOD o;
  
  //o.vPos = mul(v.vPos, mWorldViewProj);
  
  //Animate Vertex  
  o.vPos.xyz = AnimateLeavesVertex(fTime, v.vPos.xyz, v.cDiff.r, v.cDiff.g);
  o.vPos.w = v.vPos.w;
  
  
  o.vTexC = mul(half4(v.vTexC, 0, 1), mTexBase);
  //float3 vWorld = mul(v.vPos, mWorld);
  float3 vWorld = mul(o.vPos, mWorld);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld, vMapDimMin, vMapDimMax);
  
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
    
  float3 vv;
  vv.xyz = v.vNorm;  
  
  o.vNorm = mul(vv, mInvWorldTrans);
  o.vNorm = normalize(o.vNorm);
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
    
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.vNorm), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.vNorm, vSunDirection));
  
  return o;
}



void PS_Tree_AlphaTest(VS_OUTPUT_TEST p, out half4 cOut: COLOR0,
                       uniform bool bShadows, uniform bool bExplicitFog)
{
  half4 cPix;
  half3 vNorm;
  half fVO;
  
  cPix = tex2D(sBase, p.vTexC);
  vNorm = p.vNorm;
  fVO = CalcVO(sOcclusion, p.vVOC);

  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
 
  vNorm.xyz = normalize(vNorm);
 
  cOut = CalcAmbDiff(cMa, half4(cMd.rgb, cPix.a), 
                     cAmbientLight, cSunColor, cPix,
                     fBacklightStrength, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(cOut, p.vNorm, cPix, fVO);
  cOut.rgb += DecodeLight(p.cLight, half4(cPix.rgb, 0), fVO);
  SetTextureVision(p.cDiff.b, sVision, p.vVOC);
  cOut.rgb *= p.cDiff.b;
  cOut.a *= lerp(0.0, 2.0, p.cDiff.b);

  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, p.fFog);
}



void PS_Tree_Trunk(VS_OUTPUT p, out half4 cOut: COLOR0,
                   uniform bool bShadows, uniform bool bExplicitFog)
{
  half4 cPix;
  half4 vNorm;
  half fVO;
  
  cPix = tex2D(sBase, p.vTexC.xy);
  vNorm = tex2D(sNormal, p.vTexC.zw);
  fVO = CalcVO(sOcclusion, p.vVOC);
  
  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);

  vNorm.xyz = normalize(mul(FixNorm(vNorm.xyz), p.mTan));

  cOut = CalcAmbDiffSpec(cMa, cMd, cMs, fShininess, 
                         cAmbientLight, cSunColor, cSunSpecColor, cPix,
                         fBacklightStrength, p.vHalfPos, vNorm.xyz, vSunDirection, fVO);
  OverridePixelLight(cOut, p.mTan[0], half4(cPix.rgb, cMd.a), fVO);
  cOut.rgb += DecodeLight(p.cLight, cPix, fVO);
  SetTextureVision(p.cDiff.b, sVision, p.vVOC);
  cOut.rgb *= p.cDiff.b;                             
  cOut.a *= lerp(0.0, 2.0, p.cDiff.b);
  
  if (bExplicitFog)
    cOut.rgb = lerp(cFogColor, cOut.rgb, p.fFog);                             
}


//Tree techniques

#define TREE_TECH(t, d, pub, impa, p)\
  technique t\
  <\
    string shadername = #t;\
    string description = d;\
    int implementation = 0;\
    string NBTMethod = "NDL";\
    bool UsesNIRenderState = false;\
    bool UsesNILightState = false;\
    bool bPublic = pub;\
    bool ImplicitAlpha = impa;\
  >\
  {\
    p\
  }

#define TREE_STATES\
  AlphaBlendEnable = false;\
  AlphaTestEnable = false;\
  AlphaRef = 32;\
  AlphaFunc = greater;\
  ColorWriteEnable = CWEVALUE;\
  DitherEnable = true;\
  CullMode = CW;\
  StencilEnable = <!!iOccluder>;\
  TwoSidedStencilMode = false;\
  StencilFail = KEEP;\
  StencilPass = REPLACE;\
  StencilZFail = KEEP;\
  StencilFunc = ALWAYS;\
  StencilMask = 0x10;\
  StencilWriteMask = 0x10;\
  StencilRef = 0x10;\
  FogEnable = true;\
  ZEnable = true;\
  ZFunc = LESSEQUAL;\
  ZWriteEnable = true
  
#define TREE_STATES_ALPHATEST\
    AlphaBlendEnable = false;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaRef = 32;\
    AlphaFunc = greater;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = false;\
    CullMode = none;\
    StencilEnable = <!!iOccluder>;\
    TwoSidedStencilMode = false;\
    StencilFail = KEEP;\
    StencilPass = REPLACE;\
    StencilZFail = KEEP;\
    StencilFunc = ALWAYS;\
    StencilMask = 0x10;\
    StencilWriteMask = 0x10;\
    StencilRef = 0x10;\
    FogEnable = true;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define TREE_STATES_ALPHABLEND\
    AlphaBlendEnable = true;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaRef = 0;\
    AlphaFunc = greater;\
    ColorWriteEnable = CWEVALUE;\
    DitherEnable = false;\
    CullMode = none;\
    StencilEnable = <!!iOccluder>;\
    TwoSidedStencilMode = false;\
    StencilFail = KEEP;\
    StencilPass = REPLACE;\
    StencilZFail = KEEP;\
    StencilFunc = ALWAYS;\
    StencilMask = 0x10;\
    StencilWriteMask = 0x10;\
    StencilRef = 0x10;\
    FogEnable = true;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = true

#define TREES_PASS(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(pos,sha);\
    PixelShader = compile ps_ver ps(sha,fog);\
  }
  
#define TINT_PASS_TREES(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(pos,sha);\
    PixelShader = compile ps_ver ps(sha,fog);\
  }\
  TINT_PASS_OBJECT_ALPHATEST_ANIM(false)

#define TREE_TECHTINT(t,d,pub,impa,ds,vs_ver,vs,ps_ver,ps,pos,sha,fog)\
  TREE_TECH(t,d,pub,impa,TREES_PASS(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog))\
  TREE_TECH(t##_Tint,"Internal technique, do not use.",false,impa,TINT_PASS_TREES(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog))

#define TREE_TECHNIQUE(t,d,impa,ds,vs_ver,vs,ps_ver,ps,pos)\
  TREE_TECHTINT(t,d,true,impa,ds,vs_ver,vs,ps_ver,ps,pos,false,false)\
  TREE_TECHTINT(t##_Shadows,"Internal technique, do not use.",false,impa,ds,vs_ver,vs,ps_ver,ps,pos,true,false)

#define TINT_PASS_TRUNK(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(pos,sha);\
    PixelShader = compile ps_ver ps(sha,fog);\
  }\
  TINT_PASS_OBJECT_ANIM(true)

#define TRUNK_TECHTINT(t,d,pub,impa,ds,vs_ver,vs,ps_ver,ps,pos,sha,fog)\
  TREE_TECH(t,d,pub,impa,TREES_PASS(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog))\
  TREE_TECH(t##_Tint,"Internal technique, do not use.",false,impa,TINT_PASS_TRUNK(ds,vs_ver,vs,ps_ver,ps,pos,sha,fog))

#define TRUNK_TECHNIQUE(t,d,impa,ds,vs_ver,vs,ps_ver,ps,pos)\
  TRUNK_TECHTINT(t,d,true,impa,ds,vs_ver,vs,ps_ver,ps,pos,false,false)\
  TRUNK_TECHTINT(t##_Shadows,"Internal technique, do not use.",false,impa,ds,vs_ver,vs,ps_ver,ps,pos,true,false)

  
TRUNK_TECHNIQUE(_Embel_Spec_Tree_Normal, "Shader with base texture, normal map, VOE and specular.", false,
                TREE_STATES, _VS2X_, VS_Tree_Trunk, _PS2X_, PS_Tree_Trunk, false)
TREE_TECHNIQUE(_Embel_Tree_AlphaTest, "Tree shader (with animated vertices) with base texture & VOE, and alpha in base map.", false,
               TREE_STATES_ALPHATEST, _VS2X_, VS_Tree_AlphaTest, _PS2X_, PS_Tree_AlphaTest, true)
TREE_TECHNIQUE(_Embel_Tree_AlphaBlend, "Test tree (animating vertices) embelishments shader with base texture & VOE, specular color and alpha in base map.", true,
               TREE_STATES_ALPHABLEND, _VS2X_, VS_Tree_AlphaTest, _PS2X_, PS_Tree_AlphaTest, true)
