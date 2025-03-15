// Units shader

#include "PS_Units.fxh"

// Transformations:
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
half4x4   mInvWorldTrans : INVWORLDTRANSPOSE /*WorldInverseTranspose*/;

struct VS_INPUT {
  float4 vPos         : POSITION;
  half2  vTexC        : TEXCOORD;
  half3  vNorm        : NORMAL;
  half3  vBin         : BINORMAL; 
  half3  vTan         : TANGENT; 
};

struct VS_BLD_INPUT {
  float4 vPos         : POSITION;
  half2  vTexC        : TEXCOORD;
  half2  vDarkTexC    : TEXCOORD1;
  half3  vNorm        : NORMAL;
  half3  vBin         : BINORMAL; 
  half3  vTan         : TANGENT; 
};

struct VS_ITEM_INPUT {
  float4 vPos : POSITION;
  half2  vTexC: TEXCOORD;
  half3  vNorm: NORMAL; 
  half3  vBin : BINORMAL; 
  half3  vTan : TANGENT; 
  half4  cColor: COLOR;       //.x -> weight, used for animation
};


VS_OUTPUT VS_Units(VS_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT o;
  float3 vWorld;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  vWorld = mul(v.vPos, mWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  o.cLights = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));

  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

VS_BLD_OUTPUT VS_Bld(VS_BLD_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_BLD_OUTPUT o;
  float3 vWorld;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC.xy = v.vTexC;
  o.vTexC.zw = v.vDarkTexC;
  vWorld = mul(v.vPos, mWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans);
  CalcVertAmbDiff(o.mTan[0], cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.mTan[2], vSunDirection);
  o.cLights = EncodeLight(CalcAdditionalLights(vWorld, o.mTan[2]), CalcSpec(cMs, cSunSpecColor, fShininess, vHalf, o.mTan[2], vSunDirection));

  if (bShadows)
    CalcShadowBufferTexCoords(float4(vWorld, 1), o.vShaC);
  else
    o.vShaC = 0;
  o.fFog = CalcFog(distance(vWorld, vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}


VS_ITEM_OUTPUT VS_Item(VS_ITEM_INPUT v, uniform bool bPosition, uniform bool bShadows)
{
  VS_ITEM_OUTPUT o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  
  o.vTexC.xy = mul(half4(v.vTexC, 0, 1), mTexBase);
  o.vTexC.zw = v.vTexC;
  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC.xyz = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
  half3 vHalf = CalcHalfway(vWorld, vSunDirection, vWorldCamera);
  if (bPosition)
    o.vHalfPos = vWorld;
  else
    o.vHalfPos = vHalf;
  o.mTan = CalcTangentSpace(v.vNorm, v.vBin, v.vTan, (half3x3) mInvWorldTrans, true);
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

#define UNITS_ANNO\
    int implementation = 0;\
    string NBTMethod = "NDL";\
    bool UsesNIRenderState = false;\
    bool UsesNILightState = false

#define UNITS_ALPHA_ANNO\
    int implementation = 0;\
    string NBTMethod = "NDL";\
    bool UsesNIRenderState = false;\
    bool UsesNILightState = false;\
    bool ImplicitAlpha = true;\
    bool DoubleSided = true
    
#define SUFF_PUBLIC\
    bool bPublic = true

#define SUFF_INTERNAL\
    bool bPublic = false
    
#define UNITS_TECH(t,d,a,suff,p)\
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

#define UNITS_PASS(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(pos,sha);\
    PixelShader = compile ps_ver ps(pcol,glow,sha,fog,fow,opm);\
  }

#include "Tint.fxh"

#define TINT_PASS_UNITS(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs(pos,sha);\
    PixelShader = compile ps_ver ps(pcol,glow,sha,fog,fow,opm);\
  }\
  TINT_PASS_OBJECT

#define UNITS_TECHTINT(t,d,a,suff,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm)\
  UNITS_TECH(t,d,a,suff,UNITS_PASS(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm))\
  UNITS_TECH(t##_Tint,"Internal technique, do not use.",a,SUFF_INTERNAL,TINT_PASS_UNITS(ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,sha,fog,fow,opm))
  
#define UNITS_TECHSHADOWS(t,d,a,suff,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,fow,opm)\
  UNITS_TECHTINT(t,d,a,suff,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,false,false,fow,opm)\
  UNITS_TECHTINT(t##_Shadows,"Internal technique, do not use.",a,SUFF_INTERNAL,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,true,false,fow,opm)

#define UNITS_TECHNIQUE(t,d,a,ds,dstrans,vs_ver,vs,ps_ver,ps,pos,pcol,glow,opamsk)\
  UNITS_TECHSHADOWS(t,d,a,SUFF_PUBLIC,ds,vs_ver,vs,ps_ver,ps,pos,pcol,glow,false,opamsk)\
  UNITS_TECHSHADOWS(t##_Trans,"Internal technique, do not use.",UNITS_ALPHA_ANNO,SUFF_INTERNAL,dstrans,vs_ver,vs,ps_ver,ps,pos,pcol,glow,true,opamsk)

UNITS_TECHNIQUE(_Units, "Default units shader with base texture, normal map, player color, VEO and specular. Alpha in the base texture is a gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
                UNITS_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units, false, true, false, false)
UNITS_TECHNIQUE(_Units_Alpha, "Units shader with base texture, normal map, player color, VEO, specular and opacity. Alpha in the base texture is an opacity mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
                UNITS_ALPHA_ANNO, UNIT_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Alpha, false, true, false, false)
UNITS_TECHNIQUE(_Units_Env, "Units shader with base texture, normal map, player color, VEO and environment map. Alpha in the base texture is a environment gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
                UNITS_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Env, true, true, false, false)
UNITS_TECHNIQUE(_Units_Env_Alpha, "Units shader with base texture, normal map, VEO, environment map and transparency. Alpha in the base texture is a gloss mask, and alpha in the normal map means transparency.",
                UNITS_ALPHA_ANNO, UNIT_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Env, true, false, false, false)
UNITS_TECHNIQUE(_Units_Glow, "Units shader with base texture, normal map, player color, VEO and emissive glow. Alpha in the base texture is a glow mask, and alpha in the normal map marks where the player color should be used over the texture.",
                UNITS_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Glow, true, true, true, false)

UNITS_TECHNIQUE(_Units_Human, "Human units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
                UNITS_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mask, false, true, true, false)
//UNITS_TECHNIQUE(_Units_Human_Alpha, "Human units shader with base texture, normal map, player color, VEO, specular, glow and opacity. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//                UNITS_ALPHA_ANNO, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mask, false, true, true, false)
UNITS_TECHNIQUE(_Units_Human_Opacity, "Human units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
                UNITS_ALPHA_ANNO, UNIT_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mask, false, true, true, true)
UNITS_TECHNIQUE(_Units_Human_Test, "Human units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
                UNITS_ANNO, UNIT_TEST_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mask, false, true, true, true)


//UNITS_TECHNIQUE(_Units_Mutant, "Mutant units shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//                UNITS_ANNO, UNIT_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mask, false, true, true, false)
//UNITS_TECHNIQUE(_Units_Mutant_Opacity, "Mutant units shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//                UNITS_ALPHA_ANNO, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mask, false, true, true, true)
//UNITS_TECHNIQUE(_Units_Mutant_Test, "Mutant units shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//                UNITS_ANNO, UNIT_TEST_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mask, false, true, true, true)


//UNITS_TECHNIQUE(_Units_Core, "Core units shader with base texture, normal map, emitting player color, VEO and specular. Alpha in the base texture is a gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
//                UNITS_ANNO, UNIT_STATES, vs_3_0, VS_Units, ps_3_0, PS_Units, false, true, true)
//UNITS_TECHNIQUE(_Units_Core_Env, "Core units shader with base texture, normal map, emitting player color, VEO and environment map. Alpha in the base texture is a environment gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
//                UNITS_ANNO, UNIT_STATES, vs_3_0, VS_Units, ps_3_0, PS_Units_Env, true, true, true)
//UNITS_TECHNIQUE(_Units_Simple, "Units shader with base texture, VEO and specular without normal map. Alpha in the base texture is a gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
//                UNITS_ANNO, UNIT_STATES, vs_3_0, VS_Units, ps_3_0, PS_Units_Simple, false, true, false)

UNITS_TECHNIQUE(_Units_Mirror, "Mirror surface units shader with base texture, normal map, player color, VEO, specular, glow and environment map. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
                UNITS_ANNO, UNIT_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Mirror, true, true, true, false)

// Artefacts techniques
UNITS_TECHSHADOWS(_Units_Item, "Base texture, normal map, VOE, specular and glow. Alpha in base texture is gloss, alpha in normal map is glow map.",
                  UNITS_ANNO, SUFF_PUBLIC, ITEM_STATES, _VS2X_, VS_Item, _PS2X_, PS_Item, false, true, false, false, false)

// Building shader techniques
/*
UNITS_TECHNIQUE(_Bld, "Default buildings shader with base texture, normal map, player color, VEO and specular. Alpha in the base texture is a gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
                UNITS_ANNO, BLD_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units, false, true, false, false)
UNITS_TECHNIQUE(_Bld_Alpha, "Buildings shader with base texture, normal map, player color, VEO, specular and opacity. Alpha in the base texture is an opacity mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
                UNITS_ALPHA_ANNO, BLD_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Alpha, false, true, false, false)
UNITS_TECHNIQUE(_Bld_Env, "Buildings shader with base texture, normal map, player color, VEO and environment map. Alpha in the base texture is a environment gloss mask, and alpha in the normal map marks where the player color should be used over the texture. Parameter: cColorization - color.",
                UNITS_ANNO, BLD_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Env, true, true, false, false)
UNITS_TECHNIQUE(_Bld_Env_Alpha, "Buildings shader with base texture, normal map, VEO, environment map and transparency. Alpha in the base texture is a gloss mask, and alpha in the normal map means transparency.",
                UNITS_ALPHA_ANNO, BLD_ALPHA_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Env, true, false, false, false)
UNITS_TECHNIQUE(_Bld_Glow, "Buildings shader with base texture, normal map, player color, VEO and emissive glow. Alpha in the base texture is a glow mask, and alpha in the normal map marks where the player color should be used over the texture.",
                UNITS_ANNO, BLD_STATES, UNIT_ALPHA_STATES, _VS2X_, VS_Units, _PS2X_, PS_Units_Glow, true, true, true, false)
*/
UNITS_TECHNIQUE(_Bld_Human, "Human buildings shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
                UNITS_ANNO, BLD_STATES, BLD_ALPHA_STATES, _VS2X_, VS_Bld, _PS2X_, PS_Bld, false, true, true, false)
//UNITS_TECHNIQUE(_Bld_Human_Alpha, "Human buildings shader with base texture, normal map, player color, VEO, specular, glow and opacity. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//                UNITS_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Bld, _PS2X_, PS_Bld, false, true, true, false)
UNITS_TECHNIQUE(_Bld_Human_Opacity, "Human buildings shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
                UNITS_ALPHA_ANNO, BLD_ALPHA_STATES, BLD_ALPHA_STATES, _VS2X_, VS_Bld, _PS2X_, PS_Bld, false, true, true, true)
UNITS_TECHNIQUE(_Bld_Human_Test, "Human buildings shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
                UNITS_ANNO, BLD_TEST_STATES, BLD_ALPHA_STATES, _VS2X_, VS_Bld, _PS2X_, PS_Bld, false, true, true, true)

//UNITS_TECHNIQUE(_Bld_Mutant, "Mutant buildings shader with base texture, normal map, player color, VEO, specular and glow. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask. Parameter: cColorization - color.",
//                UNITS_ANNO, BLD_STATES, _VS2X_, VS_Bld, _PS2X_, PS_Bld, false, true, true, false)
//UNITS_TECHNIQUE(_Bld_Mutant_Opacity, "Mutant buildings shader with base texture, normal map, player color, VEO, specular, glow and opacity mask. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//                UNITS_ALPHA_ANNO, BLD_ALPHA_STATES, _VS2X_, VS_Bld, _PS2X_, PS_Bld, false, true, true, true)
//UNITS_TECHNIQUE(_Bld_Mutant_Test, "Mutant buildings shader with base texture, normal map, player color, VEO, specular, glow and alpha test. Alpha in the base texture is a gloss mask, alpha in the mask map marks where the player color should be used over the texture, red in the mask map is glow mask, green in the mask map is opacity mask. Parameter: cColorization - color.",
//                UNITS_ANNO, BLD_TEST_STATES, _VS2X_, VS_Bld, _PS2X_, PS_Bld, false, true, true, true)