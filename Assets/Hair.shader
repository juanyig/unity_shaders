Shader "Hair"
{
	Properties
	{

        [Header(Diffuse properties)]
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor("Albedo", Color) = (1,0.6,0.6,1)
		_LightColor("Light Color", Color) = (0,0,0,1)
		_ShadowColor("Shadow Color", Color) = (0,0,0,1)
		_RampTex("Ramp Texture", 2D) = "white" {}

		[Space]
		[Header(Specular properties)]
		[Toggle(BLINN)]
		_BlinnPhong("Blinn Phong", Int) = 1
		_SpecColor("Specular Color", Color) = (0,0,0,1)
		_Gloss("Glossiness", Range(0.0, 256)) = 40

		[Space]
		[Header(Rim Color)]
		[Toggle(RIM)]
		_Rim("Rim", Int) = 0
		_RimColor("Rim Color", Color) = (1,0,0,1)
		_RimPower("Rim Power",  Range(2, 10)) = 5

		[Space]
		[Header(Outline Color)]
		[Toggle(OUTLINE)]
		_Outline("Outline", Int) = 0
		_OutlineColor("Outline Color", Color) = (1,0,0,1)
		_OutlineWidth("Outline Width",  Range(0, 10)) = 0.1

		[Space]
		[Header(Toon Shading Style)]
		[Toggle(TOON)]
		_Toon("Toon", Int) = 0
		//[KeywordEnum(self defined, ramp texture)] _ToonShadowStyle ("shadow style", Float) = 0
		_ToonShadowColor("Shadow Color", Color) = (0.36,0.3,0.34,1)
		_ToonHighlightCoLor("Highlight Color", Color) = (1,0.84,1,1)

		[Space]
		[Header(Anime Hair highlight)]
		[Toggle(HAIR)]
		_AnimeHair("ON/OFF", Int) = 0
		_HighlightPower("Glossiness", Range(0, 256)) = 256
		_HighlightColor("Highlight Color1", Color) = (1,1,1,1)
		_HighlightColor2("Highlight Color2", Color) = (1,1,1,1)
		_HighlightTex1("Texture1", 2D) = "white" {}
		_HighlightTex2("Texture2", 2D) = "white" {}
		_Shift("Secondary Highlight Shift", float) = 0.3

	}
	SubShader
	{

		Pass
		{ 
		    Tags { "LightMode"="ForwardBase"  }
		    Cull Front
		    //Zwrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature OUTLINE

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float4 _OutlineColor;
			float _OutlineWidth;

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#ifdef OUTLINE
				float3 dir = lerp(v.normal, normalize(v.vertex.xyz), 0.8);
				//float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, dir);
				//float2 offset = TransformViewToProjection(norm.xy);
				//o.vertex.xy += offset * o.vertex.z * _OutlineWidth;
				o.vertex = UnityObjectToClipPos(v.vertex + float4(normalize(dir) * _OutlineWidth, 0));
				#endif

				return o;
			}

		    fixed4 frag (v2f i) : SV_Target
			{

				return float4(_OutlineColor);
			}

			ENDCG

		}

		Pass
		{
			Tags { "LightMode"="ForwardBase"  }

			CGPROGRAM

			#pragma multi_compile_fwdbase
		    #pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature BLINN
			#pragma shader_feature RIM
			#pragma shader_feature TOON
			#pragma shader_feature HAIR
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 norm: NORMAL;
				float3 tan: TANGENT;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
				float3 N: NORMAL;    //normal direction
				float3 L: TEXCOORD1; //light direction
				float3 H: TEXCOORD2; 
				float3 V: TEXCOORD3; //view direction form camera
				float3 T: TANGENT;
				SHADOW_COORDS(4)

			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;
			sampler2D _RampTex;
			float4 _ShadowColor;

			float4 _LightColor;
			float4 _SpecColor;
			float _Gloss;

			int _Rim;
			float4 _RimColor;
			float _RimPower;

			float4 _ToonShadowColor;
			float4 _ToonHighlightCoLor;

			sampler2D _HighlightTex1;
			float4 _HighlightColor;
			sampler2D _HighlightTex2;
			float4 _HighlightColor2;
			float _HighlightPower;
			float _Shift;

			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				TRANSFER_SHADOW(o);

				o.N = UnityObjectToWorldNormal(v.norm);
				o.L = UnityWorldSpaceLightDir(mul(unity_ObjectToWorld, v.vertex).xyz);
				o.V = UnityWorldSpaceViewDir(mul(unity_ObjectToWorld, v.vertex).xyz);
				o.H = normalize(o.L) + normalize(o.V);
				o.T = mul(unity_ObjectToWorld, v.tan);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
float3 L_tmp = normalize(i.L);
			    float3 N_tmp = normalize(i.N);
			    float3 H_tmp = normalize(i.H);
			    float3 V_tmp = normalize(i.V);
			    float3 T_tmp = normalize(i.T).xyz;
			    float3 tangent = normalize(cross(T_tmp.xyz, N_tmp));
			    float2 uv = float2( 1 - (0.5 * dot(L_tmp, N_tmp) + 0.5), 1 - (0.5 * dot(L_tmp, N_tmp) + 0.5));
			    float intensity = smoothstep(0, 0.01, dot(L_tmp, N_tmp) * SHADOW_ATTENUATION(i));
				float3 diffu = tex2D (_MainTex, i.uv) * _MainColor.xyz * (0.5 * dot(L_tmp, N_tmp) + 0.5) * tex2D(_RampTex, uv) * _LightColor.xyz;
				diffu += (1 - (0.5 * dot(L_tmp, N_tmp) + 0.5)) * _ShadowColor.xyz;
				float3 spec = float3(0,0,0);
				float3 rim = float3(0,0,0);

				#ifdef BLINN
					spec = pow(max(0.0, dot(N_tmp, H_tmp)), _Gloss) * _LightColor.xyz * _SpecColor.xyz;
				#endif

				#ifdef RIM
					rim = _RimColor.xyz * pow(1.0 - dot(N_tmp, V_tmp), _RimPower);
				#endif

				float3 dir, dir2;
				float sinTH, dirAtten, sinTH2, dirAtten2, spec2;

				#ifdef HAIR
					dir = normalize(tangent + N_tmp * tex2D(_HighlightTex1, i.uv).g);
					sinTH = sqrt(1 - pow(dot(dir, H_tmp),2));
					dirAtten = smoothstep(-0.1,0.1,dot(dir, H_tmp));
					spec = dirAtten * pow(sinTH, _HighlightPower) * _LightColor.xyz * _HighlightColor.xyz;

					dir2 = normalize(tangent + N_tmp * (tex2D(_HighlightTex2, i.uv).g + _Shift));
					sinTH2 = sqrt(1 - pow(dot(dir2, H_tmp),2));
					dirAtten2 = smoothstep(-0.2,1,dot(dir2, H_tmp));
					spec2 = dirAtten2 * pow(sinTH2, _HighlightPower/10) * _LightColor.xyz * _HighlightColor2.xyz;

					spec += spec2;


				#endif

				#ifdef TOON
				    diffu =tex2D (_MainTex, i.uv) * _MainColor.xyz  * _LightColor.xyz;
				    spec = float3(0,0,0);
				    //rim = float3(0,0,0);
				    //shadow intensity
			    	float shadowIntensity = dot(L_tmp, N_tmp) * SHADOW_ATTENUATION(i) > 0 ? 1 : 0;
			    	if (!shadowIntensity) diffu = _ToonShadowColor.xyz;
			    	//light intensity
			    	dir2 = normalize(tangent + N_tmp * (tex2D(_HighlightTex2, i.uv).g + _Shift));
					sinTH2 = sqrt(1 - pow(dot(dir2, H_tmp),2));
					dirAtten2 = smoothstep(-0.2,1,dot(dir2, H_tmp));
			    	float lightIntensity =  (dirAtten2 * pow(sinTH2, _HighlightPower/10)  > 0.14 && shadowIntensity)? 1 : 0;
			    	if(lightIntensity) diffu = _ToonHighlightCoLor.xyz;
			    	float rimPower =  pow(1.0 - dot(N_tmp, V_tmp), _RimPower) > 0.5? 1 : 0;
			    	if (rimPower && _Rim) diffu = _RimColor.xyz;	
				#endif
				return fixed4(diffu + spec + rim, 1.0);
			}
			ENDCG
		}
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"

	}

	FallBack "Diffuse"
}