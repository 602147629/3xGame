package com.midasplayer.engine.playdata
{
    import com.midasplayer.input.*;
    import com.midasplayer.math.*;

    public class MouseReleasePlayData extends Object implements IExecutablePlayData
    {
        private var _input:MouseInput;
        private var _tick:int;
        private var _x:int;
        private var _y:int;

        public function MouseReleasePlayData(param1:int, param2:int, param3:int, param4:MouseInput)
        {
            this._tick = param1;
            this._x = param2;
            this._y = param3;
            this._input = param4;
            return;
        }// end function

        public function getTick() : int
        {
            return this._tick;
        }// end function

        public function execute() : void
        {
            this._input.setReleased(new Vec2(this._x, this._y));
            return;
        }// end function

        public function toPlayData() : String
        {
            return PlayDataConstants.MouseReleased + "|" + this._tick + "|" + this._x + "|" + this._y;
        }// end function

    }
}
