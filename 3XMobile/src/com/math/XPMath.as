package com.math
{

    public class XPMath 
    {

        public function XPMath()
        {
            return;
        }// end function

        public static function atan2(param1:Number, param2:Number) : Number
        {
            var _loc_5:Number = NaN;
            var _loc_3:Number = 3.14159;
            var _loc_4:Number = 1.5708;
            if (param2 == 0)
            {
                if (param1 > 0)
                {
                    return _loc_4;
                }
                if (param1 == 0)
                {
                    return 0;
                }
                return -_loc_4;
            }
            var _loc_6:* = param1 / param2;
            if (Math.abs(_loc_6) < 1)
            {
                _loc_5 = _loc_6 / (1 + 0.28 * _loc_6 * _loc_6);
                if (param2 < 0)
                {
                    if (param1 < 0)
                    {
                        return _loc_5 - _loc_3;
                    }
                    return _loc_5 + _loc_3;
                }
            }
            else
            {
                _loc_5 = _loc_4 - _loc_6 / (_loc_6 * _loc_6 + 0.28);
                if (param1 < 0)
                {
                    return _loc_5 - _loc_3;
                }
            }
            return _loc_5;
        }// end function

        public static function cos(param1:Number) : Number
        {
            var _loc_2:int = 0;
            var _loc_3:Number = param1 > 0 ? (param1) : (-param1);
            var _loc_4:Number = 1.5708;
            if (_loc_3 >= 12.5664 + _loc_4)
            {
                _loc_2 = int(_loc_3 * 0.63662);
                if ((_loc_2 & 1) != 0)
                {
                    _loc_2++;
                }
                _loc_3 = _loc_3 - _loc_2 * _loc_4;
            }
            else if (_loc_3 < _loc_4)
            {
            }
            else if (_loc_3 < _loc_4 + 3.14159)
            {
                _loc_3 = _loc_3 - 3.14159;
                _loc_2 = 2;
            }
            else if (_loc_3 < 6.28319 + _loc_4)
            {
                _loc_3 = _loc_3 - 6.28319;
            }
            else if (_loc_3 < 9.42478 + _loc_4)
            {
                _loc_3 = _loc_3 - 9.42478;
                _loc_2 = 2;
            }
            else
            {
                _loc_3 = _loc_3 - 12.5664;
            }
            var _loc_5:* = _loc_3 * _loc_3;
            var _loc_6:* = 1 + _loc_5 * (-0.499999 + _loc_5 * (0.0416636 + _loc_5 * (-0.00138536 + _loc_5 * 2.31524e-005)));
            return (_loc_2 & 2) != 0 ? (-_loc_6) : (_loc_6);
        }// end function

        public static function sin(param1:Number) : Number
        {
            param1 = param1 - 1.5708;
            var _loc_2:int = 0;
            var _loc_3:Number = param1 > 0 ? (param1) : (-param1);
            if (_loc_3 >= 12.5664 + 1.5708)
            {
                _loc_2 = int(_loc_3 * 0.63662);
                if ((_loc_2 & 1) != 0)
                {
                    _loc_2++;
                }
                _loc_3 = _loc_3 - _loc_2 * 1.5708;
            }
            else if (_loc_3 < 1.5708)
            {
            }
            else if (_loc_3 < 1.5708 + 3.14159)
            {
                _loc_3 = _loc_3 - 3.14159;
                _loc_2 = 2;
            }
            else if (_loc_3 < 6.28319 + 1.5708)
            {
                _loc_3 = _loc_3 - 6.28319;
            }
            else if (_loc_3 < 9.42478 + 1.5708)
            {
                _loc_3 = _loc_3 - 9.42478;
                _loc_2 = 2;
            }
            else
            {
                _loc_3 = _loc_3 - 12.5664;
            }
            var _loc_4:Number = _loc_3 * _loc_3;
            var _loc_5:Number = 1 + _loc_4 * (-0.499999 + _loc_4 * (0.0416636 + _loc_4 * (-0.00138536 + _loc_4 * 2.31524e-005)));
            return (_loc_2 & 2) != 0 ? (-_loc_5) : (_loc_5);
        }// end function

    }
}
