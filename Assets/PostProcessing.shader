Shader "NewImageEffectShader"
{
	Properties
	{

		_MainTex ("Texture", 2D) = "white" {}

		[Header(Gaussian Blur)]
		[Toggle(BLUR)]
		_Blur("On/Off", Int) = 0
		_Radius("Radius", Range(0, 20)) = 1
		_Theta("Theta", Float) = 5
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
		    #pragma vertex vert
			#pragma fragment frag
			#pragma shader_feature BLUR
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			sampler2D _MainTex;
			float _Radius;
			float _Theta;
			float4 _MainTex_TexelSize;

			float GaussDistrib(float x, float y, float theta)
			{
				float expon = - (x * x + y * y) / (2 * theta * theta);
				float coeff = 1 / (2 * UNITY_PI * theta * theta);
				return coeff * exp(expon);
			}

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
		

			fixed4 frag (v2f i) : SV_Target
			{
				#ifndef BLUR
					return tex2D(_MainTex, i.uv);
				#endif

			    if (_Radius == 0) return tex2D(_MainTex, i.uv);

				float4 col = float4(0,0,0,0);
				float sum = 0.0;
				float width = _MainTex_TexelSize.z;
				float height = _MainTex_TexelSize.w;

				for (int j = -_Radius; j < _Radius; j++)
				{
					for (int k = -_Radius; k < _Radius; k++)
					{
						sum += GaussDistrib(j, k, _Theta);
					}
				}

				for (int m = -_Radius; m < _Radius; m++)
				{
					for (int n = -_Radius; n < _Radius; n++)
					{
						float2 index = float2((i.uv.x + _MainTex_TexelSize.x * m) % width, (i.uv.y + _MainTex_TexelSize.y * n) % height);
						col += tex2D(_MainTex, index) * GaussDistrib(m, n, _Theta) / sum;
					}
				}
				return col;
			}
			ENDCG
		}
	}
}
