Shader "Xnoise/Generators/PerlinV2"
{
    Properties
    {
            _PositionX("positionX",Float) = 0.0
            _PositionY("positionY",Float) = 0.0
            _PositionZ("positionZ",Float) = 0.0
            _Permutations("Permutations", 2D) = "white" {}
            _frequency("Frequency",Float) = 0.0
            _lacunarity("Lacunarity",Float) = 0.0
            _octaves("Octaves",Int) = 6
            _persistence("Persistence",Float) = 0.0
            _Seed("Seed",Int) = 42
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            // Upgrade NOTE: excluded shader from DX11, OpenGL ES 2.0 because it uses unsized arrays
            #pragma exclude_renderers d3d11 gles
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float[] _Perms;
            float _persistence, _lacunarity, _frequency;
            int _octaves, _Seed;

            float _PositionX;
            float _PositionY;
            float _PositionZ;

            sampler2D _Permutations;
            float4 _Permutations_ST;

            // noise consts
            int GeneratorNoiseX = 1619;
            int GeneratorNoiseY = 31337;
            int GeneratorNoiseZ = 6971;
            int GeneratorSeed = 1013;
            int GeneratorShift = 8;

            float MakeInt32Range(float value)
            {
                if (value >= 1073741824.0)
                {
                    return 0;
                    return (2.0 * (value - (value / 1073741824.0))) - 1073741824.0;
                }
                if (value <= -1073741824.0)
                {
                    return 0;
                    return (2.0 * (value - (value / 1073741824.0))) + 1073741824.0;
                }
                return value;
            }

            float MapQuinticSCurve(float value)
            {
                float a3 = value * value * value;
                float a4 = a3 * value;
                float a5 = a4 * value;

                return (6.0 * a5) - (15.0 * a4) + (10.0 * a3);
            }

            float InterpolateLinear(float a, float b, float position)
            {
                return ((1.0 - position) * a) + (position * b);
            }

            float GradientNoise3D(float fx, float fy, float fz, int ix, int iy, int iz, float seed)
            {
                int i = ((int)(GeneratorNoiseX * ix + GeneratorNoiseY * iy + GeneratorNoiseZ * iz +
                    GeneratorSeed * seed)) & 0xffffffff;
                i ^= (i >> GeneratorShift);
                i &= 0xff;

                int x = (i << 2);
                int y = (i << 2) + 1;
                int z = (i << 2) + 2;
                float2 uvposition = float2(((float)x / 1024.0), ((float)x / 1024.0));
                float xvg =
                    (tex2D(_Permutations, float4(uvposition, 0, 0)) * 2.0) - 1.0;
                uvposition = float2(((float)y / 1024.0), (((float)y) / 1024.0));
                float yvg =
                    (tex2D(_Permutations, float4(uvposition, 0, 0)) * 2.0) - 1.0;
                uvposition = float2(((float)z / 1024.0), ((float)z / 1024.0));
                float zvg =
                    (tex2D(_Permutations, float4(uvposition, 0, 0)) * 2.0) - 1.0;

                float xvp = (fx - (float)ix);
                float yvp = (fy - (float)iy);
                float zvp = (fz - (float)iz);

                return ((xvg * xvp) + (yvg * yvp) + (zvg * zvp)) * 2.12;
            }

            float GradientCoherentNoise3D(float x, float y, float z, int seed)
            {
                int x0 = x > 0.0 ? x : x - 1;
                int x1 = x0 + 1;
                int y0 = y > 0.0 ? y : y - 1;
                int y1 = y0 + 1;
                int z0 = z > 0.0 ? z : z - 1;
                int z1 = z0 + 1.0;

                // Quality
                float xs = 0, ys = 0, zs = 0;
                xs = MapQuinticSCurve(x - x0);
                ys = MapQuinticSCurve(y - y0);
                zs = MapQuinticSCurve(z - z0);
                // end quality

                float n0 = GradientNoise3D(x, y, z, x0, y0, z0, seed);

                float n1 = GradientNoise3D(x, y, z, x1, y0, z0, seed);
                float ix0 = InterpolateLinear(n0, n1, xs);

                n0 = GradientNoise3D(x, y, z, x0, y1, z0, seed);
                n1 = GradientNoise3D(x, y, z, x1, y1, z0, seed);

                float ix1 = InterpolateLinear(n0, n1, xs);
                float iy0 = InterpolateLinear(ix0, ix1, ys);
                n0 = GradientNoise3D(x, y, z, x0, y0, z1, seed);
                n1 = GradientNoise3D(x, y, z, x1, y0, z1, seed);
                ix0 = InterpolateLinear(n0, n1, xs);
                n0 = GradientNoise3D(x, y, z, x0, y1, z1, seed);
                n1 = GradientNoise3D(x, y, z, x1, y1, z1, seed);
                ix1 = InterpolateLinear(n0, n1, xs);
                float iy1 = InterpolateLinear(ix0, ix1, ys);

                return InterpolateLinear(iy0, iy1, zs);
            }

            float Perlin(float _x, float _y, float _z)
            {
                float value = 0.0;
                float signal = 0.0;
                float curPersistence = 1.0;
                float nx, ny, nz;
                float seed = 42;
                float x, y, z;

                x = _x;
                y = _y;
                z = _z;

                x *= _frequency;
                y *= _frequency;
                z *= _frequency;

                for (int curOctave = 0; curOctave < _octaves; curOctave++)
                {
                    nx = MakeInt32Range(x);
                    ny = MakeInt32Range(y);
                    nz = MakeInt32Range(z);

                    // Get the coherent-noise value from the input value and add it to the
                    // final result.
                    seed = ((_Seed + curOctave) & 0xffffffff);

                    signal = GradientCoherentNoise3D(nx, ny, nz, seed);

                    value += signal * curPersistence;

                    // Prepare the next octave.
                    x *= _lacunarity;
                    y *= _lacunarity;
                    z *= _lacunarity;
                    curPersistence *= _persistence;
                }

                return value;
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
                // convert uv to rad angles
                float Ln = ((i.uv.x * 2) - 1) * 1.5707963268 * 2;
                float Lat = ((i.uv.y * 2) - 1) * 1.5707963268;

                // get the 3D coordinates according to my 
                float4  Coordinates = GetSphericalCoordinatesRad(Ln, Lat);

                return Perlin(
                    Coordinates.x + _PositionX,
                    Coordinates.y + _PositionY,
                    Coordinates.z + _PositionZ);
            }
            ENDCG
        }
    }
}
