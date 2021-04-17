namespace NoiseGraph
{
    [CreateNodeMenu("NoiseGraph/Graph/LibNoiseSubGraph")]
    public class LibNoiseSubGraph : Graph.SubGraphNode
    {
        public override object Run()
        {
            if (SubGraph == null)
            {
                return new SerializableModuleBase(0);
            }

            SubGraph.storage = ((LibnoiseGraph)graph).storage;

            return ((RootModuleBase)((LibnoiseGraph)SubGraph).root).Run();
        }
    }
}