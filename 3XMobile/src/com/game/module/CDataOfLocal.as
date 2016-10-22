package com.game.module
{
	import flash.net.SharedObject;
	import flash.utils.Dictionary;

	/**
	 * @author caihua
	 * @comment 本地存储 不能存false
	 * 创建时间：2014-7-9 下午4:36:11 
	 */
	public class CDataOfLocal extends CDataBase
	{
		private var so:SharedObject;
		private var storage:Object;
		private var dictionary:Dictionary;
		
		public static var LOCAL_DATA_KEY:String = "sanxiaolocal";
		public static var LOCAL_KEY_MUSIC_EFFECT:String = "musiceffect";
		public static var LOCAL_KEY_MUSIC_WORLD:String = "musicworld";
		public static var LOCAL_KEY_LEVEL_SETTING:String = "levelSetting";
		
		public function CDataOfLocal()
		{
			super("CDataOfLocal");
			setupSharedObject(LOCAL_DATA_KEY);
		}
		
		public function setupSharedObject(_string:String):void 
		{
			so = SharedObject.getLocal(_string);
		}
		
		public function getKey(_string:String , _defval:* = null):* 
		{
			var _data:* = so.data[_string];
			
			if(!_data)
			{
				return _defval;
			}
				
			return _data;
		}
		
		public function setKey(_key:String , _val:*):void 
		{
			so.data[_key] = _val
			save();
		}
		
		public function delKey(_key:String):void
		{
			if(so.data.hasOwnProperty(_key))
			{
				so.data[_key] = null;
				save();
			}
		}
		
		public function save():void {
			so.flush()
		}
	}
}