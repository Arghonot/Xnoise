Shader "Xnoise/Selectors/Blend"
{
    Properties
    {
        _TextureA("TextureA", 2D) = "white" {}
        _TextureB("TextureB", 2D) = "white" {}
        _TextureC("TextureC", 2D) = "white" {}
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

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float2 uv3 : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };

            float _fallOff;
            sampler2D _TextureA;
            float4 _TextureA_ST;
            sampler2D _TextureB;
            float4 _TextureB_ST;
            sampler2D _TextureC;
            float4 _TextureC_ST;

            v2f vert(appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _TextureA);
                o.uv2 = TRANSFORM_TEX(v.uv2, _TextureB);
                o.uv3 = TRANSFORM_TEX(v.uv3, _TextureC);

                return o;
            }


            float InterpolateLinear(float a, float b, float position)
            {
                return ((1.0 - position) * a) + (position * b);
            }

            float MapCubicSCurve(float value)
            {
                return (value * value * (3.0 - 2.0 * value));
            }

            float GetFallof(float value)
            {
                float bs = 1 - -1;
                _raw = value;

                if (value > bs / 2)
                {
                    _fallOff = bs / 2;
                }
                else
                {
                    _fallOff = value;
                }

                return _fallOff;
            }

            float GetValue(float2 uv1, float2 uv2, float2 uv3)
            {
                float cv = tex2D(_TextureC, i.uv3);
                float _fallOff = 
                if (_fallOff > 0.0)
                {
                    double a;
                    if (cv < (_min - _fallOff))
                    {
                        return tex2D(_TextureA, i.uv1);
                    }
                    if (cv < (_min + _fallOff))
                    {
                        var lc = (_min - _fallOff);
                        var uc = (_min + _fallOff);
                        a = MapCubicSCurve((cv - lc) / (uc - lc));
                        return InterpolateLinear(
                            tex2D(_TextureA, i.uv1),
                            tex2D(_TextureB, i.uv2),
                            a);
                    }
                    if (cv < (_max - _fallOff))
                    {
                        return tex2D(_TextureB, i.uv2);
                    }
                    if (cv < (_max + _fallOff))
                    {
                        var lc = (_max - _fallOff);
                        var uc = (_max + _fallOff);
                        a = MapCubicSCurve((cv - lc) / (uc - lc));
                        return InterpolateLinear(
                            tex2D(_TextureB, i.uv2),
                            tex2D(_TextureA, i.uv1), a);
                    }
                    return tex2D(_TextureA, i.uv1);
                }
                if (cv < _min || cv > _max)
                {
                    return tex2D(_TextureA, i.uv1);
                }
                return tex2D(_Textureb, i.uv2);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return InterpolateLinear(
                    tex2D(_TextureA, i.uv1),
                    tex2D(_TextureB, i.uv2),
                    tex2D(_TextureC, i.uv3));
            }
            ENDCG
        }
    }
}
