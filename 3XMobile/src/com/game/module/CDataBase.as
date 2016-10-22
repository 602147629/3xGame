package com.game.module
{
	/**
	 * @author caihua
	 * @comment 数据基类
	 * 创建时间：2014-6-12 下午2:31:55 
	 */
	public class CDataBase
	{
		protected var _databaseName:String
		protected var _dataContains:Array;
		
		public function CDataBase(name:String)
		{
			this._databaseName = name;	
			_dataContains = new Array();
		}
		
		public function get databaseName():String
		{
			return _databaseName;
		}

		public function setData(key:String ,val:*):void
		{
			_dataContains[key] = val;
		}
		
		public function getData(key:String ,defval:* = null):*
		{
			if(!_dataContains[key])
			{
				return defval;
			}
			
			return _dataContains[key];
		}
	}
}