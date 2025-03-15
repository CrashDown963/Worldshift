#include "Terrain_Shaders.fxh"
#include "Tint.fxh"

////////////////////////////////////////////////////////////////////////////////
// Techniques:
//
#define MAIN_PASS(vs_ver, vs, ps_ver, ps)\
  pass Main\
  {\
    VertexShader     = compile vs_ver vs;\
    PixelShader      = compile ps_ver ps;\
    FogEnable        = true;\
    ZEnable          = true;\
    ZWriteEnable     = true;\
    AlphaBlendEnable = true;\
    StencilEnable    = false;\
    StencilFail      = KEEP;\
    StencilPass      = REPLACE;\
    StencilZFail     = KEEP;\
    StencilFunc      = ALWAYS;\
    StencilMask      = 0x10;\
    StencilWriteMask = 0x10;\
    StencilRef       = 0x10;\
    CullMode         = CW;\
    SrcBlend         = SrcAlpha;\
    DestBlend        = InvSrcAlpha;\
    ColorWriteEnable = CWEVALUE;\
  }
  
#define TECH(t, d)\
technique t\
<\
  string ShaderName = #t;\
  string Description = d;\
  int Implementation = 0;\
  string NBTMethod = "NDL";\
  bool UsesNIRenderState = true;\
  bool UsesNILightState = false;\
  bool bPublic = true;\
>

#define TECH_INT(t)\
technique t\
<\
  string ShaderName = #t;\
  string Description = "Internal technique.\nDo not use manually!";\
  int Implementation = 0;\
  string NBTMethod = "NDL";\
  bool UsesNIRenderState = true;\
  bool UsesNILightState = false;\
>

// Four versions for every terrain technique - (non-)shadowed/(non-)tinted:
#define TERRAIN_TECHS(t, d, vs_ver, vs_name, ps_ver, ps_name) \
TECH    (t, d)             { MAIN_PASS(vs_ver, vs_name(false), ps_ver, ps_name(false,false)) } \
TECH_INT(t##_Shadows)      { MAIN_PASS(vs_ver, vs_name(true),  ps_ver, ps_name(true,false))  } \
TECH_INT(t##_Tint)         { MAIN_PASS(vs_ver, vs_name(false), ps_ver, ps_name(false,false)) TINT_PASS_TERRAIN } \
TECH_INT(t##_Tint_Shadows) { MAIN_PASS(vs_ver, vs_name(true),  ps_ver, ps_name(true,false))  TINT_PASS_TERRAIN }

TERRAIN_TECHS(_Terrain, "Base map, gloss map in base alpha, no normal map", 
              _VS2X_, vsSimple, _PS2X_, psSimple)
TERRAIN_TECHS(_Terrain_Normals, "Base map, gloss map in base alpha, normal map in bump slot", 
              _VS2X_, vsNormals, _PS2X_, psNormals)
//TERRAIN_TECHS(_Terrain_Parallax, "Base map, gloss map in base alpha, parallax map in bump slot", 
//              vs_3_0, vsParallax, ps_3_0, psParallax)
TERRAIN_TECHS(_Terrain_Environment, "Base map, gloss map in base alpha, normal map in bump slot, environment mapping", 
              _VS2X_, vsEnvironment, _PS2X_, psEnvironment)
TERRAIN_TECHS(_Terrain_Glow, "Base map, glow map in base alpha, no specular, no normal map", 
              _VS2X_, vsSimple, _PS2X_, psGlow)
TERRAIN_TECHS(_Terrain_Glow_Normals, "Base map, glow map in base alpha, no specular, normal map in bump slot", 
              _VS2X_, vsNormals, _PS2X_, psGlowNormals)
TERRAIN_TECHS(_Terrain_Deep_Ice, "No pigment map, gloss map in normal alpha, normal map in bump slot, Fresnel environment mapping",
              _VS2X_, vsEnvironment, _PS2X_, psDeepIce)
