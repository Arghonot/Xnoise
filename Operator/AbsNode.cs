﻿using LibNoise.Operator;
using UnityEngine;
using LibNoise;

namespace NoiseGraph
{
    [CreateNodeMenu("NoiseGraph/Modifier/Abs")]
    public class AbsNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Controller;

        public override object Run()
        {
            return new Abs(
                GetInputValue<SerializableModuleBase>(
                    "Controller",
                    this.Controller));
        }
    }
}