using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static XNode.Node;

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

            SubGraph.gd = ((LibnoiseGraph)graph).gd;
            return ((RootModuleBase)((LibnoiseGraph)SubGraph).root).Run();
        }
    }
}