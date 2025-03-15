// Units shader

#include "Utility.fxh"

#define CWEVALUE (RED | GREEN | BLUE | ALPHA)

// Supported maps:
texture BaseMap      <string NTM = "base";   int NTMIndex = 0;>;
texture ShadowMap    <string NTM = "shader"; int NTMIndex = 1; bool hidden = true;>;
texture OcclusionMap <string NTM = "shader"; int NTMIndex = 6; bool hidden = true;>;
texture ZPassMap     <string NTM = "shader"; int NTMIndex = 4; bool hidden = true;>;
texture DownsampleMap <string NTM = "shader"; int NTMIndex = 7; bool hidden = true;>;

// Transformations:
half4x4   mWorldView     : WORLDVIEW;
float4x4  mWorldViewProj : WORLDVIEWPROJECTION;
half4x4   mInvWorldTrans : INVWORLDTRANSPOSE /*WorldInverseTranspose*/;
half4x4   mInvWorld      : INVWORLD;
half4x4   mWorldTrans    : WORLDTRANSPOSE;
float4x4  mSkinWorldView : SKINWORLDVIEW;
half4x4   mInvView       : INVVIEW;
float4x4  mViewProj      : VIEWPROJ;

half3 cSkyHorizon        : GLOBAL = {0.3,  0.3,  1.0};
half3 cSkyMiddle         : GLOBAL = {0.15, 0.15, 0.65};
half3 cSkyZenith         : GLOBAL = {0.0,  0.0,  0.3};
half  fSkyGradient       : GLOBAL = 0.5;
half  fSinCooldown       : ATTRIBUTE <bool hidden = true;> = 0.0f;
half  fCooldownFirstHalf : ATTRIBUTE <bool hidden = true;> = 0.5f;
float fUseBrightness: ATTRIBUTE = 1.0;


half4 cDrawInterfaceModul : ATTRIBUTE;

half fFogOfWar          : ATTRIBUTE <bool hidden = true;> = 1.0f;



struct VS_INPUT_SKY {
  float4 vPos: POSITION;
  half4  cDiff: COLOR0;
  half2  vTexC: TEXCOORD;
};

struct VS_INPUT_COLOR_ONLY {
  float4 vPos : POSITION;
  half2  vTexC: TEXCOORD;
  half3  vNorm: NORMAL; 
  half4  cColor: COLOR;
};

struct VS_OUTPUT_SKY {
  float4 vPos: POSITION;
  half4  cDiff: COLOR0;
  half2  vTexC: TEXCOORD;
  half3  vNorm: TEXCOORD1;
  half   hFog: FOG;
};

struct VS_OUTPUT_COLOR_ONLY {
  float4  vPos     : POSITION;
  half3   vNorm    : TEXCOORD;
  half3   vVOC     : TEXCOORD1;
  float3  vHalfPos : TEXCOORD2;
  float4  vShaC    : TEXCOORD3;
  half3   cLight   : TEXCOORD4;
  half    fFog     : FOG;
};

struct PS_OUTPUT {
  half4 cColor: COLOR;
};

VS_OUTPUT_SKY VS_Sky(const VS_INPUT_SKY v)
{
  VS_OUTPUT_SKY o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);
  o.cDiff = v.cDiff;
  o.vTexC = v.vTexC;
  o.vNorm = normalize(v.vPos);
  o.hFog = 1.0;

  return o;
}

void VS_Occluded(in float4 vInPos: POSITION, out float4 vOutPos: POSITION)
{
  vOutPos.xy = vInPos.xy;
  vOutPos.z = 0.5;
  vOutPos.w = 1;
}

void VS_Outline(in  float4 vInPos : POSITION, out float4 vOutPos: POSITION)
{
  vOutPos = mul(vInPos, mWorldViewProj);
}

void VS_Transparent(in  float4 vInPos   : POSITION,
                    in  half2  vInTexC  : TEXCOORD,
                    in  half4  cInColor : COLOR,
                    out float4 vOutPos  : POSITION,
                    out half2  vOutTexC : TEXCOORD,
                    out half4  cOutColor: TEXCOORD1,
                    out half   fOutFog  : FOG,
                    uniform bool bOverbright)
{
  vOutPos = mul(vInPos, mWorldViewProj);
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);
  if (bOverbright)
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor + cMe * lerp(1, fBrightness, fUseBrightness);
  else
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor + cMe;
  cOutColor.a = cMd.a;
  cOutColor.a *= saturate((fFogOfWar - 0.5) * 2);
  cOutColor *= cInColor;
  float4 vPos = mul(vInPos, mWorldView);
  fOutFog = CalcFog(length(vPos), fNearPlane, fFogFarPlane, fFogDepth);
}

void VS_Skin_Transparent(in  float4     vInPos         : POSITION,
                         in  half4      vInBlendIndices: BLENDINDICES,
						 in  WEIGHTTYPE vInBlendWeights: BLENDWEIGHT,
                         in  half2      vInTexC        : TEXCOORD,
                         in  half4      cInColor       : COLOR,
                         out float4     vOutPos        : POSITION,
                         out half2      vOutTexC       : TEXCOORD,
                         out half4      cOutColor      : TEXCOORD1,
                         out half       fOutFog        : FOG,
                         uniform bool bOverbright,
                         uniform int iBonesPerVertex = 4)
{
  float4 vSkinPos;
  float4x3 mBlendedBone;

  mBlendedBone = GetBlendMatrix(vInBlendIndices, vInBlendWeights, iBonesPerVertex);
  vSkinPos.xyz = mul(vInPos, mBlendedBone);
  vSkinPos.w = 1.0;
  vOutPos = mul(vSkinPos, mSkinWorldViewProj);
  float4 vPos = mul(vSkinPos, mSkinWorldView);

  vOutPos = mul(vInPos, mWorldViewProj);
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);
  if (bOverbright)
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor + cMe * lerp(1, fBrightness, fUseBrightness);
  else
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor + cMe;
  cOutColor.a = cMd.a;
  cOutColor.a *= saturate((fFogOfWar - 0.5) * 2);
  cOutColor *= cInColor;
  fOutFog = CalcFog(length(vPos), fNearPlane, fFogFarPlane, fFogDepth);
}

void VS_Transparent_PremultipliedAlpha(in  float4 vInPos   : POSITION,
                    in  half2  vInTexC  : TEXCOORD,
                    in  half4  cInColor : COLOR,
                    out float4 vOutPos  : POSITION,
                    out half2  vOutTexC : TEXCOORD,
                    out half4  cOutColor: TEXCOORD1,
                    out half   fOutFog  : TEXCOORD2,
                    uniform bool bOverbright)
{
  vOutPos = mul(vInPos, mWorldViewProj);
  vOutTexC = mul(half4(vInTexC, 0, 1), mTexBase);
  if (bOverbright)
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor + cMe * lerp(1, fBrightness, fUseBrightness);
  else
    cOutColor.rgb = cMa * cAmbientLight + cMd * cSunColor + cMe;
  cOutColor.a = cMd.a;
  cOutColor.a *= saturate((fFogOfWar - 0.5) * 2);
  cOutColor *= cInColor;
  float4 vPos = mul(vInPos, mWorldView);
  fOutFog = CalcFog(length(vPos), fNearPlane, fFogFarPlane, fFogDepth);
}

VS_OUTPUT_COLOR_ONLY VS_Misc_ColorOnly(VS_INPUT_COLOR_ONLY v, uniform bool bPosition, uniform bool bShadows)
{
  VS_OUTPUT_COLOR_ONLY o;
  
  o.vPos = mul(v.vPos, mWorldViewProj);

  float3 vWorld = mul(v.vPos, mWorld);
  o.vVOC = CalcVOCoords(vWorld, vMapDimMin, vMapDimMax);
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
  CalcVertAmbDiff(o.vNorm, cMa, cMd, cAmbientLight, cSunColor, fBacklightStrength, o.vNorm, vSunDirection);
  
  return o;
}


void VS_ZPass(in float4 vPos: POSITION, 
              out float4 oPos: POSITION, 
              out float4 oPosTex: TEXCOORD)
{
  oPos = mul(vPos, mWorldView);
  oPosTex = oPos;  
  oPosTex.z = oPosTex.z / oPosTex.w;
  oPos = mul(vPos, mWorldViewProj);
  //oPosTex.x = oPos.x;
  //oPosTex.y = oPos.y;
  //oPosTex.w = oPos.w;
}


void VS_ZPass_Test(in float4 vPos: POSITION, 
              out float4 oPos: POSITION, 
              out float4 oPosTex: TEXCOORD)
{
  oPos = mul(vPos, mWorldView);
  oPosTex = oPos;  
  oPosTex.z /= oPosTex.w;
  oPos = mul(vPos, mWorldViewProj);
  oPosTex.x = oPos.x;
  oPosTex.y = oPos.y;
  oPosTex.w = oPos.w;
}


void VS_DrawFont(in float4 vPos: POSITION, 
                 in  half2  vInTexC  : TEXCOORD,
                 //in  half4  cInColor : COLOR,
                 out float4 oPos: POSITION, 
                 out half2  oPosTex: TEXCOORD)
                 //out half4  oColor : TEXCOORD1)
{
  oPos = mul(vPos, mWorldViewProj);

  oPosTex = vInTexC;
  
  //oColor = cInColor;
}

void VS_InterfaceDraw(in float4 vPos: POSITION, 
                      in  half2  vInTexC  : TEXCOORD,
                      in  half2  vInGridTexC  : TEXCOORD1,
                      out float4 oPos: POSITION, 
                      out half2  oPosTex: TEXCOORD,
                      out half2  oGridTex: TEXCOORD1,
                      uniform bool bTexTransform = false)
{
  oPos = mul(vPos, mWorldViewProj);

  if (bTexTransform)
	oPosTex = mul(half4(vInTexC, 0, 1), mTexBase);
  else 
	oPosTex = vInTexC;
	
  oGridTex = vInGridTexC;
}

float TRUE_OFF_WIDTH : GLOBAL = 1024.0f;
float TRUE_OFF_HEIGHT : GLOBAL = 768.0f;

void VS_InterfaceDrawBB(in float4 vPos: POSITION, 
                      in  half2  vInTexC  : TEXCOORD,
                      in  half2  vInGridTexC  : TEXCOORD1,
                      out float4 oPos: POSITION, 
                      out half2  oPosTex: TEXCOORD,
                      out half2  oGridTex: TEXCOORD1,
                      out half2  oTexelSize: TEXCOORD2)
{
  oPos = mul(vPos, mWorldViewProj);

  oPosTex = vInTexC;
  oGridTex = vInGridTexC;
  
  
  //VS_OUTPUT_DOWNSAMPLE o;
	
  float2 texelSize;
  
  texelSize.x = 1.0 / TRUE_OFF_WIDTH;
  texelSize.y = 1.0 / TRUE_OFF_HEIGHT;

  //o.Position = mul(Position, mWorldViewProj);

  //o.TexCoord[0] = TexCoord;// - 0.5f * texelSize;
  oTexelSize = texelSize; 
  
  //return o;  
}

void VS_InterfaceDrawAction(in float4 vPos: POSITION, 
                            in  half2  vInTexC  : TEXCOORD,
                            in  half2  vInGridTexC  : TEXCOORD1,
                            out float4 oPos: POSITION, 
                            out half2  oPosTex: TEXCOORD,
                            out half2  oGridTex: TEXCOORD1)
{
  oPos = mul(vPos, mWorldViewProj);

  oPosTex = vInTexC;
  oGridTex = (vInGridTexC - 0.5f) * 2.0f;
  oGridTex.y = -oGridTex.y;
}

void VS_DrawBox(in float4 vPos: POSITION, 
                //in  half4  cInColor : COLOR,
                out float4 oPos: POSITION 
                /*out half4  oColor : TEXCOORD*/)
{
  oPos = mul(vPos, mWorldViewProj);
  //oColor = cInColor;
}

void VS_DrawBoxList(in float4 vPos: POSITION, 
                in  half4  cInColor : COLOR,
                out float4 oPos: POSITION, 
                out half4  oColor : TEXCOORD)
{
  oPos = mul(vPos, mWorldViewProj);
  oColor = cInColor;
}

sampler2D sBase = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = wrap; AddressV = wrap;
};


sampler2D sBaseClamp = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = Linear;
  MipMapLODBias = <iMipMapLODBias>;
  AddressU = clamp; AddressV = clamp;
};


sampler2D sBaseClampInterface = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = None;
  MipMapLODBias = <iMipMapLODBias>;
  MaxAnisotropy = 1;
  AddressU = clamp; AddressV = clamp;
};
/*
sampler2D sBaseClampInterface = sampler_state
{
  texture = <BaseMap>;
  MinFilter = Point; MagFilter = Point; MipFilter = None;
  MipMapLODBias = <iMipMapLODBias>;
  MaxAnisotropy = 1;
  AddressU = clamp; AddressV = clamp;
};
*/

sampler2D sZPassMap = sampler_state
{
  texture = <ZPassMap>;
  MinFilter = Point; MagFilter = Point; MipFilter = Point;
  RESET_BIAS;  
  AddressU = Clamp; AddressV = Clamp;
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

sampler2D sDownsample = sampler_state
{
  texture = <DownsampleMap>;
  MinFilter = Linear; MagFilter = Linear; MipFilter = None;
  RESET_BIAS;  
  AddressU = clamp; AddressV = clamp;
};

PS_OUTPUT PS_Sky(const VS_OUTPUT_SKY p)
{
  PS_OUTPUT o;
  half4 cPix;
  
  cPix = tex2D(sBase, p.vTexC);
  
  o.cColor = cPix * cMd * p.cDiff;
  o.cColor.rgb *= fSkyBrightness;
  return o;
}

PS_OUTPUT PS_ProcSky(const VS_OUTPUT_SKY p)
{
  PS_OUTPUT o;
  half4 cPix;
  //half  fAltitude = asin(p.vNorm.z) / 1.57;
  half  fAltitude = p.vNorm.z;
  
  if (fAltitude < fSkyGradient)
    cPix.rgb = lerp(cSkyHorizon, cSkyMiddle, fAltitude / fSkyGradient);
  else
    cPix.rgb = lerp(cSkyMiddle, cSkyZenith, (fAltitude - fSkyGradient) / (1.0 - fSkyGradient));
    
  cPix.a = saturate(lerp(0.0, 10.0, fAltitude));
  
  o.cColor = cPix * cMd * p.cDiff;
  o.cColor.rgb *= fBrightness;
  return o;
}

half4 PS_Occluded(): COLOR
{
  return cMd;
}

half4 PS_Outline(): COLOR
{
  return 0;
}

half4 PS_Transparent(in half2  vInTexC : TEXCOORD,
                     in half4  cInColor: TEXCOORD1,
                     uniform bool bClampTexture = false): COLOR
{
  half4 cOut, cPix;
  if (bClampTexture)
    cPix = tex2D(sBaseClamp, vInTexC);
  else
    cPix = tex2D(sBase, vInTexC);
  
  cOut = cPix * cInColor;
  return cOut;
}

half4 PS_Transparent_PremultipliedAlpha(in half2  vInTexC : TEXCOORD,
                                        in half4  cInColor: TEXCOORD1,
                                        in  half  hFog:    TEXCOORD2,
                                        uniform bool bClampTexture = false): COLOR
{
  half4 cOut, cPix;
  if (bClampTexture)
    cPix = tex2D(sBaseClamp, vInTexC);
  else
    cPix = tex2D(sBase, vInTexC);
    
  //cPix.rgb *= cMd.a;
  cPix *= cMd.a;
  cOut = cPix * cInColor;
  //cOut.a *= cMd.a;
  
  cOut.rgb = cOut.rgb * hFog + cFogColor * (1 - hFog) * cOut.a;
  
  return cOut;
}


PS_OUTPUT PS_Misc_ColorOnly(VS_OUTPUT_COLOR_ONLY p, uniform bool bShadows, uniform bool bExplicitFog)
{
  PS_OUTPUT o;
  half fVO;
  //fVO = CalcVO(sOcclusion, p.vVOC);
  fVO = 1;

  if (bShadows) 
    fVO *= CalcShadowShadowBuffer(sShadowMap, p.vShaC);
 
  o.cColor = CalcAmbDiff(cMa, cMd, 
                         cAmbientLight, cSunColor, half4(cMe, 1),
                         fBacklightStrength, normalize(p.vNorm.xyz), vSunDirection, fVO);

  OverridePixelLight(o.cColor, p.vNorm, half4(cMe, cMd.a), fVO);
  o.cColor.rgb += DecodeLight(p.cLight, half4(1, 1, 1, 0), fVO);
      
  //if(p.vFace > 0) o.cColor = 1;                                            
  if (bExplicitFog)
    o.cColor.rgb = lerp(cFogColor, o.cColor.rgb, p.fFog);
      
  return o;
}


float4 PS_ZPass(in float4 vPosTex: TEXCOORD): COLOR0
{
  float4 tmp;
  
  //tmp.r = vPosTex.z / vPosTex.w;
  tmp.r = (vPosTex.z - fNearPlane) / (fFarPlane - fNearPlane);
  tmp.r = saturate(tmp.r);
  //tmp.r = (tmp.r * 0.5f) + 0.5f;
  tmp.a = 1;
  tmp.b = 0;
  tmp.g = 0;
  
  /*tmp.r = 0;
  tmp.r = 0;
  
  if(vPosTex.x < 0) tmp.r = 1;
  if(vPosTex.y < 0) tmp.b = 1;
  */
  
  return tmp;
}


float4 PS_ZPass_Test(in float4 vPosTex: TEXCOORD): COLOR0
{
  float4 tmp, sample;
  
  //tmp.r = vPosTex.z; // / vPosTex.w;
  tmp.r = (vPosTex.z - fNearPlane) / (fFarPlane - fNearPlane);
  //tmp.r = (tmp.r * 0.5f) + 0.5f;
  
  float2 texC;
  texC.x = (vPosTex.x / vPosTex.w)* 0.5f + 0.5f;
  texC.y = (-vPosTex.y / vPosTex.w)* 0.5f + 0.5f;
  sample = tex2D(sZPassMap, texC);
  
  tmp.r = (sample.r - tmp.r) * ((fFarPlane - fNearPlane) / 100);
  
  float4 col;
  col.a = 1;
  col.b = 0;
  col.g = 0;
  col.r = 0;

  col.a = saturate(tmp.r);
  
 
  //col = sample;
  
  return col;
}

                 
float4 PS_DrawFont(in half2 vTexC: TEXCOORD) : COLOR0                 
{
  float4 col;
  col.a = tex2D(sBaseClamp, vTexC).r;
  //col.rgb = vColor.rgb;
  col.rgb = 1;
  col *= cDrawInterfaceModul;
  
  return col;
}

float4 PS_InterfaceDraw(in half2 vTexC: TEXCOORD) : COLOR0                 
{
  float4 col;
  col = tex2D(sBaseClampInterface, vTexC);
  
  col *= cDrawInterfaceModul;
  //col.rgb *= cDrawInterfaceModul.a;
  
  return col;
}

float4 PS_InterfaceDrawBW(in half2 vTexC: TEXCOORD) : COLOR0                 
{
  half4 col;
  half tmpMin, tmpMax;

  col = tex2D(sBaseClampInterface, vTexC);

  tmpMin = min(col.r, col.g);
  tmpMin = min(tmpMin, col.b);

  tmpMax = max(col.r, col.g);
  tmpMax = max(tmpMax, col.b);
  
  col.rgb = (tmpMin + tmpMax) / 2;
  
  col *= cDrawInterfaceModul;
  
  return col;
}

float4 PS_InterfaceDrawBlurredBack(in half2 vTexC: TEXCOORD, in half2 vBackTexC: TEXCOORD1) : COLOR0                 
{
  float4 col;
  float4 back;
  col = tex2D(sBaseClampInterface, vTexC);
  col *= cDrawInterfaceModul;
  
  back = tex2D(sDownsample, vBackTexC);
  col.rgb = lerp(back.rgb, col.rgb, col.a);
  //col = back;
  
  //col = 1;
  
  return col;
}

float4 PS_InterfaceDrawBlurredBack_Tooltip(in half2 vTexC: TEXCOORD, in half2 vBackTexC: TEXCOORD1) : COLOR0                 
{
  float4 col;
  float4 back;
  col = tex2D(sBaseClampInterface, vTexC);
  col *= cDrawInterfaceModul;
  
  back = tex2D(sDownsample, vBackTexC);
  col.rgb = lerp(back.rgb, col.rgb, col.a);
  if(col.a > 0) col.a = 1;

  //col = back;
  
  //col = 1;
  
  return col;
}

float4 PS_InterfaceDrawBB(in half2 vTexC: TEXCOORD, in half2 vBackTexC: TEXCOORD1, in half2 vTexelSize: TEXCOORD2) : COLOR0                 
{
  float4 col;
  float4 back;
  col = tex2D(sBaseClampInterface, vTexC);
  col *= cDrawInterfaceModul;
  
  float4 c = 0;
	
  for(int i = 0; i < 4; i++) {
    for(int j = 0; j < 4; j++) {
      float2 s;
      s.x = vBackTexC.x + (i-1) * vTexelSize.x;
      s.y = vBackTexC.y + (j-1) * vTexelSize.y;
      c += tex2D(sDownsample, s);
    }
  }
  
  c /= 16.0f;

/*
  for(int i = 0; i < 3; i++) {
    for(int j = 0; j < 3; j++) {
      float2 s;
      s.x = vBackTexC.x + (i-1) * vTexelSize.x;
      s.y = vBackTexC.y + (j-1) * vTexelSize.y;
      c += tex2D(sDownsample, s);
    }
  }
  
  c /= 9.0f;  
  */  
  
  
  back = tex2D(sDownsample, vBackTexC);
  back = c;
  col.rgb = lerp(back.rgb, col.rgb, col.a);
  col.rgb = back;
  
  //col = 1;
  
  return col;
}

#define COOLDOWN_MODULATOR 0.25f

float4 PS_InterfaceDrawAction(in half2 vTexC: TEXCOORD, in half2 vGridTexC: TEXCOORD1) : COLOR0                 
{
  float4 col;
  col = tex2D(sBaseClampInterface, vTexC);
  col *= cDrawInterfaceModul;

  half fPixelMod = 1.0f;
  half2 pos = normalize(vGridTexC);

  if(vGridTexC.x >= 0.0f)
  {
    if(fCooldownFirstHalf > 0.01f)
    {
	  if(pos.y < fSinCooldown) fPixelMod = COOLDOWN_MODULATOR;
	}
  }
  else
  {
    if(fCooldownFirstHalf <= 0.01f)
    {
	  if(pos.y > fSinCooldown) fPixelMod = COOLDOWN_MODULATOR;
    }
    else fPixelMod = COOLDOWN_MODULATOR;
  }
  
  col.rgb *= fPixelMod;
  
  return col;
}

#undef COOLDOWN_MODULATOR

float4 PS_DrawBox(/*in half4 vColor : TEXCOORD*/) : COLOR0                 
{
  return cDrawInterfaceModul;
}

float4 PS_DrawBoxList(in half4 vColor : TEXCOORD) : COLOR0                 
{
/*
  float4 col;
  col.rgba = vColor;
  col.a = 1;*/
  return vColor;
}


technique _Misc_Sky
<
  string shadername = "_Misc_Sky";
  int implementation = 0;
  string description = "Simple skybox shader. No lighting, just overbright the texture.";
  string NBTMethod = "none";
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
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = ALWAYS;
    ZWriteEnable = false;
    SpecularEnable = false;
    CullMode = None;//CCW;
    FillMode = Solid;
  
    VertexShader = compile vs_1_1 VS_Sky();
    PixelShader = compile ps_2_0 PS_Sky();
  }
}

technique _Misc_Procedure_Sky
<
  string shadername = "_Misc_Procedure_Sky";
  int implementation = 0;
  string description = "Simple gradient skybox shader. No lighting, colors set in the map editor.";
  string NBTMethod = "none";
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
    AlphaTestEnable = false;
    AlphaFunc = GREATER;
    AlphaRef = 0;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
    ZEnable = false;
    ZFunc = ALWAYS;
    ZWriteEnable = false;
    SpecularEnable = false;
    CullMode = None;//CCW;
    FillMode = Solid;
  
    VertexShader = compile vs_1_1 VS_Sky();
    PixelShader = compile ps_2_0 PS_ProcSky();
  }
}

technique _Misc_Occluded
<
  string shadername = "_Misc_Occluded";
  int implementation = 0;
  string description = "Internal technique, do not use. Used by the engine to draw the colorization of the occluded units.";
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = true;
    StencilFail = KEEP;
    StencilPass = KEEP;
    StencilZFail = KEEP;
    StencilFunc = EQUAL;
    StencilMask = 0x1f;
    StencilWriteMask = 0x1f;
    StencilRef = <iFaction>;
    FogEnable = false;
    ZEnable = false;
    ZFunc = ALWAYS;
    ZWriteEnable = false;
    CullMode = None;
    FillMode = Solid;

    VertexShader = compile vs_1_1 VS_Occluded();
    PixelShader = compile ps_2_0 PS_Occluded();    
  }
}

technique _Misc_Outline
<
  string ShaderName = "_Misc_Outline";
  string Description = "Internal technique, no not use. Used to mark backfacing polys in the stencil.";
  int Implementation = 0;
  string NBTMethod = "None";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    FogEnable        = false;
    ZEnable          = true;
    ZWriteEnable     = false;
    AlphaBlendEnable = true;
    SrcBlend         = Zero;
    DestBlend        = One;
    AlphaTestEnable  = false;
    AlphaFunc        = NEVER;
    StencilEnable    = true;
    StencilFail      = KEEP;
    StencilPass      = REPLACE;
    StencilZFail     = KEEP;
    StencilFunc      = ALWAYS;
    StencilMask      = 0x10;
    StencilWriteMask = 0x10;
    StencilRef       = 0x10;
    CullMode         = CCW;
    ColorWriteEnable = CWEVALUE;
    ClipPlaneEnable  = 0;
    
    VertexShader     = compile vs_1_1 VS_Outline();
    PixelShader      = compile ps_2_0 PS_Outline();
  }
}

technique _Misc_TransparentRadar
<
  string description = "Shader for general transparent objects. Uses ambient, diffuse and emissive lighting but does not honor normals (objects are lit as if they are maximally exposed to the light). Texture is tiled.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  //bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
  pass p0 {
    /*AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;*/
  
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/  
  
    ZEnable = false;  
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    CullMode = none;
    

    VertexShader = compile vs_1_1 VS_Transparent(true);
    PixelShader  = compile ps_2_0 PS_Transparent();
  }
}

technique _Misc_Transparent_PremultipliedAlpha
<
  string description = "Shader for general transparent objects. Uses ambient, diffuse and emissive lighting but does not honor normals (objects are lit as if they are maximally exposed to the light). Texture is tiled.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
  pass p0 {
/*  AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    

    SrcBlend = One;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = false;
/*  ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/  
    
    CullMode = none;
    

    VertexShader = compile vs_1_1 VS_Transparent_PremultipliedAlpha(true);
    PixelShader  = compile ps_2_0 PS_Transparent_PremultipliedAlpha();
  }
}

technique _Misc_Transparent
<
  string description = "Shader for general transparent objects. Uses ambient, diffuse and emissive lighting but does not honor normals (objects are lit as if they are maximally exposed to the light). Texture is tiled.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
  pass p0 {
/*  AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*  ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/  
    
    CullMode = none;
    

    VertexShader = compile vs_1_1 VS_Transparent(true);
    PixelShader  = compile ps_2_0 PS_Transparent();
  }
}

technique _Misc_Skin_Transparent
<
  string description = "Skinned shader for transparent objects. Uses ambient, diffuse and emissive lighting but does not honor normals (objects are lit as if they are maximally exposed to the light). Texture is tiled.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  int BonesPerPartition = BONES_PER_PARTITION;
  bool bPublic = true;
>
{
  pass p0 {
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
    CullMode = none;
    
    VertexShader = compile vs_1_1 VS_Skin_Transparent(true);
    PixelShader  = compile ps_2_0 PS_Transparent();
  }
}

technique _Misc_Transparent_Clamp
<
  string description = "Shader for general transparent objects. Uses ambient, diffuse and emissive lighting but does not honor normals (objects are lit as if they are maximally exposed to the light). Texture is clamped, not tiled.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/  
    CullMode = none;
    

    VertexShader = compile vs_1_1 VS_Transparent(true);
    PixelShader  = compile ps_2_0 PS_Transparent(true);
  }
}

technique _Misc_Transparent_Energy
<
  string description = "Shader for emitting transparent objects. Uses ambient, diffuse and emissive lighting but does not honor normals (objects are lit as if they are maximally exposed to the light). No overbrighting the emissive color component.";
  string NBTMethod = "None";
  bool UsesNIRenderState = true;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
  bool bPublic = true;
>
{
  pass p0 {
/*    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = true;
    AlphaFunc = GREATER;
    AlphaRef = 0;
*/    
    ColorWriteEnable = CWEVALUE;
    DitherEnable = true;
    StencilEnable = false;
    FogEnable = true;
/*    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = false;
*/  
    CullMode = none;
    

    VertexShader = compile vs_1_1 VS_Transparent(false);
    PixelShader  = compile ps_2_0 PS_Transparent();
  }
}

technique _Misc_ColorOnly
<
  string shadername = "_Misc_ColorOnly";
  int implementation = 0;
  string description = "Test only shader with color only.";
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  //bool DoubleSided = true;
  bool bPublic = true;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    AlphaRef = 0;
    AlphaFunc = greater;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = false;
    CullMode = CW;
    StencilEnable = false;
    TwoSidedStencilMode = false;
    StencilFail = KEEP;
    StencilPass = REPLACE;
    StencilZFail = KEEP;
    StencilFunc = ALWAYS;
    StencilMask = 0x10;
    StencilWriteMask = 0x10;
    StencilRef = 0x10;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = true;
  
  
    VertexShader = compile _VS2X_ VS_Misc_ColorOnly(true, false);
    PixelShader =  compile ps_2_0 PS_Misc_ColorOnly(false,false);  
  }
}
  
technique _Misc_ColorOnly_Shadows
<
  string shadername = "_Misc_ColorOnly_Shadows";
  int implementation = 0;
  string description = "Internal, do not use";
  string NBTMethod = "NDL";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  //bool DoubleSided = true;
>
{
  pass P0
  {
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    AlphaRef = 0;
    AlphaFunc = greater;
    ColorWriteEnable = CWEVALUE;
    DitherEnable = false;
    CullMode = CW;
    StencilEnable = false;
    TwoSidedStencilMode = false;
    StencilFail = KEEP;
    StencilPass = REPLACE;
    StencilZFail = KEEP;
    StencilFunc = ALWAYS;
    StencilMask = 0x10;
    StencilWriteMask = 0x10;
    StencilRef = 0x10;
    FogEnable = true;
    ZEnable = true;
    ZFunc = LESSEQUAL;
    ZWriteEnable = true;
  
  
    VertexShader = compile _VS2X_ VS_Misc_ColorOnly(true, true);
    PixelShader =  compile ps_2_0 PS_Misc_ColorOnly(true,false);  
  }
}


technique _Misc_ZPass
<
  string shadername = "_Misc_ZPass";
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
    StencilEnable = false;
    CullMode = CW;
    
    VertexShader = compile vs_1_1 VS_ZPass();
    PixelShader =  compile ps_2_0 PS_ZPass();
  }
}


technique _Misc_ZPass_Test
<
  string shadername = "_Misc_ZPass_Test";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool bPublic = true;
>
{
  pass P0
  {
    ZEnable = true;
    ZWriteEnable = true;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    
    VertexShader = compile vs_1_1 VS_ZPass_Test();
    PixelShader =  compile ps_2_0 PS_ZPass_Test();
  }
}


technique _Misc_DrawFont
<
  string shadername = "_Misc_DrawFont";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_DrawFont();
    PixelShader =  compile ps_2_0 PS_DrawFont();
  }
}

technique _Misc_InterfaceDraw
<
  string shadername = "_Misc_InterfaceDraw";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDraw();
  }
}

technique _Misc_InterfaceDrawXForm
<
  string shadername = "_Misc_InterfaceDrawXForm";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw(true);
    PixelShader =  compile ps_2_0 PS_InterfaceDraw();
  }
}

technique _Misc_InterfaceDrawNoTransp
<
  string shadername = "_Misc_InterfaceDrawNoTransp";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDraw();
  }
}

technique _Misc_InterfaceDrawBW
<
  string shadername = "_Misc_InterfaceDrawBW";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDrawBW();
  }
}


technique _Misc_IDBW
<
  string shadername = "_Misc_IDBW";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDrawBW();
  }
}


// _Misc_InterfaceDrawBlurredBack
technique _Misc_IDBB
<
  string shadername = "_Misc_IDBB";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDrawBlurredBack();
  }
}


technique _Misc_IDBB_Tooltip
<
  string shadername = "_Misc_IDBB_Tooltip";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDrawBlurredBack_Tooltip();
  }
}

/*
// _Misc_InterfaceDrawBlurredBack
technique _Misc_IDBB
<
  string shadername = "_Misc_IDBB";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = false;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDrawBB();
    PixelShader =  compile ps_2_0 PS_InterfaceDrawBB();
  }
}
*/

/*
technique _Misc_InterfaceDrawAction
<
  string shadername = "_Misc_InterfaceDrawAction";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDraw();
  }
}
*/

technique _Misc_InterfaceDrawAction
<
  string shadername = "_Misc_InterfaceDrawAction";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDrawAction();
    PixelShader =  compile ps_2_0 PS_InterfaceDrawAction();
  }
}


technique _Misc_InterfaceDrawAdditive
<
  string shadername = "_Misc_InterfaceDrawAdditive";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = One;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDraw();
  }
}

technique _Misc_InterfaceDrawMultiply
<
  string shadername = "_Misc_InterfaceDrawMultiply";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = DestColor;
    DestBlend = Zero;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDraw();
  }
}

technique _Misc_InterfaceDrawScreen
<
  string shadername = "_Misc_InterfaceDrawScreen";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = One;
    DestBlend = InvSrcColor;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_InterfaceDraw();
    PixelShader =  compile ps_2_0 PS_InterfaceDraw();
  }
}



technique _Misc_DrawBox
<
  string shadername = "_Misc_DrawBox";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_DrawBox();
    PixelShader =  compile ps_2_0 PS_DrawBox();
  }
}

technique _Misc_DrawBoxList
<
  string shadername = "_Misc_DrawBoxList";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
  bool ImplicitAlpha = true;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = true;
    SrcBlend = SrcAlpha;
    DestBlend = InvSrcAlpha;    
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    ColorWriteEnable = Red | Blue | Green | Alpha;
    
    VertexShader = compile vs_1_1 VS_DrawBoxList();
    PixelShader =  compile ps_2_0 PS_DrawBoxList();
  }
}

technique _Misc_DrawRectsMinimap
<
  string shadername = "_Misc_DrawRectsMinimap";
  int implementation = 0;
  string NBTMethod = "none";
  bool UsesNIRenderState = false;
  bool UsesNILightState = false;
>
{
  pass P0
  {
    ZEnable = false;
    ZWriteEnable = false;
    ColorWriteEnable = CWEVALUE;
    ZFunc = LESSEQUAL;
    FogEnable = false;
    AlphaBlendEnable = false;
    AlphaTestEnable = false;
    StencilEnable = false;
    CullMode = none;
    
    VertexShader = compile vs_1_1 VS_DrawBoxList();
    PixelShader =  compile ps_2_0 PS_DrawBoxList();
  }
}


void VS_ReflectionsMonoTerrain(in float4 vPos: POSITION, 
                               out float4 oPos: POSITION)
{
  oPos = mul(vPos, mWorldViewProj);
}


float4 PS_ReflectionsMonoTerrain() : COLOR0
{
  return 0;
}


technique _Misc_ReflectionsMonoTerrain
<
  string shadername = "_Misc_ReflectionsMonoTerrain";
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
    StencilEnable = false;
    CullMode = CCW;
    ColorWriteEnable = 0;
    
    VertexShader = compile vs_1_1 VS_ReflectionsMonoTerrain();
    PixelShader =  compile ps_2_0 PS_ReflectionsMonoTerrain();
  }
}