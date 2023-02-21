﻿Shader "Xnoise/Modifiers/Terrace"
{
    Properties
    {
        _Src ("Source", 2D) = "white" {}
        _Gradient ("Gradient", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _Src;
            float4 _Src_ST;
            sampler2D _Gradient;
            float4 _Gradient_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _Src);
                return o;
            }
            
            float getColorGrayscale(float3 sample)
            {
                return 0.21 * sample.r + 0.71 * sample.g + 0.07 * sample.b;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_Gradient, float2(getColorGrayscale(tex2D(_Src, i.uv)), i.uv.y));
            }
            ENDCG
        }
    }
}
