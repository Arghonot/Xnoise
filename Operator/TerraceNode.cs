using LibNoise.Operator;
using LibNoise;
using UnityEngine;
using System.Collections.Generic;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Modifier/Terrace")]
    public class TerraceNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Input;

        [Input(dynamicPortList = true)]
        public List<double> Terrace = new List<double>();

        public override object Run()
        {
            if (Terrace.Count == 0)
            {
                return GetInputValue<SerializableModuleBase>("Input", this.Input);
            }

            Terrace terr = new Terrace(
                GetInputValue<SerializableModuleBase>("Input", this.Input));

            for (int i = 0; i < Terrace.Count; i++)
            {
                terr.Add
                    (GetInputValue<List<double>>(
                        "Terrace " + i.ToString(),
                        this.Terrace)[i]);
            }

            return terr;
        }

        public Material _materialGPU;
        private Shader _sphericalGPUShader = Shader.Find("Xnoise/Modifiers/Terrace");
        public Texture2D tex;

        [ContextMenu("DebugeTerrace")]
        public  void GetSphericalValueGPU()
        {
            _materialGPU = new Material(Shader.Find("Xnoise/Modifiers/Terrace"));
            RenderTexture src = GetInputValue<SerializableModuleBase>("Input", this.Input).
                GetSphericalValueGPU(Vector2.one * 512);

            _materialGPU.SetTexture("_MainTex", src);
            _materialGPU.SetTexture("_Terrace",
                UtilsFunctions.GetTerracePointListAsTexture(Terrace));


            RenderTexture rdB = RdbCollection.GetFromStack(Vector2.one * 512);

            //RenderTexture rdB = new RenderTexture((int)size.x, (int)size.y, 16);

            RenderTexture.active = rdB;
            Graphics.Blit(Texture2D.whiteTexture, rdB, _materialGPU);

            RdbCollection.AddToStack(rdB);
            tex = new Texture2D(rdB.width, rdB.height);
            tex.ReadPixels(new Rect(0, 0, rdB.width, rdB.height), 0, 0);
            tex.Apply();

            //UnityEngine.Debug.Log(size);
            //return GetImage(_materialGPU, size);
        }

        [ContextMenu("GeneratePointTexture")]
        public void GeneratePointTexture()
        {
            var tex = UtilsFunctions.GetTerracePointListAsTexture(Terrace);
            UtilsFunctions.SaveImage(tex, "TerraceTest");
        }
    }
}