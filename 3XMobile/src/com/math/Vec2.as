package com.math
{

    public class Vec2 extends Object
    {
        public var x:Number = 0;
        public var y:Number = 0;
        public static const Epsilon:Number = 1e-007;
        public static const EpsilonSqr:Number = 1e-014;
        private static const _RadsToDeg:Number = 57.2958;

        public function Vec2(x_:Number = 0, y_:Number = 0)
        {
            this.x = x_;
            this.y = y_;
            return;
        }// end function

        public function equals(pos:Vec2) : Boolean
        {
            return this.x == pos.x && this.y == pos.y;
        }// end function

        public function equalsXY(dx:Number, dy:Number) : Boolean
        {
            return this.x == dx && this.y == dy;
        }// end function

        public function copy(param1:Vec2) : void
        {
            this.x = param1.x;
            this.y = param1.y;
            return;
        }// end function

        public function copyXY(param1:Number, param2:Number) : void
        {
            this.x = param1;
            this.y = param2;
            return;
        }// end function

        public function add(param1:Vec2) : Vec2
        {
            return new Vec2(this.x + param1.x, this.y + param1.y);
        }// end function

        public function sub(param1:Vec2) : Vec2
        {
            return new Vec2(this.x - param1.x, this.y - param1.y);
        }// end function

        public function mul(param1:Vec2) : Vec2
        {
            return new Vec2(this.x * param1.x, this.y * param1.y);
        }// end function

        public function div(param1:Vec2) : Vec2
        {
            return new Vec2(this.x / param1.x, this.y / param1.y);
        }// end function

        public function addSelf(param1:Vec2) : void
        {
            this.x = this.x + param1.x;
            this.y = this.y + param1.y;
            return;
        }// end function

        public function subSelf(param1:Vec2) : void
        {
            this.x = this.x - param1.x;
            this.y = this.y - param1.y;
            return;
        }// end function

        public function mulSelf(param1:Vec2) : void
        {
            this.x = this.x * param1.x;
            this.y = this.y * param1.y;
            return;
        }// end function

        public function divSelf(param1:Vec2) : void
        {
            this.x = this.x / param1.x;
            this.y = this.y / param1.y;
            return;
        }// end function

        public function addXY(param1:Number, param2:Number) : Vec2
        {
            return new Vec2(this.x + param1, this.y + param2);
        }// end function

        public function subXY(param1:Number, param2:Number) : Vec2
        {
            return new Vec2(this.x - param1, this.y - param2);
        }// end function

        public function addXYSelf(param1:Number, param2:Number) : void
        {
            this.x = this.x + param1;
            this.y = this.y + param2;
            return;
        }// end function

        public function subXYSelf(param1:Number, param2:Number) : void
        {
            this.x = this.x - param1;
            this.y = this.y - param2;
            return;
        }// end function

        public function dot(param1:Vec2) : Number
        {
            return this.x * param1.x + this.y * param1.y;
        }// end function

        public function dotXY(param1:Number, param2:Number) : Number
        {
            return this.x * param1 + this.y * param2;
        }// end function

        public function scale(param1:Number) : Vec2
        {
            return new Vec2(this.x * param1, this.y * param1);
        }// end function

        public function scaleSelf(param1:Number) : void
        {
            this.x = this.x * param1;
            this.y = this.y * param1;
            return;
        }// end function

        public function get length() : Number
        {
            return Math.sqrt(this.x * this.x + this.y * this.y);
        }// end function

        public function get lengthSqr() : Number
        {
            return this.x * this.x + this.y * this.y;
        }// end function

        public function distance(param1:Vec2) : Number
        {
            var _loc_2:* = this.x - param1.x;
            var _loc_3:* = this.y - param1.y;
            return Math.sqrt(_loc_2 * _loc_2 + _loc_3 * _loc_3);
        }// end function

        public function distanceSqr(param1:Vec2) : Number
        {
            var _loc_2:* = this.x - param1.x;
            var _loc_3:* = this.y - param1.y;
            return _loc_2 * _loc_2 + _loc_3 * _loc_3;
        }// end function

        public function normalize() : Vec2
        {
            var _loc_1:* = 1 / Math.sqrt(this.x * this.x + this.y * this.y);
            return new Vec2(this.x * _loc_1, this.y * _loc_1);
        }// end function

        public function normalizeSelf() : void
        {
            var _loc_1:* = 1 / Math.sqrt(this.x * this.x + this.y * this.y);
            this.x = this.x * _loc_1;
            this.y = this.y * _loc_1;
            return;
        }// end function

        public function isNormalized() : Boolean
        {
            return Math.abs(1 - (this.x * this.x + this.y * this.y)) < Vec2.EpsilonSqr;
        }// end function

        public function isValid() : Boolean
        {
            return this.x != Infinity && this.x != -Infinity && this.y != Infinity && this.y != -Infinity && !isNaN(this.x) && !isNaN(this.y);
        }// end function

        public function isNear(param1:Vec2) : Boolean
        {
            return this.distanceSqr(param1) < EpsilonSqr;
        }// end function

        public function clone() : Vec2
        {
            return new Vec2(this.x, this.y);
        }// end function

        public function normalRight() : Vec2
        {
            return new Vec2(-this.y, this.x);
        }// end function

        public function normalLeft() : Vec2
        {
            return new Vec2(this.y, -this.x);
        }// end function

        public function normalRightSelf() : void
        {
            var _loc_1:* = this.x;
            this.x = -this.y;
            this.y = _loc_1;
            return;
        }// end function

        public function normalLeftSelf() : void
        {
            var _loc_1:* = this.x;
            this.x = this.y;
            this.y = -_loc_1;
            return;
        }// end function

        public function negate() : Vec2
        {
            return new Vec2(-this.x, -this.y);
        }// end function

        public function negateSelf() : void
        {
            this.x = -this.x;
            this.y = -this.y;
            return;
        }// end function

        public function crossDet(param1:Vec2) : Number
        {
            return this.x * param1.y - param1.x * this.y;
        }// end function

        public function crossDetXY(param1:Number, param2:Number) : Number
        {
            return this.x * param2 - param1 * this.y;
        }// end function

        public function rotate(param1:Number) : Vec2
        {
            var _loc_2:* = XPMath.cos(param1);
            var _loc_3:* = XPMath.sin(param1);
            return new Vec2(_loc_2 * this.x - _loc_3 * this.y, _loc_3 * this.x + _loc_2 * this.y);
        }// end function

        public function rotateSelf(param1:Number) : void
        {
            var _loc_2:Number = NaN;
            var _loc_3:Number = NaN;
            _loc_2 = XPMath.cos(param1);
            _loc_3 = XPMath.sin(param1);
            var _loc_4:* = _loc_2 * this.x - _loc_3 * this.y;
            this.y = _loc_3 * this.x + _loc_2 * this.y;
            this.x = _loc_4;
            return;
        }// end function

        public function rotateComplex(param1:Vec2) : Vec2
        {
            return new Vec2(this.x * param1.x - this.y * param1.y, this.x * param1.y + this.y * param1.x);
        }// end function

        public function rotateComplexSelf(param1:Vec2) : void
        {
            var _loc_2:* = this.x * param1.x - this.y * param1.y;
            this.y = this.x * param1.y + this.y * param1.x;
            this.x = _loc_2;
            return;
        }// end function

        public function reflect(param1:Vec2) : Vec2
        {
            var _loc_2:Vec2 = null;
            _loc_2 = param1.normalize();
            var _loc_3:* = this.dot(_loc_2);
            return _loc_2.scale(2 * _loc_3).sub(this);
        }// end function

        public function lerp(param1:Vec2, param2:Number) : Vec2
        {
            return new Vec2(this.x + (param1.x - this.x) * param2, this.y + (param1.y - this.y) * param2);
        }// end function

        public function slerp(param1:Vec2, param2:Number) : Vec2
        {
            var _loc_4:Number = NaN;
            var _loc_3:* = this.dot(param1);
            if (_loc_3 > 1 - Epsilon)
            {
                return param1.clone();
            }
            if (_loc_3 < -1 + Epsilon)
            {
                return this.lerp(param1, param2);
            }
            _loc_4 = Math.abs(Math.acos(_loc_3));
            var _loc_5:* = XPMath.sin(_loc_4);
            var _loc_6:* = XPMath.sin(_loc_4 * param2);
            var _loc_7:* = XPMath.sin((1 - param2) * _loc_4);
            return new Vec2((this.x * _loc_7 + param1.x * _loc_6) / _loc_5, (this.y * _loc_7 + param1.y * _loc_6) / _loc_5);
        }// end function

        public function cwDegreesBetween(param1:Vec2) : Number
        {
            return this.cwRadiansBetween(param1) * _RadsToDeg;
        }// end function

        public function cwRadiansBetween(param1:Vec2) : Number
        {
            var _loc_2:* = XPMath.atan2(this.crossDet(param1), this.dot(param1));
            return _loc_2 >= 0 ? (_loc_2) : (2 * Math.PI + _loc_2);
        }// end function

        public function toString() : String
        {
            return "(" + this.x + ", " + this.y + ")";
        }// end function

    }
}
