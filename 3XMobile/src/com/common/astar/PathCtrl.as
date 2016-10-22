package com.common.astar
{
	import flash.geom.Point;
	
	import framework.fibre.core.Fibre;

	/**
	 * 寻路核心类
	 * @author zhangxin
	 * */
	public class PathCtrl
	{
		public var grids:GridsList;
		private var _openList:Array = [];//因为此数组执行弹出操作频繁，故不使用Vector
		private var _closeList:Vector.<Node> = new Vector.<Node>;
		//
		private const COST_STRAIGHT:Number = 1.0;//平行
		private const COST_DIAG:Number = 1.414;//对角
		//
		public var pathVec:Vector.<Node>;
		//
		public static const FIND:int = 1;
		public static const FIND_SAME_GRID:int = 2;
		public static const FIND_NOT:int = -1;
		
		public static const END_POSITION:String = "END_POSITION";
		//初始化起始点和终点
		public function initStartAndEndNode(posX:int,posY:int,targetX:int,targetY:int):Boolean
		{
			grids.startNode = grids.getNodeByLocation(posX,posY);
			var endNode:Node = grids.getNodeByLocation(targetX,targetY);
			
			if(endNode && !endNode.walkable)
			{
				grids.endNode = grids.findATargetLocation(grids.startNode,endNode);
				return false;
			}
			else
			{
				grids.endNode = endNode;
				
				return true;
			}
		}
		
		/**
		 * 查找路径
		 * @return	Boolean 是否找到路径
		 */
		public function searchRoute():int
		{
			//由于网格的分布比较简单，在本机测试寻路过程不超过2毫秒
			//var beforeT:Number = getTimer()
			var node:Node = grids.startNode;
			var end:Node = grids.endNode;
			if(!node || !end ) 
			{
				return FIND_NOT;//起点或终点为空时，不做寻路操作
			}
			if(node.i == end.i && node.j == end.j) 
			{
				return FIND_SAME_GRID;//终结点和起点为同一个格子，不做寻路操作
			}
			
			_openList = [];
			_closeList = new Vector.<Node>;
			
			while(node != end)
			{
				//
				var startI:int = Math.max(0,node.i - 1);
				var startJ:int = Math.max(0,node.j - 1);
				var endI:int = Math.min(grids.numCols - 1, node.i + 1);
				var endJ:int = Math.min(grids.numRows - 1,node.j + 1);
				//
				for(var row:int = startI; row <= endI ; row++)
				{
					//
					for(var col:int = startJ; col <= endJ; col++)
					{
						var test:Node = grids.getNode(row,col);
						//|| !grids.getNode(node.i,test.j).walkable || !grids.getNode(test.i,node.j).walkable
						if(test == null || test == node || !test.walkable) 
						{
							continue;
						}
						
						var cost:Number = COST_STRAIGHT;
						if(!((node.i == test.i) || !(node.j == test.j)))
						{
							cost = COST_DIAG;
						}
						
						var g:Number = node.g + cost;// * test.costMultiplier;
						var h:Number = heuristic(test);
						var f:Number = g + h;
						if(isClose(test) || isOpen(test))
						{
							if(test.f > f)
							{
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						}else
						{
							test.g = g;
							test.h = h;
							test.f = f;
							test.parent = node;
							_openList.push(test);
						}
					}
				}
				
				_closeList.push(node);
				if(_openList.length == 0)
				{
					return FIND_NOT;
				}
				_openList.sortOn("f",Array.NUMERIC);
				node = _openList.shift() as Node;
			}
			
			pathVec = createAPath();
			
			Fibre.getInstance().sendNotification(END_POSITION,returnEndNodePosition());
			//trace("找到路径所需时间：",getTimer() - beforeT);
			return FIND;
		}
		
		private function returnEndNodePosition():Point
		{
			if(!pathVec)
			{
				return null;
			}
			var endX:int = pathVec[pathVec.length - 1].x;
			var endY:int = pathVec[pathVec.length - 1].y;
			return new Point(endX,endY);
		}
		
		/**
		 * 查找路径方法2
		 * @return	Boolean 是否找到路径
		 */
		public function search():Boolean
		{
			//从起始节点开始
			var node:Node = grids.startNode;
			var end:Node = grids.endNode;
			if(!node || !end)
			{
				return false;
			}
			_closeList = new Vector.<Node>();
			//变量
			var startX:int, endX:int, startY:int, endY:int, test:Node;
			var g:Number, h:Number, f:Number;
			//如果当前节点不是终点节点
			while (node != end)
			{
				//需要比对的节点的范围
				startX = Math.max(0, node.i - 1);
				endX = Math.min(grids.numCols - 1, node.i + 1);
				startY = Math.max(0, node.j - 1);
				endY = Math.min(grids.numRows - 1, node.j + 1);
				//比对节点
				for (var row:int = startX; row <= endX; row++ )
				{
					for (var col:int = startY; col <= endY; col++)
					{
						//获取比对节点
						test = grids.getNode(row,col);
						//如果比对节点是以下类型，则跳过
						//比对节点是当前节点
						//比对节点是不可通的
						//比对节点和当前节点是对角节点并且不可通时
						//if (test == node || !test.walkable || !_nodes[node.x][test.y].walkable || !_nodes[test.x][node.y].walkable)
						if (test == node || !test.walkable)
						{
							continue;
						}
						//计算估价
						if (node.i == test.i || node.j == test.j)
						{
							g = node.g + 1.0;
						}
						else
						{
							g = node.g + COST_DIAG;
						}
						h = heuristicMht(test);
						f = g + h;
						//如果该节点在待考察列表，或都在已考察更表中
						//则比对以前的代价，如果比以前的代价小，则更换代价值
						if (_openList.indexOf(test) != -1 || _closeList.indexOf(test) != -1)
						{
							if (test.f > f)
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
							_openList.push(test);
						}
					}
				}
				//将当前节点放入已考察列表
				_closeList.push(node);
				//如果没有待考察节点则说明无通路
				if (_openList.length == 0)
				{
					/*
					Debugger.trace("********************************");
					Debugger.trace("no path found");
					Debugger.trace("_startX:" + _startX);
					Debugger.trace("_startY:" + _startY);
					Debugger.trace("_endX:" + _endX);
					Debugger.trace("_endY:" + _endY);
					Debugger.trace("********************************");
					*/
					return false;
				}
				//从待考察列表中取出最小代价的进行考察
				node = _openList.shift() as Node;
			}
	
			pathVec = createAPath();
			return true;
		}
		
		
		//建立路径
		private function createAPath():Vector.<Node>
		{
			var path:Vector.<Node> = new Vector.<Node>();
			path.push(grids.endNode);
			var node:Node = grids.endNode.parent;
			while(node != null)
			{
				if(node == grids.startNode) 
				{
					break;
				}
				path.push(node);
				node = node.parent;
			}
			path = path.reverse();
			return path;
		}
		
		//估算检测点到终点代价的方法(几何估价法)
		private function heuristic(test:Node):Number
		{
			var dx:int = grids.endNode.x - test.x;
			var dy:int = grids.endNode.y - test.y;
			return Math.sqrt((dx * dx + dy * dy));
		}
		
		/**
		 * 估价算法manhattan算法
		 * @param	node	估价的节点
		 * @return	Number	估价值
		 */
		private function heuristicMht(node:Node):Number
		{
			var n:int = node.x > grids.endNode.x ? node.x - grids.endNode.x : grids.endNode.x - node.x;
			n += node.y > grids.endNode.y ? node.y - grids.endNode.y : grids.endNode.y - node.y;
			return n;
		}
		
		//查看节点是否待考察列表里
		private function isOpen(test:Node):Boolean
		{
			 return _openList.indexOf(test) >= 0;
		}
		
		//查看节点是否在已考察列表里
		private function isClose(test:Node):Boolean
		{
			return _closeList.indexOf(test) >= 0
		}
	}
}