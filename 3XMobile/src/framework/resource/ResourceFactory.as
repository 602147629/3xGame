package framework.resource
{
	import framework.model.BackgroundLoadProxy;
	import framework.model.FileProxy;
	import framework.model.LoadingThread;
	import framework.model.StaticResProxy;
	import framework.util.XmlUtil;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;
	import framework.util.rsv.RsvSplitManager;
	
	public class ResourceFactory
	{
		public function ResourceFactory()
		{
		}
		
		public function isResourceNode(xml:XML):Boolean
		{
			return (xml.name() == "res") || (xml.name() == "resource");
		}
		
		public function isParentNode(xml:XML):Boolean
		{
			return XmlUtil.attrString(xml, "parent") == "true";
		}
		
		public function createResource(xml:XML, parent:Resource, rm:ResourceManager):Resource
		{
			CONFIG::debug
			{
				ASSERT(false, "ASSERT");
			}
			return null;
		}
		
		public static function createSimpleResource(id:String, path:String, placeHolderType:int = 2, xml:XML = null):Resource
		{
			if(ResourceManager.getInstance().resMap[id] != null)
			{
				return ResourceManager.getInstance().resMap[id];
			}
			
			if(path == null)
			{
				if(RsvFile.fileExtension(id) == "png")
				{
					path = StaticResProxy.inst.getPath( RsvFile.getFileName(id) + ".jpg");
				}
			}
			
			var file:ResourceFile = getResourceFile(id, path, ResourceManager.getInstance());

			var res:Resource = new Resource();

			res.init(xml, file, null, id);
			
			res.placeHolderType = placeHolderType;
			
			ResourceManager.getInstance().validationUniqueResId(res, null);
			ResourceManager.getInstance().resMap[res.id] = res;
		
			return res;
		}
		
		protected static function getResourceFile(fileId:String, filePath:String, rm:ResourceManager):ResourceFile
		{
			if(fileId == null)
			{
				return null;
			}

			var originalPathId:String = fileId;
			
			var splitFilePath:String = RsvSplitManager.getFilePath(fileId);
			if(splitFilePath != null)
			{
				fileId = RsvSplitManager.getSplitFileId(splitFilePath, filePath);
			}			
			
			var rf:ResourceFile = rm.getResourceFile(fileId);
			
			if(rf == null)
			{
//				CONFIG::debug
//				{
//					TRACE_LOG("create resource file:" + fileId);
//				}
				
				var rsv:RsvFile;
				if(splitFilePath != null)
				{
					rsv = loadSplitGroupFile(fileId, originalPathId, filePath);
				}
				else
				{
					rsv = Rsv.getFile_s(fileId);
					
					if(rsv == null)
					{
						rsv = createRsvFile(fileId, filePath, true);
					}
				}
				
				CONFIG::debug
				{
					ASSERT(rsv != null, "ASSERT");
				}

				rf = createResourceFile(fileId, rsv);
				rm.addResourceFile(rf);
				
				CONFIG::debug
				{
					ASSERT(rf != null, "ASSERT");
				}

			}
			return rf;
		}
		
		private static function loadSplitGroupFile(pathId:String, originalPathId:String, swf:String):RsvFile
		{
			var rsv:RsvFile = Rsv.getFile_s(pathId);
			if(rsv == null)
			{
				rsv = createRsvFileForSplitGroup(originalPathId, swf);
			}
			return rsv;
		}
		
		public static function getRsvFileId(fileId:String, swfName:String):String
		{
			var splitFilePath:String = RsvSplitManager.getFilePath(fileId);
			if(splitFilePath != null)
			{
				fileId = RsvSplitManager.getSplitFileId(splitFilePath, swfName);
			}
			return fileId;
		}
		
		public static function createRsvFile(fileId:String, path:String, autoRegist:Boolean = true, groupId:String = null, callBack:Function = null):RsvFile
		{			
			var rsv:RsvFile = new RsvFile(fileId, path, autoRegist, groupId);
			
			var thread:LoadingThread = BackgroundLoadProxy.inst.addBackGroundLoad(rsv, callBack);
			
			CONFIG::debug
			{
				if(Debug.TEST_LOAD_SPLIT_GROUP)
				{
					BackgroundLoadProxy.inst.increasePriorityToLoadingThread(rsv.id);
				}
			}
			
			return rsv;
		}

		public static function createRsvFileForSplitGroup(pathId:String, swf:String):RsvFile
		{
			var splitFilePath:String = RsvSplitManager.getFilePath(pathId);
			if(splitFilePath != null)
			{
				pathId = RsvSplitManager.getSplitFileId(splitFilePath, swf);
				
				var rsv:RsvFile = Rsv.getFile_s(pathId);
				if(rsv == null)
				{
					//add a background loading thread to load file
					var url:String = RsvSplitManager.getSplitFileUrl(splitFilePath, swf);
					
					rsv = createRsvFile(pathId, url, true, FileProxy.SPLIT_LOADING_GROUP_ID);
				}

				return rsv;
			}			


			return null;
		}

		
		private static  function createResourceFile(id:String, referenceRsvFile:RsvFile):ResourceFile
		{
			return new ResourceFile(id, referenceRsvFile);
		}
		
		
	}
}