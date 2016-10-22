package com.midasplayer.engine.playdata
{
    import __AS3__.vec.*;
    import com.midasplayer.debug.*;

    public class PlayDataParser extends Object
    {
        private const _entries:Vector.<IPlayData>;

        public function PlayDataParser(param1:String, param2:IPlayDataFactory)
        {
            var _loc_3:XML = null;
            var _loc_4:XMLList = null;
            var _loc_6:String = null;
            this._entries = new Vector.<IPlayData>;
            Debug.assert(param2 != null, "The play data factory is null.");
            Debug.assert(param1 != null, "The play data is null.");
            _loc_3 = new XML(param1);
            Debug.assert(_loc_3.length() == 1, "The play data XML should only have 1 root child.");
            _loc_4 = _loc_3.child("gameover");
            Debug.assert(_loc_4.length() == 1, "Expected exactly one game over element in playdata.");
            var _loc_5:* = _loc_4.child("entry");
            for each (_loc_6 in _loc_5)
            {
                
                this._entries.push(param2.create(_loc_6));
            }
            return;
        }// end function

        public function getEntries() : Vector.<IPlayData>
        {
            return this._entries;
        }// end function

    }
}
