#define COMPILE_DECALS   true
#include "Terrain_Shaders.fxh"
#include "Tint.fxh"

//#define CWEVALUE (RED | GREEN | BLUE)

// Selection decals (vertex diffuse + backlight)
void vsSelectionMask(const VS_INPUT In,
                     out float4 vPos : POSITION,
                     out half2  vTexC: TEXCOORD0)
{
  vPos = mul(In.vPos, mWorldViewProj);
  vTexC = mul(half4(In.vTexC, 0, 1), mTexBase);
}

void psSelectionMask(in half2  vTexC: TEXCOORD0,
                     out half4 cOut : COLOR0)
{
  cOut.rgb = 0;
  cOut.a = tex2D(sNormalMap, vTexC).r;
}


technique _Selection_Mask
<
  string shadername = "_Selection_Mask";
  int implementation = 0;
  string description = "Internal technique";
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    AlphaTestEnable = true;
    AlphaRef = 86;
    AlphaFunc = greater;
    ColorWriteEnable = 0;
    DitherEnable = false;
    CullMode = NONE;
    StencilEnable = true;
    TwoSidedStencilMode = false;
    StencilFail = REPLACE;
    StencilPass = REPLACE;
    StencilZFail = REPLACE;
    StencilFunc = ALWAYS;
    StencilMask = 0x20;
    StencilWriteMask = 0x20;
    StencilRef = 0x20;
    FogEnable = false;
    ZEnable = false;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
  
  
    VertexShader = compile vs_1_1 vsSelectionMask();
    PixelShader  = compile ps_2_0 psSelectionMask();  
  }
}


technique _Decal_Selection
<
  string shadername = "_Decal_Selection";
  int implementation = 0;
  string description = "Selection decal shader.";
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 1;
    ColorWriteEnable = CWEVALUE;
    CullMode = CW;
    DitherEnable = true;
    
    StencilEnable = false;
    TwoSidedStencilMode = false;
    StencilFail = KEEP;
    StencilPass = KEEP;
    StencilZFail = KEEP;
    StencilFunc = NOTEQUAL;
    StencilMask = 0x20;
    StencilWriteMask = 0x20;
    StencilRef = 0x20;

    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;      
  
    VertexShader = compile _VS2X_ vsSelection(false);
    PixelShader  = compile ps_2_0 psSelection(false, false);
  }
}


technique _Decal_Selection_Merged
<
  string shadername = "_Decal_Selection_Merged";
  int implementation = 0;
  string description = "Selection decal shader for merging selections.";
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    CullMode = CW;
    DitherEnable = true;
    
    StencilEnable = true;
    TwoSidedStencilMode = false;
    StencilFail = KEEP;
    StencilPass = KEEP;
    StencilZFail = KEEP;
    StencilFunc = NOTEQUAL;
    StencilMask = 0x20;
    StencilWriteMask = 0x20;
    StencilRef = 0x20;

    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;      
  
    VertexShader = compile _VS2X_ vsSelection(false);
    PixelShader  = compile ps_2_0 psSelection(false, false);  
  }
}

technique _Decal_Selection_Merged_Tint
<
  string shadername = "_Decal_Selection_Merged_Tint";
  int implementation = 0;
  string description = "Selection decal shader for merging selections - internal tinted version.";
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = false;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    CullMode = CW;
    DitherEnable = true;
    
    StencilEnable = true;
    TwoSidedStencilMode = false;
    StencilFail = KEEP;
    StencilPass = KEEP;
    StencilZFail = KEEP;
    StencilFunc = NOTEQUAL;
    StencilMask = 0x20;
    StencilWriteMask = 0x20;
    StencilRef = 0x20;

    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;      
  
    VertexShader = compile _VS2X_ vsSelection(false);
    PixelShader  = compile ps_2_0 psSelection(false, false);  
  }
  TINT_PASS_TERRAIN
}


// Techniques
#define DECAL_STATES\
    AlphaBlendEnable = true;\
    SrcBlend = SrcAlpha;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    CullMode = CW;\
    DitherEnable = true;\
    StencilEnable = false;\
    FogEnable = true;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = false

#define DECAL_STATES_MULTIPLY\
    AlphaBlendEnable = true;\
    SrcBlend = Zero;\
    DestBlend = SrcColor;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    CullMode = CW;\
    DitherEnable = true;\
    StencilEnable = false;\
    FogEnable = true;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = false

#define DECAL_STATES_FOG\
    AlphaBlendEnable = true;\
    SrcBlend = One;\
    DestBlend = InvSrcAlpha;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    CullMode = CW;\
    DitherEnable = true;\
    StencilEnable = false;\
    FogEnable = false;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = false

#define DECAL_STATES_ADDITIVE\
    AlphaBlendEnable = true;\
    SrcBlend = SrcAlpha;\
    DestBlend = One;\
    AlphaTestEnable = true;\
    AlphaFunc = GREATER;\
    AlphaRef = 0;\
    ColorWriteEnable = CWEVALUE;\
    CullMode = CW;\
    DitherEnable = true;\
    StencilEnable = false;\
    FogEnable = true;\
    ZEnable = true;\
    ZFunc = LESSEQUAL;\
    ZWriteEnable = false


#define SUFF_PUBLIC\
    bool bPublic = true

#define SUFF_INTERNAL\
    bool bPublic = false
    
#define DECAL_TECH(t,d,p,a)\
  technique t\
  <\
    string shadername = #t;\
    int implementation = 0;\
    string description = d;\
    string NBTMethod = "NDL";\
    bool UsesNIRenderState = false;\
    bool UsesNILightState = false;\
    a;\
  >\
  {\
    p\
  }

#define EMPTY_PASS(ds,vs_ver,vs,ps_ver,ps)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs;\
    PixelShader = compile ps_ver ps;\
  }

#define TINT_PASS_DECAL(ds,vs_ver,vs,ps_ver,ps)\
  pass P0\
  {\
    ds;\
    VertexShader = compile vs_ver vs;\
    PixelShader = compile ps_ver ps;\
  }\
  TINT_PASS_TERRAIN

#define DECAL_TECHTINT(t,d,suff,ds,vs_ver,vs,ps_ver,ps)\
  DECAL_TECH(t,d,EMPTY_PASS(ds,vs_ver,vs,ps_ver,ps),suff)\
  DECAL_TECH(t##_Tint,"Internal technique, do not use.",TINT_PASS_DECAL(ds,vs_ver,vs,ps_ver,ps),SUFF_INTERNAL)

#define DECAL_TECHNIQUE(t,d,ds,vs_ver,vs,ps_ver,ps,fog)\
  DECAL_TECHTINT(t,d,SUFF_PUBLIC,ds,vs_ver,vs(false),ps_ver,ps(false,fog))\
  DECAL_TECHTINT(t##_Shadow,"Internal technique, do not use.",SUFF_INTERNAL,ds,vs_ver,vs(true),ps_ver,ps(true,fog))
  
DECAL_TECHNIQUE(_Decal_DiffuseOnly, "Decal shader with base texture and diffuse lighting (no normal map!). Base alpha is transparency.",
                DECAL_STATES_FOG, _VS2X_, vsNormals, ps_2_0, psDiffuseFog, true)             
DECAL_TECHNIQUE(_Decal_Diffuse_NonPre, "Decal shader with base texture and diffuse lighting (no normal map!), non-premultiplied alpha. Base alpha is transparency.",
                DECAL_STATES, _VS2X_, vsNormals, ps_2_0, psDiffuseFog, false)             
DECAL_TECHNIQUE(_Decal_ReliefOnly, "Decal shader with normal map that superimposes its diffuse lighting over the surface below. Normal alpha is transparency.",
                DECAL_STATES_MULTIPLY, _VS2X_, vsNormals, ps_2_0, psLighting, false)             
DECAL_TECHNIQUE(_Decal_Env, "Decal shader with base texture, normal map and environment map. Base alpha is transparency, normal map alpha is gloss.",
                DECAL_STATES_FOG, _VS2X_, vsEnvironment, ps_2_0, psEnvironmentFog, true)
DECAL_TECHNIQUE(_Decal_Glow, "Decal shader with base texture, normal map and glow. Base alpha is transparency, normal map alpha is glow map.",
                DECAL_STATES_FOG, _VS2X_, vsNormals, ps_2_0, psGlowNormalsFog, true)
DECAL_TECHNIQUE(_Decal_Spec, "Decal shader with base texture with pre-multiplied alpha, normal map and diffuse + specular lighting. Base alpha is transparency.",
                DECAL_STATES_FOG, _VS2X_, vsNormals, ps_2_0, psNormalsFog, true)
DECAL_TECHNIQUE(_Decal_Diffuse_Normal, "Decal shader with base texture with pre-multiplied alpha, normal map and diffuse lighting. Base alpha is transparency.",
                DECAL_STATES_FOG, _VS2X_, vsNormals, ps_2_0, psNormalsDiffuseFog, true) 
DECAL_TECHNIQUE(_Decal_Molten_Spot, "Decal shader with 2 base textures, normal map and glow. Base alpha is transparency, normal map alpha is gloss, base texture 2 alpha is glow mask.",
                DECAL_STATES_FOG, _VS2X_, vsNormals, ps_2_0, psMoltenSpot, true)
DECAL_TECHNIQUE(_Decal_Molten_Area, "Decal shader base texture. Base alpha is glow phase shift mask. Additive blending.",
                DECAL_STATES_ADDITIVE, _VS2X_, vsSimple, ps_2_0, psMoltenArea, false)
DECAL_TECHNIQUE(_Decal_Feedback, "Visual feedback decal shader. Base texture and vertex lighting with diffuse, ambient and emissive lights. Base alpha is transparency. Not premultiplied.",
                DECAL_STATES, _VS2X_, vsSelection, ps_2_0, psSelection, false)


//DECAL_TECHNIQUE(_Decal_Normal, "Default decal shader with base texture, normal map and specular. Base alpha is transparency, normal map alpha is gloss.",
//                DECAL_STATES, vs_3_0, vsNormals, ps_3_0, psNormals)
//DECAL_TECHNIQUE(_Decal_Diffuse, "Decal shader with base texture, normal map and diffuse lighting. Base alpha is transparency.",
//                DECAL_STATES, vs_3_0, vsNormals, ps_3_0, psNormalsDiffuse)
//DECAL_TECHNIQUE(_Decal_Parallax, "Decal shader with base texture, normal map, steep parallax and specular. Base alpha is transparency, normal alpha is parallax map height.",
//                DECAL_STATES, vs_3_0, vsParallax, ps_3_0, psParallax)

//DECAL_TECHNIQUE(_Decal_Selection, "Selection decal shader.",
//                DECAL_STATES, vs_1_1, vsSelection, ps_2_0, psSelection)
