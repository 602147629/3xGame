package com.math
{

    public class IntCoord extends Object
    {
        public var x:int;
        public var y:int;

        public function IntCoord(param1:int = 0, param2:int = 0)
        {
            this.x = param1;
            this.y = param2;
            return;
        }// end function

//        public function unique(param1 = null, param2 = null) : int
//        {
//            if (param1 == null)
//            {
//                param1 = this.x;
//            }
//            if (param2 == null)
//            {
//                param2 = this.y;
//            }
//            return IntCoord.uniqueVal(param1, param2);
//        }// end function

        public function toString(param1:int = 0, param2:int = 0) : String
        {
            return "(" + (this.x + param1) + "," + (this.y + param2) + ")";
        }// end function

        public static function fromUnique(param1:int) : IntCoord
        {
            var _loc_2:* = param1 / 65536;
            return new IntCoord(param1 - _loc_2 * 65536, _loc_2);
        }// end function

        public static function uniqueVal(param1:int, param2:int) : int
        {
            return param2 * 65536 + param1;
        }// end function

        public static function center(array:Array) : IntCoord
        {
            var temp:IntCoord = null;
            var center:IntCoord = new IntCoord();
            var index:int = 0;
            for each (temp in array)
            {
                
                center.x = center.x + temp.x;
                center.y = center.y + temp.y;
                index++;
            }
            return new IntCoord(center.x / index, center.y / index);
        }// end function

    }
}
