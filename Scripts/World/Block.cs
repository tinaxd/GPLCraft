using System;

namespace GPLCraft
{
    public class Block
    {
        private int blockID;

        public static Block AirBlock = new Block(0);

        public Block(int blockID)
        {
            this.blockID = blockID;
        }

        public int BlockID
        {
            get => blockID;
        }
    }
}