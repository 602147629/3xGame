package framework.util.cacher
{
	import framework.util.map.Map;

	public class GlobalCacheImageCreatorManager
	{
		public function GlobalCacheImageCreatorManager()
		{
		}
		
		private static var creators:Map=new Map();
		public static function getCreator(key:String):CacheToImageCreator
		{
			return creators.getValue(key) as CacheToImageCreator;
		}
		public static function addCreator(key:String, param:CacheToImageCreator):void
		{
			creators.push(key, param);
		}
		

	}
}

