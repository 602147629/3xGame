package com.games.candycrush.board.match
{
    import com.games.candycrush.board.Board;
    import com.games.candycrush.board.Item;
    
    import __AS3__.vec.Vector;

    public class OrthoPatternMatcher
    {
        private var _mPicInt:Vector.<Vector.<int>>;
        private var _width:int;
        private var _height:int;
        private var _minMatch:int;
        private var _matchPatterns:Array;

        public function OrthoPatternMatcher(vectors:Vector.<Vector.<int>>, patterns:Array, minMatch:int)
        {
            this._mPicInt = vectors;
            this._width = vectors[0].length;
            this._height = vectors.length;
            this._minMatch = minMatch;
            this._matchPatterns = patterns;
            
        }// end function

        private function get(col:int, row:int) : int
        {
            return this._mPicInt[row][col];
        }
		
		public function testMatchXY(picType:int, gridX:int, gridY:int):Match
		{
			var searchLeftIndex:int = gridX;
			var searchRightIndex:int = gridX;
			while (--searchLeftIndex >= 0)
			{
				
				if (picType != get(searchLeftIndex, gridY))
				{
					break;
				}
			}
			searchLeftIndex++;
			
			while (++searchRightIndex < this._width)
			{
				
				if (picType != get(searchRightIndex, gridY))
				{
					break;
				}
			}
			
			searchRightIndex = searchRightIndex - 1;
			
			var searchUpIndex:int = gridY;
			var searchDownIndex:int = gridY;
			while (--searchUpIndex >= 0)
			{
				
				if (picType != this.get(gridX, searchUpIndex))
				{
					break;
				}
			}
			searchUpIndex++;
			
			while (++searchDownIndex < this._height)
			{
				
				if (picType != this.get(gridX, searchDownIndex))
				{
					break;
				}
			}
			searchDownIndex = searchDownIndex - 1;
			
			var isWidthMatch:Boolean = searchRightIndex - searchLeftIndex + 1 >= this._minMatch;
			var isHeightMatch:Boolean = searchDownIndex - searchUpIndex + 1 >= this._minMatch;
			if (isWidthMatch || isHeightMatch)
			{
				return new Match(gridX, gridY, isWidthMatch ? (searchLeftIndex) : (gridX), isWidthMatch ? (searchRightIndex) : (gridX), isHeightMatch ? (searchUpIndex) : (gridY), isHeightMatch ? (searchDownIndex) : (gridY), picType);
			}
			return null;
		}

        private function _matchXY(gridX:int, gridY:int) : Match
        {
            var picType:int = get(gridX, gridY);
			
			if(picType == Item.INVALID_COLOR)
			{
				return null;
			}
			
            return testMatchXY(picType, gridX, gridY);
        }// end function

        public function matchXY(gridX:int, gridY:int) : Match
        {
            var matchPattern:MatchPattern = null;
            var match:Match = this._matchXY(gridX, gridY);
            if (match == null)
            {
                return null;
            }
            for each (matchPattern in this._matchPatterns)
            {
                
                if (matchPattern.isMatch(match))
                {
                    return match;
                }
            }
            return null;
        }// end function

        public function matchAll() : Vector.<Match>
        {
            var pattern:MatchPattern = null;
            var westIndex:int = 0;
            var northIndex:int = 0;
            var match:Match = null;
            var dictionary:Object = {};
            var rowIndex:int = 0;
            var colIndex:int = 0;
            var matchs:Vector.<Match> = new Vector.<Match>;
            for each (pattern in this._matchPatterns)
            {
                
                rowIndex = 0;
                while (rowIndex < this._height)
                {
                    
                    colIndex = 0;
                    while (colIndex < this._width)
                    {
                        
                        if (get(colIndex, rowIndex) == Item.INVALID_COLOR || get(colIndex, rowIndex) == Item.INVALID_COLOR2|| dictionary[colIndex + this._width * rowIndex] != null)
                        {
							/*CONFIG::debug
							{
								TRACE_GRID("find pattern grid has been occupied! "+ " x: "+ colIndex+" y: "+rowIndex);
							}*/
							
                        }
                        else
                        {
                            match = this.matchXY(colIndex, rowIndex);
                            if (match != null && pattern.isMatch(match))
                            {
                                match.patternId = pattern.getId();
                                matchs.push(match);
                                westIndex = match.west;
                                while (westIndex <= match.east)
                                {
                                    
                                    dictionary[westIndex + this._width * rowIndex] = 1;
                                    westIndex++;
                                }
                                northIndex = match.north;
                                while (northIndex <= match.south)
                                {
                                    
                                    dictionary[colIndex + this._width * northIndex] = 1;
                                    northIndex++;
                                }
                            }
                        }
                        colIndex++;
                    }
                    rowIndex++;
                }
            }
            return matchs;
        }// end function

    }
}
