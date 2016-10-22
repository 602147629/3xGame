package com.midasplayer.engine
{
    import com.midasplayer.debug.*;

    public class GameDataParser extends Object
    {
        private var _seed:int = 0;
        private var _gameData:XML;
        private var _textElements:XMLList;

        public function GameDataParser(param1:String)
        {
            Debug.assert(param1 != null, "Could not parse the game data, the xml parameter is null.");
            this._gameData = new XML(param1);
            Debug.assert(this._gameData.length() == 1, "The game data XML should only have 1 root child.");
            this._seed = parseInt(this._gameData.attribute("randomseed"));
            Debug.assert(this._seed != 0, "The game data randomseed attribute is 0, this may result in complete randomness.");
            this._textElements = this._gameData.child("text");
            return;
        }// end function

        public function getRandomSeed() : int
        {
            return this._seed;
        }// end function

        public function getText(param1:String) : String
        {
            var texts:XMLList;
            var id:* = param1;
            var _loc_4:int = 0;
            var _loc_5:* = this._textElements;
            var _loc_3:* = new XMLList("");
            for each (_loc_6 in _loc_5)
            {
                
                var _loc_7:* = _loc_5[_loc_4];
                with (_loc_5[_loc_4])
                {
                    if (@id == id)
                    {
                        _loc_3[_loc_4] = _loc_6;
                    }
                }
            }
            texts = _loc_3;
            Debug.assert(texts.length() == 1, "Could not find the text element (or found more than 1) with attribute id \'" + id + "\' in the game data.");
            return texts.text();
        }// end function

        public function getAsString(param1:String) : String
        {
            return this._getOneElement(param1).text();
        }// end function

        public function getAsInt(param1:String) : int
        {
            var _loc_2:XMLList = null;
            _loc_2 = this._getOneElement(param1);
            var _loc_3:* = parseInt(_loc_2.text());
            Debug.assert(!isNaN(_loc_3), "Could not parse a game data property as int \'" + param1 + "\' value: " + _loc_2.text());
            return int(_loc_3);
        }// end function

        public function getAsBool(param1:String) : Boolean
        {
            var _loc_2:* = this.getAsString(param1).toLowerCase();
            Debug.assert(_loc_2 == "0" || _loc_2 == "1" || _loc_2 == "false" || _loc_2 == "true", "Could not parse a boolean, the value should be \'true\', \'false\', \'0\' or \'1\'. Element: " + param1 + ", value: " + _loc_2);
            return _loc_2 == "true" || _loc_2 == "1";
        }// end function

        private function _getOneElement(param1:String) : XMLList
        {
            var _loc_2:* = this._gameData.child(param1);
            Debug.assert(_loc_2.length() == 1, "Could not find the element (or found more than 1) with the name \'" + param1 + "\' in the game data.");
            return _loc_2;
        }// end function

    }
}
