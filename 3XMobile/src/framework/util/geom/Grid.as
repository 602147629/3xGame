package framework.util.geom
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	public class Grid extends Parallelogram
	{
		/**
		 * 
		 * cell:
		 * 
		 *       /\
		 *       \/
		 * 
		 * Grid:
		 * 
		 *    rowNum: 5
		 *    columnNum : 9
		 * 
		 *           xoffset
		 *           |----|
		 *         _  ______________
		 *         | |    /\        |
		 *         | |   /  \       |
		 * yoffset | |  /    \      |
		 *         | | /      \     |
		 *         _ |/        \    |
		 *           |\         \   |
		 *           | \         \  |
		 *           |  \         \ |
		 *           |   \         \| _
		 *           |    \        /| | 
		 *           |     \      / | | 
		 *           |      \    /  | | yoffset
		 *           |       \  /   | | 
		 *           |        \/    | _ 
		 *           ---------------- 
		 *                    |----|
		 *                    xoffset
		 * 
		 * 
		 * */
		// cell offsets based on a common grid coordinates
		public var cellX:int;
		public var cellY:int;
		
		// grid infomation
		public var cell:Parallelogram;
		public var rowNum:int = 1;
		public var columnNum:int = 1;
		public var total:int = 1;
		
		// data for each cell
		public var defaultCellData:Object;
		public var cellData:Vector.<int>;
		
		// intersectiong data definitions
		public static const GRID_SETINCOPY:int = 1;
		public static const GRID_SETINADD:int = 2;
		public static const GRID_SETINREMOVE:int = 4;
		
		public static const GRID_SETINVALUE:int = 8;
		public static const GRID_SETINDATA:int = 16;
		
		public static const GRID_SETOUTVALUE:int = 32;
		
		public static const GRID_SETTOFORM1:int = 64;
		public static const GRID_SETTOFORM2:int = 128;

		
		public function Grid(cell:Parallelogram=null, column:int=1, row:int=1)
		{
			super();
			setCell(cell);
			setGrid(column, row);
		}
		
		public function setCell(newcell:Parallelogram):void
		{
			if(newcell == null)
				cell = null;
			else if(cell == null)
				cell = newcell.clone() as Parallelogram;
			else
				newcell.cloneTo(cell);
		}
		
		public function getMinSize():int
		{
			return columnNum > rowNum ? rowNum : columnNum;
		}
		
		public function setGrid(row:int, column:int):void
		{
			// grid
			this.rowNum = row < 1 ? 1 : row;
			this.columnNum = column < 1 ? 1 : column;
			this.total = row * column;
			
			// shape
			if(cell != null)
			{
				var xo:Number = cell.xoffset * this.rowNum;
				var yo:Number = cell.yoffset * this.rowNum;
				super.setShape(xo + (cell.width-cell.xoffset) * this.columnNum, 
							yo + (cell.height-cell.yoffset) * this.columnNum,
							xo, yo);
			}
			
			// data, only enlarge if necessary
			if(cellData != null)
			{
				xo = total - cellData.length;
				while(xo > 0)
				{
					--xo;
					cellData.push(defaultCellData);
				}
			}
		}
		
		public function setCellData(cx:int, cy:int, d:int):void
		{
			if(cellData == null)
				cellData = new Vector.<int>(total);
			cellData[cy*columnNum+cx] = d;
			
			//wizim change it, maybe it is wrong 
			//the old code is : cellData[cy*row+cx] = d;
		}
		
		/*
		public function getCellData(cx:int, cy:int):Object
		{
			return cellData == null ? null : cellData[cy*column+cx];
		}
		*/
		
		public override function cloneTo(newobj:Object):Object
		{
			newobj = super.cloneTo(newobj);
			newobj.cellX = this.cellX;
			newobj.cellY = this.cellY;
			newobj.cell = this.cell != null ? this.cell.clone() : null;
			newobj.setGrid(this.rowNum, this.columnNum);
			newobj.cellData = this.cellData == null ? null : this.cellData.slice();
			return newobj;
		}
		
		public function isBelongToGrid(cellX:int, cellY:int):Boolean
		{
			return !(cellX > this.cellX+this.columnNum
				|| cellX < this.cellX
				|| cellY > this.cellY+this.rowNum
				|| cellY < this.cellY);
		}
		
		public function intersectsGrid(another:Grid, result:Grid=null):Boolean
		{
			if(another.cellX >= this.cellX+this.columnNum
				|| another.cellX+another.columnNum <= this.cellX
				|| another.cellY >= this.cellY+this.rowNum
				|| another.cellY+another.rowNum <= this.cellY)
				return false;
				
			if(result != null)
			{
				var cx:int = Math.max(another.cellX, this.cellX);
				var cy:int = Math.max(another.cellY, this.cellY);
				var ro:int = Math.min(another.cellX+another.columnNum, this.cellX+this.columnNum) - cx;
				var co:int = Math.min(another.cellY+another.rowNum, this.cellY+this.rowNum) - cy;
			
				result.setGrid(co, ro);
				result.cellX = cx;
				result.cellY = cy;
			}
			return true;
		}
		
		private static var _volatileGrid:Grid = new Grid();
		public function intersectsGridWithRange(range:int, another:Grid, result:Grid=null):Boolean
		{
			var sizeIncrease:int = range << 1;
			
			_volatileGrid.cellX = cellX - range;
			_volatileGrid.cellY = cellY - range;
			_volatileGrid.columnNum = sizeIncrease + columnNum;
			_volatileGrid.rowNum = sizeIncrease + rowNum;
			
			return _volatileGrid.intersectsGrid(another, result);
		}
		
		protected static var _intersectResult:Grid = new Grid();
		
		//Grid.setIntersectData(dragSource.frame, mapPanel.frame, Grid.GRID_SETINCOPY | Grid.GRID_SETINDATA | Grid.GRID_SETOUTVALUE | Grid.GRID_SETTOFORM1, -1, 0);
		
		public static function setIntersectData(form1:Grid, form2:Grid, option:int,
												outValue:Number=-1, invalue:Number=0, extraTileInfo : Dictionary = null):void
		{
			// auto create
			if(form1.cellData == null)
				form1.cellData = new Vector.<int>(form1.total);
			if(form2.cellData == null)
				form2.cellData = new Vector.<int>(form2.total);
				
			// flags	
			var setBehavior:int = (GRID_SETINCOPY|GRID_SETINADD|GRID_SETINREMOVE) & option; //copy
			var setOut:Boolean = (GRID_SETOUTVALUE & option) != 0; // true
			var inValue:Boolean = (GRID_SETINVALUE & option) != 0; // set in data
			var setIn:Boolean = ((GRID_SETINVALUE | GRID_SETINDATA) & option) != 0; // true
			//to form 1
			
			// less is loop form
			var loopForm:Grid, otherForm:Grid; 
			if(form1.total <= form2.total)
			{
				loopForm = form1;
				otherForm = form2;
			}
			else
			{
				loopForm = form2;
				otherForm = form1;
			}
			var toLoopForm:Boolean = ((GRID_SETTOFORM1 & option) != 0) == (loopForm == form1);
			var total:int = loopForm.total;
				
			// intersection data, local coords for loopForm
			var inStart:int, inEnd:int, inFinalEnd:int, otherIndex:int;
			if(form1.intersectsGrid(form2, _intersectResult))
			{
				// loop index
				inStart = (_intersectResult.cellY-loopForm.cellY) * loopForm.columnNum 
						+ _intersectResult.cellX-loopForm.cellX; 
				inEnd = inStart + _intersectResult.columnNum;
				inFinalEnd = inEnd + (_intersectResult.rowNum - 1) * loopForm.columnNum; 
				
				// other index
				otherIndex = (_intersectResult.cellY-otherForm.cellY) * otherForm.columnNum 
						+ _intersectResult.cellX-otherForm.cellX;
			}
			else
			{
				// all out
				if(!setOut)
					return ;
				inStart = loopForm.total;
				inEnd = inStart;
				inFinalEnd = inStart;
				otherIndex = 0;
			}

			// set
			var src:Number;		
			for(var row : int = 0; row < loopForm.rowNum; row ++)
			{
				for(var col : int = 0; col < loopForm.columnNum; col ++)
				{
					var index : int = row * loopForm.columnNum + col;
					if(index == inEnd)					// end of current setting window
					{
						if(inEnd == inFinalEnd)		// no more set 
						{
							inStart = total;
							inEnd = total;
						}
						else
						{
							inStart += loopForm.columnNum;
							inEnd += loopForm.columnNum;
							otherIndex += otherForm.columnNum - (inEnd - inStart);
						}
					}
					if(index < inStart)		// out
					{
						if(!setOut)
							continue;
						src = outValue;
					}
					else 				// in
					{
						if(!setIn)
							continue;
						if(inValue)
						{
							src = invalue;
							if(extraTileInfo != null)
							{
								var value : Object = extraTileInfo[(row + 1) + ":" + (col + 1)];
								if(value != null)
								{
									src = (int)(value);									
								}
							}
						}
						else
						{
							if(toLoopForm)
							{
								src = otherForm.cellData[otherIndex];
								++otherIndex;
							}
							else
							{
								src = loopForm.cellData[index];
							}
						}
					}
					if(toLoopForm)		// set
					{
						switch(setBehavior)
						{
							case GRID_SETINCOPY:
								loopForm.cellData[index] = src;
								break;
							
							case GRID_SETINADD:
								loopForm.cellData[index] |= src;
								break;
							
							case GRID_SETINREMOVE:
								loopForm.cellData[index] &= ~src;
								break;
						}
					}
					else 
					{
						switch(setBehavior)
						{
							case GRID_SETINCOPY:
								otherForm.cellData[otherIndex] = src;
								break;
							
							case GRID_SETINADD:
								otherForm.cellData[otherIndex] |= src;
								break;
							
							case GRID_SETINREMOVE:
								otherForm.cellData[otherIndex] &= ~src;
								break;
						}
						++otherIndex;
					}
				}
			}
		}
		
/*		public function containsPointInGrid(px:Number, py:Number, result:Grid):void
		{
			ASSERT(false, "containsPointInGrid() Not implemented in Class cw.geom.Grid");
		}
*/		
		
		public function setPosCell(cx:int, cy:int, parent:Grid):void
		{
			CONFIG::debug
			{
				ASSERT(false, "setPosCell() Not implemented in Class cw.geom.Grid");
			}
		}

	}
}