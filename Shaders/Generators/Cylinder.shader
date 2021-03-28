﻿Shader "Xnoise/Generators/Cylinder"
{
    Properties
    {
        _Frequency("Frequency",Float) = 0.0
        _PositionX("PositionX",Float) = 0.0
        _PositionY("PositionY",Float) = 0.0
    }
    SubShader
    {
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

            float _Frequency;
            float _PositionX;
            float _PositionY;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float ComputeColor(float x, float y, float z)
            {
                x *= _Frequency;
                z *= _Frequency;
                float dfc = sqrt(x * x + z * z);
                float dfss = dfc - floor(dfc);
                float dfls = 1.0 - dfss;
                float nd = min(dfss, dfls);

                return 1.0 - (nd * 4.0);
            }

            float4 GetSphericalCoordinatesRad(float Lnrad, float Latrad)
            {
                return float4(
                    cos(Latrad) * sin(Lnrad),
                    cos(Latrad) * cos(Lnrad),
                    sin(Latrad),
                    0);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float Ln = ((i.uv.x * 2) - 1) * 1.5708;
                float Lat = ((i.uv.y * 2) - 1) * 1.5708;// 3.14159;
                float4  Coordinates = GetSphericalCoordinatesRad(Ln, Lat);

                float color = ComputeColor(Coordinates.x, Coordinates.y, Coordinates.z);

                return float4(color, color, color, 1);

                return 1;
            }
            ENDCG
        }
    }
}