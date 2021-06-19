using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UIElements;

[CustomEditor(typeof(Planet))]
public class GraphUserEditor : Editor
{
    public override void OnInspectorGUI()
    {
        Planet myTarget = (Planet)target;
        Xnoise.XnoiseGraph graph = myTarget.graph;        

        base.OnInspectorGUI();

        if (graph != myTarget.graph)
        {
            myTarget.UpdateStorage();
        }
    }
}
