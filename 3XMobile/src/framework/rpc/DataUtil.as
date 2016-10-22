package framework.rpc
{
	import com.netease.protobuf.UInt64;
	import com.ui.util.CTimer;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	public class DataUtil extends Object
	{
		public var myUserID:UInt64;
		public var selectProductID:int;
		public var selectMatchProductID:int;
		public var currentDiplomaNum:int;
		public var diplomaList:Array;
		public var tryReconnect:int;
		
		public static const RECONNECT_NUM:int = 3;
		
		private var _systemTime:Number;
		private var _spanTime:Number;
		/**
		 * 记录防沉迷时间 
		 */		
		private var _fcmTime:Number = 0;
		
		/**
		 * 数据保存
		 **/
		protected var _cacheDatabase:Dictionary;	
		
		private static var _instance:DataUtil;
		private var _roomInfo:Object;
		
		private var _isExitGame:Boolean;
		private var _userType:int;
		
		private var _loadFirstGroupStartTime:Number;
		private var _loadFirstGroupEndTime:Number;
		
		private var _loadSecondGroupStartTime:Number;
		private var _loadSecondGroupEndTime:Number;
		
		private var _netConnectionStartTime:Number;
		private var _netConnectionEndTime:Number;
		
		private var _configDecodeStartTime:Number;
		private var _configDecodeEndTime:Number;
		
		private var _isInWorld:Boolean = false;
		private var _myRank:int;
		
		private var _systemCtimer:CTimer;
		
		private var _totalUser:int;
		private var _isResReadey:Boolean;
		private var _currentPos:int = -1;
		private var _giftId:int;
		public var qt:String;
		
		private var _getFriendNum:int = 0;
		public var showNotice:Boolean;
		
		private var _isLoadingFriendData:Boolean = false;
		
		public function DataUtil()
		{
			this._cacheDatabase = new Dictionary();
			this.diplomaList = new Array();
			this.tryReconnect = RECONNECT_NUM;
		}
		
		public static function get instance() : DataUtil
		{
			if(_instance == null)
			{
				_instance = new DataUtil();
			}
			return _instance;
		}
		
		public function getSystemTimeSpan(date:Number):Number
		{
			var ret:Number;
			ret = date - systemTime;
			return ret;
		}
		
		/**
		 * 设置数据
		 **/
		public function setCacheDB(className:Class, data:Object):Boolean
		{
			var ret:Boolean = false;
			var tableName:String = getQualifiedClassName(className).replace("::",".");
			
			var dbObj:* = getCacheDBTableById(tableName,data.id);
			if(!dbObj)
			{
				dbObj = new className(data);
				
				var tableObject:Object = _cacheDatabase[tableName];
				if(tableObject==null)
				{ 
					tableObject = new Object(); 
				}
				
				tableObject[data.id] = dbObj;			
				_cacheDatabase[tableName] = tableObject;	
				
				ret = true;
			}else
			{
				for(var o:Object in data)
				{
					dbObj[o] = data[o];
				}
			}
			
			return ret;
		}
		
		/**
		 *  存入key value键值对 
		 * @param key
		 * @param value
		 * @return 
		 * 
		 */		
		public function setCacheDBByKV(key:*, value:*):Boolean
		{
			var ret:Boolean = false;
			if(this._cacheDatabase[key] == null)
			{
				this._cacheDatabase[key] = value;
				ret = true;
			}
			return ret;
		}
		
		/**
		 * 去除数据 
		 * 
		 */		
		public function cleanCache():void
		{
			_cacheDatabase = new Dictionary();
		}
		
		/**
		 * 获取数据
		 **/
		public function getCacheDBTable(tablename:String):*
		{
			if(!_cacheDatabase){_cacheDatabase=new Dictionary();}			
			return _cacheDatabase[tablename];
		}
		
		/**
		 *  获取key value 键值对 
		 * @param key
		 * @return 
		 * 
		 */		
		public function getCacheDBByKey(key:*):*
		{
			if(!_cacheDatabase){_cacheDatabase=new Dictionary();}
			return _cacheDatabase[key];
		}
		
		/**
		 * 删除数据
		 **/
		public function deleteCacheDBTable(key:*):void
		{
			if(_cacheDatabase[key] != null)
			{
				delete _cacheDatabase[key];	
			}
		}
		
		/**
		 *  删除单个数据 
		 * @param tablename
		 * @param keyId
		 * 
		 */		
		public function deleteCacheDBTableByID(tablename:String,keyId:*):void
		{
			if(_cacheDatabase[tablename] != null && _cacheDatabase[tablename][keyId] != null)
			{
				delete _cacheDatabase[tablename][keyId];	
			}
		}
		
		/**
		 * 根据keyId获取单个数据
		 * @param tablename
		 * @param keyId
		 * @return  
		 * 
		 */		
		public function getCacheDBTableById(tablename:String,keyId:*):*
		{
			if(!_cacheDatabase[tablename])
			{
				return null;
			}
			return _cacheDatabase[tablename][keyId];
		}
		
		/**
		 * 获取数据列表 
		 * @param tablename
		 * @return 
		 * 
		 */		
		public function getCacheDBTableToArray(tablename:String):Array
		{
			if(!_cacheDatabase){_cacheDatabase=new Dictionary();}			
			var obj:Object = _cacheDatabase[tablename];
			var ret:Array = new Array();
			for each(var o:Object in obj)
			{
				ret.push(o);
			}
			return ret;
		}
		
		/**
		 * 获取数据列表 
		 * @param tablename
		 * @return 
		 * 
		 */		
		public function getCacheDBTableByCustomKey(tablename:String,...tableKeys):Array
		{
			if(!_cacheDatabase){_cacheDatabase=new Dictionary();}			
			var obj:Object = _cacheDatabase[tablename];
			var ret:Array = new Array();
			var isTrue:Boolean = true;
			return ret;
		}
		
		/**
		 *  设置系统时间 
		 * @param time
		 * 
		 */		
		public function setSystemTime(time:Number):void
		{
			this._systemTime = time;
			
			if(_systemCtimer == null)
			{
				this._systemCtimer = new CTimer();
				this._systemCtimer.addCallback(repeat,1);
				_systemCtimer.start();
			}
		}
		
		public function get systemTime() : Number
		{
			return this._systemTime;
		}
		
		public function set fcmTime(value:Number):void
		{
			this._fcmTime = value;
		}
		
		public function get fcmTime() : Number
		{
			return this._fcmTime;
		}
		
		/**
		 * 跑秒 
		 * 
		 */		
		private function repeat():void
		{
			this._systemTime += 1;
		}

		public function get roomInfo():Object
		{
			return _roomInfo;
		}

		public function set roomInfo(value:Object):void
		{
			_roomInfo = value;
		}

		public function get isExitGame():Boolean
		{
			return _isExitGame;
		}

		public function set isExitGame(value:Boolean):void
		{
			_isExitGame = value;
		}

		public function get userType():int
		{
			return _userType;
		}

		public function set userType(value:int):void
		{
			_userType = value;
		}

		public function get loadFirstGroupStartTime():Number
		{
			return _loadFirstGroupStartTime;
		}

		public function set loadFirstGroupStartTime(value:Number):void
		{
			_loadFirstGroupStartTime = value;
		}

		public function get netConnectionStartTime():Number
		{
			return _netConnectionStartTime;
		}

		public function set netConnectionStartTime(value:Number):void
		{
			_netConnectionStartTime = value;
		}

		public function get loadFirstGroupEndTime():Number
		{
			return _loadFirstGroupEndTime;
		}

		public function set loadFirstGroupEndTime(value:Number):void
		{
			_loadFirstGroupEndTime = value;
		}

		public function get netConnectionEndTime():Number
		{
			return _netConnectionEndTime;
		}

		public function set netConnectionEndTime(value:Number):void
		{
			_netConnectionEndTime = value;
		}

		public function get configDecodeStartTime():Number
		{
			return _configDecodeStartTime;
		}

		public function set configDecodeStartTime(value:Number):void
		{
			_configDecodeStartTime = value;
		}

		public function get configDecodeEndTime():Number
		{
			return _configDecodeEndTime;
		}

		public function set configDecodeEndTime(value:Number):void
		{
			_configDecodeEndTime = value;
		}

		public function get loadSecondGroupStartTime():Number
		{
			return _loadSecondGroupStartTime;
		}

		public function set loadSecondGroupStartTime(value:Number):void
		{
			_loadSecondGroupStartTime = value;
		}

		public function get loadSecondGroupEndTime():Number
		{
			return _loadSecondGroupEndTime;
		}

		public function set loadSecondGroupEndTime(value:Number):void
		{
			_loadSecondGroupEndTime = value;
		}

		public function get isInWorld():Boolean
		{
			return _isInWorld;
		}

		public function set isInWorld(value:Boolean):void
		{
			_isInWorld = value;
		}

		public function get myRank():int
		{
			return _myRank;
		}

		public function set myRank(value:int):void
		{
			_myRank = value;
		}

		public function get totalUser():int
		{
			return _totalUser;
		}

		public function set totalUser(value:int):void
		{
			_totalUser = value;
		}

		public function get isResReadey():Boolean
		{
			return _isResReadey;
		}

		public function set isResReadey(value:Boolean):void
		{
			_isResReadey = value;
		}

		public function get currentPos():int
		{
			return _currentPos;
		}

		public function set currentPos(value:int):void
		{
			_currentPos = value;
		}

		public function get giftId():int
		{
			return _giftId;
		}

		public function set giftId(value:int):void
		{
			_giftId = value;
		}

		public function get getFriendNum():int
		{
			return _getFriendNum;
		}

		public function set getFriendNum(value:int):void
		{
			_getFriendNum = value;
		}

		public function get isLoadingFriendData():Boolean
		{
			return _isLoadingFriendData;
		}

		public function set isLoadingFriendData(value:Boolean):void
		{
			_isLoadingFriendData = value;
		}


	}
}
