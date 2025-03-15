// Detail objects shader

#include "Utility.fxh"


//#define CWEVALUE (RED | BLUE | GREEN)

// Supported maps:
texture BaseMap   <string NTM = "base";   int NTMIndex = 0;>;
texture ShadowMap <string NTM = "shader"; int NTMIndex = 1; bool hidden = true;>;
texture VisionMap    <string NTM = "shader"; int NTMIndex = 4; bool hidden = true;>;


// Attributes:
half3 cDetailEmittance : ATTRIBUTE;

// Transformations:
half4x4   mWorldView     : WORLDVIEW;
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
half4x4   mInvWorldTrans : INVWORLDTRANSPOSE;
//float4x4  mShadowProj    : GLOBAL;

//Fade distance!
static const float fFadeDist1 = 10000.0f;
static const float fFadeDist2 = 12000.0f;

float      fTime          : GLOBAL = 1.0f;
//float     fTime          : TIME;

struct VS_INPUT {
  float4 vPos: POSITION;
  half2 vTexC: TEXCOORD;
};

struct VS_OUTPUT {
  float4 vPos: POSITION;
  half2 vTexC: TEXCOORD;
  half  fFog: FOG;
};

struct VS_INPUT_EMITTANCE {
  float4  vPos: POSITION;
  half3   vNorm: NORMAL;     
  half4   vOcclusion : COLOR0;
  half2   vTexC: TEXCOORD0;
  half2   vData: TEXCOORD1;
};


struct VS_OUTPUT_EMITTANCE {
  float4 vPos: POSITION;
  half2 vTexC: TEXCOORD;
  half4 vEmittance: TEXCOORD1;
  half3 vVOC: TEXCOORD2;
  half  fFog: FOG;
};


struct VS_OUTPUT_SHADOW {
  float4 vPos: POSITION;
  half2 vTexC: TEXCOORD;
  half4 vShaC: TEXCOORD1;
  half  fFog: FOG;
};

struct VS_OUTPUT_SHADOW_EMITTANCE {
  float4 vPos: POSITION;
  half2 vTexC: TEXCOORD;
  half4 vEmittance: TEXCOORD1;
  half4 vShaC: TEXCOORD2;
  half3 vVOC: TEXCOORD3;
  half  fFog: FOG;
};


struct PS_OUTPUT {
  half4 cColor: COLOR;
};

struct VS_INPUT_GROUNDFOG {
  float4  vPos: POSITION;
  half3   vNorm: NORMAL;     
  half4   vOcclusion : COLOR0;    //xyz -> Norm terrain, w -> Phase!
  half2   vTexC: TEXCOORD0;
  half2   vData: TEXCOORD1;
};


struct VS_OUTPUT_GROUNDFOG {
  float4 vPos: POSITION;
  half2 vTexC: TEXCOORD;
  half4 vEmittance: TEXCOORD1;
  half3 vVOC: TEXCOORD2;
  half  fFog: FOG;
};


VS_OUTPUT VS_Detail(const VS_INPUT v)
{
  VS_OUTPUT o;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  half3 vPos = mul(v.vPos, mWorldView);
  o.fFog = CalcFog(length(vPos), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}


VS_OUTPUT_SHADOW VS_Detail_Shadow(const VS_INPUT v)
{
  VS_OUTPUT_SHADOW o;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  float4 vPos = mul(v.vPos, mWorld);
  
  CalcShadowBufferTexCoords(vPos, o.vShaC);    
  o.fFog = CalcFog(length(vPos.xyz - vWorldCamera), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}


//if (fDist < fDist1) -> return 1.0f
//if (fDist > fDist1 && fDist < fDist2) -> return the map value between 1.0f and 0.0f
//if (fDist > fDist2) -> return 0.0f
half CalcDistAlpha(const half fDist, const half fDist1, const half fDist2)
{
  //return (1 - min(fDist, fDist2) / fDist2);
  return 1 - SlopedStep(fDist1, fDist2, fDist);
}

float3 AnimateVertex(float3 vPos, float fWeight)
{
  //Animate!
  float fXPosPhase = vPos.x /** 1000.0f*/;
  float fYPosPhase = vPos.y /** 1000.0f*/;
  //float fTimeScale = fmod(fXPosPhase + fYPosPhase, 1.0f) + 0.5f; 
  float fTimeScale = 4.5f;
  float f = sin((fTime +  fXPosPhase + fYPosPhase) * fTimeScale);
  vPos.xyz += fWindPower * vWindDirection * fWeight * f * 13.0f;
  return vPos;
}


VS_OUTPUT_EMITTANCE  VS_Detail_Emittance(const VS_INPUT_EMITTANCE v)
{
  VS_OUTPUT_EMITTANCE o;

  //o.vPos = mul(v.vPos, mWorldViewProj);

  //Animate Vertex  
  o.vPos.xyz = AnimateVertex(v.vPos.xyz, v.vOcclusion.a);
  o.vPos.w = v.vPos.w;
  float4 vWorld = mul(o.vPos, mWorld);
  half fVertDist = distance(vWorld.xyz, vWorldCamera);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld.xyz, vMapDimMin, vMapDimMax);
  
  //  
  o.vTexC = v.vTexC;
  
  //o.vEmittance.rgb = v.vOcclusion.rgb * 3.0f * v.vData.xxx;
  o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, v.vNorm, vSunDirection, v.vOcclusion.r);
  o.vEmittance.a = cMd.a * CalcDistAlpha(fVertDist, fFadeDist1, fFadeDist2) * lerp(0.0, 2.0, v.vData.x);
 
  o.fFog = CalcFog(fVertDist, fNearPlane, fFogFarPlane, fFogDepth);

  return o;
}


VS_OUTPUT_SHADOW_EMITTANCE VS_Detail_Emittance_Shadow(const VS_INPUT_EMITTANCE v)
{
  VS_OUTPUT_SHADOW_EMITTANCE o;

  //o.vPos = mul(v.vPos, mWorldViewProj);

  //Animate Vertex  
  o.vPos.xyz = AnimateVertex(v.vPos.xyz, v.vOcclusion.a);
  o.vPos.w = v.vPos.w;
  float4 vWorld = mul(o.vPos, mWorld);
  half fVertDist = distance(vWorld.xyz, vWorldCamera);
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld, vMapDimMin, vMapDimMax);
  
  o.vTexC = v.vTexC;
  CalcShadowBufferTexCoords(vWorld, o.vShaC);    
  o.fFog = CalcFog(fVertDist, fNearPlane, fFogFarPlane, fFogDepth);
  
  //o.vEmittance.rgb = v.vOcclusion.rgb * 3.0f * v.vData.xxx;
  o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, v.vNorm, vSunDirection, v.vOcclusion.r);  
  o.vEmittance.a = cMd.a * CalcDistAlpha(fVertDist, fFadeDist1, fFadeDist2) * lerp(0.0, 2.0, v.vData.x);
  
  //o.vEmittance.rgb = 0;
  return o;
}


VS_OUTPUT VS_Detail_NotEmissive(const VS_INPUT v)
{
  VS_OUTPUT o;

  o.vPos = mul(v.vPos, mWorldViewProj);
  o.vTexC = v.vTexC;
  half3 vPos = mul(v.vPos, mWorldView);
  o.fFog = CalcFog(length(vPos), fNearPlane, fFogFarPlane, fFogDepth);
  
  return o;
}

float3 AnimateFogVertices(float3 vPos, float fWeight)
{
  //Animate!
  float fXPosPhase = vPos.x /** 1000.0f*/;
  float fYPosPhase = vPos.y /** 1000.0f*/;
  //float fTimeScale = fmod(fXPosPhase + fYPosPhase, 1.0f) + 0.5f; 
  float fTimeScale = 1.5f;
  float f = sin((fTime +  fXPosPhase + fYPosPhase) * fTimeScale);
  vPos.xyz += fWeight * f * 80.0f;
  return vPos;
}

VS_OUTPUT_GROUNDFOG  VS_Detail_GroundFog(const VS_INPUT_GROUNDFOG v)
{
  VS_OUTPUT_GROUNDFOG o;
  
  //Animate Vertex  
  float fXPosPhase = v.vPos.x /** 1000.0f*/;
  float fYPosPhase = v.vPos.y /** 1000.0f*/;
  float fTimeScale = 1.3f;
  float f = sin((fTime +  fXPosPhase + fYPosPhase) * fTimeScale);
  
  //o.vPos.xyz = v.vPos.xyz + v.vOcclusion.a * f * 40.0f;
  o.vPos.xy = v.vPos.xy + v.vOcclusion.a * f * 50.0f;
  o.vPos.z = v.vPos.z;
  //o.vPos.xyz = v.vPos.xyz;
  o.vPos.w = v.vPos.w;
  
  float4 vWorld = mul(o.vPos, mWorld);
  
  half3 vWorldView = vWorld.xyz - vWorldCamera;
  half fVertDist = length(vWorldView);
  
  //Transform normal
  half3 vNorm =  mul(v.vNorm, mInvWorldTrans);
  vNorm = normalize(vNorm);

  //Calc fade factor!  
  float fFade = abs(dot(normalize(vWorldView), vNorm));
  
/*  float fTresh = 0.4;
  
  fFade = fFade * step(fTresh, fFade);
  
  //MAP (x, l, r, l1, r1) = l1 + (x - l) * (r1 - l1) / (r - l)
  fFade = (fFade - fTresh)  / (1 - fTresh);
  fFade = max(0, fFade);
    
  f = max(f, 0);
  fFade += fFade * (f);
*/  
  
  //Pos into View space!
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld, vMapDimMin, vMapDimMax);
      
  //  
  o.vTexC = v.vTexC;
  
  //o.vEmittance.rgb = v.vOcclusion.rgb * 3.0f * v.vData.xxx;
  //o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, vNorm /*v.vNorm*/, vSunDirection, v.vOcclusion.r);
  //o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, v.vOcclusion.rgb /*v.vNorm*/, vSunDirection, 1);
  //o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, v.vNorm, vSunDirection, /*v.vOcclusion.r*/ 1);
  
  o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, v.vOcclusion.rgb, vSunDirection, v.vData.y);
  //o.vEmittance.rgb = v.vData.y;
  //o.vEmittance.rgb = v.vOcclusion.rgb;
  o.vEmittance.a = cMd.a * CalcDistAlpha(fVertDist, fFadeDist1, fFadeDist2) * lerp(0.0, 2.0, v.vData.x);
  
  o.vEmittance.a *= fFade;
  
  o.fFog = CalcFog(fVertDist, fNearPlane, fFogFarPlane, fFogDepth);
  return o;
}

VS_OUTPUT_GROUNDFOG  VS_Detail_GodRays(const VS_INPUT_GROUNDFOG v)
{
  VS_OUTPUT_GROUNDFOG o;
  
  //Animate Vertex  
  float fXPosPhase = v.vPos.x /** 1000.0f*/;
  float fYPosPhase = v.vPos.y /** 1000.0f*/;
  float fTimeScale = 1.3f;
  float f = sin((fTime +  fXPosPhase + fYPosPhase) * fTimeScale);
  
  //o.vPos.xyz = v.vPos.xyz + v.vOcclusion.a * f * 40.0f;
  o.vPos.xy = v.vPos.xy + v.vOcclusion.a * f * 50.0f;
  o.vPos.z = v.vPos.z;
  //o.vPos.xyz = v.vPos.xyz;
  o.vPos.w = v.vPos.w;
  
  float4 vWorld = mul(o.vPos, mWorld);
  
  half3 vWorldView = vWorld.xyz - vWorldCamera;
  half fVertDist = length(vWorldView);
  
  //Transform normal
  half3 vNorm =  mul(v.vNorm, mWorld);
  vNorm = normalize(vNorm);

  //Calc fade factor!  
  float fFade = abs(dot(normalize(vWorldView), vNorm));
  
  float fTresh = 0.4;
  
  fFade = fFade * step(fTresh, fFade);
  
  //MAP (x, l, r, l1, r1) = l1 + (x - l) * (r1 - l1) / (r - l)
  fFade = (fFade - fTresh)  / (1 - fTresh);
  fFade = max(0, fFade);
    
  f = max(f, 0);
  fFade += fFade * (f);
  
  //Pos into View space!
  o.vPos = mul(o.vPos, mWorldViewProj);
  o.vVOC = CalcVOFogCoords(vWorld, vMapDimMin, vMapDimMax);
      
  //  
  o.vTexC = v.vTexC;
  
  //o.vEmittance.rgb = v.vOcclusion.rgb * 3.0f * v.vData.xxx;
  //o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, vNorm /*v.vNorm*/, vSunDirection, v.vOcclusion.r);
  //o.vEmittance.rgb = v.vData.xxx * CalcAmbDiff(cMa, cMd, cAmbientLight, cSunColor, 1, fBacklightStrength, v.vOcclusion.rgb /*v.vNorm*/, vSunDirection, 1);
  o.vEmittance.rgb = 1;
  o.vEmittance.a = cMd.a * CalcDistAlpha(fVertDist, fFadeDist1, fFadeDist2) * lerp(0.0, 2.0, v.vData.x);
  
  o.vEmittance.a *= fFade;
  
  o.fFog = CalcFog(fVertDist, fNearPlane, fFogFarPlane, fFogDepth);
  return o;
}


sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = Clamp; AddressV = Clamp;
};

sampler2D sShadow = sampler_state
{
  texture = <ShadowMap>;
  SHADOW_SAMPLER_STATES;
};

sampler2D sVision = sampler_state
{
  texture = <VisionMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp; AddressW = clamp;
};

PS_OUTPUT PS_Detail(const VS_OUTPUT p)
{
  PS_OUTPUT o;

  o.cColor = tex2D(sBase, p.vTexC);
  o.cColor.rgb *= cDetailEmittance;
  o.cColor.a *= cMd.a;
  
  return o;
}

PS_OUTPUT PS_Detail_Emittance(VS_OUTPUT_EMITTANCE p)
{
  PS_OUTPUT o;
  SetTextureVision(p.vEmittance.a, sVision, p.vVOC);
  o.cColor = tex2D(sBase, p.vTexC) * p.vEmittance;
//  o.cColor.a = 1.0f;
//  o.cColor.rgb = p.vVOC;
  //o.cColor.rgb = p.vEmittance.rgb;
  return o;
}


PS_OUTPUT PS_Detail_Shadow(const VS_OUTPUT_SHADOW p)
{
  PS_OUTPUT o;

  o.cColor = tex2D(sBase, p.vTexC);
  //half fShadow = CalcShadow(sShadow, p.vShaC);
  half fShadow = CalcShadowShadowBuffer(sShadow, p.vShaC);  
  o.cColor.rgb *= lerp(cAmbientLight * cMa, cDetailEmittance, fShadow);
  o.cColor.a *= cMd.a;
  
  return o;
}

PS_OUTPUT PS_Detail_Emittance_Shadow(VS_OUTPUT_SHADOW_EMITTANCE p)
{
  PS_OUTPUT o;

  SetTextureVision(p.vEmittance.a, sVision, p.vVOC);
  o.cColor = tex2D(sBase, p.vTexC);
  //half fShadow = CalcShadow(sShadow, p.vShaC);
  half fShadow = CalcShadowShadowBuffer(sShadow, p.vShaC);  
  o.cColor.rgb *= lerp(cAmbientLight * cMa, p.vEmittance.rgb, fShadow);
  //o.cColor.rgb *= lerp(cAmbientLight * cMa, p.vEmittance.rgb, fShadow);  //removed the *3.0f to conform with the noshadow shader
  o.cColor.a *= p.vEmittance.a; 
  //o.cColor.a *= p.vEmittance.a;    //removed the  cMd.a multiplier to conform with the noshadow shader
  
//  o.cColor.a = 1.0f;
//  o.cColor.rgb = p.vEmittance.a;
  
  return o;
}

PS_OUTPUT PS_Detail_GroundFog(VS_OUTPUT_GROUNDFOG p)
{
  PS_OUTPUT o;
  half fFog = 1;
  SetTextureVision(fFog, sVision, p.vVOC);
  p.vEmittance.a *= fFog;
  o.cColor = tex2D(sBase, p.vTexC) * p.vEmittance;
  //o.cColor.rgba = 1.0f;
  //o.cColor.a = p.vEmittance.a;
  //o.cColor.rgb = 1;
  //o.cColor = p.vEmittance;
  //o.cColor.a = 1.0f;
//  o.cColor.a = 1.0f;
//  o.cColor.rgb = p.vEmittance.a;
  return o;
}


technique _Detail_AlphaTest
<
  string shadername = "_Detail_AlphaTest";
  int implementation = 0;
  string description = "Detail objects shader - emissive lighting and alpha test.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }
}

technique _Detail_AlphaTest_Shadows
<
  string shadername = "_Detail_AlphaTest_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Shadow();
  }
}


technique _Detail_AlphaBlend
<
  string shadername = "_Detail_AlphaBlend";
  int implementation = 0;
  string description = "Detail objects shader - emissive lighting and alpha blending.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
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
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }
  
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }  
}

technique _Detail_AlphaBlend_Shadows
<
  string shadername = "_Detail_AlphaBlend_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Shadow();
  }
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Shadow();
  } 
}

technique _Detail_AlphaBlend_Emittance
<
  string shadername = "_Detail_AlphaBlend_Emittance";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
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
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance();
    PixelShader = compile ps_2_0 PS_Detail_Emittance();
  }
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance();
    PixelShader = compile ps_2_0 PS_Detail_Emittance();
  }  

}

technique _Detail_AlphaBlend_Emittance_Shadows
<
  string shadername = "_Detail_AlphaBlend_Emittance_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
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
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Emittance_Shadow();
  }
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Emittance_Shadow();
  } 
}

// Dummy techniques with _Tint that don't really tint anything for now, to avoid runtime error messages

technique _Detail_AlphaTest_Tint
<
  string shadername = "_Detail_AlphaTest_Tint";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool bPublic = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }
}

technique _Detail_AlphaTest_Shadows_Tint
<
  string shadername = "_Detail_AlphaTest_Shadows_Tint";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Shadow();
  }
}


technique _Detail_AlphaBlend_Tint
<
  string shadername = "_Detail_AlphaBlend_Tint";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
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
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }
  
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }  
}

technique _Detail_AlphaBlend_Shadows_Tint
<
  string shadername = "_Detail_AlphaBlend_Shadows_Tint";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Shadow();
  }
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Shadow();
  } 
}

technique _Detail_AlphaBlend_Tint_Emittance
<
  string shadername = "_Detail_AlphaBlend_Tint_Emittance";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
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
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance();
    PixelShader = compile ps_2_0 PS_Detail_Emittance();
  }
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance();
    PixelShader = compile ps_2_0 PS_Detail_Emittance();
  }  

}

technique _Detail_AlphaBlend_Tint_Emittance_Shadows
<
  string shadername = "_Detail_AlphaBlend_Tint_Emittance_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Emittance_Shadow();
  }
  pass P1
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Emittance_Shadow();
  } 
}



//------------------------------Detail AlphaTest Emittance techniques!
technique _Detail_AlphaTest_Emittance
<
  string shadername = "_Detail_AlphaTest_Emittance";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  //bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance();
    PixelShader = compile ps_2_0 PS_Detail_Emittance();
  }
}

technique _Detail_AlphaTest_Emittance_Shadows
<
  string shadername = "_Detail_AlphaTest_Emittance_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  //bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Emittance_Shadow();
  }
}

technique _Detail_AlphaTest_Tint_Emittance
<
  string shadername = "_Detail_AlphaTest_Tint_Emittance";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  //bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance();
    PixelShader = compile ps_2_0 PS_Detail_Emittance();
  }
}

technique _Detail_AlphaTest_Tint_Emittance_Shadows
<
  string shadername = "_Detail_AlphaTest_Tint_Emittance_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  //bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_Emittance_Shadow();
    PixelShader = compile ps_2_0 PS_Detail_Emittance_Shadow();
  }
}



technique _Detail_GroundFog
<
  string shadername = "_Detail_GroundFog";
  int implementation = 0;
  string description = "Ground Fog Detail objects shader - emissive lighting and alpha blending.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
/*
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GroundFog();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }
  */
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = greater;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }  

}


technique _Detail_GroundFog_Emittance
<
  string shadername = "_Detail_GroundFog_Emittance";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
/*
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GroundFog();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }
  */
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = greater;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GroundFog();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }  

}


technique _Detail_GroundFog_Emittance_Shadows
<
  string shadername = "_Detail_GroundFog_Emittance_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
/*
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GroundFog();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }
  */
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = greater;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GroundFog();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }  
}

technique _Detail_GodRays
<
  string shadername = "_Detail_GodRays";
  int implementation = 0;
  string description = "God Rays Detail objects shader - emissive lighting and alpha blending.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
/*
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GroundFog();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }
  */
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = true;
    AlphaFunc = greater;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail();
    PixelShader = compile ps_2_0 PS_Detail();
  }  

}


technique _Detail_GodRays_Emittance
<
  string shadername = "_Detail_GodRays_Emittance";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
/*
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GodRays();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }
  */
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 255;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GodRays();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }  

}


technique _Detail_GodRays_Emittance_Shadows
<
  string shadername = "_Detail_GodRays_Emittance_Shadows";
  int implementation = 0;
  string description = "Internal technique, do not use.";
  string NBTMethod = "none";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = false;
>
{
/*
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 128;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GodRays();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }
  */
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;
    AlphaTestEnable = true;
    AlphaFunc = LESSEQUAL;
    AlphaRef = 255;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    ZWriteEnable = false;
    ZEnable = true;
    ZFunc = LESS;
    CullMode = None;
    FogEnable = true;
    VertexShader = compile vs_1_1 VS_Detail_GodRays();
    PixelShader = compile ps_2_0 PS_Detail_GroundFog();
  }  
}
