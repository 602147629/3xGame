package framework.model
{
	import flash.net.URLLoader;
	import flash.utils.getTimer;
	
	import framework.fibre.patterns.Proxy;
	import framework.game.InitState;
	import framework.resource.MyFactory;
	import framework.resource.ResourceManager;
	import framework.resource.ResourceNodeInfo;
	import framework.sound.StaticSoundConfig;
	import framework.util.XmlUtil;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;

	
	public class StaticResProxy extends Proxy
	{
		private var _resManager:ResourceManager;
		
		private var _promotionFileLoader:URLLoader;
		
		private var _fileMap:Object;

		public static const NAME:String = "StaticResProxy";
		
		public static var inst:StaticResProxy;
		
		public var staticSoundConfig:StaticSoundConfig;
		
		public static const FILES_ID:String = "file_xml_path";
		
		private const TYPE_CONDITION_MAPPING:Array = [
		];
		
		private static const RELEASE_PARSING_XML_FILES:Array = ["file_res_ui","file_second_res","file_res_sound_config"
			];
		
		private static function get LOAD_FIRST_GROUP_XML_COST_EACH_FRAME():Number
		{
			/*if(ViewPanelPreloadInterstitial.isShow())
			{
				return 10;
			}*/
				
			return 100;
		}
		
		
		public function StaticResProxy()
		{
			inst = this;
			super(NAME);
			
			_fileMap = new Object();
		}
		
		public function updateFile(rsvfAry:Array):void
		{
			if(_resManager != null)
			{
				_resManager.updateFile(rsvfAry);
			}
		}
		
		
		//
		private var _firstAssetGroup:Array;
		private var _firstAssetGroupPosition:int;
		private var _state:int = -1;
		private static const STATE_INIT_FIRST:int = 0;
		private static const STATE_LOAD_FIRST:int = 1;
		private static const STATE_LOAD_OTHER:int = 2;
		private static const STATE_IDLE:int = 3;
		
		public function initStaticResProxy():void
		{
			_state = STATE_INIT_FIRST;
		}
		
		override public function tickObject(psdTickMs:Number):void
		{
			super.tickObject(psdTickMs);

			if(_state == STATE_INIT_FIRST)
			{
				initFirst();
			}
			
			if(_state == STATE_LOAD_FIRST)
			{
				initLoadFirst();
			}
			
			if(_state == STATE_LOAD_OTHER)
			{
				initLoadOthers();
			}

		}
		
		private function initFirst():void
		{
			_resManager = ResourceManager.getInstance(this);
			
			_firstAssetGroup = Rsv.getGroup_s(FileProxy.FIRST_LOADING_GROUP_ID).all();
			_firstAssetGroupPosition = 0;

			_resManager.setFactory(new MyFactory());
			
			_state = STATE_LOAD_FIRST;
		}


		private function initLoadFirst():void
		{
			
			if(_firstAssetGroupPosition < _firstAssetGroup.length)
			{
				var time:Number = getTimer();
				while(_firstAssetGroupPosition < _firstAssetGroup.length &&
					(getTimer() - time) < LOAD_FIRST_GROUP_XML_COST_EACH_FRAME)
				{
					_loadResourceFromFirstGroupXmlOneByOne();
				}
			}
			else
			{
				GameEngine.getInstance().setInitAssetProgress(100);
				
				_resManager.initAllData();
				_resManager.updateFile(_firstAssetGroup);
				
				_state = STATE_LOAD_OTHER;
			}

		}

		private var _waitingResourceNodeInfos:Vector.<ResourceNodeInfo> = new Vector.<ResourceNodeInfo>();
		private var resourceCountInOneXml:int;
		private var resourceTimeCostInOneXml:int;
		private var readingXmlCandidateFile:RsvFile;

		private function _loadResourceFromFirstGroupXmlOneByOne():void
		{
			if(_waitingResourceNodeInfos.length == 0)
			{
				_traceCreateResourceInfo();
				
				resourceCountInOneXml = 0;
				resourceTimeCostInOneXml = 0;
				readingXmlCandidateFile = null;
				
				_createResourceFromFile();
			}
			
			_createResourceFromWaitingResourceNodeInfos();

		}
		
		private function _traceCreateResourceInfo():void
		{
			CONFIG::debug
			{
				if(readingXmlCandidateFile != null)
				{
					if(resourceCountInOneXml > 0)
					{
						TRACE_LOADING("[read resource xml], id = " + readingXmlCandidateFile.id + ", cost = " + resourceTimeCostInOneXml + ", count = " + resourceCountInOneXml);
					}
					else
					{
						TRACE_LOADING("[should add to SKIP list], id = " + readingXmlCandidateFile.id + ", cost = " + resourceTimeCostInOneXml + ", count = " + resourceCountInOneXml);
					}
				}
			}
			
		}
		
		public function getPath(fileId:String):String
		{
			return _fileMap[fileId];
		}
		
		private function _createResourceFromFile():void
		{
			var rsvFile:RsvFile = _firstAssetGroup[_firstAssetGroupPosition];
			++_firstAssetGroupPosition;
			
			var p:Number = 100 * _firstAssetGroupPosition / _firstAssetGroup.length;
			GameEngine.getInstance().setInitAssetProgress(p);
			
			if(rsvFile.xml != null)
			{
				if(RELEASE_PARSING_XML_FILES.indexOf(rsvFile.id) >= 0)
				{					
					var timeStart:Number = getTimer();
					readingXmlCandidateFile = rsvFile;
					
					_waitingResourceNodeInfos = _resManager.collectResXmlNodesAtTopLayer(rsvFile.xml, null);
					
					Rsv.releaseXmlOnceResLoaded(rsvFile);
					
					var timeCost:Number = getTimer() - timeStart;
					resourceTimeCostInOneXml += timeCost;
				}
				else if(rsvFile.id == FILES_ID)
				{
					/*var xmlList:XMLList = rsvFile.xml.resource;
					for each(var xml:XML in xmlList)
					{
						var key:String = XmlUtil.attrString(xml, "key");
						var path:String = XmlUtil.attrString(xml, "path");
						_fileMap[key] = path;
					}
					
					Rsv.releaseXmlOnceResLoaded(rsvFile);*/
					CONFIG::debug
					{
						TRACE_LOG("--------------------------load File ok");
					}
				}
			}
			
			

			CONFIG::debug
			{
				if(rsvFile.xml != null)
				{
					TRACE_RES(rsvFile.id + ", version:" + rsvFile.xml.@version);
				}
			}
		}
		
		public function initPath():void
		{
			var xmlList:XMLList = Rsv.inst.getFile(FileProxy.LOAD_PATH_FILE_ID).xml.resource;
			for each(var xml:XML in xmlList)
			{
				var key:String = XmlUtil.attrString(xml, "key");
				var path:String = XmlUtil.attrString(xml, "path");
				_fileMap[key] = path;
			}
			
			Rsv.releaseXmlOnceResLoaded(Rsv.inst.getFile(FileProxy.LOAD_PATH_FILE_ID));
		}
		
		private function _createResourceFromWaitingResourceNodeInfos():void
		{
			var timeStart:Number = getTimer();

			resourceCountInOneXml += _waitingResourceNodeInfos.length;

			_waitingResourceNodeInfos = _resManager.collectChildrenResXmlNodesFromTopLayerNodes(_waitingResourceNodeInfos);
			
			var timeCost:Number = getTimer() - timeStart;
			resourceTimeCostInOneXml += timeCost;
		}
		
		
/*		private function loadResourceFromFirstGroupXmlOneByOne():void
		{
			var rsvFile:RsvFile = firstAssetGroup[firstAssetGroupPosition];
			++firstAssetGroupPosition;
			
			var p:Number = 100 * firstAssetGroupPosition / firstAssetGroup.length;
			GameEngine.inst.setInitAssetProgress(p);
			
			if(rsvFile.xml != null && EXCLUDE_PARSING_XML_FILES.indexOf(rsvFile.id) == -1)
			{
				var timeStart:int = getTimer();
				
				var count:int = _resManager.loadResXml(rsvFile.xml, null);
				Rsv.releaseXmlOnceResLoaded(rsvFile);
				
				var timeCost:int = getTimer() - timeStart;
				CONFIG::debug
				{
					if(count > 0)
					{
						TRACE_LOADING("[read resource xml], id = " + rsvFile.id + ", cost = " + timeCost + ", count = " + count);
					}
					else
					{
						TRACE_LOADING("[should add to SKIP list], id = " + rsvFile.id + ", cost = " + timeCost + ", count = " + count);
					}
				}
			}
		}
*/
		
		private function initLoadOthers():void
		{
				
			_resManager.initLang();
			
			InitState.recordFinish(InitState.KEY_STATIC_RES);

			_state = STATE_IDLE;

		}
	}
}

