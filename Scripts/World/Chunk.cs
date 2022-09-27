using System;

namespace GPLCraft
{
    public class Chunk
    {
        private Block[] blocks;
        public static readonly int SizeX = 16;
        public static readonly int SizeY = 128;
        public static readonly int SizeZ = 16;

        public readonly int CX;
        public readonly int CZ;

        public static int GetIndex(int rx, int ry, int rz)
        {
            return rx + rz * SizeX + ry * (SizeX * SizeZ);
        }

        public Chunk(int cx, int cz)
        {
            this.CX = cx;
            this.CZ = cz;
            this.blocks = new Block[SizeX * SizeY * SizeZ];

            // initialize with air block
            for (int i = 0; i < SizeX; i++)
            {
                for (int j = 0; j < SizeY; j++)
                {
                    for (int k = 0; k < SizeZ; k++)
                    {
                        SetBlock(i, j, k, Block.AirBlock);
                    }
                }
            }
        }

        public void SetBlock(int idx, Block blk)
        {
            this.blocks[idx] = blk;
        }

        public void SetBlock(int rx, int ry, int rz, Block blk)
        {
            SetBlock(GetIndex(rx, ry, rz), blk);
        }

        public Block GetBlock(int rx, int ry, int rz)
        {
            return GetBlock(GetIndex(rx, ry, rz));
        }

        public Block GetBlock(int idx)
        {
            return this.blocks[idx];
        }
    }
}