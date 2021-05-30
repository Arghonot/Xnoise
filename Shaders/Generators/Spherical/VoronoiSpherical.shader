//2D Gradient Perlin Noise
//https://github.com/przemyslawzaworski/Unity3D-CG-programming

Shader "Xnoise/Generators/SphericalVoronoi"
{
    Properties
    {
            _Permutations("Permutations", 2D) = "white" {}
            _Frequency("Frequency",Float) = 0.0
            _Displacement("Displacement",Float) = 0.0
            _Distance("_Distance",Int) = 0
            _Radius("Radius",Float) = 0.0
            _Seed("Seed",Int) = 42
    }
    Subshader
    {
        Tags { "RenderType" = "Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vertex_shader
            #pragma fragment pixel_shader
            #pragma target 3.0

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            float _Frequency, _Displacement, _Radius;
            int _Seed, _Distance;
            sampler2D    _Permutations;
            SamplerState   sampler_Permutations;

            int GeneratorNoiseX = 1619;
            int GeneratorNoiseY = 31337;
            int GeneratorNoiseZ = 6971;
            int GeneratorSeed = 1013;
            int GeneratorShift = 8;
            #include "UnityCG.cginc"
            #include "../../LibnoiseUtils.cginc"
            float4 _Permutations_ST;

            v2f vertex_shader(appdata v)
            {
                v2f o;
                o.uv = TRANSFORM_TEX(v.uv, _Permutations);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            float ValueNoise3DInt(int x, int y, int z, int seed)
            {
                int GeneratorNoiseX = 1619;
                int GeneratorNoiseY = 31337;
                int GeneratorNoiseZ = 6971;
                int GeneratorSeed = 1013;

                int n = (GeneratorNoiseX * x + GeneratorNoiseY * y + GeneratorNoiseZ * z +
                    GeneratorSeed * seed) & 0x7fffffff;
                n = (n >> 13) ^ n;
                return (n * (n * n * 60493 + 19990303) + 1376312589) & 0x7fffffff;
            }

            float ValueNoise3D(int x, int y, int z, int seed)
            {
                return 1.0 - (ValueNoise3DInt(x, y, z, seed) / 1073741824.0);
            }

            float VoronoiGetValue(float x, float y, float z)
            {
                x *= _Frequency;
                y *= _Frequency;
                z *= _Frequency;

                int xInt = (x > 0.0 ? (int)x : (int)x - 1);
                int yInt = (y > 0.0 ? (int)y : (int)y - 1);
                int zInt = (z > 0.0 ? (int)z : (int)z - 1);

                float minDist = 2147483647.0;
                float xCandidate = 0;
                float yCandidate = 0;
                float zCandidate = 0;

                // Inside each unit cube, there is a seed point at a random position.  Go
                // through each of the nearby cubes until we find a cube with a seed point
                // that is closest to the specified position.
                for (int zCur = zInt - 2; zCur <= zInt + 2; zCur++) {
                    for (int yCur = yInt - 2; yCur <= yInt + 2; yCur++) {
                        for (int xCur = xInt - 2; xCur <= xInt + 2; xCur++) {

                            // Calculate the position and distance to the seed point inside of
                            // this unit cube.
                            float xPos = xCur + ValueNoise3D(xCur, yCur, zCur, _Seed);
                            float yPos = yCur + ValueNoise3D(xCur, yCur, zCur, _Seed + 1);
                            float zPos = zCur + ValueNoise3D(xCur, yCur, zCur, _Seed + 2);
                            float xDist = xPos - x;
                            float yDist = yPos - y;
                            float zDist = zPos - z;
                            float dist = xDist * xDist + yDist * yDist + zDist * zDist;

                            if (dist < minDist) {
                                // This seed point is closer to any others found so far, so record
                                // this seed point.
                                minDist = dist;
                                xCandidate = xPos;
                                yCandidate = yPos;
                                zCandidate = zPos;
                            }
                        }
                    }
                }

                float value;
                if (_Distance > 0)
                {
                    // Determine the distance to the nearest seed point.
                    float xDist = xCandidate - x;
                    float yDist = yCandidate - y;
                    float zDist = zCandidate - z;
                    value = (sqrt(xDist * xDist + yDist * yDist + zDist * zDist)
                        ) * 1.73205080757 - 1.0;
                }
                else 
                {
                    value = 0.0;
                }

                // Return the calculated distance with the displacement value applied.
                return value + (_Displacement * (float)ValueNoise3D(
                    (int)(floor(xCandidate)),
                    (int)(floor(yCandidate)),
                    (int)(floor(zCandidate)),
                    _Seed));
            }

            float4 pixel_shader(v2f ps) : SV_TARGET
            {
                float2 uv = ps.uv;
                float3 pos = GetCartesianFromUV(ps.uv.x, ps.uv.y, _Radius);

                float color = (VoronoiGetValue(pos.x, pos.z, pos.y)) / 2 + 0.5f;

                return float4(color, color, color, 1);
            }

            ENDCG

        }
    }
}