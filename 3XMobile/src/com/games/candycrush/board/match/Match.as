package com.games.candycrush.board.match
{
    import com.games.candycrush.board.Item;
    import com.games.candycrush.input.SwapInfo;

    public class Match
    {
        public var x:int;
        public var y:int;
        public var west:int;
        public var east:int;
        public var north:int;
        public var south:int;
        public var creationItem:Item = null;
        public var associatedSwap:SwapInfo = null;
        private var _patternId:int = -1;
        public var color:int;

        public function Match(x_:int, y_:int, west_:int, east_:int, north_:int, south_:int, color_:int = -1)
        {
            this.x = x_;
            this.y = y_;
            this.west = west_;
            this.east = east_;
            this.north = north_;
            this.south = south_;
            this.color = color_;
        }

        public function get width() : int
        {
            return this.east - this.west +1;
        }// end function

        public function get height() : int
        {
            return this.south - this.north + 1;
        }// end function

        public function get size() : int
        {
            return this.east + this.south - this.west - this.north + 1;
        }
		public function get patternId():int
		{
			return _patternId;
		}

		public function set patternId(value:int):void
		{
			_patternId = value;
		}
    }
}
