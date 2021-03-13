Shader "Unlit/Cylinder"
{
    Properties
    {
        _frequency("Frequency",Float) = 0.0
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
            float _frequency;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            float ComputeColor(float x, float y, float z)
            {
                x *= _frequency;
                z *= _frequency;
                float dfc = sqrt(x * x + z * z);
                float dfss = dfc - floor(dfc);
                float dfls = 1.0 - dfss;
                float nd = min(dfss, dfls);

                return 1.0 - (nd * 4.0);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return ComputeColor(i.worldPos.x,i.worldPos.y, i.worldPos.z);
            }
            ENDCG
        }
    }
}
