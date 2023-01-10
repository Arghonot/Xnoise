Shader "Xnoise/Modifiers/Terrace"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Terrace("Curve", 2D) = "white" {}
        _Radius("Radius", Float) = 0.0
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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            float _Radius;

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Terrace;
            float4 _Terrace_ST;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _Terrace);

                return o;
            }

            float GetAmountOfPoints(v2f i)
            {
                return (tex2D(_Terrace, float2(0, 0)).x * 255) - 1;
            }

            float getValueFrom(v2f i, float pos)
            {
                return tex2D(_MainTex, float2(pos, 0));
            }

            float getValueFromPoint(v2f i, float pos)
            {
                return tex2D(_Terrace, float2(pos, 0));
            }

            float2 getClosestPoints(v2f i)
            {
                int amountOfPoints = GetAmountOfPoints(i);
                float currentValue = tex2D(_MainTex, i.uv);
                float step = 1 / amountOfPoints;
                // we want to cap the maximum iteration to 255 so the for
                // loop can be unrolled
                // TODO find a better way to do this
                int iterationCount = min(amountOfPoints, 255);

                for (int index = 0; index < iterationCount; index++)
                {
                    if (getValueFrom(i, (step * index) + step) > currentValue)
                    {
                        return float2(index - 1, index);
                    }
                }

                return float2(currentValue, currentValue);
                return float2(amountOfPoints, amountOfPoints);
            }

            float InterpolateLinear(float a, float b, float position)
            {
                return ((1 - position) * a) + (position * b);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float res = tex2D(_Terrace, float2(tex2D(_MainTex, i.uv).x, 0));// 

                //// sample the texture
                ////fixed4 col = tex2D(_MainTex, i.uv);
                //int amount = GetAmountOfPoints(i);
                //float2 indexes = getClosestPoints(i);
                //float sourceModuleValue = tex2D(_MainTex, i.uv);
                //float value0 = 0;
                //float value1 = 0;
                //float alpha = 0;
                //float res = 0;

                ////return amount;// / 125;
                //return float4(indexes.x, indexes.x, indexes.x, 1);
                //indexes = float2(
                //    clamp(indexes.x, 0, amount),
                //    clamp(indexes.y, 0, amount));

                ////if (indexes.x == indexes.y)
                ////{
                ////    res = getValueFrom(i, indexes.x);

                ////    return float4(0, res, 0, 1);
                ////}

                ////return float4(0, tex2D(_Terrace, float2(_Radius, 0)).x, 0, 1);

                //value0 = getValueFromPoint(i, indexes.x);
                //value1 = getValueFromPoint(i, indexes.y);

                //alpha = (sourceModuleValue - value0) / (value1 - value0);
                //alpha *= alpha;

                ////res = ((1.0 - alpha) * value0) + (alpha * value1);
                //res = InterpolateLinear(value0, value1, alpha) + 1;
                ////res *= 255;
                return float4(res, res, res, 1);
            }
            ENDCG
        }
    }
}
