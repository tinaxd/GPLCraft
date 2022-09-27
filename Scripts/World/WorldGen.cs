using System;

namespace GPLCraft
{
    public class WorldGen
    {
        private int seed;

        public WorldGen(int seed)
        {
            this.seed = seed;
        }

        private float[,] GenerateHeight(int cx, int cz)
        {
            SimplexNoise.Noise.Seed = seed;
            int x = 16, z = 16;
            float scale = 0.05f;
            float[,] noiseValues = SimplexNoise.Noise.Calc2D(x, z, scale);

            for (int i = 0; i < x; i++)
            {
                for (int j = 0; j < z; j++)
                {
                    var v = noiseValues[i, j];
                    noiseValues[i, j] = (float)(64.0 + (v / 256.0 * 16.0));
                }
            }

            return noiseValues;
        }

        public Chunk GenerateChunk(int cx, int cz)
        {
            float[,] heights = GenerateHeight(cx, cz);
            Chunk c = new Chunk(cx, cz);
            for (int i = 0; i < 16; i++)
            {
                for (int j = 0; j < 16; j++)
                {
                    for (int k = 0; k < heights[i, j]; k++)
                    {
                        // dirt block
                        Block d = new Block(1);
                        c.SetBlock(i, j, k, d);
                    }
                }
            }
            return c;
        }
    }
}