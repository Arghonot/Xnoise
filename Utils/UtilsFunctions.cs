using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Xnoise
{
    public static class UtilsFunctions
    {
        public static int TextureSize = 100;

        public static Texture2D GetCurveAsTexture(AnimationCurve curve)
        {
            Texture2D curveTexture = new Texture2D(TextureSize, 1);
            float currentValue = 0f;

            for (int i = 0; i < TextureSize; i++)
            {
                currentValue = curve.Evaluate(Mathf.Lerp(-1f, 1f, (float)i / (float)TextureSize)) + 1f / 2f;
                curveTexture.SetPixel(i, 0, new Color(currentValue, currentValue, currentValue));
            }

            curveTexture.Apply();

            return curveTexture;
        }

        public static Texture2D GetDoubleArrayAsTexture(double[] array)
        {
            Texture2D curveTexture = new Texture2D(TextureSize, 1);
            float currentValue = 0f;
            AnimationCurve curve = new AnimationCurve();

            for (int i = 0; i < TextureSize; i++)
            {
                //currentValue = curve.Evaluate(Mathf.Lerp(-1f, 1f, (float)i / (float)TextureSize)) + 1f / 2f;
                curveTexture.SetPixel(i, 0, new Color(currentValue, currentValue, currentValue));
            }

            curveTexture.Apply();

            return curveTexture;
        }
    }
}