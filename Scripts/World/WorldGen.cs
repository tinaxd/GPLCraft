using System;

namespace GPLCraft
{
    public class WorldGen
    {
        private int seed;
        private SharpNoise.Modules.Perlin perlin;
        // private Godot.OpenSimplexNoise noise;

        public WorldGen(int seed)
        {
            this.seed = seed;
            perlin = new SharpNoise.Modules.Perlin()
            {
                Seed = seed
            };

            // noise = new Godot.OpenSimplexNoise();
            // noise.Seed = seed;
            // noise.Octaves = 4;
            // noise.Period = 20.0f;
            // noise.Persistence = 0.8f;
        }

        private int[,] GenerateHeight(int cx, int cz)
        {
            int SizeX = Chunk.SizeX, SizeZ = Chunk.SizeZ;
            int[,] noiseValues = new int[SizeX, SizeZ];

            for (int i = 0; i < SizeX; i++)
            {
                for (int j = 0; j < SizeZ; j++)
                {
                    var fv = perlin.GetValue(cx + i / (float)SizeX, cz + j / (float)SizeZ, 0);
                    // var fv = noise.GetNoise2d(cx + i / (float)SizeX, cz + j / (float)SizeZ) * 256.0;
                    fv = (float)(64.0 + (fv / 256.0 * 16.0));
                    noiseValues[i, j] = (int)fv;
                }
            }

            return noiseValues;
        }

        public Chunk GenerateChunk(int cx, int cz)
        {
            int[,] heights = GenerateHeight(cx, cz);
            Chunk c = new Chunk(cx, cz);
            for (int i = 0; i < 16; i++)
            {
                for (int j = 0; j < 16; j++)
                {
                    for (int k = 0; k < heights[i, j]; k++)
                    {
                        // dirt block
                        Block d = new Block(1);
                        c.SetBlock(i, k, j, d);
                    }
                }
            }
            return c;
        }
    }
}