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

        public float[,] GenerateHeight(int cx, int cz)
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
    }
}