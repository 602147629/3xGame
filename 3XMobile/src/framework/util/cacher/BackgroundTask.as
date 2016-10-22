package framework.util.cacher
{
	
	import flash.display.Sprite;

	public class BackgroundTask
	{
		public static const TYPE_UNKNOWN:int=0;
		public static const REFRESH_CACHE:int=1;	
		public static const GENERATE_ASSET:int=2;
		public var type:int = TYPE_UNKNOWN;
		
		public var container:CachePlaceholder;
		public var level:Number;

		public function BackgroundTask(type:int, container:CachePlaceholder, level:Number)
		{
			this.type=type;
			this.container=container;
			this.level=level;
		}
		
		
	}
}