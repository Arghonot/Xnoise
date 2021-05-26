Shader "Xnoise/Transformers/Displace"
{
    Properties
    {
        _TextureA("TextureA", 2D) = "white" {}
        _TextureB("TextureB", 2D) = "white" {}
        _TextureC("TextureC", 2D) = "white" {}
        _Control("Control", 2D) = "white" {}
        _FallOff("Falloff", Float) = 1
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
                #include "../LibnoiseUtils.cginc"

                struct appdata
                {
                    float4 vertex : POSITION;
                    float2 uv1 : TEXCOORD0;
                    float2 uv2 : TEXCOORD1;
                    float2 uv3 : TEXCOORD2;
                    float2 uv4 : TEXCOORD3;
        };

                struct v2f
                {
                    float2 uv1 : TEXCOORD0;
                    float2 uv2 : TEXCOORD1;
                    float2 uv3 : TEXCOORD2;
                    float2 uv4 : TEXCOORD4;
                    float4 vertex : SV_POSITION;
                };

                float _FallOff, _raw, _min, _max;
                sampler2D _TextureA;
                float4 _TextureA_ST;
                sampler2D _TextureB;
                float4 _TextureB_ST;
                sampler2D _TextureC;
                float4 _TextureC_ST;
                sampler2D _Control;
                float4 _Control_ST;

                v2f vert(appdata v)
                {
                    v2f o;

                    o.vertex = UnityObjectToClipPos(v.vertex);
                    o.uv1 = TRANSFORM_TEX(v.uv1, _TextureA);
                    o.uv2 = TRANSFORM_TEX(v.uv2, _TextureB);
                    o.uv3 = TRANSFORM_TEX(v.uv3, _TextureC);
                    o.uv4 = TRANSFORM_TEX(v.uv4, _Control);

                    return o;
                }

                float GetDisplace(float2 uv1, float2 uv2, float2 uv3, float x, float y, float z)
                {
                    float2 lnlat = GetSphericalFromCartesian(x, y, z);
                    float2 uv = GetUVFromSpherical(lnlat.x, lnlat.y);
                    float2 FinalLnLat;
                    float2 FinalUV;

                    int dx = x + tex2D(_TextureA, uv);
                    int dy = y + tex2D(_TextureB, uv);
                    int dz = z + tex2D(_TextureC, uv);

                    float3 normalized = normalize(float3(dx, dy, dz));
                    FinalLnLat = GetSphericalFromCartesian(normalized.x, normalized.y, normalized.z);
                    FinalUV = GetUVFromSpherical(FinalLnLat.x, FinalLnLat.y);

                    return tex2D(_TextureA, FinalUV);
                }

                fixed4 frag(v2f i) : SV_Target
                {
                    float3 pos = GetSphericalCoordinatesRad(i.uv1.x, i.uv1.y, 1);

                    float val = GetDisplace(
                            i.uv1,
                            i.uv2,
                            i.uv3,
                            pos.x,
                            pos.y,
                            pos.z);

                    return float4(val, val, val, val);
                }
                ENDCG
            }
        }
}
