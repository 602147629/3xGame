package framework.util
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	import framework.model.BackgroundLoadProxy;
	import framework.model.FileProxy;
	import framework.model.StaticResProxy;
	import framework.resource.Resource;
	import framework.resource.ResourceFactory;
	import framework.resource.ResourceManager;
	import framework.util.backgroundloadmovieclip.BackGroundLoadMovieClip;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvEvent;
	import framework.util.rsv.RsvFile;
	import framework.util.rsv.RsvGroup;
	
	public class ResHandler
	{
		public function ResHandler()
		{
		}
		
		public static function getMcBackgroundLoad(className:String, cbComplete:Function = null, useCache:Boolean = false, loadPriority:int = 0):MovieClip
		{
			return new BackGroundLoadMovieClip(className, cbComplete, useCache, loadPriority);
		}
		
		public static function tryGetMcFirstLoad(className:String):MovieClip
		{
			return getMcFirstLoad(className, true);
		}
		
		public static function getMcFirstLoad(className:String, skipCheck:Boolean = false):MovieClip
		{
			if(className == null)
			{
				return null;
			}			
			
			if(className == "flash.display.MovieClip")
			{
				return new MovieClip();
			}
			
			var result:MovieClip = getMcFromResourceManager(className);

			CONFIG::debug
			{
				if(!skipCheck)
				{
					var res:Resource = ResourceManager.getInstance().getResource(className);
					ASSERT(res != null, "Can not get Resource for: " + className);
					
					if(res.getLoadType() != FileProxy.FIRST_LOADING_GROUP_ID)
					{
						var firstLoadGroup:RsvGroup = Rsv.getGroup_s(FileProxy.FIRST_LOADING_GROUP_ID);
						if(!firstLoadGroup.contains(res.file.referenceRsvFile))
						{
							var idPrimitive:String = res.idPrimitive;
							
							if(idPrimitive != null)
							{								
								var resPrimitive:Resource = ResourceManager.getInstance().getResource(idPrimitive);
								
								var msg:String = "asset query by this method must defined as first load, or its primitive defined as first load:" + res.id;
								ASSERT(resPrimitive != null && resPrimitive.getLoadType() == FileProxy.FIRST_LOADING_GROUP_ID, msg);
							}
						}
					}
				}
			}
			
			if(Debug.CREATE_MC_FOR_RESOURCE_NOT_FOUND && result == null)
			{
				result = createHintForNotExistingMc(className);
			}
			
			return result;
		}

		public static function getMcFromDomain(resourceId:String):MovieClip
		{
			var resource:Resource = ResourceManager.getInstance().getResource(resourceId);
			
			CONFIG::debug
			{
				ASSERT(resource != null, "Can not find the Resource for " + resourceId);
			}
			
			var resourceFile:RsvFile = Rsv.getFile_s(resource.file.pathId);
			var resourceClass:Class = resourceFile.contentDomain.getDefinition(resource.className) as Class;
			var mc:MovieClip = new resourceClass();
			return mc;
		}

		public static function getMcFromAppDomain(className:String):MovieClip
		{
			var MyClass:Class = getDefinitionByName(className) as Class;
			return new MyClass();
		}
		
		private static function createHintForNotExistingMc(className:String):MovieClip
		{
			var result:MovieClip = null;
			
			if(Debug.CREATE_MC_FOR_RESOURCE_NOT_FOUND)
			{
				result = new MovieClip();
				var textFiled:TextField = new TextField();
				textFiled.mouseEnabled = false;
				textFiled.text = className;
				result.addChild(textFiled);
			}
			
			return result;
		}
		
		public static function getBitMapFromResourceManager(id:String):Bitmap
		{
			var result:Bitmap = null;
			
			var res:Resource = ResourceManager.getInstance().getResource(id);
			if(res != null)
			{
				result = res.getContent() as Bitmap;
			}
			
			return result;
		}
		
		private static function getMcFromResourceManager(className:String):MovieClip
		{
			var result:MovieClip = null;
			
			var res:Resource = ResourceManager.getInstance().getResource(className);
			if(res != null)
			{
				result = res.getContent() as MovieClip;
			}

			return result;
		}
		
		public static function getClass(resourceName:String):Class
		{
			var res:Resource = ResourceManager.getInstance().getResource(resourceName);
			if(res != null)
			{
				return res.swfClass;
			}
			
			return null;
		}
		
		public static function getClassInst(className:String):*
		{
			var MyClass:Class = getDefinitionByName(className) as Class;
			return new MyClass();
		}
		
		public static function loadBitMapHandler(fileId:String, callBack:Function):void
		{
			if(Rsv.getFile_s(fileId) && Rsv.getFile_s(fileId).bitmapData != null)
			{
				if(callBack != null)
				{					
					callBack(fileId);
				}
			}
			else
			{
				if(Rsv.inst.getFile(fileId) == null)
				{
					ResourceFactory.createRsvFile(fileId, StaticResProxy.inst.getPath(fileId));
				}
				var completeHandler:Function = function (rsvEvent:RsvEvent):void
				{
					if(rsvEvent.type == ""+ RsvEvent.CONTENTREADY)
					{				
						callBack(fileId);
					}
				}
				BackgroundLoadProxy.inst.increasePriorityToLoadingThread(fileId,BackgroundLoadProxy.PRIORITY_BITMAP,completeHandler);			
			}
		}
		
		public static function loadXmlHandler(fileId:String, callBack:Function):void
		{
			if(Rsv.getFile_s(fileId) && Rsv.getFile_s(fileId).xml != null)
			{
				if(callBack != null)
				{					
					callBack(fileId);
				}
			}
			else
			{
				if(Rsv.inst.getFile(fileId) == null)
				{
					ResourceFactory.createRsvFile(fileId, StaticResProxy.inst.getPath(fileId));
				}
				var completeHandler:Function = function (rsvEvent:RsvEvent):void
				{
					if(rsvEvent.type == ""+ RsvEvent.CONTENTREADY)
					{				
						callBack(fileId);
					}
				}
				BackgroundLoadProxy.inst.increasePriorityToLoadingThread(fileId,BackgroundLoadProxy.PRIORITY_XML,completeHandler);			
			}
		}
		
		/**
		 * 
		 * */
		public static function loadSwfHandler(fileId:String, callBack:Function):void
		{
			if(Rsv.getFile_s(fileId) && Rsv.getFile_s(fileId).mc != null)
			{
				if(callBack != null)
				{					
					callBack(fileId);
				}
			}
			else
			{
				if(ResourceManager.getInstance().getResource(fileId) == null)
				{
					ResourceFactory.createSimpleResource(fileId, StaticResProxy.inst.getPath(fileId));
//					ResourceFactory.createRsvFile(fileId, StaticResProxy.inst.getPath(fileId));
				}
				var completeHandler:Function = function (rsvEvent:RsvEvent):void
				{
					if(rsvEvent.type == "" + RsvEvent.CONTENTREADY)
					{	
						callBack(fileId);
					}
				}
				BackgroundLoadProxy.inst.increasePriorityToLoadingThread(fileId,BackgroundLoadProxy.PRIORITY_SWF,completeHandler);			
			}
		}

	}
}