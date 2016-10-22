package com.game.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * @author zhangxin
	 * */
	public class ResourceLoader extends EventDispatcher
	{
		private var _loader:URLLoader;
		private var _type:int;
		private var _resource:*;
		private var _name:String;
		public function ResourceLoader()
		{
		}
		
		public function get name():String
		{
			return _name;
		}

		public function load(url:String,type:int,fName:String):void
		{
			_type = type;
			_name = fName;
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			try
			{
				_loader.load(new URLRequest(url));
			} 
			catch(error:Error) 
			{
				CONFIG::debug
				{
					TRACE_LOADING("路径不对");
				}
			}
			
			initEvents();
		}
		
		private function initEvents():void
		{
			_loader.addEventListener(Event.COMPLETE,completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
		}
		
		private function removeEvents():void
		{
			if (_loader) 
			{
				_loader.removeEventListener(Event.COMPLETE,completeHandler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			}
		}
		
		private function completeHandler(e:Event):void{
			_resource = e.target.data;
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.removeEvents();
		}
		
		private function IOErrorHandler(event:IOErrorEvent):void{
			this.removeEvents();
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get resource():*
		{
			return _resource;
		}
		
	}
}