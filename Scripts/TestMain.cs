using Godot;
using System;

namespace GPLCraft
{
    public class TestMain : Node
    {
        // Declare member variables here. Examples:
        // private int a = 2;
        // private string b = "text";

        // Called when the node enters the scene tree for the first time.
        private WorldGen gen;

        public override void _Ready()
        {
            // GD.PushError("OnREADY!!");
            var multimesh = GetNode<MultiMeshInstance>("multimesh");
            multimesh.Multimesh.InstanceCount = 10;
            for (int i = 0; i < 10; i++)
            {
                var position = multimesh.Multimesh.GetInstanceTransform(i);
                position = position.Translated(new Vector3(i, 0, 0));
                multimesh.Multimesh.SetInstanceTransform(i, position);
            }

            // gen = new WorldGen(5);
            // var heights = gen.GenerateHeight(0, 0);
            // for (int i = 0; i < 16; i++)
            // {
            //     for (int j = 0; j < 16; j++)
            //     {

            //         GD.Print(heights[i, j]);
            //     }
            // }
        }

        //  // Called every frame. 'delta' is the elapsed time since the previous frame.
        //  public override void _Process(float delta)
        //  {
        //      
        //  }
    }
}
