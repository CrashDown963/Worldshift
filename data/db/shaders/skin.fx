// Skinned units shader

#include "PS_Units.fxh"

struct VS_SKIN_INPUT {
  float4 vPos         : POSITION;
  half4  vBlendIndices: BLENDINDICES;
  WEIGHTTYPE  vBlendWeights: BLENDWEIGHT;
  half2  vTexC        : TEXCOORD;
  half3  vNorm        : NORMAL;
  half3  vBin         : BINORMAL; 
  half3  vTan         : TANGENT; 
};


struct VS_SKIN_VCOLOR_INPUT {
  float4 vPos         : POSITION;
  half4  vColor       : COLOR; 
  half4  vBlendIndices: BLENDINDICES;
  WEIGHTTYPE  vBlendWeights: BLENDWEIGHT;
  half2  vTexC        : TEXCOORD;
  half3  vNorm        : NORMAL;
  half3  vBin         : BINORMAL; 
  half3  vTan         : TANGENT; 
};


struct VS_BLD_SKIN_INPUT {
  float4 vPos         : POSITION;
  half4  vBlendIndices: BLENDINDICES;
  WEIGHTTYPE  vBlendWeights: BLENDWEIGHT;
  half2  vTexC        : TEXCOORD;
  half2  vDarkTexC    : TEXCOORD1;
  half3  vNorm        : NORMAL;
  half3  vBin         : BINORMAL; 
  half3  vTan         : TANGENT; 
};

struct VS_BLD_BUILD_SKIN_INPUT {
  float4 vPos         : POSITION;
  half4  vBlendIndices: BLENDINDICES;
  WEIGHTTYPE  vBlendWeights: BLENDWEIGHT;
  half2  vTexC        : TEXCOORD;
  half2  vDarkTexC    : TEXCOORD1;
  half2  vAlphaBldTexC: TEXCOORD2;
  half3  vNorm        : NORMAL;
  half3  vBin         : BINORMAL; 
  half3  vTan         : TANGENT; 
};


struct VS_ITEM_SKIN_INPUT {
  float4 vPos          : POSITION;
  half4  vBlendIndices : BLENDINDICES;
  WEIGHTTYPE  vBlendWeights : BLENDWEIGHT;
  half2  vTexC         : TEXCOORD;
  half3  vNorm         : NORMAL; 
  half3  vBin          : BINORMAL; 
  half3  vTan          : TANGENT; 
  half4  cColor        : COLOR;       //.x -> weight, used for animation
};

half4x4   mInvWorldTrans : INVWORLDTRANSPOSE;

VS_OUTPUT VS_Skin(VS_SKIN_INPUT v, uniform int iBonesPerVertex, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT o;

  float4 vSkinPos;
  float4x3 mBlendedBone;
  float3 vWorld;

  mBlendedBone = GetBlendMatrix(v.vBlendIndices, v.vBlendWeights, iBonesPerVertex);
  vSkinPos.xyz = mul(v.vPos, mBlendedBone);
  vSkinPos.w = 1.0;
  o.vPos = mul(vSkinPos, mSkinWorldViewProj);
  o.vTexC = v.vTexC;
  vWorld = mul(vSkinPos, mSkinWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  // Transfer normals to skin space, then to world
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, mul((half3x3) mBlendedBone, (half3x3) mInvSkinWorldTrans));
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);

  o.cLights = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

VS_VALPHA_OUTPUT VS_Skin_VAlpha(VS_SKIN_VCOLOR_INPUT v, uniform int iBonesPerVertex, uniform bool bPosition, uniform bool bShadows)
{
  VS_VALPHA_OUTPUT o;

  float4 vSkinPos;
  float4x3 mBlendedBone;
  float3 vWorld;

  mBlendedBone = GetBlendMatrix(v.vBlendIndices, v.vBlendWeights, iBonesPerVertex);
  vSkinPos.xyz = mul(v.vPos, mBlendedBone);
  vSkinPos.w = 1.0;
  o.vPos = mul(vSkinPos, mSkinWorldViewProj);
  o.vTexC = v.vTexC;
  vWorld = mul(vSkinPos, mSkinWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  // Transfer normals to skin space, then to world
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, mul((half3x3) mBlendedBone, (half3x3) mInvSkinWorldTrans));
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  o.cLights = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cVColor = v.vColor;
  
  return o;
}


VS_BLD_OUTPUT VS_Bld_Skin(VS_BLD_SKIN_INPUT v, uniform int iBonesPerVertex, uniform bool bPosition, uniform bool bShadows)
{
  VS_BLD_OUTPUT o;

  float4 vSkinPos;
  float4x3 mBlendedBone;
  float3 vWorld;

  mBlendedBone = GetBlendMatrix(v.vBlendIndices, v.vBlendWeights, iBonesPerVertex);
  vSkinPos.xyz = mul(v.vPos, mBlendedBone);
  vSkinPos.w = 1.0;
  o.vPos = mul(vSkinPos, mSkinWorldViewProj);
  o.vTexC.xy = v.vTexC;
  o.vTexC.zw = v.vDarkTexC;
  vWorld = mul(vSkinPos, mSkinWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  // Transfer normals to skin space, then to world
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, mul((half3x3) mBlendedBone, (half3x3) mInvSkinWorldTrans));
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  o.cLights = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

VS_BLD_BUILD_OUTPUT VS_Bld_Skin_Build(VS_BLD_BUILD_SKIN_INPUT v, uniform int iBonesPerVertex, uniform bool bPosition, uniform bool bShadows)
{
  VS_BLD_BUILD_OUTPUT o;

  float4 vSkinPos;
  float4x3 mBlendedBone;
  float3 vWorld;

  mBlendedBone = GetBlendMatrix(v.vBlendIndices, v.vBlendWeights, iBonesPerVertex);
  vSkinPos.xyz = mul(v.vPos, mBlendedBone);
  vSkinPos.w = 1.0;
  o.vPos = mul(vSkinPos, mSkinWorldViewProj);
  o.vTexC.xy = v.vTexC;
  o.vTexC.zw = v.vDarkTexC;
  o.vAlphaBldTexC.xy =  mul(half4(v.vAlphaBldTexC, 0, 1), mTexBase);
  vWorld = mul(vSkinPos, mSkinWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  // Transfer normals to skin space, then to world
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, mul((half3x3) mBlendedBone, (half3x3) mInvSkinWorldTrans));
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  o.cLights = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

VS_OUTPUT VS_Skin_Rimlight(VS_SKIN_INPUT v, uniform int iBonesPerVertex, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT o = VS_Skin(v, iBonesPerVertex, true, bShadows);
  o.vHalfPos = normalize(vWorldCamera - o.vHalfPos);
  return o;
}

VS_ITEM_OUTPUT VS_Item_Skin(VS_ITEM_SKIN_INPUT v, uniform int iBonesPerVertex, uniform bool bPosition, uniform bool bShadows)
{
  VS_ITEM_OUTPUT o;
  
  float4 vSkinPos;
  float4x3 mBlendedBone;
  float3 vWorld;

  mBlendedBone = GetBlendMatrix(v.vBlendIndices, v.vBlendWeights, iBonesPerVertex);

  vSkinPos.xyz = mul(v.vPos, mBlendedBone);
  vSkinPos.w = 1.0;
  o.vPos = mul(vSkinPos, mSkinWorldViewProj);
  vWorld = mul(vSkinPos, mSkinWorld);
  o.vTexC.xy = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.vTexC.zw = v.vTexC;
  o.vVOC.xyz = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, mul((half3x3) mBlendedBone, (half3x3) mInvSkinWorldTrans), true);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
/*  o.mTan = float3x3(v.vTan, v.vBin, v.vNorm);
  o.mTan = TransformTangentSpace(o.mTan);
  o.mTan = mul(o.mTan, mInvWorldTrans);
  o.mTan[0] = normalize(o.mTan[0]);
  o.mTan[1] = normalize(o.mTan[1]);
  o.mTan[2] = normalize(o.mTan[2]);
*/  
  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else 
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  o.cLight = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));
  
  return o;
}

#define SKIN_ANNO\
    int implementation = 0;\
    string NBTMethod = "NDL";\
    bool UsesNIRenderState = false;\
    bool UsesNILightState = false;\
    int BonesPerPartition = BONES_PER_PARTITION

#define SKIN_ALPHA_ANNO\
    int implementation = 0;\
    string NBTMethod = "NDL";\
    bool UsesNIRenderState = false;\
    bool UsesNILightState = false;\
    bool ImplicitAlpha = true;\
    bool DoubleSided = true;\
    int BonesPerPartition = BONES_PER_PARTITION

#define SUFF_PUBLIC\
    bool bPublic = true

#define SUFF_INTERNAL\
    bool bPublic = false
    
#define SKIN_TECH(t,d,a,suff,p)\
  technique t\
  <\
    string shadername = #t;\
    string description = d;\
    a;\
    suff;\
  >\
  {\
    p\
  }

#define SKIN_PASS(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(4,pos,sha);\
    PixelShader = compile ps_ver ps(pcol,glow,sha,fog,fow,opm);\
  }

float4x4  mWorldViewProj  : WORLDVIEWPROJ;
#include "Tint.fxh"

#define TINT_PASS_SKIN(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(4,pos,sha);\
    PixelShader = compile ps_ver ps(pcol,glow,sha,fog,fow,opm);\
  }\
  TINT_PASS_SKINNED_OBJECT

#define SKIN_TECHTINT(t,d,a,suff,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm)\
  SKIN_TECH(t,d,a,suff,SKIN_PASS(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm))\
  SKIN_TECH(t##_Tint,"Internal technique, do not use.",a,SUFF_INTERNAL,TINT_PASS_SKIN(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm))
  
#define SKIN_TECHSHADOWS(t,d,a,suff,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,fow,opm)\
  SKIN_TECHTINT(t,d,a,suff,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,false,false,fow,opm)\
  SKIN_TECHTINT(t##_Shadows,"Internal technique, do not use.",a,SUFF_INTERNAL,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,true,false,fow,opm)

#define SKIN_TECHNIQUE(t,d,a,ds,dstrans,vs_ver,vs,ps_ver,ps,pos,pcol,glow,opamask)\
  SKIN_TECHSHADOWS(t,d,a,SUFF_PUBLIC,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,false,opamask)\
  SKIN_TECHSHADOWS(t##_Trans,"Internal technique, do not use.",SKIN_ALPHA_ANNO,SUFF_INTERNAL,UNIT_ALPHA_STATES,vs_ver,vs,ps_ver,ps,pos,pcol,glow,true,opamask)


SKIN_TECHNIQUE(_Skin, "Default skinned units shader with base texture, normal map, player color, VEO and specular. Alpha in the base texture is a gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
               SKIN_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units, false, true, false, false)
SKIN_TECHNIQUE(_Skin_Alpha, "Skinned units shader with base texture, normal map, player color, VEO, specular and opacity. Alpha in the base texture is an opacity mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Alpha, false, true, false, false)
//SKIN_TECHNIQUE(_Skin_Rimlight, "Default skinned units shader with base texture, normal map, player color, VEO and specular. Alpha in the base texture is a gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
//               SKIN_ANNO, UNIT_STATES, _VS2X_, VS_Skin_Rimlight, _PS2X_, PS_Units_Rimlight, false, true, false, false)
SKIN_TECHNIQUE(_Skin_Env, "Skinned units shader with base texture, normal map, player color, VEO and environment map. Alpha in the base texture is a environment gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
               SKIN_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Env, true, true, false, false)
SKIN_TECHNIQUE(_Skin_Env_Alpha, "Skinned units shader with base texture, normal map, VEO, environment map and transparency. Alpha in the base texture is a gloss mask, and alpha in the normal map means transparency.",
               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Env, true, false, false, false)
SKIN_TECHNIQUE(_Skin_Glow, "Skinned units shader with base texture, normal map, player color, VEO and emissive glow. Alpha in the base texture is a glow mask, and alpha in the normal map marks where the player color should be used over the texture.",
               SKIN_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Glow, true, true, true, false)

//SKIN_TECHNIQUE(_Skin_Human, "Human skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//               SKIN_ANNO, UNIT_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, false)
//SKIN_TECHNIQUE(_Skin_Human_Alpha, "Human skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, false)
//SKIN_TECHNIQUE(_Skin_Human_Opacity, "Human skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)
//SKIN_TECHNIQUE(_Skin_Human_Test, "Human skinned units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//               SKIN_ANNO, UNIT_TEST_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)


//SKIN_TECHNIQUE(_Skin_Mutant, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//               SKIN_ANNO, UNIT_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, false)
//SKIN_TECHNIQUE(_Skin_Mutant_Opacity, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)
//SKIN_TECHNIQUE(_Skin_Mutant_Test, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//               SKIN_ANNO, UNIT_TEST_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)
SKIN_TECHNIQUE(_Skin_Mutant_VAlpha, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular, glow and vertex alpha. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin_VAlpha, _PS2X_, PS_Units_VAlpha_Mask, false, true, true, false)


//SKIN_TECHNIQUE(_Skin_Animal, "Skinned animals/objects shader with base texture, normal map, VEO, specular and glow. Alpha in the base texture is a gloss mask. No hufx.",
//               SKIN_ANNO, UNIT_STATES_NOSTENCIL, _VS2X_, VS_Skin, _PS2X_, PS_Units, false, true, false, false)
//SKIN_TECHNIQUE(_Skin_Mob_Opacity, "Mob skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)
//SKIN_TECHNIQUE(_Skin_Mob_Test, "Mob skinned units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//               SKIN_ANNO, UNIT_TEST_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)



SKIN_TECHNIQUE(_Skin_Mirror, "Special mirror skinned units shader with base texture, normal map, player color, VEO, specular, glow and environment map. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
               SKIN_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mirror, true, true, true, false)

// Artefact shader techniques, curse them and all the DirectX bugs!
//SKIN_TECHSHADOWS(_Skin_Item, "Skinned, base texture, normal map, VOE, specular and glow. Alpha in base texture is gloss, alpha in normal map is glow map.",
//                 SKIN_ANNO, SUFF_PUBLIC, ITEM_STATES, _VS2X_, VS_Item_Skin, _PS2X_, PS_Item, false, true, false, false, false)


// Building skinned shader techniques
/*
SKIN_TECHNIQUE(_BSkin, "Default skinned buildings shader with base texture, normal map, player color, VEO and specular. Alpha in the base texture is a gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
               SKIN_ANNO, BLD_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units, false, true, false, false)
SKIN_TECHNIQUE(_BSkin_Alpha, "Skinned buildings shader with base texture, normal map, player color, VEO, specular and opacity. Alpha in the base texture is an opacity mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Alpha, false, true, false, false)
SKIN_TECHNIQUE(_BSkin_Env, "Skinned buildings shader with base texture, normal map, player color, VEO and environment map. Alpha in the base texture is a environment gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
               SKIN_ANNO, BLD_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Env, true, true, false, false)
SKIN_TECHNIQUE(_BSkin_Env_Alpha, "Skinned buildings shader with base texture, normal map, VEO, environment map and transparency. Alpha in the base texture is a gloss mask, and alpha in the normal map means transparency.",
               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Env, true, false, false, false)
SKIN_TECHNIQUE(_BSkin_Glow, "Skinned buildings shader with base texture, normal map, player color, VEO and emissive glow. Alpha in the base texture is a glow mask, and alpha in the normal map marks where the player color should be used over the texture.",
               SKIN_ANNO, BLD_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Glow, true, true, true, false)
*/
//SKIN_TECHNIQUE(_BSkin_Human, "Human skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//               SKIN_ANNO, BLD_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, false)
//SKIN_TECHNIQUE(_BSkin_Human_Alpha, "Human skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, false)
//SKIN_TECHNIQUE(_BSkin_Human_Opacity, "Human skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, true)
SKIN_TECHNIQUE(_BSkin_Human_Test, "Human skinned units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity. Parameter: cColorization - color.",
               SKIN_ANNO, BLD_TEST_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, true)

//SKIN_TECHNIQUE(_BSkin_Human_MaterialAlpha, "Human skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, false)



//SKIN_TECHNIQUE(_BSkin_Mutant, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//               SKIN_ANNO, BLD_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, false)
//SKIN_TECHNIQUE(_BSkin_Mutant_Opacity, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity. Parameter: cColorization - color.",
//               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, true)
//SKIN_TECHNIQUE(_BSkin_Mutant_Test, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity. Parameter: cColorization - color.",
//               SKIN_ANNO, BLD_TEST_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, true)
SKIN_TECHNIQUE(_BSkin_Mutant_Build, "Mutant skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin_Build, _PS2X_, PS_Bld_Build, false, true, true, false)

// New -------------------------

SKIN_TECHNIQUE(_Skin_Faction, "Faction skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
               SKIN_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, false)
SKIN_TECHNIQUE(_Skin_Faction_Opacity, "Human skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
               SKIN_ALPHA_ANNO, UNIT_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)
SKIN_TECHNIQUE(_Skin_Faction_Test, "Faction skinned units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
               SKIN_ANNO, UNIT_TEST_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Skin, _PS2X_, PS_Units_Mask, false, true, true, true)

SKIN_TECHSHADOWS(_Skin_Item, "Skinned, base texture, normal map, VOE, specular and glow. Alpha in base texture is gloss, alpha in normal map is glow map.",
                 SKIN_ANNO, SUFF_PUBLIC, ITEM_STATES, _VS2X_, VS_Item_Skin, _PS2X_, PS_Item, false, true, false, false, false)

// Artefact shader techniques, curse them and all the DirectX bugs!
SKIN_TECHNIQUE(_Skin_Animal, "Skinned animals/objects shader with base texture, normal map, VEO, specular and glow. Alpha in the base texture is a gloss mask. No hufx.",
               SKIN_ANNO, UNIT_STATES_NOSTENCIL, UNIT_ALPHA_STATES_NOSTENCIL, _VS2X_, VS_Skin, _PS2X_, PS_Units, false, true, false, false)
               
SKIN_TECHNIQUE(_BSkin_Faction, "Faction skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
               SKIN_ANNO, BLD_STATES, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, false)
SKIN_TECHNIQUE(_BSkin_Faction_Opacity, "Faction skinned units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity. Parameter: cColorization - color.",
               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, true)

SKIN_TECHNIQUE(_BSkin_Faction_MaterialAlpha, "Faction skinned units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
               SKIN_ALPHA_ANNO, BLD_ALPHA_STATES, BLD_ALPHA_STATES, _VS2X_, VS_Bld_Skin, _PS2X_, PS_Bld, false, true, true, false)