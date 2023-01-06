Shader "Xnoise/Generators/SphericalCylinder"
{
    Properties
    {
        _Frequency("Frequency", Float) = 1
        _Radius("radius",Float) = 1.0
        _OffsetPosition("Offset", Vector) = (0,0,0,0)
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
            #include "../../noiseSimplex.cginc"
            #include "../../LibnoiseUtils.cginc"

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
            float _Frequency, _Lacunarity, _Octaves, _Persistence;
            int _Radius;
            float4 _OffsetPosition;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                return o;
            }

            float ComputeCylinder(float x, float y, float z)
            {
                x *= _Frequency;
                z *= _Frequency;
                float dfc = sqrt(x * x + z * z);
                float dfss = dfc - floor(dfc);
                float dfls = /*1.0 - */dfss;
                float nd = min(dfss, dfls);

                return 1.0 - (nd * 4.0);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                float3 pos = GetCartesianFromUV(i.uv.x, i.uv.y, _Radius);

                float color = ComputeCylinder(
                    pos.x + _OffsetPosition.x,
                    pos.y + _OffsetPosition.y,
                    pos.z + _OffsetPosition.z) / 2 + 0.5f;

                return float4(color, color, color, 1);
            }
            ENDCG
        }
    }
}
