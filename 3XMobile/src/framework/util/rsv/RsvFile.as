package framework.util.rsv
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import framework.model.FileProxyUtil;
	import framework.model.LoadingThread;
	import framework.resource.LocatorManager;
	import framework.util.faxb.FAXB;
	
	/**
	 * comments by Ding Ning
	 * each RsvFile corresponding to a single file
	 * this class used to load binary stream of any single file
	 * then it will ask RsvPaser to convert them to flash contents
	 */
	
	public class RsvFile extends RsvObject
	{
		protected var _filePath:String;
		protected var _fileExt:String;
		protected var _urlLoader:URLLoader;
		protected var _loader:Loader;
		protected var _retryCount:int;
		protected var _rawdata:ByteArray;
		protected var _groupId:String;
		protected var _versions:String;
		
		protected var _status:int = STA_WAIT;
		
		protected var _parser:RsvFileParser;
		protected var _content:Object;
		protected var _contentData:Object;
		
		public static var commonParserClass:Class;
		
		public static const STA_WAIT:int = 0;
		public static const STA_LOADING:int = 1;
		public static const STA_LOADCOMPLETE:int = 2;
		public static const STA_ERROR:int = 3;
		public static const STA_CONTENTREADY:int = 4;
		public static const STA_PARSEERROR:int = 5;
		
		private static const RETRY_TIMES:int = 5;
		
		public const FILE_TYPE_XML:int = 1;
		public const FILE_TYPE_SWF:int = 2;
		public const FILE_TYPE_IMG:int  =3;
		public const FILE_TYPE_NULL:int = -1;
		
		//used for sorting back ground loading tasks 
		public var importanceWeight:int = LoadingThread.PRIORITY_LAOD_ON_DEMAND;
		
		public var fileDomain:int;
		public var fileSize:int;
		
		public var parameters:Object;
		
		private var _webPath:String;
		
		private static const USE_LZMA_DECODE:Boolean = false;
		
		public function RsvFile(id:String=null, filePath:String=null, autoRegist:Boolean=true, groupId:String = null, versions:String = null)
		{
			super(id, autoRegist);
			
			_groupId = groupId;	
			_versions = versions;
			
			_webPath = Debug.resPath;
			
			_filePath = filePath;
			_fileExt = fileExtension(_filePath);
			
			fileDomain = getDomain();
			fileSize = getFileSize();
			
			if(id == null || id =="" || id == " ")
			{
				CONFIG::debug
				{
					ASSERT(id != null, "id can not equals null!");
				}
			}
			
		/*	CONFIG::debug
			{
				if(groupId != FileProxy.SPLIT_LOADING_GROUP_ID && id != FileProxyUtil.PACKAGE_CONFIGURE_FILE_ID)
				{
					ASSERT(fileDomain >= 0, "can't get domain for asset, id = " + id + ", file = " + filePath);
				}
			}*/
			
		}
		
		/*public function isLangFile():Boolean
		{
			return _groupId == FileProxy.LANG_GROUP_ID;
		}*/
		
		public function get contentData():Object
		{
			return _contentData;
		}

		public function set contentData(value:Object):void
		{
			_contentData = value;
		}
		
		public function getFaxbContentData(classObject:Class):Object
		{
			if(_contentData == null)
			{
				CONFIG::debug
				{
					ASSERT(xml != null, "xml can not null when want to do faxb! fileId: "+id);
				}
				
				_contentData = FAXB.unmarshal(xml, getQualifiedClassName(classObject));
			}
			
			return _contentData;
		}

		public function getLoadType():String
		{
			return _groupId;
		}
		
		public function get rawdata():Object
		{
			return _rawdata;
		}
		
		public function get status():int
		{
			return _status;
		}
		
		public function get path():String
		{
//			if(Debug.force_reload)
//			{
//				if(_groupId != FileProxy.SPLIT_LOADING_GROUP_ID)
//				{					
//					return _filePath + "?v="+ (_versions == null ? new Date().time : _versions);
//				}
//			}
			
			return _filePath;
		}
		
		public function get extension():String
		{
			return _fileExt;
		}
		
		public function get contentDomain():ApplicationDomain
		{
			return _parser != null ? _parser.getContentDomain() : null;
		}
		
/*		public function getDefinitionClass(name:String):Class
		{
			var domain:ApplicationDomain = this.contentDomain;
			return domain != null && domain.hasDefinition(name) ? domain.getDefinition(name) as Class : null;
		}
*/
		
/*		public function getDefinitionMc(name:String):MovieClip
		{
			var cls:Class = this.getDefinitionClass(name);
			return cls != null ? new cls() as MovieClip : null;
		}
*/
		
		public function get content():Object
		{
			return _content;
		}
		
		public function get mc():MovieClip
		{
			return this.content as MovieClip;
		}
		
/*		public function get sprite():Sprite
		{
			return this.content as Sprite;
		}
*/
		public function get bitmapData():BitmapData
		{
			return (this.content as Bitmap).bitmapData;
		}
		
		public function get xml():XML
		{
			return this.content as XML;
		}
		
		public static function fileExtension(fileName:String):String
		{
			if(fileName == null)
				return null;
			var i:int = fileName.lastIndexOf(".");
			var tempStr:String = i >= 0 ? fileName.substring(i+1) : "";
			
			var j:int = tempStr.indexOf("?");
			return j >= 0 ? tempStr.substring(0,j) : tempStr;
		}
		
		public static function getFileName(fileName:String):String
		{
			if(fileName == null)
				return null;
			var i:int = fileName.lastIndexOf(".");
			return i >= 0 ? fileName.substring(0,i) : "";
		}
		
		public function isWaitingDownload():Boolean
		{
			return (_status == STA_WAIT);
		}
		
		private var initWithBytesStream:Boolean;

		public function loadFromBytes(bytes:ByteArray, callback:Function):void
		{
			initWithBytesStream = true;
			
			CONFIG::debug
			{
				ASSERT(_status == STA_WAIT, "ASSERT");
			}

			_cb = callback;

			createParser();
			
			_rawdata = bytes;
			
			initWithBytes();

		}
		
		private function createParser():void
		{
			if(commonParserClass != null)
			{
				_parser = new commonParserClass(this, handleParser);
			}
			else
			{
				_parser = new RsvFileParser(this, handleParser);
			}
			
		}
		
		public function load(callback:Function):void
		{
			_cb = callback;
			
			if(initWithBytesStream)
			{
				CONFIG::debug
				{
					ASSERT(_status == STA_CONTENTREADY, "should have successed by initialized with bytes");
				}
				
				sendCallBack(RsvEvent.LOADCOMPLETE);
				sendCallBack(RsvEvent.CONTENTREADY);
			}
			else
			{
				CONFIG::debug
				{
					ASSERT(_status == STA_WAIT, "ASSERT");
				}
				
				GameEngine._instance.currentLoaderID = this.id;
				
				createParser();
				
				_status = STA_LOADING;
				
				createLoader();
				var url:String = getUrl();
				_urlLoader.load(new URLRequest(url));
				
				_retryCount = RETRY_TIMES;
				
				CONFIG::debug
				{
					if(Debug.TEST_LOAD_SPLIT_GROUP)
					{
						_retryCount = 0;
					}
				}
				
			}


			// simplely return when it's already loading
			
			// URLLoader only gets bytesTotal after the loading is completed
			// so no progress listener
			//should not in here
			
		}
		
	/*	private function isLangAndLoadOnline():Boolean
		{
			return isLangFile();
		}*/
		
		public function getUrl():String
		{
			return File.applicationDirectory.resolvePath(path).url;
			
//			return LocatorManager.instance.getAbsoluteURL(_webPath + path);
		}
		
		private function getDomain():int
		{			
			return LocatorManager.instance.getAbsoluteDomain(_webPath + _filePath);
		}
		
		private function getFileSize():int
		{
			return LocatorManager.instance.getFileSize(_webPath + _filePath);
		}
		
		private function createLoader():void
		{
			CONFIG::debug
			{
				ASSERT(_urlLoader == null, "ASSERT");
			}
			
			_urlLoader = new URLLoader();
			_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		protected function deleteLoader():void
		{
			if(_urlLoader != null)
			{
				_urlLoader.close();
				_urlLoader.removeEventListener(Event.COMPLETE, onComplete);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				_urlLoader = null;
			}
		}
		
/*		public function notifyStopLoad():void
		{
			deleteLoader();
			
			_status = STA_FORCE_STOP;
		}
*/
		
		public function getLoadedByte():int
		{
			if(status == STA_LOADCOMPLETE || status == STA_CONTENTREADY)
			{
				if(_urlLoader)
				{
					return _urlLoader.bytesTotal;
				}
				else
				{
					return fileSize;
				}
			}
			
			if(_urlLoader)
			{
				return _urlLoader.bytesLoaded;
			}
			
			return 0;
		}
		
		protected function onError(ev:IOErrorEvent):void
		{
			deleteLoader();

			if(--_retryCount > 0)
			{
				createLoader();
				var url:String = getUrl();
				_urlLoader.load(new URLRequest(url));			
			}
			else
			{
				if(id == FileProxyUtil.PACKAGE_CONFIGURE_FILE_ID)
				{
					//ignore
				}
				else
				{
					var msg:String = "fail to load file, id = " + id + ", file = " + _filePath;
					CONFIG::debug
					{					
						ASSERT(false, msg);
					}
					
				}

				_status = STA_ERROR;
				sendCallBack(RsvEvent.LOADERROR);
			}
		}
		
	
		private function onComplete(ev:Event):void
		{
			TRACE_RES("success load, id= "+ this.id +", file= "+this._filePath + ",size="+_urlLoader.bytesTotal/1000+"K");
			_rawdata = _urlLoader.data;
			
			deleteLoader();

			initWithBytes();
		}
		
		private function initWithBytes():void
		{
			if(!initWithBytesStream)
			{
				var isPkg:Boolean = (_fileExt == "pkg");
				var isXml:Boolean = (_fileExt == "xml");
				if(isPkg || (isXml && Debug.COMPRESS_XML_TO_ZIP))
				{
					_rawdata = uncompress(_rawdata);
				}
			}

			
			dataReady();
			

		}
		
		private function uncompress(data:ByteArray):ByteArray
		{
			var remainingBytes : ByteArray;
			
			if(USE_LZMA_DECODE)
			{
				remainingBytes = LZMA.decode(data);
			}
			else
			{
				remainingBytes = new ByteArray();
				data.readBytes(remainingBytes);
				try
				{
					remainingBytes.uncompress();
				}
				catch(e:Error)
				{
					CONFIG::debug
					{
						ASSERT(false, "uncompress error, id = " + id + ", file = " + _filePath + ", length = " + fileSize);
					}
				}
			}
			

			return remainingBytes;
			
		}
		
		protected function dataReady():void
		{
			_status = STA_LOADCOMPLETE;
			sendCallBack(RsvEvent.LOADCOMPLETE);
			
			// start parse			
			if(_parser != null)
			{				
				_parser.parse();
			}
		}
		
		protected function handleParser(ev:RsvEvent):void
		{
			if(ev.id == RsvEvent.CONTENTERROR)
			{
				_status = STA_PARSEERROR;
				sendCallBack(RsvEvent.CONTENTERROR);
			}
			else if(ev.id == RsvEvent.CONTENTREADY)
			{
				_content = (ev.from as RsvFileParser).getContent();
				CONFIG::debug
				{
					ASSERT(_content != null, "ASSERT");
				}
				
				_status = STA_CONTENTREADY;
				sendCallBack(RsvEvent.CONTENTREADY);
				
				_rawdata = null;
			}
		}
		
		public function rsvFileType():int
		{
			if(!_fileExt)
			{
				return FILE_TYPE_NULL;
			}
			var fileExt:String =_fileExt.toLowerCase();
			var type:int;
			switch(_fileExt)
			{
				case RsvFileConst.TAIL_SWF:
					return FILE_TYPE_SWF;
					break;
				case RsvFileConst.TAIL_BMP:
				case RsvFileConst.TAIL_JPG:
				case RsvFileConst.TAIL_PNG:
					return FILE_TYPE_IMG;
					break;
				default://本项目XML文件后缀名很多，所以是default,其他资源后缀名一律标明判断
					return FILE_TYPE_XML;
					break;
			}
		}
		
		public override function destroy():void
		{
			deleteLoader();
			
			if(_parser != null)
			{
				_parser.destroy();
				_parser = null;
			}
			
			_content = null;
			
			super.destroy();
		}
		
		
		
	}
}