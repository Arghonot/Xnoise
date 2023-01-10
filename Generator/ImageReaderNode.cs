using LibNoise;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using UnityEngine;
using static XNode.Node;

namespace Xnoise
{
    [CreateNodeMenu("NoiseGraph/Debug/ImageReader")]
    public class ImageReaderNode : LibnoiseNode
    {
        public Texture2D input;

        public override object Run()
        {
            LibNoise.Image img = new LibNoise.Image(0);
            img.input = input;

            return img;
        }
    }
}