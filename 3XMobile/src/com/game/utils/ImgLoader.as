package com.game.utils
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * 加载图片的通用类 
	 * @author melody
	 */	
	public class ImgLoader extends EventDispatcher {
		
		//加载内容需要添加的版本信息 比如 xx.swf?v=12345
		public static var contentVersion:String="";
		
		private var _loader:Loader;
		
		public var _name:String;
		public var _img:Bitmap;
		
		public function ImgLoader(url:String,name:String="") {
			if(!url) return;
			this._loader=new Loader();
			this._name=name;
			this.initEvents();
			//增加版本控制
			this._loader.load(new URLRequest(url+contentVersion),new LoaderContext(true));//currentDomain?
		}
		
		private function initEvents():void{
			this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
		}
		
		private function removeEvents():void{
			if (_loader) 
			{
				this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeHandler);
				this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,IOErrorHandler);
			}
		}
		
		private function completeHandler(event:Event):void{
			this.removeEvents();
			this._img=event.target.content as Bitmap;
			this._loader.unloadAndStop();
			this._loader=null;
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function IOErrorHandler(event:IOErrorEvent):void{
			this.removeEvents();
		}
		
		public function dispose():void{
			if (_img&&_img.bitmapData) 
			{
				this._img.bitmapData.dispose();
			}
			this._img=null;
			if (_loader) 
			{
				this.removeEvents();
				_loader=null;
			}
		}
		
	}
}