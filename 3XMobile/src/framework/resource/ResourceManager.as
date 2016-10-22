package framework.resource 
{
	import framework.model.StaticResProxy;
	import framework.util.map.Map;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;

	/**
	 * comments by Ding Ning
	 * generally, it is used to save key - resourceFile pair
	 * each resourceFile is corresponding to a single flash LINKAGE class 
	 * when query a flash linkage class, resourceManager will return a handle to user ( may be create it firstly ),
	 * >no matter it been loaded or not,
	 * >when the file finally been loaded, all handles belong to it will be notified ( by updateFile ) 
	 */

	public class ResourceManager 
	{
		private static var _instance:ResourceManager;
		
		private var _fileMap:Map;
		private var _resMap:Object;
		public var _factory:ResourceFactory;
		
		public var loadedComplete:Boolean;

		
		private var resProxy:StaticResProxy;
		
		public function ResourceManager(resProxy:StaticResProxy) 
		{
			this.resProxy = resProxy
			// resource file map	
			_fileMap = new Map();				
			_resMap = new Object();
		}

		public static function getInstance(resProxy:StaticResProxy = null):ResourceManager
		{
			if (_instance == null)
			{
				_instance = new ResourceManager(resProxy);
			}
				
			if(resProxy!= null)
			{
				_instance.resProxy = resProxy;
			}
			return _instance;
		}
		
/*		public function get config():XML
		{
			return Rsv.getFile_s("file_res").xml;
		}
*/
/*		public function loadAll(factory:ResourceFactory,firstArray:Array):void 
		{
			_factory=factory;
			//RsvFile
			for(var i:int = 0 ; i < firstArray.length ; i++)
			{
				var rsvFile:RsvFile = firstArray[i];
				
//				if(rsvFile.id.indexOf("file_res") >= 0)
				if(rsvFile.xml != null)
				{
					loadRes(rsvFile.xml,null);
				}
			}
		}
*/
		
		public function setFactory(factory:ResourceFactory):void 
		{
			_factory=factory;
		}

		public function initAllData() : void
		{
			// file types
			var resourceFiles:Vector.<Object> = _fileMap.getValues(false);
			for each(var rf:ResourceFile in resourceFiles)
			{
				var rsvFile:RsvFile = Rsv.getFile_s(rf.pathId);
				CONFIG::debug
				{
					ASSERT(rsvFile != null, "can't find path define " + rf.pathId);
				}
				rf.fileType = ResourceFile.getFileType(rsvFile.extension);
			}
			
			// init
//			var array:Vector.<Object>=_resMap.getValues(false);
			for each (var res:Resource in _resMap)
			{
				res.initData();
			}
		}

		public function initLoad(fc : ResourceFactory) : void
		{
			_factory = fc;
		}

		public function initLang() : void
		{
			// init lang
//			var array:Vector.<Object>=_resMap.getValues(false);
			for each (var res:Resource in _resMap)
			{
				res.notifyLangChange();
			}
		}
		
		public function addResourceNodes(xml:XML, parent:Resource = null):void
		{
			var nodes:Vector.<ResourceNodeInfo> = collectResXmlNodesAtTopLayer(xml, parent);
			
			collectChildrenResXmlNodesFromTopLayerNodes(nodes);
		}

		
		public function collectResXmlNodesAtTopLayer(xml:XML, parent:Resource):Vector.<ResourceNodeInfo>
		{
			var nodes:Vector.<ResourceNodeInfo> = new Vector.<ResourceNodeInfo>();
			collectResXmlNodesAtDeepLayer(xml, parent, nodes);
			return nodes;
		}
		
		private function collectResXmlNodesAtDeepLayer(xml:XML, parent:Resource, nodes:Vector.<ResourceNodeInfo>):void
		{
			// if this xml can not create a resource
			if(!_factory.isResourceNode(xml))
			{
				collectChildrenResXmlNodesAtDeepLayer(xml, parent, nodes);
			}
			else
			{
				var info:ResourceNodeInfo = new ResourceNodeInfo(this);
				info.xml = xml;
				info.parent = parent;
				
				nodes.push(info);
				
			}

		}
		
		private function collectChildrenResXmlNodesAtDeepLayer(xml:XML, parent:Resource, nodes:Vector.<ResourceNodeInfo>):void
		{
			var children:XMLList = xml.elements();
			
			for each (var child:XML in children) 
			{
				collectResXmlNodesAtDeepLayer(child, parent, nodes);
			}

		}
		
		
		public function collectChildrenResXmlNodesFromTopLayerNodes(infos:Vector.<ResourceNodeInfo>):Vector.<ResourceNodeInfo>
		{
			var childrenInfos:Vector.<ResourceNodeInfo> = new Vector.<ResourceNodeInfo>();
			for each(var info:ResourceNodeInfo in infos)
			{
				info.createResource();
				if(_factory.isParentNode(info.xml))
				{
					collectChildrenResXmlNodesAtDeepLayer(info.xml, info.resource, childrenInfos);
				}
			}
			return childrenInfos;
		}
		
/*		public function loadResXml(xml:XML, parent:Resource):int 
		{
			var count:int = 0;
			
			// if this xml can not create a resource
			if(!_factory.isResourceNode(xml))
			{
				count += loadChildren(xml, parent);
				return count;
			}
			
			// res
			var res:Resource = _factory.createResource(xml, parent, this);
			CONFIG::debug
			{
				ASSERT(res != null, "can't create resource from this xml node = \n" + xml.toString());
			}
			
			++count;
			
			validationUniqueResId(res, xml);
			_resMap[res.id] = res;
			
			// deeper check
			if(_factory.isParentNode(xml))
			{
				count += loadChildren(xml, res);
			}
			
			return count;
		}
		
		private function loadChildren(xml:XML, parent:Resource):int
		{
			var count:int = 0;
			
			var children:XMLList = xml.elements();
				
			for each (var child:XML in children) 
			{
				count += loadResXml(child, parent);
			}
			
			return count;
		}
*/
		
		internal function validationUniqueResId(res:Resource, xml:XML):void
		{
			CONFIG::debug
			{
				if(res.id != MyFactory.LANG_ROOT_NODE_NAME)
				{
					var msg:String = "Duplicate id: " + res.id + "\n" + xml;
					ASSERT(_resMap[res.id] == null, msg);
				}
			}
		}
		
		public function updateFile(rsvfAry:Array):void
		{
			var flag:Object = new Object();
			
			// map rsv files to ResourceFile
			for each(var rsvf:RsvFile in rsvfAry)
			{
				if(_fileMap.contains(rsvf.id))
				{
					flag[rsvf.id] = 1;
					updateFileContent(rsvf.id);
				}
			}
			
			// if file's ready, initialize res objects
//			var array:Vector.<Object>=_resMap.getValues(false);
			for each (var res:Resource in _resMap)
			{
				if(res.file != null)
				{
					if(flag.hasOwnProperty(res.file.pathId))
					{
						res.notifyResReady();
					}
				}
			}
		}
		
		public function updateFileContent(key:String):void
		{
			var rf:ResourceFile = _fileMap.getValue(key) as ResourceFile;
			var rsvf:RsvFile = Rsv.getFile_s(key);
			
			if(rsvf.xml != null)
			{
				rf.setContent(ResourceFile.FILETYPE_XML, rsvf.xml, null);
			}
			else if(rsvf.mc != null)
			{
				rf.setContent(ResourceFile.FILETYPE_SWF, rsvf.mc, rsvf.contentDomain);
			}
			else if(rsvf.bitmapData != null)
			{
				rf.setContent(ResourceFile.FILETYPE_BITMAP, rsvf.bitmapData, rsvf.contentDomain);
			}
		}

		public function addResourceFile(rf:ResourceFile):void
		{
			_fileMap.push(rf.pathId, rf);
		}

		public function getResourceFile(file:String):ResourceFile
		{
			return _fileMap.getValue(file) as ResourceFile;
		}

		public function getResource(id:String):Resource
		{
			var resource:Resource = _resMap[id] as Resource;
			
			if(resource == null)
			{
//				ResourceFactory.createSimpleResource(id, StaticResProxy.inst.getPath(id));
			}
			
			return _resMap[id] as Resource;
		}

		
		// should cache every types? should put the resType to class: Resource.as?
		public function getGameResourcesByType(type : int) : Vector.<Object>
		{
			var result : Vector.<Object> = new Vector.<Object>();
//			var resValues : Vector.<Object> = _resMap.getValues(false);
			for each(var res : Resource in _resMap)
			{
				if(res is GameResource && (res as GameResource).resType == type)
				{
					result.push(res);
				}
			}
			return result;
		}

		public function get resMap():Object
		{
			return _resMap;
		}
	}
}