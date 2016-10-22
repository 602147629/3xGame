package framework.resource
{
	import framework.model.FileProxyUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class LocatorManager
	{
		private static var _instance:LocatorManager;
		public static function get instance():LocatorManager
		{
			if(_instance == null)
			{
				_instance = new LocatorManager();
			}
			return _instance;
		}
		
		public var log:String = "";
		public function pushLog(str:String):void
		{
			log += str + "\n";
		}
		
		private var manifestLoader:URLLoader;
		private var _onSuccess:Function;
		private var _onFail:Function;
		private var _data:XML;
		
		public var urlPathGroupTable:Array;
		public var resourceLocatorTable:Array;
		
		public function LocatorManager()
		{
			urlPathGroupTable = new Array();
			resourceLocatorTable = new Array();
		}
		
		public function prepare(url:String, onSuccess:Function, onFail:Function):void
		{
			_onSuccess = onSuccess;
			_onFail = onFail;
			
			var req:URLRequest = new URLRequest(url);
			manifestLoader = new URLLoader();
			pushLog("manifest file url:" + url);
			manifestLoader.dataFormat = URLLoaderDataFormat.TEXT;			
			manifestLoader.load(req);
			manifestLoader.addEventListener(Event.COMPLETE, manifestLoadSuccess);
			manifestLoader.addEventListener(IOErrorEvent.IO_ERROR, manifastLoadFail);
		}
		
		private function manifastLoadFail(e:Event):void
		{
			pushLog("manifastLoadFail");
			CONFIG::debug
			{
				TRACE_RES("Manifest File load fail!");
			}
			
			if(_onFail != null)
			{
				_onFail();
			}
			destoryLoader();
		}
		
		
		private function manifestLoadSuccess(e:Event):void
		{
			pushLog("manifastLoadFail");
//			TRACE_RES("Manifest File load success!");
			manifestLoader.removeEventListener(Event.COMPLETE, manifestLoadSuccess);
			
			loadFromXml(new XML(manifestLoader.data));
			
			
			if(_onSuccess != null)
			{
				_onSuccess();
			}
			destoryLoader();
		}
		
		private function loadFromXml(xml:XML):void
		{
			_data = xml;
			init();
		}
		
		public function loadTestXml(url:String):void
		{
			var callback:Function = function (e:Event):void
			{
				loadFromXml(new XML(testLoader.data));
				
				//future test
				
			}

			var testLoader:URLLoader = new URLLoader();
			testLoader.load(new URLRequest(url));
			testLoader.addEventListener(Event.COMPLETE, callback);


		}
		
		private function destoryLoader():void
		{
			manifestLoader.removeEventListener(Event.COMPLETE, manifastLoadFail);
			manifestLoader.removeEventListener(IOErrorEvent.IO_ERROR, manifastLoadFail);
			manifestLoader = null;
		}
		
		
		private function init():void
		{
			initPaths();
			initResources();
			releaseDataUsedAtInitialPhase();
		}
		
		private function initPaths():void
		{
			var paths:XMLList = _data.paths.path;
			for(var i:int = 0 ; i < paths.length(); ++i)
			{
				var xml:XML = paths[i];
				var group:BaseURLGroup = getURLBaseGroup(xml.@name);
				group.addPath(xml.@src);
			}
		}
		
		private function getURLBaseGroup(name:String):BaseURLGroup
		{
			var group:BaseURLGroup = urlPathGroupTable[name];
			if(group == null)
			{
				group = new BaseURLGroup(name);
				urlPathGroupTable[name] = group;
			}
			return group;
		}
		
		private function initResources():void
		{
			var domain:int = int(_data.@path);
			var resources:XMLList = _data.resources;

			var count:int = resources.length();
			for(var i:int = 0; i < count; ++i)
			{
				initResource(resources[i].resource, domain);
			}
		}
		
		private function initResource(resourceList:XMLList, domain:int):void
		{
			var locator:ResourceLocator;
			var count:int = resourceList.length();
			for(var i:int = 0; i < count; ++i)
			{
				locator = new ResourceLocator(resourceList[i], domain);
				resourceLocatorTable[locator.name] = locator;
				pushLog(locator.name);
			}
		}
		
		private function releaseDataUsedAtInitialPhase():void
		{
			_data = null;
		}

		private function getLocator(path:String):ResourceLocator
		{
			var key:String = ResourceLocator.getKeyFromGamePath(path);
			var locator:ResourceLocator = resourceLocatorTable[key];
			
			return locator;
		}
		
		public function getAbsoluteDomain(path:String):int
		{
			CONFIG::assetcaching
			{
				var locator:ResourceLocator = getLocator(path);
				if(locator != null)
				{
					return locator.domain;
				}
				else
				{
					return -1;					
				}
				
			}	
			return 0;
		}

		public function getAbsoluteURL(path:String):String
		{
			CONFIG::assetcaching
			{		
				var absoluteURL:String;
				
				var locator:ResourceLocator = getLocator(path);
				if(locator != null)
				{
					absoluteURL = getBaseURL(locator.baseGroup) + locator.src;
				}
				else
				{
					if(path.indexOf(FileProxyUtil.PACKAGE_CONFIGURE_FILE_PATH) >= 0)
					{
						locator = resourceLocatorTable["se"];
						absoluteURL = getBaseURL(locator.baseGroup) + locator.src + ".package";
						
					}
					else
					{
						CONFIG::debug
						{
							//don't use ASSERT here, this class will be included in GameLoader
							TRACE_LOG("can't find file define in s3, id = " + path);
							throw new Error("can't find file define in s3, id = " + path);
						}
					}

				}
				

//				assertForAssetCache(locator != null, "Can't found Path : " + path + " 's locator! KEY : " + key + "\n "+ log);
				
//				if(notfound)
//				{
//					return absoluteURL + "notfound";
//				}
				
				CONFIG::debug
				{
					TRACE_RES("get path for: " + path + ":" + absoluteURL);
				}
				
				return absoluteURL;
			}
			return path;
		}
		
		public function getFileSize(path:String):int
		{
			CONFIG::assetcaching
			{
				var key:String = ResourceLocator.getKeyFromGamePath(path);
				var locator:ResourceLocator = resourceLocatorTable[key]; 
				
				if(locator)
				{
					return locator.length;
				}
				return 0;
			}
			
			return 1;
		}
		
//		public function getFileSize(path:String):int
//		{
//			CONFIG::assetcaching
//			{
//				var key:String = SimCityResourceLocator.getKeyFromGamePath(path);
//				var locator:SimCityResourceLocator = resourceLocatorTable[key]; 
//				return locator.size;
//			}
//			return 100;
//		}
		
		public function getBaseURL(baseGroup:String):String
		{
			CONFIG::assetcaching
			{
				var group:BaseURLGroup = urlPathGroupTable[baseGroup];
//				assertForAssetCache(group != null, "Can't found BaseURLGroup : " + baseGroup);
				return group.getBaseURL();
			}
			return baseGroup;
		}
		
/*		private function assertForAssetCache(condition:Boolean, message:String = "ASSERT"):void
		{
			CONFIG::debug
			{
				if(!condition)
				{
					var error:Error = new Error(message);
					TRACE_LOG(error.getStackTrace());
					if(message.indexOf("audio/audio") < 0)
					{
						throw error;
					}
				}
			}
		}
*/		
		
	}
}