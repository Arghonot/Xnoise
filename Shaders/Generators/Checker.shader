﻿Shader "Unlit/Checker"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            float ComputeChecker(float x, float y, float z)
            {
                int ix = (int)(floor(x));
                int iy = (int)(floor(y));
                int iz = (int)(floor(z));

                return (ix & 1 ^ iy & 1 ^ iz & 1) != 0 ? -1.0 : 1.0;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return ComputeChecker(i.worldPos.x,i.worldPos.y, i.worldPos.z);
            }
            ENDCG
        }
    }
}
