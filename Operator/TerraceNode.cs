using LibNoise.Operator;
using LibNoise;
using UnityEngine;
using System.Collections.Generic;
using System.Linq;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Modifier/Terrace")]
    public class TerraceNode : LibnoiseNode
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase InputModule;
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public AnimationCurve curve;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public List<double> TerraceDoubles = new List<double>();
        public int mode;

        public override object Run()
        {
            if (TerraceDoubles.Count == 0)
            {
                return GetInputValue<SerializableModuleBase>("Input", this.InputModule);
            }

            Terrace terr = new Terrace(
                GetInputValue<SerializableModuleBase>("Input", this.InputModule));

            if (mode == 1)
            {
                TerraceDoubles = new List<double>();
                for (int i = 0; i < curve.length; i++)
                {
                    TerraceDoubles.Add(curve.keys[i].value);
                }
            }

            for (int i = 0; i < TerraceDoubles.Count; i++)
            {
                terr.Add
                    (GetInputValue<List<double>>(
                        "Terrace " + i.ToString(),
                        this.TerraceDoubles)[i]);
            }

            return terr;
        }

        public Material _materialGPU;
        private Shader _sphericalGPUShader;
        public Texture2D tex;
        public Texture2D curvetex;

        private new void OnEnable()
        {
            base.OnEnable();
            _sphericalGPUShader = Shader.Find("Xnoise/Modifiers/Terrace");
        }

        private void RebuildInputList()
        {
            for (int i = 0; i < TerraceDoubles.Count; i++)
            {
                Debug.Log(i + " " + TerraceDoubles.Count);
                TerraceDoubles[i] = GetInputValue<double>((i + 1).ToString());
            }
        }

        [ContextMenu("DebugeTerrace")]
        public void GetSphericalValueGPU()
        {
            RebuildInputList();
            _materialGPU = new Material(Shader.Find("Xnoise/Modifiers/Terrace"));
            RenderTexture src = GetInputValue<SerializableModuleBase>("Input", this.InputModule).
                GetSphericalValueGPU(Vector2.one * 512);
            curvetex = UtilsFunctions.GetTerracePointListAsTexture(TerraceDoubles);
            _materialGPU.SetTexture("_MainTex", src);
            _materialGPU.SetTexture("_Terrace",
                curvetex);


            RenderTexture rdB = RdbCollection.GetFromStack(Vector2.one * 512);

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
        public Texture2D GeneratePointTexture()
        {
            if (mode == 0)
            {
                RebuildInputList();
                return UtilsFunctions.GetTerracePointListAsTexture(TerraceDoubles);
                //UtilsFunctions.SaveImage(tex, "TerraceTest");
            }
            else
            {
                return UtilsFunctions.GetCurveAsTexture(GetPort("Terrace").GetInputValue<AnimationCurve>());
                //UtilsFunctions.SaveImage(tex, "TerraceTestFromCurve");
            }
        }
    }
}