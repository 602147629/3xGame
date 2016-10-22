package framework.model
{
	import com.game.consts.ConstGameFlow;
	import com.ui.util.CBaseUtil;
	
	import framework.fibre.patterns.Proxy;
	import framework.resource.CustomParser;
	import framework.rpc.DataUtil;
	import framework.text.LangProxy;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvEvent;
	import framework.util.rsv.RsvFile;
	import framework.util.rsv.RsvGroup;
	import framework.util.rsv.RsvSplitManager;
	import framework.view.notification.GameNotification;
	
	public class FileProxy extends Proxy 
	{
		public static const NAME:String = "FileProxy";
		
		public static var inst:FileProxy;
		
		public static const FIRST_LOADING_GROUP_ID:String = "firstload";
		public static const SECOND_LOADING_GROUP_ID:String = "secondload";
		public static const SPLIT_LOADING_GROUP_ID:String = "split";
		public static const LANG_GROUP_ID:String = "lang";
		
		private static const BASE_CONFIGURE_FILE_PATH:String = "xml/se.xml";
		private static const BASE_CONFIGURE_FILE_ID:String = "file_se";

		public static const LOAD_PATH_FILE_ID:String = "file_path";
		
		private var prepareFileCountBeforeFirstGroupLoad:int;
		private var finishLoadFirstGroup:Boolean = false;
		
		private var _finishSecondeLoadGroup:Boolean = false;
		
		private var _detectFirstLoadFinishedTicker:int;
		private var _detectSecondLoadFinishedTicker:int;

		public function FileProxy()
		{
			inst = this;
			super(NAME);
			RsvFile.commonParserClass = CustomParser;
			
			
		}
		
		public function initFileProxy():void
		{
			TRACE_FLOW(ConstGameFlow.START_LOAD_RESOURCE);
			
//			addPrepareFile(BASE_CONFIGURE_FILE_ID, BASE_CONFIGURE_FILE_PATH + "?v=" + new Date().time);
			addPrepareFile(BASE_CONFIGURE_FILE_ID, BASE_CONFIGURE_FILE_PATH);
		}
		
		private function addPrepareFile(id:String, path:String):void
		{
			(new RsvFile(id, path)).load(fileHandler);
			++prepareFileCountBeforeFirstGroupLoad;
		}
		
		
		
		private function getGroupsPercent(group:RsvGroup):int
		{
			var totalSize:int = 0;
			var totalCompleteSize:int = 0;

			var list:Array = group.all();
			for each(var f:RsvFile in list)
			{
				totalCompleteSize += f.getLoadedByte();
				totalSize += f.fileSize;
			}
			
			if(totalSize == 0)
			{
				return 100;
			}
			else
			{
				return totalCompleteSize / totalSize * 100;
			}
			
		}
		
		
		
		public function isGroupAllComplete(group:RsvGroup):Boolean
		{
			var list:Array = group.all();
			for each(var f:RsvFile in list)
			{
				if(f.status != RsvFile.STA_CONTENTREADY)
				{
					return false;
				}
			}
			
			return true;
		}
		
		
		private function detectFirstLoadFinished():void
		{
			++_detectFirstLoadFinishedTicker;
			if((_detectFirstLoadFinishedTicker & 0xf) != 0)
			{
				return;
			}
			
			if(!finishLoadFirstGroup)
			{
				var firstGroup:RsvGroup = Rsv.getGroup_s(FIRST_LOADING_GROUP_ID);
				if(firstGroup != null &&
					isGroupAllComplete(firstGroup))
				{
					CONFIG::debug
					{
						ASSERT(doneLoadPackage, "ASSERT");
					}
					
					finishLoadFirstGroup = true;
					
					var resProxy:StaticResProxy = fibre.retrieveProxy(StaticResProxy.NAME) as StaticResProxy;
					resProxy.initStaticResProxy();
					
					DataUtil.instance.loadFirstGroupEndTime = new Date().getTime();
					
					TRACE("加载第一组资源共耗时:" + (DataUtil.instance.loadFirstGroupEndTime - DataUtil.instance.loadFirstGroupStartTime) / 1000 +"s"  , "time");
					
					GameEngine.getInstance().setLoadAssetProgress(100);
				}			
			}	
		}
		
		private function detectSecondLoadFinished():void
		{
			++_detectSecondLoadFinishedTicker;
			if((_detectSecondLoadFinishedTicker & 0xf) != 0)
			{
				return;
			}
			
			if(!_finishSecondeLoadGroup)
			{
				var secondGroup:RsvGroup = Rsv.getGroup_s(SECOND_LOADING_GROUP_ID);
				if(secondGroup != null &&
					isGroupAllComplete(secondGroup))
				{
					CONFIG::debug
					{
						ASSERT(doneLoadPackage, "ASSERT");
					}
						
					_finishSecondeLoadGroup = true;
					
					DataUtil.instance.loadSecondGroupEndTime = new Date().getTime();
					
					CBaseUtil.sendEvent(GameNotification.EVENT_SECOND_LOAD_FINISH , {});
					
					TRACE("加载第二组资源共耗时:" + (DataUtil.instance.loadSecondGroupEndTime - DataUtil.instance.loadSecondGroupStartTime) / 1000 +"s"  , "time");
				}			
			}	
		}
		
		override public function tickObject(psdTickMs:Number):void
		{
			detectFirstLoadFinished();
			
			detectSecondLoadFinished();
			
			//update load percent
			if(!finishLoadFirstGroup)
			{
				var firstGroupPercent:int = 0;
				
				var firstGroup:RsvGroup = Rsv.getGroup_s(FIRST_LOADING_GROUP_ID);
				if(firstGroup != null)
				{
					firstGroupPercent = getGroupsPercent(firstGroup);
				}
				
				GameEngine.getInstance().setLoadAssetProgress(firstGroupPercent);
			}
		}
		
		private function initSplitGroup():void
		{
			var resGroup:RsvGroup = Rsv.getGroup_s(SPLIT_LOADING_GROUP_ID);
			
			CONFIG::debug
			{
				TRACE_LOG("use split group ! "+ (resGroup == null));
			}
			var splits:Array = resGroup.all();
			
			for each(var split:RsvFile in splits)
			{
				// make a id path mapping
				RsvSplitManager.addPair(split.id, split.path);
			}
			
		}
		
		private function whenLoadBaseConfig(file:RsvFile):void
		{

			detectStartFutureGroup();

			
		}
		
		public function xmlToFile(xml:XML):void
		{
			var groupId:String = xml.@group;
			
			CONFIG::debug
			{
				ASSERT(groupId == FIRST_LOADING_GROUP_ID ||
					groupId == SECOND_LOADING_GROUP_ID ||
					groupId == SPLIT_LOADING_GROUP_ID ||
					groupId == LANG_GROUP_ID, "ASSERT");
				ASSERT(groupId != null, "group id of rsv file should not be null!!!");
			}
			
			var id:String = xml.@id;
			var path:String = xml.@path.toString();
			
			if(path == "")
			{
				path = StaticResProxy.inst.getPath(id);
			}
			
			var versions:String = xml.@ versions;
			
			var file:RsvFile = new RsvFile(id, path, xml.@zip, groupId, versions);
			
			var rsvGroup:RsvGroup = Rsv.getGroup_s(groupId);
			if(rsvGroup == null)
			{
				rsvGroup = new RsvGroup(groupId);
				CONFIG::debug
				{
					TRACE_LOG("new Group create! "+ groupId);
				}
			}
			rsvGroup.add(file);
			
			BackgroundLoadProxy.inst.addBackGroundLoad(file);

		}
		
		
		private function whenLoadStrategyConfig(file:RsvFile):void
		{
//			LoadStrategyProxy.inst.initDemandedFile(file);	
//			Rsv.remove_s(LOAD_STRATEGY_FILE_ID);
			StaticResProxy.inst.initPath();
			
			detectStartFutureGroup();

		}

		private function detectStartFutureGroup():void
		{
			CONFIG::debug
			{
				ASSERT(prepareFileCountBeforeFirstGroupLoad > 0, "ASSERT");
			}
			
			--prepareFileCountBeforeFirstGroupLoad;
			
			if(prepareFileCountBeforeFirstGroupLoad <= 0)
			{
				var file:RsvFile = Rsv.inst.getFile(BASE_CONFIGURE_FILE_ID);
					
				RsvGroup.batchCallArgs_s(this, "xmlToFile", file.xml.child("f"));
				
				addNecessaryFileToFirstGroup();
				
				whenFailLoadPackageConfig();
				
				initSplitGroup();
			}
		}
		

		private var packageConfig:ResourcePackageConfig;
		private var doneLoadPackage:Boolean;
		private function whenLoadPackageConfig(file:RsvFile):void
		{
			var xml:XML = file.xml;
			packageConfig = new ResourcePackageConfig(xml);
			packageConfig.load(onFinishLoadPackage);
		}
		
		private function whenFailLoadPackageConfig():void
		{
			doneLoadPackage = true;
			loadFirstGroup();
		}

		private function onFinishLoadPackage():void
		{
			doneLoadPackage = true;
			loadFirstGroup();
		}

		private function addNecessaryFileToFirstGroup():void
		{
			//need to insert them to first group to calculate loading progress
//			addLanguageFilesToFirstGroup();
		}
		
		private function addLanguageFilesToFirstGroup():void
		{
			var fileId:String = LangProxy.instance.getDefaultLanguageFileId();
			var file:RsvFile = Rsv.getFile_s(fileId);
			
			var firstLoadGroup:RsvGroup = Rsv.getGroup_s(FIRST_LOADING_GROUP_ID);
			if(!firstLoadGroup.contains(file))
			{
				firstLoadGroup.add(file);
			}
			
			TRACE_LOADING("\n<<<<	initialize language file");
			TRACE_LOADING(file.id + ", size = " + file.fileSize + "\n");
			
		}
		

		private function loadFirstGroup():void
		{
			//put first load group into queue
			TRACE_LOADING("\n<<<<	group load before game");
			var totalSize:int = 0;
			
			var group:Array = Rsv.getGroup_s(FIRST_LOADING_GROUP_ID).all();
			for each(var rsv:RsvFile in group)
			{
				TRACE_LOADING(rsv.id + ", size = " + rsv.fileSize);
				totalSize += rsv.fileSize;
				
				if(rsv.isWaitingDownload())
				{
					BackgroundLoadProxy.inst.increasePriorityToLoadingThread(rsv.id);
				}
			}
			
			TRACE_LOADING("total size = " + totalSize + "\n");
			
		}
		
		private function fileHandler(ev:RsvEvent):void
		{
			var file:RsvFile = ev.from as RsvFile;
			
			if(ev.id == RsvEvent.CONTENTREADY)
			{	
				if(file.id == BASE_CONFIGURE_FILE_ID)
				{
					whenLoadBaseConfig(file);				
				}
				else if(file.id == LOAD_PATH_FILE_ID)
				{
					whenLoadStrategyConfig(file);				
				}
				else if(file.id == FileProxyUtil.PACKAGE_CONFIGURE_FILE_ID)
				{
					whenLoadPackageConfig(file);				
				}				
			}
			
			if(ev.id == RsvEvent.LOADERROR)
			{
				if(file.id == FileProxyUtil.PACKAGE_CONFIGURE_FILE_ID)
				{
					whenFailLoadPackageConfig();				
				}
			}
		}

		public function get finishSecondeLoadGroup():Boolean
		{
			return _finishSecondeLoadGroup;
		}

	}
}