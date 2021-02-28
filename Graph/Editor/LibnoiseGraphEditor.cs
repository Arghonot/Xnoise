using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XNode;
using XNodeEditor;

namespace NoiseGraph
{
    [CustomNodeGraphEditor(typeof(LibnoiseGraph))]
    public class LibnoiseGraphEditor : XNodeEditor.NodeGraphEditor
    {
        // TODO find a way to make this inherit generic node graph editor as well
        // perhaps use attribute Don't show in dialogue
        List<Type> HiddenTypes = new List<Type>()
        {
            typeof(RootModuleBase),
            typeof(Graph.Blackboard),
            typeof(Graph.Single),
            typeof(LibnoiseNode),
            typeof(Graph.NodeBase)
        };

        public override void RemoveNode(Node node)
        {
            if (node != ((LibnoiseGraph)target).blackboard &&
                !node.GetType().ToString().Contains("Root"))
            {
                base.RemoveNode(node);
            }
        }

        public override Texture2D GetGridTexture()
        {
            NodeEditorWindow.current.titleContent = new GUIContent(((LibnoiseGraph)target).name);

            return base.GetGridTexture();
        }

        public override string GetNodeMenuName(Type type)
        {
            if (!HiddenTypes.Contains(type) &&
                !type.ToString().Contains("Root") &&
                !type.ToString().Contains("[T]"))
            {
                return base.GetNodeMenuName(type);
            }

            else return null;
        }

        public override void OnCreate()
        {
            base.OnCreate();

            LibnoiseGraph graph = target as LibnoiseGraph;
            NodeEditorWindow.current.graphEditor = this;

            if (graph.blackboard == null)
            {
                var bb = CreateNode(typeof(Graph.Blackboard), new Vector2(0, 0));
                graph.blackboard = bb as Graph.Blackboard;
            }
            
            if (graph.root == null)
            {
                var root = CreateNode(typeof(RootModuleBase), new Vector2(0, 0));
                graph.root = root as RootModuleBase;
            }
        }
    }
}