package com.ui.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @author caihua
	 * @comment 请求
	 * 创建时间：2014-7-4 下午4:29:10 
	 */
	public class CHttpUtil
	{	
		private var _paramObj:Object = new Object();
		private var _url:String = "";
		private var _recall:Function;

		public function CHttpUtil(recall:Function , url:String)
		{
			this._recall = recall;
			_url = url;
		}

		public function reSet():void
		{
			this._paramObj = new Object();
		}
		
		private function http_req(cache:Boolean):void
		{
			var variables:URLVariables = new URLVariables();
			for(var key:Object in this._paramObj)
			{
				variables[key] = this._paramObj[key];
			}
			if (cache == false)
			{
				variables.r =  Math.random();
			}
			
			try
			{
				
				var request:URLRequest = new URLRequest();			
				request.url =  this._url;
				request.method = URLRequestMethod.GET;
				request.data = variables;
				var loader:URLLoader = new URLLoader();			
				loader.dataFormat = URLLoaderDataFormat.TEXT;
				loader.addEventListener(Event.COMPLETE, http_complete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, loader_ioError);
			
			    loader.load(request);			   		    
			}
			catch (error:Error)
			{
			    trace("Unable to load URL");
			}
		}

		private function loader_ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
			if(null != this._recall) 
			{
				this._recall(null);
			}
		}

		private function http_complete(event:Event):void
		{
			if(null != this._recall) 
			{
				this._recall(event.target.data);
			}
		}		

		public function setUrl(url:String):void
		{
			this._url = url;
		}

		public function sendQuery(cache:Boolean=false):void
		{
			http_req(cache);
		}
		
		public function setParam(obj:Object):void
		{
			this._paramObj = obj;
		}		
	}
}

