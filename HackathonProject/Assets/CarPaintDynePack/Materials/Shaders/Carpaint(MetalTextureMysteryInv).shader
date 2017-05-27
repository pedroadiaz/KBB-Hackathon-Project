Shader "abDyne/Carpaint(MetalTextureMysteryInv)" {
Properties {
	_Color ("Base Color (RGB)", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
	_Shininess ("Shininess", Range (0.01, 5)) = 0.078125
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) Texture", 2D) = "white" {}
	_FlakeAmt ("Flake Amount", Range (0, 1)) = 1
	_FlakeTex ("Flake Texture (A)", 2D) = "white" {}
	_Cube ("Reflection Cubemap", Cube) = "" { TexGen CubeReflect }
	_BumpMap ("Normalmap", 2D) = "bump" {}
	_DecTex ("Rim Mystery (RGBA)", 2D) = "white" {}
	_DecAmt ("Myst Amount", Range (0, 1)) = 1
	_RimColor0 ("Rim Color", Color) = (0,0,0,1)
	_RimColor ("Myst Overlay", Color) = (0,0,0,1)
	_RimAmt ("Rim Amount", Range (10, 0)) = 5
	_RimPwr ("Rim Power", Range (0, 10)) = 2
	_FresAmt ("Fresnel Amount", Range (0, 3)) = 1
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 400
CGPROGRAM
#pragma surface surf BlinnPhong
#pragma target 3.0
#pragma glsl
#pragma exclude_renderers d3d11_9x

sampler2D _MainTex;
sampler2D _DecTex;
float _DecAmt;
sampler2D _FlakeTex;
sampler2D _BumpMap;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;
half _Shininess;	
float _FresAmt;
float _FlakeAmt;
float _RimAmt;
float _RimPwr;
fixed4 _RimColor;
fixed4 _RimColor0;

struct Input {
	float2 uv_MainTex;
	float2 uv_DecTex;
	float2 uv_FlakeTex;
	float2 uv_BumpMap;
	float3 worldRefl;
	float3 viewDir;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 dec = tex2D(_DecTex, IN.uv_DecTex);
	fixed4 flake = tex2D(_FlakeTex, IN.uv_FlakeTex);
	fixed4 c = (tex) * _Color;
	
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

	half rim = saturate(dot (normalize(IN.viewDir), o.Normal));
	rim = 1-rim;
	half fres = rim;
	rim = pow(rim, _RimAmt);
	fres = pow(fres, _FresAmt);
	half rimp = clamp(rim*_RimPwr, 0, 1);

	o.Albedo = c.rgb*(1-rimp) + _RimColor0*rimp;
	o.Albedo = o.Albedo * (1-dec.a*rimp*_DecAmt) + (dec+_RimColor)*dec.a* rimp*_DecAmt;
	
	o.Gloss = (_SpecColor.a + (flake.a * (1-rim) * _FlakeAmt));
	o.Specular = _Shininess;
	
	float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	fixed4 reflcol = texCUBE (_Cube, worldRefl);

	o.Emission = reflcol.rgb * _ReflectColor.rgb * fres;
	o.Alpha = reflcol.a * _ReflectColor.a;
}
ENDCG
}

FallBack "Reflective/Bumped Diffuse"
}
