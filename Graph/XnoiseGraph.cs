using Graph;
using System.Linq;
using UnityEngine;
using LibNoise;

namespace Xnoise
{
    [CreateAssetMenu(fileName = "XnoiseGraph", menuName = "Graphs/XnoiseGraph", order = 2)]
    public class XnoiseGraph : DefaultGraph, ISerializationCallbackReceiver
    {
        public SerializableModuleBase GetGenerator(GraphVariableStorage newstorage = null)
        {
            if (newstorage != null)
            {
                this.originalStorage = newstorage;
            }

            return (SerializableModuleBase)root.GetValue(root.Ports.First());
        }

        public void OnAfterDeserialize()
        {
            // nothing to do there
        }

        public void OnBeforeSerialize()
        {
            if (blackboard != null && originalStorage != null)
            {
                blackboard.storage = originalStorage;
            }
        }
    }
}