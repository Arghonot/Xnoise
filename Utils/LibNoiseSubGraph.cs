using LibNoise;

namespace NoiseGraph
{
    [CreateNodeMenu("NoiseGraph/Graph/LibNoiseSubGraph")]
    public class LibNoiseSubGraph : Graph.SubGraphNode<SerializableModuleBase>
    {
        public override object Run()
        {
            if (SubGraph == null)
            {
                return null;
            }

            //SubGraph.storage = ((LibnoiseGraph)graph).storage;

            return ((RootModuleBase)((LibnoiseGraph)SubGraph).root).Run();
        }
    }
}