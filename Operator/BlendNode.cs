using LibNoise.Operator;
using UnityEngine;
using LibNoise;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Selector/Blend")]
    public class BlendNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase SourceA;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase SourceB;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Controller;

        public Texture2D tex;
        public int width;
        public int height;

        [ContextMenu("RunGPUTest")]
        public void RunGPUTest()
        {
            var blend = new Blend(
                GetInputValue<SerializableModuleBase>("SourceA", this.SourceA),
                GetInputValue<SerializableModuleBase>("SourceB", this.SourceB),
                GetInputValue<SerializableModuleBase>("Controller", this.Controller));

            var rdB = blend.GetSphericalValueGPU(new Vector2(width, height));

            tex = new Texture2D(width, height);

            tex.ReadPixels(new Rect(0, 0, rdB.width, rdB.height), 0, 0);

            tex.Apply();
        }

        public override object Run()
        {
            return new Blend(
                GetInputValue<SerializableModuleBase>("SourceA", this.SourceA),
                GetInputValue<SerializableModuleBase>("SourceB", this.SourceB),
                GetInputValue<SerializableModuleBase>("Controller", this.Controller));
        }
    }
}