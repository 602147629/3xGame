package framework.util.rsv
{
	import flash.events.Event;
	
	/**
	 * comments by Ding Ning
	 * message been used in Rsv system
	 */
	
	public class RsvEvent extends Event
	{
		public static const PROCESS:int = 0x1;
		public static const LOADERROR:int = 0x2;
		public static const LOADCOMPLETE:int = 0x4;
		public static const CONTENTREADY:int = 0x8;
		public static const CONTENTERROR:int = 0x10;

		public var id:int;
		public var param:Object;
		public var from:Object;
		
		public function RsvEvent(id:int, from:Object, param:Object=null)
		{
			super(id.toString());
			
			this.id = id;
			this.param = param;
			this.from = from;
		}
		
		override public function clone():Event
		{
			return new RsvEvent(id, from, param);
		}
	}
}