using LibNoise.Operator;
using LibNoise;
using UnityEngine;

namespace Xnoise
{
    [System.Serializable]
    [CreateNodeMenu("NoiseGraph/Modifier/Curve")]
    public class CurveNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Input;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public AnimationCurve InputCurve;

        public Texture2D animCurve;
        public Texture2D InputTexture;

        public override object Run()
        {
            Curve curve = new Curve(
                GetInputValue<SerializableModuleBase>("Input", this.Input));

            var rt = GetInputValue<SerializableModuleBase>("Input", this.Input).GetSphericalValueGPU(Vector2.one * 512);

            InputTexture = new Texture2D(rt.width, rt.height);
            InputTexture.ReadPixels(new Rect(0, 0, rt.width, rt.height), 0, 0);
            InputTexture.Apply();

            curve.SetCurve(InputCurve);
            animCurve = UtilsFunctions.GetCurveAsTexture(InputCurve);

            UtilsFunctions.SaveImage(animCurve, "curve");

            foreach (var point in InputCurve.keys)
            {
                curve.Add(point.time, point.value);
            }

            return curve;
        }
    }
}