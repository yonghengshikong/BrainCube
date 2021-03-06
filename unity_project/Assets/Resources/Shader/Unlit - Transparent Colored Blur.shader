Shader "Unlit/Transparent Colored Blur"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_Distance ("Distance", Float) = 0.003
	}
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
      		float _Distance;
	
			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}
				
			fixed4 frag (v2f IN) : COLOR
			{
				float distance = _Distance;
				
		        fixed4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x + distance , IN.texcoord.y + distance )) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x + distance , IN.texcoord.y)) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x , IN.texcoord.y + distance )) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x - distance , IN.texcoord.y - distance )) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x + distance , IN.texcoord.y - distance )) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x - distance , IN.texcoord.y + distance )) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x - distance , IN.texcoord.y)) * IN.color;
		        col += tex2D(_MainTex, half2(IN.texcoord.x , IN.texcoord.y - distance )) * IN.color;
		        col = col / 9;
			    
		        return col;
			}
			ENDCG
		}
	}

	SubShader
	{
		LOD 100

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMaterial AmbientAndDiffuse
			
			SetTexture [_MainTex]
			{
				Combine Texture * Primary
			}
		}
	}
}
