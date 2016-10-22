package com.common.astar
{
	import flash.utils.Dictionary;

	/**
	 * 网格
	 * @author zhangxin
	 * */
	public class GridsList
	{
		private var _startNode:Node;
		private var _endNode:Node;
		private var _nodes:Dictionary;
		private var _numRows:int;
		private var _numCols:int;
		
		public function GridsList()
		{
			//setNodes(data,width,height);
		}
		
		/**
		 * 当鼠标点在寻路区域不可移动的位置时，将自动推算出一个可移动的点作为寻路终点
		 * @param start 寻路起点，多数情况为人物所在位置
		 * @param target 鼠标点击的节点，且不可以作为终点 walkable == false
		 * */
		public function findATargetLocation(start:Node,target:Node):Node
		{
			//todo badlogic cannot find path
			if(!start || !target) return null;
			var multiRatioX:int;
			var multiRatioY:int;
			target.x > start.x ? multiRatioX = -1 : multiRatioX = 1;
			target.y > start.y ? multiRatioY = -1 : multiRatioY = 1;
			var sRow:int = start.i;
			var sCol:int = start.j;
			var row:int = target.i;
			var col:int = target.j;
			while(row != sRow)
			{
				while(col != sCol)
				{
					if(_nodes[row + "_" + col].walkable)
					{
						endNode = _nodes[row + "_" + col];
						return _nodes[row + "_" + col];
					}
					col += multiRatioY;
				}
				if(_nodes[row + "_" + col].walkable)
				{
					endNode = _nodes[row + "_" + col];
					return _nodes[row + "_" + col];
				}
				row += multiRatioX;
			}
			return null;
		}
		
		/**
		 * 根据位置获取节点
		 * 主要用于获取人物战立位置的节点和鼠标点击所在位置的节点
		 * @param x 横坐标
		 * @param y 纵坐标
		 * */
		public function getNodeByLocation(x:Number,y:Number):Node
		{
			for each(var node:Node in _nodes)
			{
				if((x >= node.x && x <= node.x + Node.width) && (y >= node.y && y <= node.y + Node.height)) 
				{
					return node;
				}
			}
			return null;
		}
		
		/**根据索引获取节点
		 * @param i 数据提供的索引i，行，类似于自然下标
		 * @param j 数据提供的索引j，列，类似于自然下标
		 * */
		public function getNode(i:int,j:int):Node
		{
			if(_nodes[i + "_" + j]){
				return _nodes[i + "_" + j];
			}
			return null;
		}
		
		//列
		public function get numCols():int
		{
			return _numCols;
		}

		public function set numCols(value:int):void
		{
			_numCols = value;
		}
		
		//行
		public function get numRows():int
		{
			return _numRows;
		}

		public function set numRows(value:int):void
		{
			_numRows = value;
		}
		
		//网格内所有节点
		public function get nodes():Dictionary
		{
			return _nodes;
		}
		
		/**
		 * 设置单个节点
		 * @param data 包含i j value三个值
		 * @param w 单格宽度
		 * @param h 单格高度
		 * */
		public function setNode(data:Object):void
		{
			if(_nodes == null)
			{
				_nodes = new Dictionary;
			}
			_nodes[data.i +  "_" + data.j] = new Node(data);
		}
		
		/**
		 * 以数组方式设置节点
		 * 在参数dataArray中每一项必须包含i j value三个值
		 * */
		public function setNodes(dataArray:Array):void
		{
			//_nodes = value;
			var i:int = 0;
			var len:int = dataArray.length;
			_nodes = new Dictionary;
			while(i < len)
			{
				_nodes[dataArray[i].i +  "_" + dataArray[i].j] = new Node(dataArray[i]);
				++i;
			}
		}
		
		public function zeroList():void
		{
			if(_nodes == null){
				return;
			}
			
			for each( var node:Node in _nodes)
			{
				node = null;
			}
			
			_nodes = null;
		}
		
		//寻路终点和起点清零
		public function clearStartAndEnd():void
		{
			_startNode = null;
			_endNode = null;
		}
		//终点
		public function get endNode():Node
		{
			return _endNode;
		}

		public function set endNode(value:Node):void
		{
			_endNode = value;
		}

		//起点
		public function get startNode():Node
		{
			return _startNode;
		}

		public function set startNode(value:Node):void
		{
			_startNode = value;
		}

	}
}