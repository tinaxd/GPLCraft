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
            var chunk = gen.GenerateChunk(0, 0);
            wRenderer.RenderChunk(chunk);
        }

        //  // Called every frame. 'delta' is the elapsed time since the previous frame.
        //  public override void _Process(float delta)
        //  {
        //      
        //  }
    }
}
