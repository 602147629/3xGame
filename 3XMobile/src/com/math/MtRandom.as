package com.math
{
    import flash.utils.*;

    public class MtRandom extends Object
    {
        private var mt:Array;
        private var mti:uint;
        private var _seed:uint;
        public static var N:int = 624;
        public static var M:int = 397;
        public static var MATRIX_A:uint = 2.56748e+009;
        public static var UPPER_MASK:uint = 2.14748e+009;
        public static var LOWER_MASK:uint = 2147483647;
        private static var mag01:Array = [uint(0), uint(MATRIX_A)];

        public function MtRandom(param1:uint = 0)
        {
            this.mti = N + 1;
            if (param1 == 0)
            {
                param1 = getTimer();
            }
            this.mt = new Array(N);
            this.setSeed(param1);
            return;
        }// end function

        public function getSeed() : uint
        {
            return this._seed;
        }// end function

        public function setSeed(param1:uint) : void
        {
            this._seed = param1;
            this.init_genrand(param1);
            return;
        }// end function

        public function nextInt(param1:uint) : uint
        {
            return (this.genrand_int32() & 2147483647) % param1;
        }// end function

        public function nextFloat() : Number
        {
            return this.next(24) / 16777216;
        }// end function

        public function nextDouble() : Number
        {
            return this.next(24) / 16777216;
        }// end function

        private function next(param1:uint) : uint
        {
            return this.genrand_int32() & (uint(1) << param1) - uint(1);
        }// end function

        private function init_genrand(param1:uint) : void
        {
            var _loc_2:uint = 0;
            var _loc_3:uint = 0;
            this.mt[0] = uint(param1);
            this.mti = 1;
            while (this.mti < N)
            {
                
                _loc_2 = this.mt[(this.mti - 1)] ^ this.mt[(this.mti - 1)] >>> 30;
                _loc_3 = uint(_loc_2 * 1289);
                _loc_3 = uint(_loc_3 * 1406077);
                _loc_3 = uint(_loc_3 + this.mti);
                this.mt[this.mti] = _loc_3;
            
                mti = mti + 1;
            }
            return;
        }// end function

        private function genrand_int32() : uint
        {
            var _loc_1:Number = NaN;
            var _loc_2:uint = 0;
            if (this.mti >= N)
            {
                if (this.mti == (N + 1))
                {
                    this.init_genrand(5489);
                }
                _loc_2 = 0;
                while (_loc_2 < N - M)
                {
                    
                    _loc_1 = this.mt[_loc_2] & UPPER_MASK | this.mt[(_loc_2 + 1)] & LOWER_MASK;
                    this.mt[_loc_2] = this.mt[_loc_2 + M] ^ _loc_1 >>> 1 ^ mag01[uint(_loc_1 & 1)];
                    _loc_2 = _loc_2 + 1;
                }
                while (_loc_2 < (N - 1))
                {
                    
                    _loc_1 = this.mt[_loc_2] & UPPER_MASK | this.mt[(_loc_2 + 1)] & LOWER_MASK;
                    this.mt[_loc_2] = this.mt[_loc_2 + (M - N)] ^ _loc_1 >>> 1 ^ mag01[uint(_loc_1 & 1)];
                    _loc_2 = _loc_2 + 1;
                }
                _loc_1 = this.mt[(N - 1)] & UPPER_MASK | this.mt[0] & LOWER_MASK;
                this.mt[(N - 1)] = this.mt[(M - 1)] ^ _loc_1 >>> 1 ^ mag01[uint(_loc_1 & 1)];
                this.mti = 0;
            }
           
            mti = this.mti + 1;
            _loc_1 = this.mt[this.mti++];
            _loc_1 = _loc_1 ^ _loc_1 >>> 11;
            _loc_1 = _loc_1 ^ _loc_1 << 7 & 2636928640;
            _loc_1 = _loc_1 ^ _loc_1 << 15 & 4022730752;
            _loc_1 = _loc_1 ^ _loc_1 >>> 18;
            return uint(_loc_1);
        }// end function

    }
}
