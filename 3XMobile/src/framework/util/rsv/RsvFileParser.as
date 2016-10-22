package framework.util.rsv
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import framework.util.DisplayUtil;

	/**
	 * comments by Ding Ning
	 * it is use to convert the binary stream loaded by RsvFile, to flash content, includes:
	 * -swf, another load thread will be raised
	 * -xml, directly to use
	 */
	
	public class RsvFileParser extends RsvObject
	{
		protected var _file:RsvFile;
		protected var _content:Object;
		
		protected var _swfLoader:Loader;
		protected var _domain:ApplicationDomain;
		private var context:LoaderContext;
		
		public function RsvFileParser(f:RsvFile, cb:Function)
		{
			_file = f;
			CONFIG::debug
			{
				ASSERT(_file != null, "[RsvfParser.parse]null rsvf");
			}

			CONFIG::debug
			{
				ASSERT(cb != null, "[RsvfParser.parse]null callback");
			}
				
			_cb = cb;	
			
			context = new LoaderContext();
			context.allowCodeImport = true;
			context.allowLoadBytesCodeExecution = true;
		}
		
		public function parse():void
		{
			// default parser code
			// override this function to make your own
			switch(_file.rsvFileType())
			{
				case _file.FILE_TYPE_SWF:
					if((_file.rawdata as ByteArray).length == 0)
					{
						TRACE_RES(_file.id + "(" + _file.path + ")'s data length is 0");
					}
					
					createSwfLoader();
					break;
				case _file.FILE_TYPE_IMG:
					if((_file.rawdata as ByteArray).length == 0)
					{
						TRACE_RES(_file.id + "(" + _file.path + ")'s data length is 0");
					}
					
					createSwfLoader();
					break;
				case _file.FILE_TYPE_XML:
					var xml:XML
					try
					{
						xml = new XML(_file.rawdata)
					}
					catch(err:Error)
					{
						CONFIG::debug
						{
							ASSERT(false, _file.id + " is broken," + err.toString());
						}
					}
					noticeContent(xml, RsvEvent.CONTENTREADY);
					break;
				case _file.FILE_TYPE_NULL:
					noticeContent(null, RsvEvent.CONTENTREADY);
					break;
			}
			
			//原函数体：
			/*
			if(_file.extension == "swf")
			{
				if((_file.rawdata as ByteArray).length == 0)
				{
					TRACE_RES(_file.id + "(" + _file.path + ")'s data length is 0");
				}

				createSwfLoader();
			}
			
			else if(_file.extension == "png" || _file.extension == "jpg")
			{
				if((_file.rawdata as ByteArray).length == 0)
				{
					TRACE_RES(_file.id + "(" + _file.path + ")'s data length is 0");
				}
				
				createSwfLoader();
			}
			else 
			{
				var xml:XML
				try
				{
					xml = new XML(_file.rawdata)
				}
				catch(err:Error)
				{
					CONFIG::debug
					{
						ASSERT(false, _file.id + " is broken," + err.toString());
					}
				}
				noticeContent(xml, RsvEvent.CONTENTREADY);
				// default return the raw data from file
//				noticeContent(null, RsvEvent.CONTENTREADY);
			}
			*/
		}
				
		public function getContent():Object
		{
			return _content;
		}
		
		public function getContentDomain():ApplicationDomain
		{
			return _domain;// _swfLoader != null ? _swfLoader.contentLoaderInfo.applicationDomain : null;
		}
		
		final protected function noticeContent(o:Object, itype:int):void
		{
//			removeSwfLoader();
			
			_content = (o == null) ? _file.rawdata : o;
			sendCallBack(itype);
			
/*			CONFIG::debug
			{
				if(o is XML)
				{
					TRACE_RES(_file.path + " version number:" + o.@version);
				}
			}
*/			
			
		}
		
		private function swfLoaderError(ev:IOErrorEvent):void
		{
			noticeContent(null, RsvEvent.CONTENTERROR);

			removeSwfLoader();
		}
		
		private function swfLoaderComplete(ev:Event):void
		{
			_domain = _swfLoader.contentLoaderInfo.applicationDomain;

			validateAsset();
			noticeContent(_swfLoader.content, RsvEvent.CONTENTREADY);

			removeSwfLoader();
		}
		
		private function validateAsset():void
		{
			var swfLoaderContainer:DisplayObjectContainer = _swfLoader.content as DisplayObjectContainer;
			if(swfLoaderContainer)
			{
				
				CONFIG::debug
				{
					if(swfLoaderContainer.numChildren > 0)
					{
						TRACE_VALIDATE("WARNING!!!  " + _file.path + " has asset on stage");
					}
					
					var movieClip:MovieClip = swfLoaderContainer as MovieClip;
					if(movieClip.totalFrames > 1)
					{
						TRACE_VALIDATE("WARNING!!!  " + _file.path + " has at least 2 frames");
					}
				}
				
				DisplayUtil.stopAllAnim(swfLoaderContainer);
				DisplayUtil.removeAllChildren(swfLoaderContainer);
				
			}
		}
		
		private function createSwfLoader():void
		{
			_swfLoader = new Loader();
			_swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, swfLoaderError);
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaderComplete);
			_swfLoader.loadBytes(_file.rawdata as ByteArray, context);

		}
		
		private function removeSwfLoader():void
		{
			if(_swfLoader != null)
			{
				_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaderComplete);
				_swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, swfLoaderError);
				_swfLoader = null;
			}
		}
		
		public override function destroy():void
		{
			removeSwfLoader();
			
			_file = null;
			_content = null;
			
//			if(_swfLoader != null)
//			{
//				_swfLoader = null;
//			}
			
			super.destroy();
		}
	}
}