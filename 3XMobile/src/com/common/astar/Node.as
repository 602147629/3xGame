package com.common.astar
{
	

	/**
	 * //寻路数据节点
	 * @author zhangxin
	 * */
	public class Node
	{
		public var i:int;//水平索引
		public var j:int;//垂直索引
		public var x:int;//节点左上角X坐标
		public var y:int;//节点左上角Y坐标
		public static var width:int;//节点宽度
		public static var height:int;//节点高度
		public var f:Number;//总代价
		public var g:Number;//累计代价
		public var h:Number;//这个值需要计算
		public var walkable:Boolean;//是否可以通过
		public var parent:Node;//本节点的父节点
		//public var costMultiplier:int;//代价倍率。目前只有1
		//作为目标时的移动消耗
		//public static const MOVE_COST_STRAIGHT:Number = 0.35;
		//public static const DIAG_MULIPILER:Number = 1.4;
		public function Node(data:Object)
		{
			i = data.i;
			j = data.j;
			//width = gridW;
			//height = gridH;
			x = i * width;
			y = j * height;
			f = 0;
			g = 0;
			h = 0;
			walkable = (data.value == 0);
			parent = null;
			//costMultiplier = 1.0;
		}
		
		public function toString():void
		{
			/*
			trace("i ", _i);//水平索引
			trace("j ", _j);//垂直索引
			trace("x ", _x);//节点左上角X坐标
			trace("y ", _y);//节点左上角Y坐标
			trace("width ", _width);//节点宽度
			trace("height ", _height);//节点高度
			trace("f ",_f);//总代价
			trace("g ", _g);//累计代价
			trace("h ", _h);//这个值需要计算
			trace("walkable ", _walkable);//是否可以通过
			trace("parent ", _parent);//本节点的父节点
			trace("costMultipiler ", _costMultiplier);//代价倍率。目前只有1
			*/
		}


	}
}