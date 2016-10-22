package com.midasplayer.engine.playdata
{
    import com.midasplayer.input.*;

    public class KeyReleasedPlayData extends Object implements IExecutablePlayData
    {
        private var _input:KeyboardInput;
        private var _tick:int;
        private var _code:int;

        public function KeyReleasedPlayData(param1:int, param2:int, param3:KeyboardInput)
        {
            this._tick = param1;
            this._code = param2;
            this._input = param3;
            return;
        }// end function

        public function getTick() : int
        {
            return this._tick;
        }// end function

        public function execute() : void
        {
            this._input.setReleased(this._code);
            return;
        }// end function

        public function toPlayData() : String
        {
            return PlayDataConstants.KeyReleased + "|" + this._tick + "|" + this._code;
        }// end function

    }
}
