package framework.core.tick
{
	public interface ITickObject
	{
		function tickObject(psdTickMs:Number):void;
		function isTickPaused():Boolean;
	}
}