package framework.aStar.pathfinding
{
	import framework.aStar.Bit;
	
	public class Node
	{
		public static const WALKABLE:uint = 1;
		public static const TOP_WALL:uint = 2;
		public static const RIGHT_WALL:uint = 4;
		public static const BOTTOM_WALL:uint = 8;
		public static const LEFT_WALL:uint = 16;
		
		public var column:int;
		public var row:int;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var data:uint = WALKABLE;
		public var parent:Node;
		public var costMultiplier:Number = 1;
		
		internal var inList:Boolean = false;
		
		public function Node(col:int, _row:int)
		{
			this.column = col;
			this.row = _row;
		}
		
		public function set walkable(value:Boolean):void
		{
			data = Bit.setBit(data, 0, value);
		}
		public function get walkable():Boolean
		{
			return Bit.getBit(data, 0);
		}
		
		public function set top(value:Boolean):void
		{
			data = Bit.setBit(data, 1, value);
		}
		public function get top():Boolean
		{
			return Bit.getBit(data, 1);
		}
		
		public function set right(value:Boolean):void
		{
			data = Bit.setBit(data, 2, value);
		}
		public function get right():Boolean
		{
			return Bit.getBit(data, 2);
		}
		
		public function set bottom(value:Boolean):void
		{
			data = Bit.setBit(data, 3, value);
		}
		public function get bottom():Boolean
		{
			return Bit.getBit(data, 3);
		}
		
		public function set left(value:Boolean):void
		{
			data = Bit.setBit(data, 4, value);
		}
		public function get left():Boolean
		{
			return Bit.getBit(data, 4);
		}
	}
}
