package framework.util.cacher
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	import framework.model.BackgroundLoadProxy;
	import framework.resource.Resource;
	import framework.util.ResHandler;
	import framework.util.progressiveLoder.ProgressiveLoader;
	
	public class ResCacher
	{
		public static var ACTIVE_TRACE_CACHE_INFO:Boolean=true;

		
		public function ResCacher()
		{
		}

		private static function mapCfgToKey(path:String, name:String, frame:String):String
		{
			var key:String=path;
			key+= " [a]"+ name;
			key+= " [f]"+ (frame?frame:"1");
			

			return key;
		}
		
//		public static const SAND_GLASS_LOADING:String = "SAND_GLASS_LOADING";
		
		public static function getVectorBitMapAsset(owner:Resource,cbReady:Function=null, isMapTile:Boolean = false):DisplayObject
		{
			if(owner.file.content != null)
			{
				var bitMap:Bitmap = new Bitmap(owner.file.content as BitmapData);
				
				if(cbReady != null)
				{
					cbReady(bitMap);
				}
				
				return bitMap;
			}
			else
			{
				if(isMapTile)
				{
					var dcMap:ProgressiveLoader = new ProgressiveLoader(owner, cbReady);
					
					return dcMap;
				}
				else
				{
					var data:BackgroundLoadParameter = new BackgroundLoadParameter();
					data.init(owner);
					
					var dc:CachePlaceholder = new CachePlaceholder(owner, data);
					dc.cbReady = cbReady;
					
					
					
					var additionalPriority:int = getAdditionalPriority(owner);
					BackgroundLoadProxy.inst.increasePriorityToLoadingThread(owner.file.pathId, additionalPriority);
					BackgroundTaskManager.addBackgroundLoadTask(dc);
					
					var primitive:Bitmap = createBitMapVectorAssetWithPrimitive(owner);
					
					PlaceholderHelper.addLoadingBitMapToSpaceHolder(dc, owner, primitive);
					
					return dc;
				}
			}
		}
		

		public static function getVectorSwfAsset(owner:Resource,
			frame:String=null,
			cbReady:Function=null):DisplayObject
		{
			
			if(owner.swfClass != null)
			{
				//asset is loaded
				var mc:MovieClip = new owner.swfClass();
				AssetPreprocessor.preprocessor(mc, frame);
				if(cbReady!=null)
				{
					cbReady(mc);
				}
				return mc;
			}
			else
			{
				//put it to loading queue
				var res:Resource = owner as Resource;
				
				var data:BackgroundLoadParameter = new BackgroundLoadParameter();
				data.init(owner, frame);

				var dc:CachePlaceholder = new CachePlaceholder(owner, data);
				dc.cbReady = cbReady;
				
				PlaceholderHelper.addLoadingAnimToSpaceHolder(dc, res, null, true);

				var additionalPriority:int = getAdditionalPriority(res);
				BackgroundLoadProxy.inst.increasePriorityToLoadingThread(owner.file.pathId, additionalPriority);
				BackgroundTaskManager.addBackgroundLoadTask(dc);

				var primitive:MovieClip = createSwfVectorAssetWithPrimitive(owner);
				if(primitive != null)
				{
					return primitive;
				}
				else
				{
					return dc;
				}

//				return primitive;

			}
		}
		
		private static function getAdditionalPriority(mapRes:Resource):int
		{
			var additionalPriority:int = 0;
			if(mapRes != null)
			{
				if(PlaceholderHelper.getLoadingPriority() > 0)
				{
					additionalPriority = 100;
				}
			}
			return additionalPriority;
		}
		
		private static function createBitMapVectorAssetWithPrimitive(owner:Resource):Bitmap
		{
			var mc:Bitmap;
			if(owner.idPrimitive != null)
			{
				mc = ResHandler.getBitMapFromResourceManager(owner.idPrimitive);
				
				if(mc != null)
				{
					mc.scaleX = 20;
					mc.scaleY = 20;
				}
				
				CONFIG::debug
				{
//					ASSERT(mc != null);
					ASSERT(mc == null || mc is Bitmap, "ASSERT");
				}
			}
			return mc;
		}
		
		private static function createSwfVectorAssetWithPrimitive(owner:Resource):MovieClip
		{
			var mc:MovieClip;
			if(owner.idPrimitive != null)
			{
				mc = ResHandler.getMcFirstLoad(owner.idPrimitive);
				CONFIG::debug
				{
					ASSERT(mc != null, "ASSERT");
					ASSERT(mc is MovieClip, "ASSERT");
				}
			}
			return mc;
		}

		public static function getCachedAssets(owner:Resource,
			scale:Number, frame:String,
			cbReady:Function,beConstantlyOnceCreate:Boolean,
			dontUseBuildingPlaceholder:Boolean):DisplayObject
		{
			CONFIG::debug
			{
				ASSERT(frame != null, "frame can not be null");
			}
			
			var path:String = owner.file.pathId;
			var name:String = owner.id;
			var key:String = mapCfgToKey(path,name,frame);

			var creator:CacheToImageCreator=GlobalCacheImageCreatorManager.getCreator(key);
			
			
			if(creator==null)
			{
				CONFIG::debug
				{
					if(ResCacher.ACTIVE_TRACE_CACHE_INFO)
					{
						TRACE_CACHE("create one image cache task, key = " +key);
					}
				}
				
				creator=new CacheToImageCreator();
				creator.bindToResource(owner, key, frame);
				GlobalCacheImageCreatorManager.addCreator(key, creator);
			}

			var dc:CachePlaceholder=new CachePlaceholder(owner, creator);
			dc.cbReady = cbReady;
			dc.beNotAffectedByChangeScale = beConstantlyOnceCreate;

			var level:Number = getContentCachingScale(scale);
			
			var success:Boolean = creator.trySetCachedContentToSpaceholder(dc, level);
//			trace("beConstantlyOnceCreate : " + beConstantlyOnceCreate)
//			trace("success: " + success)
			
			if(!success)
			{
				var mapRes:Resource = owner as Resource;

				//asset is not ready
				if(owner.swfClass == null)
				{
					//that's because asset is not loaded
					var additionalPriority:int = getAdditionalPriority(mapRes);
					BackgroundLoadProxy.inst.increasePriorityToLoadingThread(owner.file.pathId, additionalPriority)
				}
				
				var primitive:MovieClip = createSwfVectorAssetWithPrimitive(owner);
				PlaceholderHelper.addLoadingAnimToSpaceHolder(dc, mapRes, primitive, dontUseBuildingPlaceholder);
				
				BackgroundTaskManager.addBackgroundCacheTask(dc, level);
			}
			
			BackgroundTaskManager.addActivingCachedPlaceholder(dc);
			return dc;
		}

		
		private static function getContentCachingScale(scale:Number):Number
		{
			/*if(scale == 0)
			{
				return ZoomHandle.getGameScale();
			}
			else*/
			{
				return scale;
			}
		}

	}
}


