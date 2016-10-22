package com.games.candycrush.utils
{
    import flash.display.*;

    public class CustomFrameAnimation extends MCAnimation
    {
        protected var nframe:int = -1;
        protected var frames:Array;
        protected var wrap:Boolean;
        protected var frameCount:int;

        public function CustomFrameAnimation(param1:MovieClip, param2:Array, param3:Boolean = true, param4:int = 0)
        {
            this.frames = [];
            super(param1);
            this.wrap = param3;
            this.frameCount = param2.length;
            var _loc_5:int = 0;
            while (_loc_5 < this.frameCount)
            {
                
                this.frames.push(param2[_loc_5] + param4);
                _loc_5++;
            }
            this.frame = 0;
            return;
        }// end function

        override public function set frame(param1:int) : void
        {
            var _loc_2:* = param1;
            if (_loc_2 != this.nframe)
            {
                super.frame = this.getRawFrame(_loc_2);
                this.nframe = _loc_2;
            }
            return;
        }// end function

        override public function get frame() : int
        {
            return this.nframe;
        }// end function

        public function getRawFrame(param1:int = -1) : int
        {
            if (param1 >= this.frameCount)
            {
                param1 = this.wrap ? (param1 % this.frameCount) : ((this.frameCount - 1));
            }
            return this.frames[param1 < 0 ? (this.nframe) : (param1)];
        }// end function

        public function frameEquals(param1:int) : Boolean
        {
            return this.frames[this.nframe] == param1;
        }// end function

        public function getFrameCount() : int
        {
            return this.frameCount;
        }// end function

    }
}
