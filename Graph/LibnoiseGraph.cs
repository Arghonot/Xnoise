using Graph;
using System.Linq;
using UnityEngine;

namespace NoiseGraph
{
    [CreateAssetMenu]
    public class LibnoiseGraph : DefaultGraph
    {
        public SerializableModuleBase GetGenerator(GenericDicionnary newgd = null)
        {
            if (newgd != null)
            {
                this.gd = newgd;
            }

            return (SerializableModuleBase)root.GetValue(root.Ports.First());
        }
    }
}