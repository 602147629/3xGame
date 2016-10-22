package framework.rpc
{
	import flash.filters.ColorMatrixFilter;
	import flash.net.SharedObject;
	
	public class ConfigManager extends Object
	{
		private static var _canvasWidth:Number;
		private static var _canvasHeight:Number;
		private static var _mathematicsModelHeight:int = 0;
		private static var controlBarSpriteHeight:Number = 42;
		
		public static var leftCannonX:Number = 100;
		public static var centerCannonX:Number = 475;
		public static var rightCannonX:Number = 1280;
		public static var bottomCannonY:Number = 45;
		public static var topCannonY:Number = 773;
		
		public static var versions:String = "?v=0.0.1";
		
		public static var SOCKET_LOBBY:String = "lobbySocket";
	/*	CONFIG::debug
		{				
			public static var SOCKET_LOBBY_IP:String = "10.16.49.33";
		}*/
		
//		public static var SOCKET_LOBBY_IP:String = "lobby.3x.qipai.360.cn";
//		public static var SOCKET_LOBBY_IP:String = "lobbytest.3x.qipai.360.cn";
		public static var SOCKET_LOBBY_IP:String = CONFIG::lobbyServer;

		public static var SOCKET_LOBBY_PORT:int = 20001;
		public static var SOCKET_LOBBY_ORGION:int = 3;
		public static var GAME_ID:int = 1013;
		
		public static var FCM_TIME:int = 3;
		
		public static var SOCKET_GAME:String = "gameSocket";
		
		public static var SOCKET_MATCH:String = "matchSocket";
		
		public static var SOCKET_GAME_ORGION:int = 4;
		
		public static const REWARD_URL:String = "http://qipai.360.cn/award/?game_code=3xiao";
		
		public static const LUTAN_URL:String = "http://bbs.360safe.com/forum-2414-1.html";
		
		public static var isInit:Boolean = true;
		
		public static var FLASHFILTER:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, -100, 0, 1, 0, 0, -100, 0, 0, 1, 0, -100, 0, 0, 0, 1, 0]);
		
		/**
		 * 本地信息 
		 */		
		private static var gameSO:SharedObject;
		
		public function ConfigManager()
		{
			
		}
		
		public static function init() : void
		{
			createShareObject();
		}
		
		/**
		 *  创建本地缓存 
		 * @param userID
		 * 
		 */		
		private static function createShareObject():void
		{
			gameSO = SharedObject.getLocal("gamePlayerInfo");
		}
		
		/**
		 *  存入本地 
		 * @param key
		 * @param value
		 * 
		 */		
		public static function setShareObject(key:Object, value:Object):void
		{
			if(gameSO != null && gameSO.data != null)
			{
				gameSO.data[key] = value;
			}
		}
		
		/**
		 *  从本地取出 
		 * @param key
		 * @return 
		 * 
		 */		
		public static function getShareObject(key:Object):Object
		{
			if(gameSO != null && gameSO.data != null)
			{
				return gameSO.data[key];
			}
			return null;
		}
		
		/**
		 *  删除本地缓存 
		 * @param key
		 * 
		 */		
		public static function delShareObject(key:Object):void
		{
			if(gameSO != null && gameSO.data != null)
			{
				delete gameSO.data[key];
			}
		}
	}
}