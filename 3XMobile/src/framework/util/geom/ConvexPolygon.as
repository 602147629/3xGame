package framework.util.geom
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	
	public class ConvexPolygon implements IPolygon
	{
		// [From Wikipedia, http://en.wikipedia.org/wiki/Polygon]
		// Convex: any line drawn through the polygon (and not tangent to an edge or corner) meets its boundary exactly twice.
		
		// position
		public var x:Number = 0;
		public var y:Number = 0;
		
		// minimum bounding rectangle (MBR), also known as bounding box or envelope
		public var width:Number = 0;
		public var height:Number = 0;
		
		// The top most point is the first, and then clockwise for the others.
		protected var _pointNum:int;
		
		public function ConvexPolygon(pointnum:int=0)
		{
			CONFIG::debug
			{
				if(pointnum < 0)
				{
					ASSERT(false, "A ConvexPolygon's point number must be not less than zero.");
				}
			}
			this._pointNum = pointnum;
		}
		
		public function setPos(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function setSize(width:Number, height:Number):void
		{
			this.width = width;
			this.height = height;
		}
		
		public function get pointNumber():int
		{
			return _pointNum;
		}	
		
		public function getPoints(result:Array=null):Array
		{
			CONFIG::debug
			{
				ASSERT(false, "getPoints() not implemented in Class ConvexPolygon");
			}
			return null;
		}
		
		public function getPointsOffset(result:Array=null):Array
		{
			result = getPoints(result);
			var len:int = result.length;
			var p:Boolean = true;
			for(var i:int = 0; i<len; i++)
			{
				result[i] = result[i] + (p ? x : y);
				p = !p;
			}
			return result;
		}
		
		public function toString():String
		{
			return getQualifiedClassName(this)+"["+this._pointNum+"]: "+getPoints().toString();
		}
		
		public function clone():Object
		{
			return cloneTo(new (getDefinitionByName(getQualifiedClassName(this)) as Class)());
		}
		
		public function cloneTo(newobj:Object):Object
		{
			newobj._pointNum = this._pointNum;
			newobj.x = this.x;
			newobj.y = this.y;
			newobj.width = this.width;
			newobj.height = this.height;
			return newobj;
		}
		
		
		public function containsTileCellXY(cellX:int,cellY:int):Boolean
		{
			return true;
		}
		
		
		public function containsPoint(px:Number, py:Number):PointIntersectPolygon
		{
			CONFIG::debug
			{
				ASSERT(false, "containsPoint() not implemented in Class ConvexPolygon");
			}
			return null;
		}
		
		protected function containsPointRect(px:Number, py:Number):Boolean
		{
			// internal use, Notice px & py do NOT contains offset
			return !(px < 0 || py < 0 || px > width || py > height);
		}
	}
}