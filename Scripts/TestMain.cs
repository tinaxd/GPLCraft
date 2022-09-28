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
        private WorldRenderer wRenderer;

        public override void _Ready()
        {
            // GD.PushError("OnREADY!!");

            wRenderer = GetNode<WorldRenderer>("WorldOrigin");

            gen = new WorldGen(5);
            var chunks = new List<Chunk>();
            for (int x = -2; x <= 2; x++)
            {
                for (int z = -2; z <= 2; z++)
                {
                    chunks.Add(gen.GenerateChunk(x, z));
                }
            }

            bool isSame = true;
            for (int x = 0; x < 16; x++)
            {
                for (int z = 0; z < 16; z++)
                {
                    for (int y = 0; y < Chunk.SizeY; y++)
                    {
                        int a = chunks[0].GetBlock(x, y, z).BlockID;
                        int b = chunks[1].GetBlock(x, y, z).BlockID;
                        if (a != b)
                        {
                            GD.Print("chunks are different at: " + x + "," + y + "," + z);
                            isSame = false;
                        }
                    }
                }
            }
            GD.Print("Chunks are same!: ", isSame);

            chunks.ForEach(c => wRenderer.RenderChunk(c));
            // foreach (var c in chunks)
            // {
            //     wRenderer.RenderChunk(c);
            // }
        }

        //  // Called every frame. 'delta' is the elapsed time since the previous frame.
        //  public override void _Process(float delta)
        //  {
        //      
        //  }
    }
}
