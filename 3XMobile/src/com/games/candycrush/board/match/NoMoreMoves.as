package com.games.candycrush.board.match
{
    import com.games.candycrush.board.Board;
    
    import __AS3__.vec.Vector;

    public class NoMoreMoves extends Object
    {

        public function NoMoreMoves()
        {
            return;
        }// end function

        public static function linear3(param1:Vector.<Vector.<int>>, board:Board) : Boolean
        {
            return new Linear3Checker(param1, board).hasMoreMoves();
        }// end function

        public static function linear3match(param1:Vector.<Vector.<int>>, board:Board) : Array
        {
            return new Linear3Checker(param1, board).getHintMove();
        }// end function

    }
}
import com.games.candycrush.board.Board;
import com.games.candycrush.board.Item;

import flash.geom.Point;

import framework.model.ConstantItem;

class Linear3Checker
{
    private var _mapColor:Vector.<Vector.<int>>;
    private var _width:int;
    private var _height:int;
	private var _board:Board;
    public function Linear3Checker(map:Vector.<Vector.<int>>, board:Board)
    {
        this._mapColor = map;
        this._width = map[0].length;
        this._height = map.length;
		_board = board;
        return;
    }// end function

    public function hasMoreMoves() : Boolean
    {
        var rowIndex:int = 0;
        var gridLeft:int = 0;
        var gridUp:int = 0;
        var gridRight:int = 0;
        var gridDown:int = 0;
        var colIndex:int = 0;
        while (colIndex < this._width)
        {
            
            rowIndex = 0;
            while (rowIndex < this._height)
            {
				
				var item:Item = _board.getGridItem(colIndex, rowIndex);
				//has vine can not move
				if(item == null || !item.isCanMove)
				{
					++rowIndex;
					continue;
				}
				
				/*if(getType(colIndex, rowIndex) == -1)
				{
					++rowIndex;
					continue;
				}*/
					
                gridLeft = this.getType((colIndex - 1), rowIndex);
				var leftItem:Item = _board.getGridItem((colIndex - 1), rowIndex);
				
                gridUp = this.getType(colIndex, (rowIndex - 1));
				var upItem:Item = _board.getGridItem(colIndex, (rowIndex - 1));
				
                gridRight = this.getType((colIndex + 1), rowIndex);
				var rightItem:Item = _board.getGridItem((colIndex + 1), rowIndex);
				
                gridDown = this.getType(colIndex, (rowIndex + 1));
				var downItem:Item = _board.getGridItem(colIndex, (rowIndex + 1));
				
                if (gridLeft >=0 && gridLeft == gridUp /*&& (this.getType(colIndex - 2, rowIndex) == gridLeft || this.getType(colIndex, rowIndex - 2) == gridLeft)*/)
                {
					if(this.getType(colIndex - 2, rowIndex) == gridLeft && upItem.isCanMove &&!upItem.isHasRopeV())
					{
						return true;
					}
					if(this.getType(colIndex, rowIndex - 2) == gridLeft && leftItem.isCanMove && !item.isHasRopeH())
					{						
	                    return true;
					}
                }
                if (gridUp >= 0 && gridUp == gridRight /*&& (this.getType(colIndex, rowIndex - 2) == gridUp || this.getType(colIndex + 2, rowIndex) == gridUp)*/)
                {
					if(this.getType(colIndex, rowIndex - 2) == gridUp && rightItem.isCanMove && !rightItem.isHasRopeH())
					{
						return true;
					}
					if(this.getType(colIndex + 2, rowIndex) == gridUp && upItem.isCanMove && !upItem.isHasRopeV())
					{						
	                    return true;
					}
                }
                if (gridRight >= 0 && gridRight == gridDown /*&& (this.getType(colIndex + 2, rowIndex) == gridRight || this.getType(colIndex, rowIndex + 2) == gridRight)*/)
                {
					if(this.getType(colIndex + 2, rowIndex) == gridRight && downItem.isCanMove && !item.isHasRopeV())
					{
						return true;
					}
					if(this.getType(colIndex, rowIndex + 2) == gridRight && rightItem.isCanMove && !rightItem.isHasRopeH())
					{					
	                    return true;
					}
                }
                if (gridDown >=0 &&gridDown == gridLeft /*&& (this.getType(colIndex, rowIndex + 2) == gridDown || this.getType(colIndex - 2, rowIndex) == gridDown)*/)
                {
					if(this.getType(colIndex, rowIndex + 2) == gridDown && leftItem.isCanMove && !item.isHasRopeH())
					{
						return true;
					}
					if(this.getType(colIndex - 2, rowIndex) == gridDown && downItem.isCanMove && !item.isHasRopeV())
					{
						
	                    return true;
					}
                }
                if (gridLeft >=0 &&gridLeft == gridRight && (
					(gridDown == gridLeft && downItem.isCanMove && !item.isHasRopeV()) || (gridUp == gridLeft && upItem.isCanMove &&!upItem.isHasRopeV()) 
					|| (this.getType(colIndex - 2, rowIndex) == gridLeft && rightItem.isCanMove &&!rightItem.isHasRopeH()) 
					|| this.getType(colIndex + 2, rowIndex) == gridLeft && leftItem.isCanMove && !item.isHasRopeH()))
                {
                    return true;
                }
                if (gridUp >= 0 && gridUp == gridDown && ((gridLeft == gridUp && leftItem.isCanMove && !item.isHasRopeH()) ||
					(gridRight == gridUp && rightItem.isCanMove && !rightItem.isHasRopeH()) 
					|| (this.getType(colIndex, rowIndex - 2) == gridUp && downItem.isCanMove && !item.isHasRopeV()) 
					|| (this.getType(colIndex, rowIndex + 2) == gridUp && upItem.isCanMove && !upItem.isHasRopeV())))
                {
                    return true;
                }
                rowIndex++;
            }
            colIndex++;
        }
        return false;
    }
	
	public function getHintMove():Array
	{
		var rowIndex:int = 0;
		var gridLeft:int = 0;
		var gridUp:int = 0;
		var gridRight:int = 0;
		var gridDown:int = 0;
		var colIndex:int = 0;
		while (colIndex < this._width)
		{
			
			rowIndex = 0;
			while (rowIndex < this._height)
			{
				/*if(getType(colIndex, rowIndex) == -1)
				{
					++rowIndex;
					continue;
				}*/
				
				var item:Item = _board.getGridItem(colIndex, rowIndex);
				//has vine can not move
				if(item == null || !item.isCanMove)
				{
					++rowIndex;
					continue;
				}
				
				gridLeft = this.getType((colIndex - 1), rowIndex);
				var leftItem:Item = _board.getGridItem((colIndex - 1), rowIndex);
				
				gridUp = this.getType(colIndex, (rowIndex - 1));
				var upItem:Item = _board.getGridItem(colIndex, (rowIndex - 1));
				
				gridRight = this.getType((colIndex + 1), rowIndex);
				var rightItem:Item = _board.getGridItem((colIndex + 1), rowIndex);
				
				gridDown = this.getType(colIndex, (rowIndex + 1));
				var downItem:Item = _board.getGridItem(colIndex, (rowIndex + 1));
				
				if (gridLeft >=0 && gridLeft == gridUp /*&& (this.getType(colIndex - 2, rowIndex) == gridLeft || this.getType(colIndex, rowIndex - 2) == gridLeft)*/)
				{
					if(this.getType(colIndex - 2, rowIndex) == gridLeft && upItem.isCanMove &&!upItem.isHasRopeV())
					{
						return [new Point(upItem.x, upItem.y), ConstantItem.DIRECTOIN_V];
					}
					if(this.getType(colIndex, rowIndex - 2) == gridLeft && leftItem.isCanMove && !item.isHasRopeH())
					{						
						return [new Point(leftItem.x, leftItem.y), ConstantItem.DIRECTION_H];
					}
				}
				if (gridUp >= 0 && gridUp == gridRight /*&& (this.getType(colIndex, rowIndex - 2) == gridUp || this.getType(colIndex + 2, rowIndex) == gridUp)*/)
				{
					if(this.getType(colIndex, rowIndex - 2) == gridUp && rightItem.isCanMove && !rightItem.isHasRopeH())
					{
						return [new Point(item.x, item.y), ConstantItem.DIRECTION_H];
					}
					if(this.getType(colIndex + 2, rowIndex) == gridUp && upItem.isCanMove && !upItem.isHasRopeV())
					{						
						return [new Point(upItem.x, upItem.y), ConstantItem.DIRECTOIN_V];
					}
				}
				if (gridRight >= 0 && gridRight == gridDown /*&& (this.getType(colIndex + 2, rowIndex) == gridRight || this.getType(colIndex, rowIndex + 2) == gridRight)*/)
				{
					if(this.getType(colIndex + 2, rowIndex) == gridRight && downItem.isCanMove && !item.isHasRopeV())
					{
						return [new Point(item.x, item.y), ConstantItem.DIRECTOIN_V];
					}
					if(this.getType(colIndex, rowIndex + 2) == gridRight && rightItem.isCanMove && !rightItem.isHasRopeH())
					{					
						return [new Point(item.x, item.y), ConstantItem.DIRECTION_H];
					}
				}
				if (gridDown >=0 &&gridDown == gridLeft /*&& (this.getType(colIndex, rowIndex + 2) == gridDown || this.getType(colIndex - 2, rowIndex) == gridDown)*/)
				{
					if(this.getType(colIndex, rowIndex + 2) == gridDown && leftItem.isCanMove && !item.isHasRopeH())
					{
						return [new Point(leftItem.x, leftItem.y), ConstantItem.DIRECTION_H];
					}
					if(this.getType(colIndex - 2, rowIndex) == gridDown && downItem.isCanMove && !item.isHasRopeV())
					{						
						return [new Point(item.x, item.y), ConstantItem.DIRECTOIN_V];
					}
				}
				if (gridLeft >=0 &&gridLeft == gridRight)
				{	
					if(gridDown == gridLeft && downItem.isCanMove && !item.isHasRopeV())
					{
						return [new Point(item.x, item.y), ConstantItem.DIRECTOIN_V];
					}
					if(gridUp == gridLeft && upItem.isCanMove &&!upItem.isHasRopeV())
					{
						return [new Point(upItem.x, upItem.y), ConstantItem.DIRECTOIN_V];
					}
					if(this.getType(colIndex - 2, rowIndex) == gridLeft && rightItem.isCanMove &&!rightItem.isHasRopeH()) 
					{
						return [new Point(item.x, item.y), ConstantItem.DIRECTION_H];
					}
					if(this.getType(colIndex + 2, rowIndex) == gridLeft && leftItem.isCanMove && !item.isHasRopeH())
					{
						return [new Point(leftItem.x, leftItem.y), ConstantItem.DIRECTION_H];
					}
				}
				if (gridUp >= 0 && gridUp == gridDown)
				{
					if(gridLeft == gridUp && leftItem.isCanMove && !item.isHasRopeH())
					{
						return [new Point(leftItem.x, leftItem.y), ConstantItem.DIRECTION_H];
					}
					if(gridRight == gridUp && rightItem.isCanMove && !rightItem.isHasRopeH()) 
					{
						return [new Point(item.x, item.y), ConstantItem.DIRECTION_H];
					}
					if(this.getType(colIndex, rowIndex - 2) == gridUp && downItem.isCanMove && !item.isHasRopeV()) 
					{
						return [new Point(item.x, item.y), ConstantItem.DIRECTOIN_V];	
					}
					if(this.getType(colIndex, rowIndex + 2) == gridUp && upItem.isCanMove && !upItem.isHasRopeV())
					{
						return [new Point(upItem.x, upItem.y), ConstantItem.DIRECTOIN_V];
					}
				}
				rowIndex++;
			}
			colIndex++;
		}
		return null;
	}
	

    /*public function getMove() : Array
    {
        var rowIndex:int = 0;
        var leftColor:int = 0;
        var upColor:int = 0;
        var rightColor:int = 0;
        var downColor:int = 0;
        var leftPosition:Point = new Point();
        var upPosition:Point = new Point();
        var rightPosition:Point = new Point();
        var downPosition:Point = new Point();
        var colIndex:int = 0;
        while (colIndex < this._width)
        {
            
            rowIndex = 0;
            while (rowIndex < this._height)
            {
                
                leftPosition.x = colIndex - 1;
                leftPosition.y = rowIndex;
                leftColor = this.getType((colIndex - 1), rowIndex);
                upPosition.x = colIndex;
                upPosition.y = rowIndex - 1;
                upColor = this.getType(colIndex, (rowIndex - 1));
                rightPosition.x = colIndex + 1;
                rightPosition.y = rowIndex;
                rightColor = this.getType((colIndex + 1), rowIndex);
                downPosition.x = colIndex;
                downPosition.y = rowIndex + 1;
                downColor = this.getType(colIndex, (rowIndex + 1));
                if (leftColor == upColor)
                {
                    if (this.getType(colIndex - 2, rowIndex) == leftColor)
                    {
                        return [leftPosition, upPosition, new IntCoord(colIndex - 2, rowIndex)];
                    }
                    if (this.getType(colIndex, rowIndex - 2) == leftColor)
                    {
                        return [leftPosition, upPosition, new IntCoord(colIndex, rowIndex - 2)];
                    }
                }
                if (upColor == rightColor)
                {
                    if (this.getType(colIndex, rowIndex - 2) == upColor)
                    {
                        return [upPosition, rightPosition, new IntCoord(colIndex, rowIndex - 2)];
                    }
                    if (this.getType(colIndex + 2, rowIndex) == upColor)
                    {
                        return [upPosition, rightPosition, new IntCoord(colIndex + 2, rowIndex)];
                    }
                }
                if (rightColor == downColor)
                {
                    if (this.getType(colIndex + 2, rowIndex) == rightColor)
                    {
                        return [rightPosition, downPosition, new IntCoord(colIndex + 2, rowIndex)];
                    }
                    if (this.getType(colIndex, rowIndex + 2) == rightColor)
                    {
                        return [rightPosition, downPosition, new IntCoord(colIndex, rowIndex + 2)];
                    }
                }
                if (downColor == leftColor)
                {
                    if (this.getType(colIndex, rowIndex + 2) == downColor)
                    {
                        return [downPosition, leftPosition, new IntCoord(colIndex, rowIndex + 2)];
                    }
                    if (this.getType(colIndex - 2, rowIndex) == downColor)
                    {
                        return [downPosition, leftPosition, new IntCoord(colIndex - 2, rowIndex)];
                    }
                }
                if (leftColor == rightColor)
                {
                    if (downColor == leftColor)
                    {
                        return [leftPosition, rightPosition, downPosition];
                    }
                    if (upColor == leftColor)
                    {
                        return [leftPosition, rightPosition, upPosition];
                    }
                    if (this.getType(colIndex - 2, rowIndex) == leftColor)
                    {
                        return [leftPosition, rightPosition, new IntCoord(colIndex - 2, rowIndex)];
                    }
                    if (this.getType(colIndex + 2, rowIndex) == leftColor)
                    {
                        return [leftPosition, rightPosition, new IntCoord(colIndex + 2, rowIndex)];
                    }
                }
                if (upColor == downColor)
                {
                    if (leftColor == upColor)
                    {
                        return [upPosition, downPosition, leftPosition];
                    }
                    if (rightColor == upColor)
                    {
                        return [upPosition, downPosition, rightPosition];
                    }
                    if (this.getType(colIndex, rowIndex - 2) == upColor)
                    {
                        return [upPosition, downPosition, new IntCoord(colIndex, rowIndex - 2)];
                    }
                    if (this.getType(colIndex, rowIndex + 2) == upColor)
                    {
                        return [upPosition, downPosition, new IntCoord(colIndex, rowIndex + 2)];
                    }
                }
                rowIndex++;
            }
            colIndex++;
        }
        return null;
    }*/

    private function getType(gridX:int, gridY:int) : int
    {
        if (gridX < 0)
        {
            return -2;
        }
        if (gridY < 0)
        {
            return -3;
        }
        if (gridX >= this._width)
        {
            return -4;
        }
        if (gridY >= this._height)
        {
            return -5;
        }
        return this._mapColor[gridY][gridX];
    }// end function

}

