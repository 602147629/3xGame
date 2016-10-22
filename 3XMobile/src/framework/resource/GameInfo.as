package framework.resource
{

	public class GameInfo extends GameResource
	{
		public static var OPTIMIZE_LAYER:Boolean = false;
		public static var OPTIMIZE_CACHE:Boolean = false;
		
		public function GameInfo()
		{
		}
		
		override public function init(xml:XML, file:ResourceFile, parent:Resource, resId:String = null):void
		{
			resType = GAMETYPE_GAMEINFO;
			
			super.init(xml, file, parent);
			
			// this class is unique
			_id = getPropString(xml, "restype");
			
			initConfig(xml);
		}
		
		private function initConfig(xml:XML):void
		{
			OPTIMIZE_LAYER = getPropString(xml, "layeroptimize", "false") == "true";
			OPTIMIZE_CACHE = getPropString(xml, "cacheoptimize", "false") == "true";
			
		}
		
	}
}