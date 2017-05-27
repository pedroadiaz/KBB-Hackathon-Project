Shader "abDyne/Carpaint(MetalColorDecal)" {
Properties {
	_Color ("Base Color (RGB)", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
	_Shininess ("Shininess", Range (0.01, 5)) = 0.078125
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_DecAmt ("Decal Amount", Range (0, 1)) = 1
	_DecTex ("Decal Texture (RGBA)", 2D) = "white" {}
	_FlakeAmt ("Flake Amount", Range (0, 1)) = 1
	_FlakeTex ("Flake Texture (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "" { TexGen CubeReflect }
	_RimColor ("Rim Color", Color) = (0,0,0,1)
	_RimAmt ("Rim Amount", Range (10, 0)) = 5
	_RimPwr ("Rim Power", Range (0, 10)) = 2
	_FresAmt ("Fresnel Amount", Range (0, 3)) = 1
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 400
	Cull Off
CGPROGRAM
#pragma surface surf BlinnPhong
#pragma target 3.0
#pragma glsl
#pragma exclude_renderers d3d11_9x

sampler2D _DecTex;
float _DecAmt;
sampler2D _FlakeTex;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;
half _Shininess;	
float _FresAmt;
float _FlakeAmt;
float _RimAmt;
float _RimPwr;
fixed4 _RimColor;

struct Input {
	float2 uv_DecTex;
	float2 uv_FlakeTex;
	float3 worldRefl;
	float3 viewDir;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 dec = tex2D(_DecTex, IN.uv_DecTex);
	fixed4 flake = tex2D(_FlakeTex, IN.uv_FlakeTex);
	fixed4 c = _Color;
	
	half rim = saturate(dot (normalize(IN.viewDir), o.Normal));
	rim = 1-rim;
	half fres = rim;
	rim = pow(rim, _RimAmt);
	fres = pow(fres, _FresAmt);
	half decA = dec.a*_DecAmt;

	o.Albedo = c.rgb*(clamp(1-(rim*_RimPwr), 0, 1));
	o.Albedo = o.Albedo*(1-decA) + dec*decA;
	o.Albedo += rim*_RimColor*_RimPwr;
	
	o.Gloss = (_SpecColor.a + (flake.a * (1-rim) * _FlakeAmt))*(1-decA);
	o.Specular = _Shininess;
	
	float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	fixed4 reflcol = texCUBE (_Cube, worldRefl);

	o.Emission = reflcol.rgb * _ReflectColor.rgb * fres*(1-decA);
	o.Alpha = reflcol.a * _ReflectColor.a;
}
ENDCG
}

FallBack "Reflective/Bumped Diffuse"
}
