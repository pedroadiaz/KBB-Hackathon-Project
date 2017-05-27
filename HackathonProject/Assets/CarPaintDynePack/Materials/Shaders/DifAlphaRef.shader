Shader "abDyne/DifAlphaRef" {
Properties {
	_Color ("Base Color (RGB)", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5,0.5,0.5,1)
	_Shininess ("Shininess", Range (0.01, 5)) = 0.078125
	_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
	_Cube ("Reflection Cubemap", Cube) = "" { TexGen CubeReflect }
	_FresAmt ("Fresnel Amount", Range (0, 3)) = 1
}

SubShader {
	Tags { "RenderType"="Transparent" "Queue"="Transparent"}
	LOD 400
CGPROGRAM
#pragma surface surf BlinnPhong alpha

samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;
half _Shininess;	
float _FresAmt;

struct Input {
	float3 worldRefl;
	float3 viewDir;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = _Color;
	
	half rim = saturate(dot (normalize(IN.viewDir), o.Normal));
	rim = 1-rim;
	half fres = rim;
	fres = pow(fres, _FresAmt);

	o.Albedo = c.rgb*(clamp(1-rim, 0, 1));
	
	o.Gloss = _SpecColor.rgb;
	o.Specular = _Shininess;
	
	float3 worldRefl = WorldReflectionVector (IN, o.Normal);
	fixed4 reflcol = texCUBE (_Cube, worldRefl);

	o.Emission = reflcol.rgb * _ReflectColor.rgb * fres;
	o.Alpha = c.a + o.Emission;
}
ENDCG
}

FallBack "Reflective/Bumped Diffuse"
}
