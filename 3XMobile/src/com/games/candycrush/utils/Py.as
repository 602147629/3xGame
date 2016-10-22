package com.games.candycrush.utils
{

    public class Py
    {

        public function Py()
        {
            return;
        }// end function

        public static function range(value:int, param2 = null, stepNumber:int = 1, param4:int = 0) : Array
        {
            var index:int = 0;
            var array:Array = [];
            if (param2 == null)
            {
                param2 = value;
                value = 0;
            }
            var _loc_6:int = -1;
            if (stepNumber > 0)
            {
                index = value;
                while (index < param2)
                {
                    
                    array[++_loc_6] = index + param4;
                    index = index + stepNumber;
                }
            }
            else
            {
                index = value;
                while (index > param2)
                {
                    
                    _loc_6 = ++_loc_6 + 1;
                    var _loc_8:int = ++_loc_6 + 1;
                    array[++_loc_6 + 1] = index + param4;
                    index = index + stepNumber;
                }
            }
            return array;
        }// end function

        public static function getSlice(param1, param2:int, param3 = null, param4:int = 1) : Array
        {
            var _loc_7:int = 0;
            if (param2 < 0 || param3 < 0)
            {
                throw new Error("Negative Indexes in getSlice@Py is not implemented yet");
            }
            var _loc_5:* = range(param2, param3, param4);
            var _loc_6:Array = [];
            for each (_loc_7 in _loc_5)
            {
                
                _loc_6.push(param1[_loc_7]);
            }
            return _loc_6;
        }// end function

        public static function multValue(param1, param2:int) : Array
        {
            var _loc_3:Array = [];
            var _loc_4:int = 0;
            while (_loc_4 < param2)
            {
                
                _loc_3.push(param1);
                _loc_4++;
            }
            return _loc_3;
        }// end function

        public static function addLists(... args) : Array
        {
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            args = [];
            var _loc_3:int = 0;
            while (_loc_3 < args.length)
            {
                
                _loc_4 = args[_loc_3];
                _loc_5 = _loc_4.length;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    args.push(_loc_4[_loc_6]);
                    _loc_6++;
                }
                _loc_3++;
            }
            return args;
        }// end function

    }
}
