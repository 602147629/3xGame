package framework.resource
{
	import framework.util.XmlUtil;
	
	import flash.utils.Dictionary;

	public class AnimTimerParameter
	{
		private static var instance:AnimTimerParameter = null;
		public static function getInstance():AnimTimerParameter
		{
			if(instance == null)
			{
				instance = new AnimTimerParameter();
			}
			return instance;
		}
		
		//public static const CONSTRUCTION_TIMER:String 			= "constructionActionTimer";
		//public static const TAX_COLLECTION_TIMER:String 		= "taxCollectionActionTimer";
		public static const BUSINESS_HARVEST_TIMER:String		= "businessHarvestActionTimer"; //0
		public static const FACTORY_HARVEST_TIMER:String 		= "factoryHarvestActionTimer"; //0
		
		
		//public static const DEBRIS_CLEAR_TIMER:String 			= "debrisClearActionTimer";
		public static const COIN_SPLASHCOLLECTION_SLEEP_TIMER:String 	= "coinSplashCollectionActionTimer";
		//public static const BULLDOZER_TIMER:String 				= "bulldozerActionTimer";
		public static const DAMAGED_BUILDINGREPAIR_TIMER:String = "damagedBuildingRepairActionTimer";
		public static const TILEBUILDING_GENERATE_TIMER:String = "tileBuildingGenerateTimer";

		private var data:Dictionary = null;
		public function getSecondByID(id:String):Number
		{
			return 0;
			
			var second:Object = data[id];
			if(second == null) 
				second = 0;
			return Number(second);
		}
		
		public function AnimTimerParameter()
		{
			CONFIG::debug
			{
				if(instance != null)
					ASSERT(false, "AnimTimerParameter singleton already exist");
			}
			instance = this;
			
		}
		
		public function initParameter(xml:XML):void
		{
			if(data == null) data = new Dictionary();
			
			var list:XMLList = xml.item;
			for each(var temp:XML in list)
			{
				var type:String = XmlUtil.attrString(temp, "animType");
				var second:Number = XmlUtil.attrNumber(temp, "second");
				data[type] = second;
			}
		}
	}
}