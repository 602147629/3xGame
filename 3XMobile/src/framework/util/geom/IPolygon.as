package framework.util.geom
{
	public interface IPolygon
	{
		function clone():Object;
		function cloneTo(newobj:Object):Object;
		function toString():String;
		function getPoints(result:Array=null):Array;
		// 0 outside, 1 on a bound, 2 inside
		function containsPoint(x:Number, y:Number):PointIntersectPolygon;
	}
}