﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LibNoise;
using System.Diagnostics;
using System.IO;

namespace Xnoise
{
    [CreateNodeMenu("Experimental/Generator/SimpleShaderRenderer")]
    [NodeTint(Graph.ColorProfile.FlatBlue)]
    public class SimpleShaderRenderer : LibnoiseNode
    {

        public Material ShaderA;

        public double frequency;
        public int size;
        public Texture2D tex;

        string DataPath = "/";
        public string PictureName = "Test";

        [ContextMenu("Run")]
        public object Run()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();

            RenderTexture rdB = new RenderTexture(size, size / 2, 16);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            RenderTexture.active = rdB;
            Graphics.Blit(Texture2D.whiteTexture, rdB, ShaderA);

            tex = new Texture2D(size, size / 2);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);
            tex.ReadPixels(new Rect(0, 0, rdB.width, rdB.height), 0, 0);
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            tex.Apply();
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            return null;
        }

        [ContextMenu("Save")]
        public void Save()
        {
            if (tex == null) return;

            UnityEngine.Debug.Log(Application.dataPath + DataPath + PictureName + ".png");

            File.WriteAllBytes(Application.dataPath + DataPath + PictureName + ".png", tex.EncodeToPNG());
        }
    }
}