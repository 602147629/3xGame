package framework.util.cacher
{
	import framework.util.map.Map;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class CachedBitmapData
	{
		private var _vectorContent:DisplayObject = null;
		private var _bitmapData:BitmapData = null;
		private var _animatedItemsGroup:AnimatedContentItemGroup = new AnimatedContentItemGroup();

		public var x:Number;
		public var y:Number;
		public var w:Number;
		public var h:Number;
		public var level:Number = 1;
		
		public static var totalMemoryCost:int = 0;

		public function CachedBitmapData(rect:Rectangle, level:Number)
		{
			this.x = rect.x;
			this.y = rect.y;
			this.w = rect.width;
			this.h = rect.height;

			this.level = level;
			
			totalMemoryCost += w * h * 4;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		public function get vectorContent():DisplayObject
		{
			return _vectorContent;
		}
		
		public function setVectorContent(mc:MovieClip, ownerName:String):void
		{
			_animatedItemsGroup.pickupAllAnimatedItemsFromMc(mc, ownerName);
			_vectorContent = mc;
		}
		
		public function get animatedItemsGroup():AnimatedContentItemGroup
		{
			return _animatedItemsGroup;
		}
		
		public function reuseCacheContentWithNewAnimItem(mc:MovieClip, ownerName:String):CachedBitmapData
		{
			CONFIG::debug
			{
				ASSERT(_vectorContent == null, "ASSERT");
			}
			
			var rect:Rectangle = new Rectangle(x, y, w, h);
			var data:CachedBitmapData = new CachedBitmapData(rect, level);
			data._bitmapData = _bitmapData;
			data._animatedItemsGroup.pickupAllAnimatedItemsFromMc(mc, ownerName);
			return data;
		}

		
		public function cacheContent(mc:MovieClip, ownerName:String):void
		{
			CONFIG::debug
			{
				ASSERT(_vectorContent == null, "ASSERT");
			}
			
			_animatedItemsGroup.pickupAllAnimatedItemsFromMc(mc, ownerName);
			_animatedItemsGroup.hideAllItems();

			var m:Matrix = calcMatrixToBoundingTheContentOfMc();
			_bitmapData = new BitmapData(w, h, true, 0x0);
			_bitmapData.draw(mc, m, null, null, null, true);
			
			_animatedItemsGroup.showAllItems();
		}
		
		private function calcMatrixToBoundingTheContentOfMc():Matrix
		{
			var m:Matrix = new Matrix(level, 0, 0, level, -x, -y);
			return m;
		}

	}
}

