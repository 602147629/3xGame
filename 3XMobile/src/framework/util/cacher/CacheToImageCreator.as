package framework.util.cacher
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import framework.resource.Resource;
	import framework.util.DisplayUtil;

	public class CacheToImageCreator extends BackgroundLoadParameter
	{
		public function CacheToImageCreator()
		{
			super();
		}

	
		private var cacheContentKey:String;
		private var dataSet:Array = new Array();
		
		private static const _MAX_BMP_DATA_SIZE:int = 1024;
		
		public static var TOTAL_CACHING_COST:int = 0;
		
//		public function getTotalMemSize():int
//		{
//			var mem:int = 0;
//			var bmps:Vector.<Object> = dataSet.getValues(false);
//			for each(var data:CachedBitmapData in bmps)
//			{
//				mem += data.bitmapData.width * data.bitmapData.height * 4;
//			}
//			return mem;
//		}
		
//		private static function mapCacheConfigToKey(level:Number):String
//		{
//			var key:String = "" + level;
//			return key;
//		}
		
		private function getAlignedBoundsAtLevelFromMc(mc:MovieClip, level:Number):Rectangle
		{
			//get rect, and align position to integer value
			var rect:Rectangle = mc.getBounds(null);
			rect.x *= level;
			rect.y *= level;
			rect.width *= level;
			rect.height *= level;

			var floorX:Number = Math.floor(rect.x);
			rect.width += rect.x - floorX;
			rect.x = floorX;
			
			var floorY:Number = Math.floor(rect.y);
			rect.width += rect.y - floorY;
			rect.y = floorY;
			
			rect.width = int(Math.ceil(rect.width));
			rect.height = int(Math.ceil(rect.height));
			
			return rect;			
		}
		
		private function isAssetBeLoad():Boolean
		{
			return (owner.swfClass != null);
		}
		
		private function trySaveCachedData(level:int, data:CachedBitmapData):void
		{
			dataSet[level] = data;
		}
		
		private function tryGetCachedData(level:int):CachedBitmapData
		{
			var data:CachedBitmapData = dataSet[level] as CachedBitmapData;
			return data;
		}
		
		private function createAndDrawContentToBitmap(mc:MovieClip, rect:Rectangle, level:Number):CachedBitmapData
		{
			var data:CachedBitmapData = new CachedBitmapData(rect, level);
			data.cacheContent(mc, cacheContentKey);
			return data;
		}
		
		private static function stopAndDropMc(mc:MovieClip):void
		{
			DisplayUtil.stopAllAnim(mc);
		}
		
		private function tryCreateCachedBmpDataAndSave(scale:Number):CachedBitmapData
		{
			if(isAssetBeLoad() == false)
			{
				return null;
			}
			
			var startTime:Number = getTimer();
			
			var keyScale100:int = scale * 100;
			
			var mc:MovieClip=createAssetAndPreprocess();
			var data:CachedBitmapData=tryGetCachedData(keyScale100);
			
			if(data==null)
			{
				//original content look blur in windows mode, so have to cache them in any case
				var canUseBuildingContent:Boolean = scale > 0.99 && scale < 1.01;
				if(canUseBuildingContent)
				{
					checkContentIsBitmap(mc);
					
					data = new CachedBitmapData(new Rectangle(), scale);
					data.setVectorContent(mc, cacheContentKey);
				}
				else
				{
					data = createNewCacheData(mc, scale);
					trySaveCachedData(keyScale100, data);
				}
				
			}
			else
			{
				data = duplicateCacheDataAndRePickupAnimatedItems(data, mc);
			}

			if(data.vectorContent == null)
			{
				stopAndDropMc(mc);
			}
			
			var costTime:Number = getTimer() - startTime;
			TOTAL_CACHING_COST += costTime;

			return data;
		}
		
		private function checkContentIsBitmap(mc:MovieClip):void
		{

		}
		
		private function createAssetAndPreprocess():MovieClip
		{
			var mc:MovieClip=new owner.swfClass();
			AssetPreprocessor.preprocessor(mc, frame);
			return mc;			
		}
		
		private function createNewCacheData(mc:MovieClip, level:Number):CachedBitmapData
		{
			CONFIG::debug
			{
				if(ResCacher.ACTIVE_TRACE_CACHE_INFO)
				{
					TRACE_CACHE("complete one image cache, key = " + cacheContentKey +"	level = " + level);
				}
			}
			
			var rect:Rectangle=getAlignedBoundsAtLevelFromMc(mc, level);
//			CONFIG::debug
//			{
//				ASSERT(rect.width > 0 && rect.width <= _MAX_BMP_DATA_SIZE, "invalid asset width:" + rect.width + " for " + getQualifiedClassName(mc));
//				ASSERT(rect.height > 0 && rect.height <= _MAX_BMP_DATA_SIZE, "invalid asset height:" + rect.height + " for " + getQualifiedClassName(mc));
//			}
			
			var data:CachedBitmapData = createAndDrawContentToBitmap(mc, rect, level);
			return data;			
		}
		
		private function duplicateCacheDataAndRePickupAnimatedItems(data:CachedBitmapData, mc:MovieClip):CachedBitmapData
		{
			var duplicateData:CachedBitmapData = data.reuseCacheContentWithNewAnimItem(mc, cacheContentKey);
			return duplicateData;			
		}

		
		public function bindToResource(owner:Resource, cacheContentKey:String, frame:String):void
		{
			this.init(owner, frame);		
			this.cacheContentKey = cacheContentKey;
		}
		
		public function trySetCachedContentToSpaceholder(holder:CachePlaceholder, level:Number=1):Boolean
		{
			var data:CachedBitmapData = tryCreateCachedBmpDataAndSave(level);
			if(data)
			{
				var bmp:DisplayObject=generateWrapperToData(data);
				holder.setContent(bmp);
				holder.isLoaded = true;
				holder.setAnimatedItemsGroup(data.animatedItemsGroup);

				if(holder.cbReady!=null)
				{
					holder.cbReady(holder);
					holder.cbReady = null;
				}

				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function generateWrapperToData(data:CachedBitmapData):DisplayObject
		{
			if(data.vectorContent != null)
			{
				return data.vectorContent;
			}
			
			var bmp:Bitmap=new Bitmap(data.bitmapData);
			
			var invDataLevel:Number = 1 / data.level;
			bmp.scaleX = invDataLevel;
			bmp.scaleY = invDataLevel;
			bmp.x = data.x * invDataLevel;
			bmp.y = data.y * invDataLevel;
			
/*			bmp.transform.matrix=new Matrix(
				1/data.level,
				0, 
				0,
				1/data.level, 
				data.x/data.level,
				data.y/data.level);
*/
			
			return bmp;

		}

	}
	
	
	
}