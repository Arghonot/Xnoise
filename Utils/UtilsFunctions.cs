using System;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

namespace Xnoise
{
    public static class UtilsFunctions
    {
        public static int TextureSize = 1000;

        public static Texture2D GetCurveAsTexture(AnimationCurve curve)
        {
            Texture2D curveTexture = new Texture2D(TextureSize, 1);
            float currentValue = 0f;

            for (int i = 0; i < TextureSize; i++)
            {
                currentValue = Mathf.Clamp(
                    curve.Evaluate(
                        Mathf.Lerp(-1f, 1f, (float)i / (float)TextureSize)),
                        -1f,
                        1f) + 1f / 2f;
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

        public static Texture2D GetGradientAsTexture(Gradient gradient)
        {
            Texture2D gradientTexture = new Texture2D(TextureSize, 1);

            for (int i = 0; i < TextureSize; i++)
            {
                gradientTexture.SetPixel(i, 0, gradient.Evaluate((float)i / (float)TextureSize));
            }

            gradientTexture.Apply();

            return gradientTexture;
        }

        public static void SaveImage(Texture2D tex, string name = "")
        {
            if (name == "")
            {
                name = Guid.NewGuid().ToString();
            }

            File.WriteAllBytes(Application.dataPath + "/" + name + ".png", tex.EncodeToPNG());
        }
    }
}