using LibNoise;
using System.Diagnostics;
using System.Collections.Generic;
using UnityEngine;
using XNode;
using System.IO;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Debug/Render")]
    [NodeTint(Graph.ColorProfile.Debug)]
    public class Renderer : Node
    {
        string DataPath = "/";
        [SerializeField] public string PictureName = "Test";
        [SerializeField] public float south = 90.0f;
        [SerializeField] public float north = -90.0f;
        [SerializeField] public float west = -180.0f;
        [SerializeField] public float east = 180.0f;
        [SerializeField] public int size = 512;
        [SerializeField] public Texture2D tex = null;
        [SerializeField] public Gradient grad = new Gradient();

        public float Space = 110;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Input;

        public Rect TexturePosition = new Rect(14, 225, 180, 90);

        public long RenderTime;

        public void RenderCPU()
        {
            Stopwatch watch = new Stopwatch();

            watch.Start();

            Noise2D map = new Noise2D(
                size,
                size / 2, 
                GetInputValue<SerializableModuleBase>("Input", this.Input));

            map.GenerateSpherical(
                south,
                north,
                west,
                east);

            tex = map.GetTexture(grad);
            tex.Apply();

            watch.Stop();
            RenderTime = watch.ElapsedMilliseconds;
        }

        public void RenderGPU()
        {
            Stopwatch watch = new Stopwatch();

            tex = new Texture2D(size, size / 2);

            var rdB = GetInputValue<SerializableModuleBase>("Input", this.Input).GetSphericalValueGPU(
                new Vector2(size, size / 20));

            tex.ReadPixels(new Rect(0, 0, rdB.width, rdB.height), 0, 0);

            tex.Apply();

            watch.Stop();
            RenderTime = watch.ElapsedMilliseconds;
        }

        public void Save()
        {
            if (tex == null) return;

            UnityEngine.Debug.Log(Application.dataPath + DataPath + PictureName + ".png");

            File.WriteAllBytes(Application.dataPath + DataPath + PictureName + ".png", tex.EncodeToPNG());
        }
    }
}    