﻿using LibNoise.Operator;
using UnityEngine;

namespace NoiseGraph
{
    [CreateNodeMenu("NoiseGraph/Selector/Select")]
    public class SelectNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase SourceA;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase SourceB;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Controller;

        public override object Run()
        {
            return new Select(
                GetInputValue<SerializableModuleBase>("SourceA", this.SourceA),
                GetInputValue<SerializableModuleBase>("SourceB", this.SourceB),
                GetInputValue<SerializableModuleBase>("Controller", this.Controller));
        }
    }
}