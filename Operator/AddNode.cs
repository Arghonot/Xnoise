﻿using UnityEngine;
using LibNoise.Operator;
using LibNoise;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Combiner/Add")]
    public class AddNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase SourceA;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase SourceB;

        public override object Run()
        {
            Add add = new Add(
                GetInputValue<SerializableModuleBase>("SourceA", this.SourceA),
                GetInputValue<SerializableModuleBase>("SourceB", this.SourceB));

            return add;
        }
    }
}