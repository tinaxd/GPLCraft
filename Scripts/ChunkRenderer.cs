using Godot;
using System;
using System.Collections.Generic;

namespace GPLCraft
{
    public class ChunkRenderer : Spatial
    {
        // Declare member variables here. Examples:
        // private int a = 2;
        // private string b = "text";

        private Chunk _chunk;
        public Chunk Chunk
        {
            get => _chunk;
            set
            {
                _chunk = value;
                dirty = true;
                // GD.Print("chunk was set");
                RenderChunk();
            }
        }

        private bool dirty = false;

        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
        {
        }

        public void SetChunkLocation(int cx, int cz)
        {
            dirty = true;
            var t = Transform.Identity;
            t = t.Translated(new Vector3(cx * Chunk.SizeX, 0, cz * Chunk.SizeZ));
            this.Transform = t;
        }

        private void RenderChunk()
        {
            if (_chunk == null) return;
            if (!dirty) return;

            var dirts = new List<Vector3>();

            for (int k = 0; k < Chunk.SizeY; k++)
            {
                for (int i = 0; i < Chunk.SizeX; i++)
                {
                    for (int j = 0; j < Chunk.SizeZ; j++)
                    {
                        Block b = _chunk.GetBlock(i, k, j);
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
                var position = Transform.Identity;
                position = position.Translated(dirts[i]);
                multimesh.Multimesh.SetInstanceTransform(i, position);
            }

            dirty = false;
        }

        //  // Called every frame. 'delta' is the elapsed time since the previous frame.
        //  public override void _Process(float delta)
        //  {
        //      
        //  }
    }
}
