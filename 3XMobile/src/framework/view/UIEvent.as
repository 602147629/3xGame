package framework.view
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		public var myTarget:*;
		public var index:int;
		public var data:*;
		public var render:*;
		
		public function UIEvent(type:String)
		{
			super(type);
		}
		
		override public function clone():Event
		{
			var cloneEvent:UIEvent = new UIEvent(type);
			
			cloneEvent.myTarget = myTarget;
			cloneEvent.index = index;
			cloneEvent.data = data;
			cloneEvent.render = render;
			
			return cloneEvent;
		}
	}
}