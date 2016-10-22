package com.game.utils
{
	import com.game.consts.ResourceConst;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	/**
	 * @author zhangxin
	 * */
	public class ParseData extends EventDispatcher
	{
		private var _data:*;
		private var _callback:Function;
		private var _fName:String;
		private var _type:int;
		public function ParseData(callback:Function = null,fName:String = null,data:ByteArray = null,type:int = -1)
		{
			_fName = fName;
			_callback = callback;
			_type = type;
			if(data != null && type >= 0)
			{
				parse(data,type);
			}
		}
		
		public function get data():*
		{
			return _data;
		}
		
		/**
		 * */
		public function parse(data:ByteArray,type:int):void
		{
			switch(type)
			{
				case ResourceConst.TYPE_IMG :
					parseByLoader(data,image);
					break;
				case ResourceConst.TYPE_SWF :
					parseByLoader(data,swf);
					break;
				case ResourceConst.TYPE_XML :
					parseXml(data);
					break;
			}
		}
		
		
		/**
		 * 转换成swf资源
		 * */
		public function parseSwf(data:ByteArray):void
		{
			parseByLoader(data,swf);
		}
		
		/**
		 * 转化成XML
		 * */
		public function parseXml(data:ByteArray):XML
		{
			_data = data.readMultiByte(data.bytesAvailable,"utf-8");
			_data = new XML(_data);
			//
			if(_callback != null) 
			{
				_callback(_data,_fName,_type);
			}
			return _data;
		}
		
		/**
		 * 转化成图片
		 * */
		public function parseImg(data:ByteArray):void
		{
			parseByLoader(data,image);
		}
		
		////////////////////////////////////
		private function parseByLoader(data:ByteArray,handler:Function):void
		{
			var loader:Loader = new Loader;
			loader.loadBytes(data);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,handler);
		}
		
		private function image(e:Event):void
		{
			//trace("是位图吗？ ",(e.target.content is Bitmap));
			//trace("是位图数据吗？",(e.target.content is BitmapData));
			_data = (e.target.content as Bitmap).bitmapData;
			this.dispatchEvent(new Event(Event.COMPLETE));
			if(_callback != null)
			{
				_callback(_data,_fName,_type);
			}
		}
		
		private function swf(e:Event):void
		{
			_data = e.target.content;
			this.dispatchEvent(new Event(Event.COMPLETE));
			if(_callback != null) 
			{
				_callback(_data,_fName,_type);
			}
		}
	}
}