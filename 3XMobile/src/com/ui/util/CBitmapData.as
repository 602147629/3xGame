package com.ui.util
{
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	
	/**
	 * BitmapData 对象
	 */
	public class CBitmapData
	{
		private static var INSTANCE:CBitmapData; 	//单例
		private var _bitmapDatas:Object = { };
		private var _bitmapComposeKeys:Array = [];
		private var _bitmapLocks:Object = {};
		
		public function CBitmapData() 
		{
		}
		
		public static function o():CBitmapData
		{
			if (null == INSTANCE)
			{
				INSTANCE = new CBitmapData();
			}
			return INSTANCE;
		}
		
		public function setRaw(key:String, bitmapData:BitmapData):void
		{
			this.set(key, bitmapData);
		}
		
		public function getRaw(key:String):BitmapData
		{
			return this.get(key);
		}
		
		public function setCompose(key:String, bitmapData:BitmapData):void
		{
			this.set(key, bitmapData);
			if ( -1 == this._bitmapComposeKeys.indexOf(key))
			{
				this._bitmapComposeKeys.push(key);
			}
		}
		
		public function getCompose(key:String):BitmapData
		{
			return this.get(key);
		}
		
		public function getData(key:String):Object
		{
			if (!this.has(key)) 
			{
				return null;
			}
			return this._bitmapDatas[key];
		}
		
		private function set(key:String, bitmapData:BitmapData):void
		{
			var data:Object = {};
			data['reference'] = 0;
			data['bitmapdata'] = bitmapData;
			var date:Date = new Date();
			data["lasttime"] = date.getTime();
			data['key'] = key;
			this._bitmapDatas[key] = data;
		}
		
		private function get(key:String):BitmapData
		{
			if(this._bitmapDatas.hasOwnProperty(key))
			{
				return this._bitmapDatas[key]['bitmapdata'];
			}
			return null;
		}
		
		public function has(key:String):Boolean
		{
			return this._bitmapDatas[key] != undefined;
		}
		
		public function reomve(key:String):Boolean
		{
			if(undefined != this._bitmapDatas[key])
			{
				this._bitmapDatas[key]['bitmapdata'].dispose();
				this._bitmapDatas[key]['bitmapdata'] = null;
				delete this._bitmapDatas[key];
				return true;
			}
			
			return false;
		}
		
		public function addReferenc(key:String):void
		{
			if(undefined != this._bitmapDatas[key])
			{
				this._bitmapDatas[key]['reftime'] = getTimer();
				this._bitmapDatas[key]['reference'] ++;
			}
		}
		
		public function subReferenc(key:String):void
		{
			if(undefined != this._bitmapDatas[key] && this._bitmapDatas[key]['reference'] > 0)
			{
				this._bitmapDatas[key]['reference'] --;
			}
		}
		
		public function isLock(key:String):Boolean
		{
			return this._bitmapLocks[key] != undefined;
		}
		
		public function lock(key:String):Boolean
		{
			if(!this.isLock(key))
			{
				this._bitmapLocks[key] = 1;
				return true;
			}
			
			return false;
		}
		
		public function unlock(key:String):void
		{
			if(this.isLock(key))
			{
				delete this._bitmapLocks[key];
			}
		}
		
		public function get __bitmapDatas():Object
		{
			return this._bitmapDatas;
		}
		
		public function destoryCompose():void
		{
			var removecout:int = 0;
			for each( var key:String in this._bitmapComposeKeys)
			{
				if (this.reomve(key))
				{
					removecout++;
				}
			}
			trace("destoryCompose:" + removecout);
			this._bitmapComposeKeys = [];
		}
	}

}