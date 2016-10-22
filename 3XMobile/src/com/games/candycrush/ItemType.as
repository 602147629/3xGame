package com.games.candycrush
{
    import com.games.candycrush.board.Item;

    public class ItemType
    {
		public static const INVALID:int = -1;
        public static const NONE:int = 0;
        public static const DIAMOND:int = 8;
        public static const COLOR:int = 32;
        public static const LINE:int = 16;
        public static const COLUMN:int = 128;
		
		
        public static const MIX_COLOR_LINE:int = 555;
        public static const MIX_LINE_WRAP:int = 777;
        public static const MIX_COLOR_COLOR:int = 888;
        public static const MIX_COLOR_WRAP:int = 999;

        public function ItemType()
        {
            return;
        }// end function

        public static function isDiamond(type:int) : Boolean
        {
            return type == DIAMOND;
        }// end function

        public static function isColorBomb(type:int) : Boolean
        {
            return type == COLOR;
        }// end function

        public static function isLineBomb(type:int) : Boolean
        {
            return type == LINE;
        }// end function

        public static function isColumnBomb(type:int) : Boolean
        {
            return type == COLUMN;
        }// end function

        public static function isStripes4conected(param1:int) : Boolean
        {
            return param1 == LINE || param1 == COLUMN;
        }// end function

        public static function isNormalWrap(param1:Item) : Boolean
        {
            return !param1.isTemp() && isDiamond(param1.special);
        }// end function

        public static function isNormalColor(item:Item) : Boolean
        {
            return !item.isTemp() && isColorBomb(item.special);
        }// end function

        public static function isNormalStripes(item:Item) : Boolean
        {
            return !item.isTemp() && isStripes4conected(item.special);
        }// end function

        public static function isColorLineMix(param1:int) : Boolean
        {
            return param1 == MIX_COLOR_LINE;
        }// end function

        public static function isLineWrapMix(param1:int) : Boolean
        {
            return param1 == MIX_LINE_WRAP;
        }// end function

        public static function isColorColorMix(param1:int) : Boolean
        {
            return param1 == MIX_COLOR_COLOR;
        }// end function

        public static function isColorWrapMix(param1:int) : Boolean
        {
            return param1 == MIX_COLOR_WRAP;
        }// end function

        public static function getSpecialTypes(type:int) : Array
        {
            var types:Array = [];
            if (type & ItemType.DIAMOND)
            {
                types.push(ItemType.DIAMOND);
            }
            if (type & ItemType.LINE)
            {
                types.push(ItemType.LINE);
            }
            if (type & ItemType.COLUMN)
            {
                types.push(ItemType.COLUMN);
            }
            if (type & ItemType.COLOR)
            {
                types.push(ItemType.COLOR);
            }
            return types;
        }// end function

        public static function getAsString(type:int) : String
        {
            if (type == COLOR)
            {
                return "COLOR";
            }
            if (type == LINE)
            {
                return "DIAMOND";
            }
            if (type == DIAMOND)
            {
                return "WRAP";
            }
            if (type == COLUMN)
            {
                return "COLUMN";
            }
            return "NONE";
        }// end function

    }
}
