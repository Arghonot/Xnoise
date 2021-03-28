Shader "Xnoise/Generators/Checker"
{
    Properties
    {
        _PositionX("PositionX",Float) = 0.0
        _PositionY("PositionY",Float) = 0.0
        _PositionZ("PositionZ",Float) = 0.0
        _Size("Size",Float) = 0.0
    }
    SubShader
    {
        // No culling or depth
        //Cull Off ZWrite Off ZTest Always

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

            float _Size;
            float _PositionX;
            float _PositionY;
            float _PositionZ;

            v2f vert (appdata v)
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

            float4 GetSphericalCoordinatesRad(float Ln, float Lat)
            {
                Ln -= 180;
                Lat -= 90;
                Ln *= 0.017453292519943295;
                Lat *= 0.017453292519943295;

                return float4(
                    cos(Lat) * sin(Ln),
                    cos(Lat) * cos(Ln),
                    sin(Lat),
                    0);
            }

            fixed4 frag(v2f i) : SV_Target
            {

                float4 coords = GetSphericalCoordinatesRad(i.uv.x * 360, i.uv.y * 180) * _Size;

                float val = ComputeChecker(coords.x, coords.y, coords.z);

                return float4(val, val, val, 1);
                //return ComputeChecker(i.uv.x + _PositionX, _PositionY, i.uv.y + _PositionZ);
            }
            ENDCG
        }
    }
}
