Shader "Xnoise/Modifiers/Curve"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Curve("Curve", 2D) = "white" {}
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
                float2 uv1 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Curve;
            float4 _Curve_ST;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _Curve);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_Curve, float2(tex2D(_MainTex, i.uv).x, 0));
            }
            ENDCG
        }
    }
}
