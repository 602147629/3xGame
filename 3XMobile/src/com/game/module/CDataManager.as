package com.game.module
{
	/**
	 * @author caihua
	 * @comment 用户数据类
	 * 创建时间：2014-6-13 上午10:00:42 
	 */
	public class CDataManager
	{
		private static var instance:CDataManager;
		private var _dataList:Object;
		
		
		public function CDataManager(s:Single)
		{
			_dataList = new Array();
			
			__init();
		}
		
		private function __init():void
		{
			__register(new CDataOfGameUser());
			
			__register(new CDataOfFriendList());
			
			__register(new CDataOfLevel());
			
			__register(new CDataOfLocal());
			
			__register(new CDataOfMoney());
			__register(new CDataOfUserTool());
			__register(new CDataOfProduct());
			__register(new CDataOfStarInfo());
			__register(new CDataOfFriendScoreByLevel());
			__register(new CDataOfDebugOther());
			__register(new CDataOfFunctionList());
			
		}
		
		public static function getInstance():CDataManager
		{
			if(null == instance)
			{
				instance = new CDataManager(new Single());
			}
			return instance ;
		}
		
		public function registerData(d:CDataBase):void
		{
			_dataList.push(d);
		}
		
		private function __register( data:CDataBase ):void
		{
			setData( data.databaseName, data);
		}
		
		public function setData(key:String , val:*):void
		{
			_dataList[key] = val;
		}
		
		public function getData(key:String , defVal:* = null):*
		{
			for (var k:String in _dataList)
			{
				if(k == key)
				{
					return _dataList[k];
				}
			}
			return defVal;
		}
		
		public function clearAll():void
		{
			__init();
			
			TRACE_LOG("清理所有数据");
		}
		
		public function get dataOfGameUser():CDataOfGameUser
		{
			return getData("CDataOfGameUser");
		}
		public function get dataOfFriendList():CDataOfFriendList
		{
			return getData("CDataOfFriendList");
		}
		public function get dataOfLevel():CDataOfLevel
		{
			return getData("CDataOfLevel");
		}
		public function get dataOfLocal():CDataOfLocal
		{
			return getData("CDataOfLocal");
		}
		public function get dataOfMoney():CDataOfMoney
		{
			return getData("CDataOfMoney");
		}
		public function get dataOfUserTool():CDataOfUserTool
		{
			return getData("CDataOfUserTool");
		}
		public function get dataOfProduct():CDataOfProduct
		{
			return getData("CDataOfProduct");
		}
		public function get dataOfStarInfo():CDataOfStarInfo
		{
			return getData("CDataOfStarInfo");
		}
		public function get dataOfFriendScoreByLevel():CDataOfFriendScoreByLevel
		{
			return getData("CDataOfFriendScoreByLevel");
		}
		public function get dataOfDebugOther():CDataOfDebugOther
		{
			return getData("CDataOfDebugOther");
		}
		public function get dataOfFunctionList():CDataOfFunctionList
		{
			return getData("CDataOfFunctionList");
		}
	}
}

class Single
{
	public function Single()
	{
		
	}
}