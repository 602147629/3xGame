package framework.model
{
	import flash.utils.Dictionary;
	
	import framework.fibre.patterns.Proxy;
	import framework.resource.Resource;
	import framework.resource.ResourceFactory;
	import framework.resource.ResourceManager;
	import framework.rpc.DataUtil;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;
	import framework.util.rsv.RsvGroup;

	public class LoadStrategyProxy extends Proxy
	{
		public static const GROUP_SOUND_USED_IN_TUTORIAL:String = "SoundUsedInTutorial";
		public static const GROUP_SOUND_LOAD_BEFORE_GAME:String = "SoundLoadBeforeGame";
		public static const GROUP_SOUND_LOAD_IN_BACKGROUND:String = "SoundLoadInBackground";
		
		public static const GROUP_SWF_USED_IN_TUTORIAL_ENVIRONMENT:String = "SwfUsedInTutorial_environment";
		public static const GROUP_SWF_USED_IN_TUTORIAL_HOUSE:String = "SwfUsedInTutorial_house";
		public static const GROUP_SWF_USED_IN_TUTORIAL_NPC:String = "SwfUsedInTutorial_npc";
		public static const GROUP_SWF_USED_IN_TUTORIAL_OBSTACLE:String = "SwfUsedInTutorial_obstacle";
		public static const GROUP_SWF_USED_IN_TUTORIAL_BUILDING:String = "SwfUsedInTutorial_building";
		public static const GROUP_SWF_LOAD_IN_BACKGROUND:String = "SwfLoadInBackground";
		

		
		private static const NAME:String = "LoadStrategyProxy";
		public static var inst:LoadStrategyProxy;
		
		private var _groups:Dictionary;
		
		public function LoadStrategyProxy()
		{
			super(NAME);
			inst = this;
			
			_groups = new Dictionary();
		}
		
		public function initDemandedFile(file:RsvFile):void
		{
			var files:XMLList = file.xml.child("Groups");
			
			for each(var xml:XML in files)
			{
				var groupId:String = xml.@id;
				var filesLoad:Vector.<LoadStrategyFile> = queryStrategyGroup(groupId);
				
				var fileGroup:XMLList = xml.elements("file");
				for each(var fileXml:XML in fileGroup)
				{				
					var fileLoad:LoadStrategyFile = new LoadStrategyFile(fileXml);
					
					filesLoad.push(fileLoad);
					
				}
			}	
		}
		
		private function queryStrategyGroup(groupId:String):Vector.<LoadStrategyFile>
		{
			var filesLoad:Vector.<LoadStrategyFile> = _groups[groupId] ;
			if(filesLoad == null)
			{
				filesLoad = new Vector.<LoadStrategyFile>();				
				_groups[groupId] = filesLoad;				
			}

			return filesLoad;
		}
		
		
		public function getGroupFiles(groupId:String):Vector.<RsvFile>
		{
			var rsvFiles:Vector.<RsvFile> = new Vector.<RsvFile>();
			
			var files:Vector.<LoadStrategyFile> = queryStrategyGroup(groupId);
			for each(var file:LoadStrategyFile in files)
			{
				var rsvFile:RsvFile;

				var resourceId:String = file.getResourceId();
				if(resourceId != "")
				{
					var res:Resource = ResourceManager.getInstance().getResource(resourceId);
					rsvFile = res.file.referenceRsvFile;
				}
				else
				{
					var pathId:String = file.getId();
					var classId:String = file.getClassId();
					
					if(classId != "")
					{
						rsvFile = ResourceFactory.createRsvFileForSplitGroup(pathId, classId);
					}
					else
					{
						rsvFile = Rsv.getFile_s(pathId);
					}
					
				}
				
				CONFIG::debug
				{
					ASSERT(rsvFile != null, "ASSERT");
				}
				rsvFiles.push(rsvFile);
			}
			
			return rsvFiles;
		}
		
		public function increasePriorityForGroup(groupId:String):void
		{
			CONFIG::debug
			{
				TRACE_LOADING("\n\n<<<<	increase group id = " + groupId);
			}
				
			var totalSize:int = 0;
			var group:RsvGroup = Rsv.getGroup_s(groupId);
			
			var gourpFiles:Array = group.all();
			for each(var rsv:RsvFile in gourpFiles)
			{
				TRACE_LOADING(rsv.id + ", size = " + rsv.fileSize);
				totalSize += rsv.fileSize;
				
				if(rsv.isWaitingDownload())
				{
					BackgroundLoadProxy.inst.increasePriorityToLoadingThread(rsv.id);
				}
			}
			
			CONFIG::debug
			{
				TRACE_LOADING("total size = " + totalSize);
			}
		}
		
		public function decreasePriorityForGroup(groupId:String):void
		{
			CONFIG::debug
			{
				TRACE_LOADING("\n<<<<	decrease group id = " + groupId + "\n");
			}
			
			var totalSize:int = 0;
			var group:RsvGroup = Rsv.getGroup_s(groupId);
			
			var gourpFiles:Array = group.all();
			for each(var rsv:RsvFile in gourpFiles)
			{
				BackgroundLoadProxy.inst.decreasePriorityToLoadingThread(rsv.id);
			}
			
//			var rsvFiles:Vector.<RsvFile> = getGroupFiles(groupId);
//			
//			for each(var rsvFile:RsvFile in rsvFiles)
//			{
//				BackgroundLoadProxy.inst.decreasePriorityToLoadingThread(rsvFile.id);
//			}

		}
		

		public function startLoadSecondStuffGroupInBackground():void
		{
			
			DataUtil.instance.loadSecondGroupStartTime = new Date().getTime();
			
			increasePriorityForGroup(FileProxy.SECOND_LOADING_GROUP_ID);
//			increasePriorityForGroup(GROUP_SOUND_LOAD_IN_BACKGROUND);
//			increasePriorityForGroup(GROUP_SWF_LOAD_IN_BACKGROUND);
		}

	}	
}
