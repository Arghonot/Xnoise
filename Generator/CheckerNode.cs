using LibNoise;
using LibNoise.Generator;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Generator/Checker")]
    public class CheckerNode : LibnoiseNode
    {
        [Output(ShowBackingValue.Always, ConnectionType.Multiple, TypeConstraint.Strict)]
        public LibNoise.SerializableModuleBase GeneratorOutput;

        public override object Run()
        {
            return new Checker();
        }
    }
}