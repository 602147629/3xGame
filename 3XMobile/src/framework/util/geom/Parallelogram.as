package framework.util.geom
{
	
	public class Parallelogram extends ConvexPolygon
	{		
		// x distance from bounding box's top-left point to the top most point.  
		public var xoffset:Number;
		
		// y distance from bounding box's top-left point to the left most point.  
		public var yoffset:Number;
		
		public function Parallelogram(width:Number=0, height:Number=0, xoffset:Number=0, yoffset:Number=0)
		{
			super(4);
			setShape(width, height, xoffset, yoffset);
		}
		
		public function setShape(width:Number, height:Number, xoffset:Number, yoffset:Number):void
		{
			this.width = width;
			this.height = height;
			this.xoffset = xoffset;
			this.yoffset = yoffset;
		}
		
		public override function cloneTo(newobj:Object):Object
		{
			super.cloneTo(newobj);
			newobj.xoffset = this.xoffset;
			newobj.yoffset = this.yoffset;
			return newobj;
		}

		public override function getPoints(result:Array=null):Array
		{ 
			// create buffer
			if(result == null)
				result = new Array(8);
				
			// coordinates
			result[0] = xoffset;
			result[1] = 0;
			result[2] = width;
			result[3] = height-yoffset;
			result[4] = width-xoffset;
			result[5] = height;
			result[6] = 0;
			result[7] = yoffset;
			return result;
		}
		
		public override function containsPoint(px:Number, py:Number):PointIntersectPolygon
		{
			// must remove offset before containsPointRect()
			px -= x;
			py -= y;
			
			// quick test
			if(!containsPointRect(px, py))
				return PointIntersectPolygon.INST_OUT;

			// compare first angle, based on top most point(known as the 1st point)
			var x1:Number = px - xoffset;
			var d:Number;
			var wxoff:Number = width - xoffset;
			var hyoff:Number = height - yoffset;
			
			// py / x1 >= (height-yoffset)/(width-xoffset)
			if(x1 > 0)		
			{
				d = py * wxoff - x1 * hyoff;
				
				// on border
				if(d == 0)
					return px == width ? PointIntersectPolygon.INST_POINT(1) : PointIntersectPolygon.INST_BODER(0);
			}
			else //if(x1 <= 0)
			{
				d = py * xoffset + x1 * yoffset;
				
				// on border
				if(d == 0)
				{
					if(x1 == 0)
						return PointIntersectPolygon.INST_POINT(0);
					else
						return px == 0 ? PointIntersectPolygon.INST_POINT(3) : PointIntersectPolygon.INST_BODER(3);
				}
			}
			if(d < 0)
				return PointIntersectPolygon.INST_OUT;
			
			// compare second angle, based on bottom most point(known as the 3rd point)
			x1 = px - wxoff;
			py = height - py;
			if(x1 > 0)
			{
				d = py * xoffset - x1 * yoffset;
				if(d == 0)		// 1st point already checked
					return PointIntersectPolygon.INST_BODER(1);
			}
			else 
			{
				d = py * wxoff + x1 * hyoff;
				if(x1 == 0)
					return PointIntersectPolygon.INST_POINT(2);
				else			// 3rd point already checked
					return PointIntersectPolygon.INST_BODER(2);
			}
			if(d < 0)
				return PointIntersectPolygon.INST_OUT;
			else //if(d > 0)
				return PointIntersectPolygon.INST_IN;
		}
		
		protected static var _lineResult:Array = new Array(3);
		
		public function intersectsParallelLine(cx:int, cy:int, nx:int, ny:int, result:Array=null):Array
		{
			// get intersection point(s) between this parallelogram and a line in parallel with either side of the bounds
									
			// return value: 
			// result[0], intersection points number, >= 3 means overlapped
			// result[1], result[2], first intersection point if have
			// result[3], result[4], second intersection point if have
			
			// create buffer
			if(result == null)
				result = new Array(5);
				
			// default
			result[0] = 0;
				
			var nextdx:int, nextdy:int, x1:int, y1:int, x2:int, y2:int;
			
			// check with one side, from point1 to point4
			x1 = xoffset;
			y1 = 0;
			x2 = 0;
			y2 = yoffset;
			nextdx = width - xoffset;
			nextdy = height - yoffset;
			Line.intersectPoint(cx, cy, nx, ny, x1, y1, x2, y2, _lineResult);
			
			if(_lineResult[0] == 0)
			{
				// parallel
				// check with another, from point1 to point2
				x1 = xoffset;
				y1 = 0;
				x2 = width;
				y2 = height-yoffset;
				nextdx = width - xoffset;
				nextdy = height - yoffset;
				Line.intersectPoint(cx, cy, nx, ny, x1, y1, x2, y2, _lineResult);
			}
			
			// check point in segments
			var index:int, tx:int, ty:int;
			index = 1;
			tx = _lineResult[1];
			ty = _lineResult[2];
			
			if(_lineResult[0] == 2)
			{
				// overlapped
				if(Line.pointOnLine(cx, cy, x1, y1, x2, y2, false) > 0)
				{
					result[index] = cx;
					result[index+1] = cy;
					index += 2;
				}
				if(Line.pointOnLine(nx, ny, x1, y1, x2, y2, false) > 0)
				{
					result[index] = nx;
					result[index+1] = ny;
					index += 2;
				}
				result[0] = (index - 1) >> 1;
				result[0] += 3;
			}
			else // if(ret == 1)
			{
				if(Line.pointOnLine(tx, ty, x1, y1, x2, y2, false) == 0)
				{
					// the intersection point not on a side, means no intersection point
					return result;
				}
				if(Line.pointOnLine(tx, ty, cx, cy, nx, ny, false) > 0)
				{
					result[index] = tx;
					result[index+1] = ty;
					index += 2;
				}
				tx += nextdx;
				ty += nextdy;
				if(Line.pointOnLine(tx, ty, cx, cy, nx, ny, false) > 0)
				{
					result[index] = tx;
					result[index+1] = ty;
					index += 2;
				}
				result[0] = (index - 1) >> 1;
				
				// swap if necessary
				if(index == 5 && Line.pointOnLine(result[3], result[4], cx, cy, result[1], result[2], false) > 0)
				{
					// swap, make the first intersection point near the current point
					index = result[5];
					result[5] = result[3];
					result[3] = index;
					index = result[4];
					result[4] = result[6];
					result[6] = index;
				}
			}
			return result;
		}
	}
		
}