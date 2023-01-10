Shader "Xnoise/Modifiers/Curve"
{
    Properties
    {
        _MainTex("MainTex", 2D) = "white" {}
        _Curve("Curve", 2D) = "white" {}
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Curve;
            float4 _Curve_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float color = tex2D(_Curve, float2(tex2D(_MainTex, i.uv).x, 0));// +(1 / 2));//max(tex2D(_MainTex, i.uv), tex2D(_Curve, i.uv));
                //color = 0.0;
                return float4(color, color, color, 1);
            }
            ENDCG
        }
    }
}
