package com.input
{
    import com.math.Vec2;

    final public class MouseInput extends Object
    {
        private var _pos:Vec2;
        private var _pressPos:Vec2;
        private var _releasePos:Vec2;
        private var _hasPos:Boolean = false;
        private var _isPressed:Boolean = false;
        private var _isReleased:Boolean = false;
        private var _isDown:Boolean = false;

        public function MouseInput()
        {
            this._pos = new Vec2();
            this._pressPos = new Vec2();
            this._releasePos = new Vec2();
            return;
        }// end function

        public function reset() : void
        {
            this._isPressed = false;
            this._isReleased = false;
            this._hasPos = false;
            return;
        }// end function

        public function setPosition(param1:Vec2) : void
        {
            this._hasPos = true;
            this._pos.copy(param1);
            return;
        }// end function

        public function setPressed(param1:Vec2) : void
        {
            this._isPressed = true;
            this._isDown = true;
            this._pressPos.copy(param1);
            return;
        }// end function

        public function setReleased(param1:Vec2) : void
        {
            this._isReleased = true;
            this._isDown = false;
            this._releasePos.copy(param1);
            return;
        }// end function

        public function hasPosition() : Boolean
        {
            return this._hasPos;
        }// end function

        public function isPressed() : Boolean
        {
            return this._isPressed;
        }// end function

        public function isReleased() : Boolean
        {
            return this._isReleased;
        }// end function

        public function isDown() : Boolean
        {
            return this._isDown;
        }// end function

        public function getPosition() : Vec2
        {
            return this._pos;
        }// end function

        public function getPressPosition() : Vec2
        {
            return this._pressPos;
        }// end function

        public function getReleasePosition() : Vec2
        {
            return this._releasePos;
        }// end function

    }
}
