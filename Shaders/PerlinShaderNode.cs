using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LibNoise;
using System.Diagnostics;

namespace NoiseGraph
{
    [CreateNodeMenu("Experimental/Generator/Perlin")]
    [NodeTint(Graph.ColorProfile.FlatBlue)]
    public class PerlinShaderNode : LibnoiseNode
    {

        public Material ShaderA;
        public Material ShaderB;
        public Material MergeShader;

        public double frequency;
        public int size;
        public Texture2D tex;

        [ContextMenu("Run")]
        public override object Run()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();

            RenderTexture rdA = new RenderTexture(size, size, 16);
            RenderTexture rdB = new RenderTexture(size, size, 16);
            RenderTexture MergeRD = new RenderTexture(size, size, 16);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            ShaderB.SetFloat("Frequency", (float)frequency);
            RenderTexture.active = rdA;
            Graphics.Blit(Texture2D.whiteTexture, rdA, ShaderA);

            RenderTexture.active = rdB;
            Graphics.Blit(Texture2D.whiteTexture, rdB, ShaderB);

            MergeShader.SetTexture("_TextureB", rdB);
            MergeShader.SetTexture("_TextureA", rdA);

            RenderTexture.active = MergeRD;
            Graphics.Blit(Texture2D.whiteTexture, MergeRD, MergeShader);

            tex = new Texture2D(size, size);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);
            tex.ReadPixels(new Rect(0, 0, MergeRD.width, MergeRD.height), 0, 0);
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            tex.Apply();
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            return null;
        }

        [ContextMenu("RunA")]
        public object RunA()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();

            RenderTexture rdA = new RenderTexture(size, size, 16);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            ShaderB.SetFloat("Frequency", (float)frequency);
            RenderTexture.active = rdA;
            Graphics.Blit(Texture2D.whiteTexture, rdA, ShaderA);

            tex = new Texture2D(size, size);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);
            tex.ReadPixels(new Rect(0, 0, rdA.width, rdA.height), 0, 0);
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            tex.Apply();
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            return null;
        }

        [ContextMenu("RunB")]
        public object RunB()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();

            RenderTexture rdB = new RenderTexture(size, size, 16);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            RenderTexture.active = rdB;
            Graphics.Blit(Texture2D.whiteTexture, rdB, ShaderB);

            tex = new Texture2D(size, size);

            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);
            tex.ReadPixels(new Rect(0, 0, rdB.width, rdB.height), 0, 0);
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            tex.Apply();
            UnityEngine.Debug.Log(watch.ElapsedMilliseconds);

            return null;
        }
    }
}