﻿using LibNoise;
using System.Diagnostics;
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
        [SerializeField] public int width = 512;
        [SerializeField] public int Height = 0;
        [SerializeField] public Texture2D tex = null;
        [SerializeField] public Gradient grad = new Gradient();

        public float Space = 110;
        public int renderMode;
        public int projectionMode;

        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public SerializableModuleBase Input;

        public Rect TexturePosition = new Rect(14, 210, 180, 90);

        public long RenderTime;

        public void Render()
        {
            if (renderMode == 0)
            {
                RenderCPU();
            }
            if (renderMode == 1)
            {
                RenderGPU();
            }
            else
            {

            }
        }

        public void RenderCPU()
        {
            Stopwatch watch = new Stopwatch();

            watch.Start();
            Noise2D map = new Noise2D(
                width,
                Height == 0 ? width / 2 : Height, 
                GetInputValue<SerializableModuleBase>("Input", this.Input));
            if (projectionMode == 0)
            {
                map.GeneratePlanar(Noise2D.Left, Noise2D.Right, Noise2D.Top, Noise2D.Bottom);
            }
            else if (projectionMode == 1)
            {
                map.GenerateSpherical(
                    south,
                    north,
                    west,
                    east);
            }


            tex = map.GetTexture();
            tex.Apply();

            watch.Stop();
            RenderTime = watch.ElapsedMilliseconds;
        }

        public void RenderGPU()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();

            var map = new Noise2D(
                width,
                Height == 0 ? width / 2 : Height,
                GetInputValue<SerializableModuleBase>("Input", this.Input));
            map.useGPU = true;
            if (projectionMode == 0)
            {
                map.GeneratePlanar(Noise2D.Left, Noise2D.Right, Noise2D.Top, Noise2D.Bottom);
            }
            else if (projectionMode == 1)
            {
                map.GenerateSpherical(
                    south,
                    north,
                    west,
                    east);
            }

            tex = map.GetTexture();

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