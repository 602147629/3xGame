package framework.util.geom
{
	import flash.geom.Point;
	
	public class PointIntersectPolygon
	{		
		// actually this do NOT consider self-intersecting polygons,
		// which may have more than one borders intersecting with a point
		
		protected var _flag:int = 0;
		protected var _pointIndex:int = -1;
		protected var _borderIndex:int = -1;
		
		// point location definitions
		protected static const PL_OUTSIDE:int = 0;
		protected static const PL_INSIDE:int = 2;
		protected static const PL_ONPOINT:int = 4;
		protected static const PL_ONBORDER:int = 8;
		
		
		public function PointIntersectPolygon(intersect:Boolean, bi:int=-1, pi:int=-1,
			pt:Point=null, poly:IPolygon=null)
		{
			if(pi >= 0)
			{
				_pointIndex = pi;
				if(bi == -1)
				{
					_borderIndex = pi;
				}
				_flag = PL_ONPOINT | PL_ONBORDER;
			}
			else if(bi >= 0)
			{
				_borderIndex = bi;
				_flag = PL_ONBORDER;
			}
			else
			{
				_flag = intersect ? PL_INSIDE : PL_OUTSIDE;
			}
		}
		
		public static const INST_OUT:PointIntersectPolygon = new PointIntersectPolygon(false);
		public static const INST_IN:PointIntersectPolygon = new PointIntersectPolygon(true);
		
		public static function INST_POINT(pi:int):PointIntersectPolygon
		{
			return new PointIntersectPolygon(true, -1, pi);
		}
		
		public static function INST_BODER(bi:int):PointIntersectPolygon
		{
			return new PointIntersectPolygon(true, bi);
		}
		
		public function isOut(borderAsInside:Boolean=true):Boolean
		{
			return borderAsInside ? _flag == PL_OUTSIDE : _flag != PL_INSIDE;
		}
		
		public function isBorder():Boolean
		{
			return _borderIndex >= 0;
		}
		
		public function get borderIndex():int
		{
			return _borderIndex;
		}
		
		public function get pointIndex():int
		{
			return _pointIndex;
		}

	}
}