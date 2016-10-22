package framework.gamesetting
{
	import flash.net.SharedObject;

	public class GameSettingSharedObject
	{
		private var storage:SharedObject;
		private var _memoryStorage:Object;
		
		private static const GAME_SETTING_SHARED_OBJECT_NAME:String = "ShenJiangXiYou_game_setting13"; //never change it
		private static const GAME_SETTING_DATA_FIELD:String = "GAME_SETTING_KEY";
		

		
		private static var _instance:GameSettingSharedObject;
		public static function get instance():GameSettingSharedObject
		{
			if(_instance == null)
			{
				_instance = new GameSettingSharedObject();
			}
			return _instance;
		}
		
		private function readFile():void
		{
			try
			{
				storage = SharedObject.getLocal(GAME_SETTING_SHARED_OBJECT_NAME,"/");
			}
			catch(e:Error)
			{
			}
		}
		
		private function writeFile():void
		{
			try
			{
				storage.flush();
			}
			catch(e:Error)
			{
			}
		}
		
		private function get memoryStoragy():Object
		{
			if(_memoryStorage == null)
			{
				_memoryStorage = new Object();
				_memoryStorage.data = new Object();
			}
			return _memoryStorage;
		}
		
		public function GameSettingSharedObject()
		{
			readFile();
			
			if(storage != null)
			{
				if(storage.data[GAME_SETTING_DATA_FIELD] == null)
				{
					setDefaultSetting(storage.data);
					
					writeFile();
				}
			}
			else
			{
				setDefaultSetting(memoryStoragy);
				
			}
			
		}
		
		private function setDefaultSetting(data:Object):void
		{
			data[GAME_SETTING_DATA_FIELD] = {};
			
			data[GAME_SETTING_DATA_FIELD][GameSharedObjectSettingType.HQ_SETTING] = true;
			data[GAME_SETTING_DATA_FIELD][GameSharedObjectSettingType.MUSIC_SETTING] = true;
			data[GAME_SETTING_DATA_FIELD][GameSharedObjectSettingType.SOUND_SETTING] = true;
						
		}
		
		private function hasProperty(type:String):Boolean
		{
			if(storage != null)
			{
				return storage.data[GAME_SETTING_DATA_FIELD][type] != null;
			}
			else
			{
				return memoryStoragy[GAME_SETTING_DATA_FIELD][type] != null;
			}
		}
		
		public function getEnabled(type:String):Boolean
		{
			if(!hasProperty(type))
			{
				return false;
			}
			
			if(storage != null)
			{
				return storage.data[GAME_SETTING_DATA_FIELD][type];
			}
			else
			{
				return memoryStoragy[GAME_SETTING_DATA_FIELD][type];
			}
		}
		
		public function setEnabled(type:String,on:Boolean):void
		{
			if(storage != null)
			{
				storage.data[GAME_SETTING_DATA_FIELD][type] = on;
			}
			else
			{
				memoryStoragy[GAME_SETTING_DATA_FIELD][type] = on;
			}
		}
		
		public function getIntValue(type:String):int
		{
			if(!hasProperty(type))
			{
				return 0;
			}
			
			if(storage != null)
			{
				return storage.data[GAME_SETTING_DATA_FIELD][type];
			}
			else
			{
				return memoryStoragy[GAME_SETTING_DATA_FIELD][type];
			}
		}
		
		public function setIntValue(type:String,n:int):void
		{
			if(storage != null)
			{
				storage.data[GAME_SETTING_DATA_FIELD][type] = n;
			}
			else
			{
				memoryStoragy[GAME_SETTING_DATA_FIELD][type] = n;
			}
		}
		
		public function getStringValue(type:String):String
		{
			if(!hasProperty(type))
			{
				return "";
			}
			
			if(storage != null)
			{
				return storage.data[GAME_SETTING_DATA_FIELD][type];
			}
			else
			{
				return memoryStoragy[GAME_SETTING_DATA_FIELD][type];
			}
		}
		
		public function setStringValue(type:String,value:String):void
		{
			if(storage != null)
			{
				storage.data[GAME_SETTING_DATA_FIELD][type] = value;
			}
			else
			{
				memoryStoragy[GAME_SETTING_DATA_FIELD][type] = value;
			}
		}
		
	}
}