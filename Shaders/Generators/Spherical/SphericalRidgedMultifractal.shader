Shader "Xnoise/SphericalRidgedMultifractal"
{
    Properties
    {
        _Frequency("Frequency", Float) = 1
        _Lacunarity("lacunarity", Float) = 1
        _Persistence("Persistence", Float) = 1
        _Octaves("Octaves", Float) = 1
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

            float GetRidgedMultifractal(float x, float y, float z)
            {
                float value = 0.0;
                float signal = 0.0;
                float weight = 1.0;
                float offset = 1.0;
                float gain = 2.0;
                float _weights[12];
                float nx, ny, nz;
                float f = 1.0;

                for (int i = 0; i < _Octaves; i++)
                {
                    _weights[i] = pow(f, -1);
                    f *= _Lacunarity;
                }

                x *= _Frequency;
                y *= _Frequency;
                z *= _Frequency;

                for (int curOctave = 0; curOctave < _Octaves; curOctave++) {

                    // Make sure that these floating-point values have the same range as a 32-
                    // bit integer so that we can pass them to the coherent-noise functions.
                    nx = x;
                    ny = y;
                    nz = z;

                    // Get the coherent-noise value from the input value and add it to the
                    // final result.
                    //seed = (m_seed + curOctave) & 0xffffffff;
                    //signal = GradientCoherentNoise3D(nx, ny, nz, seed, 1);
                    signal = snoise(float3(nx, ny, nz));
                    signal = abs(signal);
                    signal = offset - signal;
                    signal *= signal;
                    signal *= weight;

                    weight = signal * 2.0;
                    weight = clamp(weight, 0, 1);
                    value += (signal * _weights[i]);
                    value = signal;

                    x *= _Lacunarity;
                    y *= _Lacunarity;
                    z *= _Lacunarity;
                }

                return (value * 1.25) - 1.0;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // sample the texture
                float3 val = GetSphericalCoordinatesRad(i.uv.x, i.uv.y, _Radius);

                return GetRidgedMultifractal(
                    val.x + _OffsetPosition.x,
                    val.y + _OffsetPosition.y,
                    val.z + _OffsetPosition.z) / 2 + 0.5f;
            }
            ENDCG
        }
    }
}
