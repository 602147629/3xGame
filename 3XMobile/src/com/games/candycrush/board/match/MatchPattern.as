package com.games.candycrush.board.match
{

    public class MatchPattern
    {
        private var _w:int;
        private var _h:int;
        private var _isRotation:Boolean;//rotation
        private var _id:int;

        public function MatchPattern(id:int, width:int, height:int, isTransposable:Boolean)
        {
            this._w = width;
            this._h = height;
            this._isRotation = isTransposable;
            this._id = id;
            return;
        }// end function

        public function getId() : int
        {
            return this._id;
        }// end function

        public function isMatch(match:Match) : Boolean
        {
            return match.width >= this._w && match.height >= this._h || this._isRotation && match.height >= this._w && match.width >= this._h;
        }// end function

    }
}
