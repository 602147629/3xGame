package com.game.module
{
	import com.ui.util.CBaseUtil;
	
	import flash.utils.Dictionary;
	
	import framework.fibre.core.Notification;
	import framework.model.DataManager;
	import framework.resource.faxb.functionopen.FunctionConfig;
	import framework.types.helpers.DictionaryUtils;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 功能开启列表
	 * 创建时间：2014-9-18 12:36:11 
	 */
	public class CDataOfFunctionList extends CDataBase
	{
		private var _openList:Dictionary;
		private var _unOpenList:Dictionary;
		private var _tobeOpenList:Dictionary;
		
		public function CDataOfFunctionList()
		{
			super("CDataOfFunctionList");
		}
		
		public function init():void
		{
			_openList = new Dictionary();
			_unOpenList = new Dictionary();
			_tobeOpenList = new Dictionary();
			
			_calcFunctionList();
			
			CBaseUtil.regEvent(GameNotification.EVENT_FUNCTION_OPEN_ANI_COMPLETE , __onAniPlayComplete);
		}
		
		private function __onAniPlayComplete(d:Notification):void
		{
			var key:String = d.data as String;
			delete _tobeOpenList[key];
			_openList[key] = 1;
		}
		
		private function _calcFunctionList():void
		{
			var maxLevel:int = CDataManager.getInstance().dataOfGameUser.maxLevel;
			var len:int = DataManager.getInstance().functionList.functionConfig.length;
			
			//初始第一关的问题
			if(maxLevel == 0)
			{
				maxLevel = -1;
			}
			
			var temp:Array = new Array();
			for(var i:int =0 ; i < len ; i++)
			{
				var config:FunctionConfig = DataManager.getInstance().functionList.functionConfig[i];
				if(config.level <= maxLevel)
				{
					_openList[config.key] = 1;
				}
				else
				{
					_unOpenList[config.key] = 1;
				}
			}
		}
		
		/**
		 * 开启功能点
		 */
		public function openFunction():void
		{
			if(DictionaryUtils.length(_tobeOpenList) == 0)
			{
				return;
			}
			
			for(var key:String in _tobeOpenList)
			{
				CBaseUtil.sendEvent(GameNotification.EVENT_FUNCTION_OPEN_PANEL , __getConfig(key));
			}
		}
		
		/**
		 * 检测是否有需要开启的功能点
		 */
		public function checkNeedOpen():void
		{
			var maxLevel:int = CDataManager.getInstance().dataOfGameUser.maxLevel;
			for(var key:String in _unOpenList)
			{
				var config:FunctionConfig = __getConfig(key);
				//有需要开启的
				if(config.level <= maxLevel)
				{
					_tobeOpenList[key] = 1;
					
					delete _unOpenList[key];
				}
			}
		}
		
		/**
		 * 是否有需要开启的功能点
		 */
		public function hasOpenFunction():Boolean
		{
			return DictionaryUtils.length(_tobeOpenList) != 0;
		}
		
		/**
		 * 获取配置
		 */
		private function __getConfig(key:String):FunctionConfig
		{
			var len:int = DataManager.getInstance().functionList.functionConfig.length;
			for(var i:int =0 ; i < len ; i++)
			{
				var config:FunctionConfig = DataManager.getInstance().functionList.functionConfig[i];
				if(config.key == key)
				{
					return config;
				}
			}
			return null;
		}
		
		/**
		 * 检测共恩那个是否开启
		 */
		public function isFunctionOpen(key:String):Boolean
		{
			if(_unOpenList[key] == 1 || _tobeOpenList[key] == 1)
			{
				return false;
			}
			return true;
		}

		public function get openList():Dictionary
		{
			return _openList;
		}

		public function get unOpenList():Dictionary
		{
			return _unOpenList;
		}

		public function get tobeOpenList():Dictionary
		{
			return _tobeOpenList;
		}


	}
}