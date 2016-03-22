// Shader adapted by Douglas Edric Stanley & Margoaux Charvolin for the Media Design Master, –HEAD Genève
// Adapted from "Multiple Metaball shader", Rodrigo Fernandez Diaz <q_layer@hotmail.com>, cf. http://codeartist.mx/tutorials/liquids

Shader "MediaDesign/Liquide" {

	Properties {
		_MainTex("Texture", 2D) = "white" { }
		_Saturation("Saturation", Range(0.0,1.0)) = 1.0
		_Luminosite("Luminosite", Range(0.0,1.0)) = 1.0
	}

	SubShader {

		Tags { "Queue" = "Transparent" }
		Pass {

			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _Color;
			sampler2D _MainTex;
			float _Saturation;
			float _Luminosite;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			float4 _MainTex_ST;

			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			float COLOR_THRESHOLD = 0.2;


			float3 rgb_to_hsv(float3 RGBColor)
			{
				float3 HSV;
			   
			 float minChannel, maxChannel;
			 if (RGBColor.x > RGBColor.y) {
				maxChannel = RGBColor.x;
				minChannel = RGBColor.y;
			 }
			 else {
				maxChannel = RGBColor.y;
				minChannel = RGBColor.x;
			 }
			 
			 if (RGBColor.z > maxChannel) maxChannel = RGBColor.z;
			 if (RGBColor.z < minChannel) minChannel = RGBColor.z;
			   
			        HSV.xy = 0;
			        HSV.z = maxChannel;
			        float delta = maxChannel - minChannel;             //Delta RGB value
			        if (delta != 0) {                    // If gray, leave H  S at zero
			           HSV.y = delta / HSV.z;
			           float3 delRGB;
			           delRGB = (HSV.zzz - RGBColor + 3*delta) / (6.0*delta);
			           if      ( RGBColor.x == HSV.z ) HSV.x = delRGB.z - delRGB.y;
			           else if ( RGBColor.y == HSV.z ) HSV.x = ( 1.0/3.0) + delRGB.x - delRGB.z;
			           else if ( RGBColor.z == HSV.z ) HSV.x = ( 2.0/3.0) + delRGB.y - delRGB.x;
			        }
			        return (HSV);
			}

			float3 hsv_to_rgb(float3 HSV)
			{
			        float3 RGB = HSV.z;
			   
			           float var_h = HSV.x * 6;
			           float var_i = floor(var_h);   // Or ... var_i = floor( var_h )
			           float var_1 = HSV.z * (1.0 - HSV.y);
			           float var_2 = HSV.z * (1.0 - HSV.y * (var_h-var_i));
			           float var_3 = HSV.z * (1.0 - HSV.y * (1-(var_h-var_i)));
			           if      (var_i == 0) { RGB = float3(HSV.z, var_3, var_1); }
			           else if (var_i == 1) { RGB = float3(var_2, HSV.z, var_1); }
			           else if (var_i == 2) { RGB = float3(var_1, HSV.z, var_3); }
			           else if (var_i == 3) { RGB = float3(var_1, var_2, HSV.z); }
			           else if (var_i == 4) { RGB = float3(var_3, var_1, HSV.z); }
			           else                 { RGB = float3(HSV.z, var_1, var_2); }
			   
			   return (RGB);
			}


			// conversion de chaque pixel en fonction de son intensité moyenne
			half4 frag (v2f i) : COLOR {

				half4 texcol = tex2D(_MainTex, i.uv);
				half4 finalColor = texcol;

				// faire la moyenne RVB pour définir si on est assez coloré
				float gris = (texcol.r + texcol.g + texcol.b) / 3.0;

				if (gris > 0.3) {

					// convertir notre pixel en RVB
					float3 couleurTSL = rgb_to_hsv(float3(texcol.r, texcol.g, texcol.b));
					// extraire la teinte
					float teinte = clamp(couleurTSL[0], 0.0, 1.0);
					// créer une couleur RVB à partir de la teinte
					float3 couleurRGB = hsv_to_rgb(float3(teinte, _Saturation, _Luminosite));
					// 
					finalColor = half4(couleurRGB.r, couleurRGB.g, couleurRGB.b, 1);

				} else {

					finalColor = half4(0,0,0,0);

				}

				return finalColor;

			} ENDCG

		}

	}

	Fallback "VertexLit"

}