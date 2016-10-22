package com.midasplayer.engine.playdata
{
    import com.midasplayer.debug.*;
    import com.midasplayer.input.*;

    public class PlayDataFactory extends Object implements IPlayDataFactory
    {
        private var _mouseInput:MouseInput;
        private var _keyboardInput:KeyboardInput;

        public function PlayDataFactory(param1:MouseInput, param2:KeyboardInput)
        {
            this._mouseInput = param1;
            this._keyboardInput = param2;
            return;
        }// end function

        public function create(param1:String) : IPlayData
        {
            var _loc_2:Array = null;
            _loc_2 = param1.split("|");
            Debug.assert(_loc_2.length > 0, "Found no arguments in a playdata.");
            var _loc_3:* = this._toInt(_loc_2[0]);
            if (_loc_3 == PlayDataConstants.MousePosition)
            {
                Debug.assert(_loc_2.length == 4, "Expected 4 parameters in mouse position playdata.");
                return new MousePositionPlayData(this._toInt(_loc_2[1]), this._toInt(_loc_2[2]), this._toInt(_loc_2[3]), this._mouseInput);
            }
            if (_loc_3 == PlayDataConstants.MousePressed)
            {
                Debug.assert(_loc_2.length == 4, "Expected 4 parameters in mouse press playdata.");
                return new MousePressPlayData(this._toInt(_loc_2[1]), this._toInt(_loc_2[2]), this._toInt(_loc_2[3]), this._mouseInput);
            }
            if (_loc_3 == PlayDataConstants.MouseReleased)
            {
                Debug.assert(_loc_2.length == 4, "Expected 4 parameters in mouse release playdata.");
                return new MouseReleasePlayData(this._toInt(_loc_2[1]), this._toInt(_loc_2[2]), this._toInt(_loc_2[3]), this._mouseInput);
            }
            if (_loc_3 == PlayDataConstants.KeyPressed)
            {
                Debug.assert(_loc_2.length == 3, "Expected 3 parameters for key pressed playdata.");
                return new KeyPressedPlayData(this._toInt(_loc_2[1]), this._toInt(_loc_2[2]), this._keyboardInput);
            }
            if (_loc_3 == PlayDataConstants.KeyReleased)
            {
                Debug.assert(_loc_2.length == 3, "Expected 3 parameters for key released playdata.");
                return new KeyReleasedPlayData(this._toInt(_loc_2[1]), this._toInt(_loc_2[2]), this._keyboardInput);
            }
            if (_loc_3 == PlayDataConstants.LastTick)
            {
                Debug.assert(_loc_2.length == 6, "Expected 6 parameters in last tick playdata.");
                return new LastTickPlayData(this._toInt(_loc_2[1]), this._toInt(_loc_2[2]), _loc_2[3] == "1", _loc_2[4] == "1", _loc_2[5]);
            }
            if (_loc_3 == PlayDataConstants.Log)
            {
                Debug.assert(_loc_2.length == 2, "Expected 2 parameters for log playdata.");
                return new LogPlayData(_loc_2[1]);
            }
            Debug.assert(false, "Unknown play data string (" + param1 + ")");
            return null;
        }// end function

        private function _toInt(param1:String) : int
        {
            var _loc_2:Number = NaN;
            _loc_2 = parseInt(param1);
            Debug.assert(!isNaN(_loc_2), "Could not parse a play data argument as int \'" + _loc_2 + "\'");
            var _loc_3:* = int(_loc_2);
            Debug.assert(_loc_2 == _loc_3, "Trying to parse a play data argument from a number with decimals to int \'" + _loc_2 + "\'");
            return _loc_3;
        }// end function

    }
}
