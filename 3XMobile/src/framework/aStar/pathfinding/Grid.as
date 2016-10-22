package framework.aStar.pathfinding
{
	public class Grid
	{
		protected var _startNode:Node;
		protected var _endNode:Node;
		protected var _nodes:Vector.<Vector.<Node>>;
		protected var _numCols:int;
		protected var _numRows:int;
		
		public function Grid(numCols:int, numRows:int)
		{
			_numCols = numCols;
			_numRows = numRows;
			_nodes = new Vector.<Vector.<Node>>();
			
			for(var i:int = 0; i < _numCols; i++)
			{
				_nodes[i] = new Vector.<Node>();
				for(var j:int = 0; j < _numRows; j++)
				{
					_nodes[i][j] = new Node(i, j);
				}
			}
		}
		
		public function clearInListFlag():void
		{
			for(var i:int = 0; i < _numCols; i++)
			{
				for(var j:int = 0; j < _numRows; j++)
				{
					var node:Node = _nodes[i][j];
					node.inList = false;
				}
			}
		}
		
		public function getNode(x:int, y:int):Node
		{
			return _nodes[x][y] as Node;
		}
		
		public function setStartNode(x:int, y:int):void
		{
			_startNode = _nodes[x][y] as Node;
		}
		
		public function set startNode(value:Node):void
		{
			_startNode = value;
		}
		
		public function get startNode():Node
		{
			return _startNode;
		}
		
		public function setEndNode(x:int, y:int):void
		{
			_endNode = _nodes[x][y] as Node;
		}
		
		public function set endNode(value:Node):void
		{
			_endNode = value;
		}
		
		public function get endNode():Node
		{
			return _endNode;
		}
		
		public function get numCols():int
		{
			return _numCols;
		}
		
		public function get numRows():int
		{
			return _numRows;
		}
	}
}
