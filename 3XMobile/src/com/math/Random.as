package com.math
{

    public class Random extends Object
    {
        private var _mtRandom:MtRandom;

        public function Random(param1:MtRandom = null)
        {
            if (param1 == null)
            {
                param1 = new MtRandom(new Date().getTime());
            }
            this._mtRandom = param1;
            return;
        }// end function

        public function getMt() : MtRandom
        {
            return this._mtRandom;
        }// end function

        public function getIntBetween(param1:int, param2:int) : int
        {
            var _loc_3:* = param2 - param1;
            return param1 + this._mtRandom.nextInt(_loc_3);
        }// end function

        public function arrayChoice(param1:Array):Object
        {
            return param1[this._mtRandom.nextInt(param1.length)];
        }// end function

        public function sample(param1:Array, param2:int) : Array
        {
            var _loc_3:* = param1.concat();
            this.shuffle(_loc_3);
            _loc_3.splice(param2);
            return _loc_3;
        }// end function

        public function choiceExclude(param1:Array, param2:Array):Object
        {
            return this.arrayChoice(exclude(param1, param2));
        }// end function

        public function shuffle(param1:Array) : void
        {
            var _loc_3:int = 0;
            var _loc_4:* = undefined;
            var _loc_2:* = param1.length;
            while (--_loc_2 != 0)
            {
                
                _loc_3 = this._mtRandom.nextInt((_loc_2 + 1));
                _loc_4 = param1[_loc_2];
                param1[_loc_2] = param1[_loc_3];
                param1[_loc_3] = _loc_4;
            }
            return;
        }// end function

        public static function exclude(param1:Array, param2:Array) : Array
        {
            var _loc_5:int = 0;
            var _loc_3:* = param1.concat();
            var _loc_4:int = 0;
            while (_loc_4 < param2.length)
            {
                
                _loc_5 = _loc_3.indexOf(param2[_loc_4]);
                if (_loc_5 >= 0)
                {
                    _loc_3.splice(_loc_5, 1);
                }
                _loc_4++;
            }
            return _loc_3;
        }// end function

    }
}
