using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LibNoise;
using System.Diagnostics;
using System.IO;

namespace NoiseGraph
{
    [CreateNodeMenu("Experimental/Transformers/DisplaceGPUNode")]
    [NodeTint(Graph.ColorProfile.FlatBlue)]
    public class DisplaceGPUNode : LibnoiseNodeGPU
    {
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public RenderTexture Source;
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public RenderTexture ControllerA;
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public RenderTexture ControllerB;
        [Input(ShowBackingValue.Always, ConnectionType.Override, TypeConstraint.Strict)]
        public RenderTexture ControllerC;
        public Material Displace;

        public Texture2D tex;

        string DataPath = "/";
        public string PictureName = "Test";

        [ContextMenu("Run")]
        public override object Run()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();

            UnityEngine.Debug.Log("Before :" + watch.ElapsedMilliseconds);
            Source = GetInputValue<RenderTexture>("Source", this.Source);
            ControllerA = GetInputValue<RenderTexture>("ControllerA", this.ControllerA);
            ControllerB = GetInputValue<RenderTexture>("ControllerB", this.ControllerB);
            ControllerC = GetInputValue<RenderTexture>("ControllerC", this.ControllerC);

            RenderTexture rdB = new RenderTexture(Source.width, Source.height, 16);
            UnityEngine.Debug.Log("After creation :" + watch.ElapsedMilliseconds);


            RenderTexture.active = rdB;
            Displace.SetTexture("_Control", Source);
            Displace.SetTexture("_TextureA", ControllerA);
            Displace.SetTexture("_TextureB", ControllerB);
            Displace.SetTexture("_TextureC", ControllerC);
            Graphics.Blit(Texture2D.whiteTexture, rdB, Displace);

            UnityEngine.Debug.Log("Render texture Blit :" + watch.ElapsedMilliseconds);
            //tex = new Texture2D(Source.width, Source.height);

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