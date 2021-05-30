﻿Shader "Xnoise/Generators/SphericalChecker"
{
    Properties
    {
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

            float ComputeChecker(float x, float y, float z)
            {
                int ix = (int)(floor(x));
                int iy = (int)(floor(y));
                int iz = (int)(floor(z));

                return (ix & 1 ^ iy & 1 ^ iz & 1) != 0 ? -1.0 : 1.0;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 pos = GetCartesianFromUV(i.uv.x, i.uv.y, _Radius);

                float color = ComputeChecker(
                    pos.x + _OffsetPosition.x,
                    pos.y + _OffsetPosition.y,
                    pos.z + _OffsetPosition.z) / 2 + 0.5f;

                return float4(color, color, color, 1);
            }
            ENDCG
        }
    }
}
