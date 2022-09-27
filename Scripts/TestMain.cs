using Godot;
using System;
using System.Collections.Generic;

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


            gen = new WorldGen(5);
            var chunk = gen.GenerateChunk(0, 0);
            RenderChunk(chunk);
        }

        private void RenderChunk(Chunk c)
        {
            var dirts = new List<Vector3>();

            for (int k = 0; k < Chunk.SizeY; k++)
            {
                for (int i = 0; i < Chunk.SizeX; i++)
                {
                    for (int j = 0; j < Chunk.SizeZ; j++)
                    {
                        Block b = c.GetBlock(i, k, j);
                        if (b.BlockID != 0)
                        {
                            // is not air
                            dirts.Add(new Vector3(i, k, j));
                        }
                    }
                }
            }

            var multimesh = GetNode<MultiMeshInstance>("multimesh");
            multimesh.Multimesh.InstanceCount = dirts.Count;
            for (int i = 0; i < dirts.Count; i++)
            {
                var position = multimesh.Multimesh.GetInstanceTransform(i);
                position = position.Translated(dirts[i]);
                multimesh.Multimesh.SetInstanceTransform(i, position);
            }
        }

        //  // Called every frame. 'delta' is the elapsed time since the previous frame.
        //  public override void _Process(float delta)
        //  {
        //      
        //  }
    }
}
