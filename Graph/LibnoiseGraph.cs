using Graph;
using System.Linq;
using UnityEngine;

namespace NoiseGraph
{
    [CreateAssetMenu(fileName = "libnoiseGraph", menuName = "Graphs/libnoiseGraph", order = 2)]
    public class LibnoiseGraph : DefaultGraph
    {
        public SerializableModuleBase GetGenerator(GraphVariableStorage newstorage = null)
        {
            if (newstorage != null)
            {
                this.storage = newstorage;
            }

            return (SerializableModuleBase)root.GetValue(root.Ports.First());
        }
    }
}