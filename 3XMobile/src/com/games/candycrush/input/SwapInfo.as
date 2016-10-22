package com.games.candycrush.input
{
    import com.games.candycrush.ItemType;
    import com.games.candycrush.board.Item;

    public class SwapInfo
    {
        public var srcX:int;
        public var srcY:int;
        public var dstX:int;
        public var dstY:int;
        public var item_a:Item;
        public var item_b:Item;
        public var isFailed:Boolean = false;
		public var isUsed:Boolean = false;
		
		
        public function SwapInfo(srcX_:int, srcY_:int, dstX_:int, dstY_:int, itemA:Item = null, itemB:Item = null) : void
        {
            this.srcX = srcX_;
            this.srcY = srcY_;
            this.dstX = dstX_;
            this.dstY = dstY_;
            this.item_a = itemA;
            this.item_b = itemB;
            return;
        }// end function
		
		public function isSpecialSwap():Boolean
		{
			if(item_a.special == ItemType.INVALID || item_b.special == ItemType.INVALID)
			{
				if(item_a.isColorItem() && item_b.isColorItem())
				{
					return (item_a.isColorItem() && item_b.isColorItem())&& ((item_a.isSpecialItem() && item_b.isSpecialItem())  || (item_a.special == ItemType.COLOR || item_b.special == ItemType.COLOR));
				}
				return false;
			}
			return (item_a.isColorItem() && item_b.isColorItem())&& ((item_a.isSpecialItem() && item_b.isSpecialItem())  || (item_a.special == ItemType.COLOR || item_b.special == ItemType.COLOR));
		}

        public function hasItems() : Boolean
        {
            return this.item_a && this.item_b;
        }// end function

        public function isHorizontal() : Boolean
        {
            return this.srcY == this.dstY;
        }// end function

        public function isVertical() : Boolean
        {
            return this.srcX == this.dstX;
        }// end function

        public function isBusy() : Boolean
        {
            if (!this.hasItems())
            {
                return false;
            }
            return this.item_a.isBusy() || this.item_b.isBusy();
        }// end function

    }
}
