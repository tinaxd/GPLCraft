using Godot;
using System;
using System.Collections.Generic;
// using System.Runtime.InteropServices;

namespace GPLCraft
{
    public class WorldRenderer : Spatial
    {
        // Declare member variables here. Examples:
        // private int a = 2;
        // private string b = "text";

        // Called when the node enters the scene tree for the first time.

        private PackedScene resource;

        public override void _Ready()
        {
            resource = GD.Load<PackedScene>("res://Scenes/ChunkRenderer.tscn");
        }

        public void RenderChunk(Chunk c)
        {
            int cx = c.CX;
            int cz = c.CZ;

            // spawn ChunkRenderer
            var instance = resource.Instance<ChunkRenderer>();

            // add to scene
            AddChild(instance);

            // set location
            instance.SetChunkLocation(cx, cz);

            // set and render chunk
            // GD.Print("settings chunk");
            instance.Chunk = c;

            // GCHandle objHandle = GCHandle.Alloc(c, GCHandleType.WeakTrackResurrection);
            // int address = GCHandle.ToIntPtr(objHandle).ToInt32();
            // GD.Print("rendering chunk: " + address);
        }
    }

}