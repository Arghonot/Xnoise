﻿Shader "Xnoise/Modifiers/ScaleBias"
{
    Properties
    {
        _TextureA("TextureA", 2D) = "white" {}
        _Bias("Bias", Float) = 0
        _Scale("Scale", Float) = 1
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
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

                float _Bias, _Scale;
                sampler2D _TextureA;
                float4 _TextureA_ST;

                v2f vert(appdata v)
                {
                    v2f o;

                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv = TRANSFORM_TEX(v.uv, _TextureA);

                    return o;
                }


                float getValueScaleBias(float value)
                {
                    return value * _Scale + _Bias;
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    return getValueScaleBias(tex2D(_TextureA, i.uv));
                }
                ENDCG
            }
        }
}
