Shader "Unlit/Add"
{
    Properties
    {
        _TextureA("TextureA", 2D) = "white" {}
        _TextureB("TextureB", 2D) = "white" {}
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
            };

            sampler2D _TextureA;
            float4 _TextureA_ST;
            sampler2D _TextureB;
            float4 _TextureB_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _TextureA);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                return (tex2D(_TextureA, i.uv) + tex2D(_TextureB, i.uv)) / 2.0;
            }
            ENDCG
        }
    }
}
