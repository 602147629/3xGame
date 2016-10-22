package framework.aStar.pathfinding
{
	public class BorderAStar
	{
		public static const STRAIGHT_COST:Number = 1;
		public static const DIAG_COST:Number = Math.SQRT2;
//		public static const HEURISTIC:Function = manhattan;
//		public static const HEURISTIC:Function = euclidian;
		public static const HEURISTIC:Function = diagonal;
		
		public static function manhattan(node:Node, endNode:Node):Number
		{
			return Math.abs(node.column - endNode.column) * STRAIGHT_COST + Math.abs(node.row + endNode.row) * STRAIGHT_COST;
		}
		
		public static function euclidian(node:Node, endNode:Node):Number
		{
			var dx:Number = node.column - endNode.column;
			var dy:Number = node.row - endNode.row;
			return Math.sqrt(dx * dx + dy * dy) * STRAIGHT_COST;
		}
		
		public static function diagonal(node:Node, endNode:Node):Number
		{
			var dx:Number = Math.abs(node.column - endNode.column);
			var dy:Number = Math.abs(node.row - endNode.row);
			var diag:Number = Math.min(dx, dy);
			var straight:Number = dx + dy;
			return DIAG_COST * diag + STRAIGHT_COST * (straight - 2 * diag);
		}
		
		protected var _open:Vector.<Node>;
		protected var _closed:Vector.<Node>;
		protected var _grid:Grid;
		protected var _endNode:Node;
		protected var _startNode:Node;
		protected var _path:Vector.<Node>;
		
		public function BorderAStar()
		{
			_open = new Vector.<Node>();
			_closed = new Vector.<Node>();
			_path = new Vector.<Node>();
		}
		
		/*one way 单向门*/
		public function findPath(grid:Grid, isSameGridFind:Boolean,oneway:Boolean = false):Boolean
		{
		
			_open.length = _closed.length = _path.length = 0;
			_grid = grid;
			_grid.clearInListFlag();
			
			_startNode = _grid.startNode;
			if(!_startNode.walkable)
			{
				_startNode.walkable = true;
				CONFIG::debug
				{
					TRACE_LOG("StartNode: walkable False! x:"+ _startNode.column+ " y: "+_startNode.row);
				}
			}
			_endNode = _grid.endNode;
			
			if(isSameGridFind && _startNode.column == _endNode.column && _startNode.row == _endNode.row)
			{
				return false;
			}
			
			_startNode.g = 0;
			_startNode.h = HEURISTIC(_startNode, _endNode);
			_startNode.f = _startNode.g + _startNode.h;
			
			return this.search(oneway);
		}
		
		protected function search(oneway:Boolean):Boolean
		{
			var node:Node = _startNode;
			while(node != _endNode)
			{
				var startX:int = Math.max(0, node.column - 1);
				var endX:int = Math.min(_grid.numCols - 1, node.column + 1);
				var startY:int = Math.max(0, node.row - 1);
				var endY:int = Math.min(_grid.numRows - 1, node.row + 1);
				for(var i:int = startX; i <= endX; i++)
				{
					for(var j:int = startY; j <= endY; j++)
					{
						if((((node.column - 1) == i) && node.left) || 
							(((node.column + 1) == i) && node.right) || 
							(((node.row - 1) == j) && node.top) || 
							(((node.row + 1) == j) && node.bottom))
						{
							continue;
						}
						
						var test:Node = _grid.getNode(i, j);
						var temp:Node;
						
						if(oneway)
						{
							if((node.column - 1) == test.column && (node.row - 1) == test.row)
							{
								try
								{
									temp = _grid.getNode(i + 1, j);
									if(temp.left)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j + 1);
									if(temp.top)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
							if((node.column + 1) == test.column && (node.row - 1) == test.row)
							{
								try
								{
									temp = _grid.getNode(i - 1, j);
									if(temp.right)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j + 1);
									if(temp.top)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
							if((node.column - 1) == test.column && (node.row + 1) == test.row)
							{
								try
								{
									temp = _grid.getNode(i + 1, j);
									if(temp.left)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j - 1);
									if(temp.bottom)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
							if((node.column + 1) == test.column && (node.row + 1) == test.row)
							{
								try
								{
									temp = _grid.getNode(i - 1, j);
									if(temp.right)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j - 1);
									if(temp.bottom)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
						}
						else
						{
							if((node.column - 1) == test.column && (node.row - 1) == test.row)
							{
								if(test.bottom || test.right)
								{
									continue;
								}
								try
								{
									temp = _grid.getNode(i + 1, j);
									if(temp.bottom || temp.left)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j + 1);
									if(temp.top || temp.right)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
							if(node.column == test.column && (node.row - 1) == test.row)
							{
								if(test.bottom)
								{
									continue;
								}
							}
							if((node.column + 1) == test.column && (node.row - 1) == test.row)
							{
								if(test.left || test.bottom)
								{
									continue;
								}
								try
								{
									temp = _grid.getNode(i - 1, j);
									if(temp.bottom || temp.right)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j + 1);
									if(temp.top || temp.left)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
							if((node.column - 1) == test.column && node.row == test.row)
							{
								if(test.right)
								{
									continue;
								}
							}
							if((node.column + 1) == test.column && node.row == test.row)
							{
								if(test.left)
								{
									continue;
								}
							}
							if((node.column - 1) == test.column && (node.row + 1) == test.row)
							{
								if(test.top || test.right)
								{
									continue;
								}
								try
								{
									temp = _grid.getNode(i + 1, j);
									if(temp.top || temp.left)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j - 1);
									if(temp.bottom || temp.right)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
							if(node.column == test.column && (node.row + 1) == test.row)
							{
								if(test.top)
								{
									continue;
								}
							}
							if((node.column + 1) == test.column && (node.row + 1) == test.row)
							{
								if(test.top || test.left)
								{
									continue;
								}
								try
								{
									temp = _grid.getNode(i - 1, j);
									if(temp.top || temp.right)
									{
										continue;
									}
								}
								catch(error:Error){}
								try
								{
									temp = _grid.getNode(i, j - 1);
									if(temp.bottom || temp.left)
									{
										continue;
									}
								}
								catch(error:Error){}
							}
						}
						
						if(test == node || 
							!test.walkable || 
							!_grid.getNode(node.column, test.row).walkable || 
							!_grid.getNode(test.column, node.row).walkable) //avoid cross angle
						{
							continue;
						}
						
						var cost:Number = STRAIGHT_COST;
						if(!((node.column == test.column) || (node.row == test.row)))
						{
							cost = DIAG_COST;
						}
						//var g:Number = node.g + cost * test.costMultiplier;
						var g:Number = node.g + cost;
						var h:Number = HEURISTIC(test, _endNode);
						var f:Number = g + h;
						if(test.inList)
						{
							if(test.f > f)
							{
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						}
						else
						{
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							appendToOpen(test);
							test.inList = true;
						}
					}
				}
			/*	for(var o:int = 0; o < _open.length; o++)
				{
				}*/
				_closed.push(node);
				node.inList = true;
				if(_open.length == 0)
				{
					return false;
				}
				node = removeFirstFromOpen();
			}
			buildPath();
			return true;
		}
		
		private function appendToOpen(node:Node):void
		{
			var index:int = _open.push(node);
			var temp:Node;
			while(index != 1 && _open[int(index / 2) - 1].f > node.f)
			{
				temp = _open[index - 1];
				_open[index - 1] = _open[int(index / 2) - 1];
				_open[int(index / 2) - 1] = temp;
				index /= 2;
			}
		}
		
		private function removeFirstFromOpen():Node
		{
			var node:Node = _open.shift();
			if(_open.length > 1)
			{
				_open.unshift(_open.pop());
				var index:int = 1, subIndex1:int, subIndex2:int, len:int = _open.length, minIndex:int;
				var nowNode:Node, subNode1:Node, subNode2:Node, temp:Node, minNode:Node;
				while(true)
				{
					subIndex1 = index * 2;
					subIndex2 = index * 2 + 1;
					if(subIndex1 > len)
					{
						break;
					}
					nowNode = _open[index - 1];
					subNode1 = _open[subIndex1 - 1];
					subNode2 = (subIndex2 > len) ? null : _open[subIndex2 - 1];
					if(subNode2 != null)
					{
						minIndex = (subNode1.f < subNode2.f) ? subIndex1 : subIndex2;
						minNode = _open[minIndex - 1];
						if(nowNode.f > minNode.f)
						{
							temp = _open[minIndex - 1];
							_open[minIndex - 1] = _open[index - 1];
							_open[index - 1] = temp;
							index = minIndex;
						}
						else
						{
							break;
						}
					}
					else
					{
						if(nowNode.f > subNode1.f)
						{
							temp = _open[subIndex1 - 1];
							_open[subIndex1 - 1] = _open[index - 1];
							_open[index - 1] = temp;
							index = subIndex1;
						}
						else
						{
							break;
						}
					}
				}
			}
			return node;
		}
		
		private function buildPath():void
		{
			_path = new Vector.<Node>();
			var node:Node = _endNode;
			_path.push(node);
			while(node != _startNode)
			{
				node = node.parent;
				_path.push(node);
			}
			
			_path.reverse();
		}
		
		public function get path():Vector.<Node>
		{
			return _path;
		}
		
		public function get visited():Vector.<Node>
		{
			return _closed.concat(_open);
		}
	}
}
