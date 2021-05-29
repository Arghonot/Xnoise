﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LibNoise;

namespace NoiseGraph
{
    /// <summary>
    /// A default class with a generic output node.
    /// </summary>
    public class LibnoiseNode : Graph.Branch<SerializableModuleBase>
    {
        public override object Run()
        {
            return null;
        }
    }

    /// <summary>
    /// A default class with a generic output node.
    /// </summary>
    public class LibnoiseNodeGPU : Graph.Branch<RenderTexture>
    {
        public override object Run()
        {
            return null;
        }
    }
}