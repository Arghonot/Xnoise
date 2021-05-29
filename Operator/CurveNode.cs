﻿using LibNoise.Operator;
using LibNoise;
using UnityEngine;

namespace NoiseGraph
{
    [System.Serializable]
    [CreateNodeMenu("NoiseGraph/Modifier/Curve")]
    public class CurveNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Input;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public AnimationCurve InputCurve;

        public override object Run()
        {
            Curve curve = new Curve(
                GetInputValue<SerializableModuleBase>("Input", this.Input));

            curve.SetCurve(InputCurve);

            //foreach (var point in InputCurve.keys)
            //{
            //    curve.Add(point.time, point.value);
            //}

            return curve;
        }
    }
}