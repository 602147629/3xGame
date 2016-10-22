package framework.resource
{
	public class GameResource extends Resource
	{
		public static const TYPE_BUILDING:int = 1;
		public static const TYPE_MATERIAL:int = 2;
		public static const TYPE_GSC_ITEM:int = 3;
		
		public var label:String;
		private var _label : String;

		public var desc:String ;
		private var _desc : String;
		
		public var resType:int;
		
		public static const GAMETYPE_UNKNOWN:int = 0;
		public static const GAMETYPE_DATATYPE:int = 1;
		public static const GAMETYPE_GAMEINFO:int = 2;
		public static const GAMETYPE_MAPINFO:int = 3;
		public static const GAMETYPE_SIM_SOUND_CONFIG:int = 39;

		
		public function GameResource()
		{
		}
		
		override public function init(xml:XML, file:ResourceFile, parent:Resource, resId:String = null):void
		{
			super.init(xml, file, parent);
			
			// label
			_label = getPropString(xml, "label");
			
			// desc
			_desc = getPropString(xml, "desc","");
		}

		override public function notifyLangChange() : void
		{
			super.notifyLangChange();
			
			label = _label;
			desc = _desc;
		}
	}
}