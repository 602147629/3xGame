package com.input
{
    import __AS3__.vec.*;
    import com.midasplayer.debug.*;

    public class KeyboardInput extends Object
    {
        private var _keysPressed:Vector.<int>;
        private var _keysReleased:Vector.<int>;

        public function KeyboardInput()
        {
            this._keysPressed = new Vector.<int>;
            this._keysReleased = new Vector.<int>;
            return;
        }// end function

        public function reset() : void
        {
            this._keysPressed.length = 0;
            this._keysReleased.length = 0;
            return;
        }// end function

        public function setPressed(param1:int) : void
        {
//            Debug.assert(param1 > 0, "Expected a positive key code press.");
            this._keysPressed.push(param1);
            return;
        }// end function

        public function setReleased(param1:int) : void
        {
//            Debug.assert(param1 > 0, "Expected a positive key code release.");
            this._keysReleased.push(param1);
            return;
        }// end function

        public function isReleased(param1:int) : Boolean
        {
            return this._keysReleased.indexOf(param1) != -1;
        }// end function

        public function isPressed(param1:int) : Boolean
        {
            return this._keysPressed.indexOf(param1) != -1;
        }// end function

    }
}
