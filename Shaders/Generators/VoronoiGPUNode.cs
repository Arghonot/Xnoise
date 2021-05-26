using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LibNoise;
using System.Diagnostics;
using System.IO;

namespace NoiseGraph
{
    [CreateNodeMenu("Experimental/Generator/VoronoiGPUNode")]
    [NodeTint(Graph.ColorProfile.FlatBlue)]
    public class VoronoiGPUNode : LibnoiseNodeGPU
    {
        public Material VoronoiShader;

        public float Frequency;
        public float Distance;
        public float Displacement;
        public float Radius;
        public int size;
        public Texture2D tex;

        string DataPath = "/";
        public string PictureName = "Test";

        [ContextMenu("Run")]
        public override object Run()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();

            RenderTexture rdB = new RenderTexture(size, size / 2, 16);

            UnityEngine.Debug.Log("Render texture creation :" + watch.ElapsedMilliseconds);

            RenderTexture.active = rdB;
            VoronoiShader.SetFloat("_Frequency", Frequency);
            VoronoiShader.SetFloat("_Displacement", Displacement);
            VoronoiShader.SetFloat("_Distance", Distance);
            VoronoiShader.SetFloat("_Radius", Radius);
            Graphics.Blit(Texture2D.whiteTexture, rdB, VoronoiShader);

            //UnityEngine.Debug.Log("Render texture Blit :" + watch.ElapsedMilliseconds);
            //tex = new Texture2D(size, size / 2);

            //UnityEngine.Debug.Log("Final texture creation :" + watch.ElapsedMilliseconds);
            //tex.ReadPixels(new Rect(0, 0, rdB.width, rdB.height), 0, 0);
            //UnityEngine.Debug.Log("Final texture just read pixels :" + watch.ElapsedMilliseconds);

            //tex.Apply();
            //UnityEngine.Debug.Log("Final texture apply() :" + watch.ElapsedMilliseconds);

            return rdB;
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