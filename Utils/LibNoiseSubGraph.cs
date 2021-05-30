using LibNoise;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Graph/LibNoiseSubGraph")]
    public class LibNoiseSubGraph : Graph.SubGraphNode<SerializableModuleBase>
    {
        public override object Run()
        {
            if (SubGraph == null)
            {
                return new SerializableModuleBase(0);
            }

            //SubGraph.storage = ((LibnoiseGraph)graph).storage;

            return ((RootModuleBase)((XnoiseGraph)SubGraph).root).Run();
        }
    }
}