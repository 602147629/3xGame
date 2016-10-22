package com.games.candycrush.input
{
    import com.math.IntCoord;

    public class Swapper
    {
        private var _switchClickN:int = 0;
        private var _swapState:int = 0;
        private var _marked:Boolean = false;
        private var _mx:int;
        private var _my:int;
        private var _isFirstSelected:Boolean = false;
        private var _tx:int;
        private var _ty:int;
        private var _swap:SwapInfo;

        public function Swapper()
        {
            return;
        }// end function

        public function reset() : void
        {
            this._marked = false;
            this._isFirstSelected = false;
            this._swap = null;
            return;
        }// end function

        public function mouseDownAt(clickX:int, clickY:int, forceSwap:Boolean = false) : void
        {
            if (clickX < 0 || clickY < 0)
            {
                return;
            }
			/*if(clickX == _mx && clickY == _my)
			{
			   //inflution mouse feal
				return;
			}*/
            if (this._marked && (forceSwap || this.nextTo(this._mx, this._my, clickX, clickY)))
            {
                this._swap = new SwapInfo(this._mx, this._my, clickX, clickY);
            }
            else
            {
                this._marked = false;
                this._isFirstSelected = true;
                this._tx = clickX;
                this._ty = clickY;
            }
            
        }// end function

        public function mouseMoveTo(dstX:int, dstY:int, forceSwap:Boolean = false) : void
        {
            if (this._isFirstSelected && (forceSwap || this.nextTo(this._tx, this._ty, dstX, dstY)))
            {
				if(_tx != dstX || _ty != dstY)
				{					
	                this._swap = new SwapInfo(this._tx, this._ty, dstX, dstY);
				}
            }
            return;
        }// end function

        private function nextTo(srcX:int, srcY:int, dstX:int, dstY:int) : Boolean
        {
            return iabs(srcX, dstX) == 1 && srcY == dstY || iabs(srcY, dstY) == 1 && srcX == dstX;
        }// end function

        public function mouseUpAt(gridX:int, gridY:int) : void
        {
            if (this._isFirstSelected && (this._tx == gridX && this._ty == gridY))
            {
//                SoundVars.sound.play(SA_Switch_mark1, 0.4, GameView.gridToStageX(param1));
                this._marked = true;
                this._mx = gridX;
                this._my = gridY;
            }
            this._isFirstSelected = false;
          
        }

        public function shouldSwap() : Boolean
        {
            return this._swap != null;
        }// end function

        public function getSwap() : SwapInfo
        {
            return this._swap;
        }// end function

        public function isMarked() : Boolean
        {
            return this._marked || this._isFirstSelected;
        }// end function

        public function getMarkedPos() : IntCoord
        {
            if (this._isFirstSelected)
            {
                return new IntCoord(this._tx, this._ty);
            }
            return new IntCoord(this._mx, this._my);
        }// end function

        private static function iabs(numA:int, numB:int) : int
        {
            return numA > numB ? (numA - numB) : (numB - numA);
        }// end function

    }
}
