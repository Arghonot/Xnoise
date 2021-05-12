using System;
using System.Collections.Generic;
using UnityEngine;

namespace Graph
{
    #region LibnoiseVariables

    //[Serializable]
    //[StorableType(typeof(LibNoise.QualityMode))]
    //public class QualityModeVariable : VariableStorage<LibNoise.QualityMode> { }

    public partial class GraphVariableStorage : GraphVariableStorageHelper
    {
        //[SerializeField] public List<QualityModeVariable> QualityModes;
    }

    #endregion
}

//[BlackboardType("QualityMode")]
//public class Quality : Variable
//{
//    public override string GetDefaultName()
//    {
//        return "QualityMode";
//    }

//    public override Type GetValueType()
//    {
//        return typeof(LibNoise.QualityMode);
//    }
//}
