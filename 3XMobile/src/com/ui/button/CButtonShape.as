package com.ui.button
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.util.ResHandler;

	/**
	 * @author caihua
	 * @comment 按钮形状
	 * 创建时间：2014-6-10 上午11:10:10 
	 */
	
	public class CButtonShape extends Bitmap 
	{
		private var _rect:Rectangle;
		private var _size:Point;
		private var _scale:Number = 1;

		public function CButtonShape(cname:String, size:Point, rect:Rectangle , scale:Number = 1)
		{
			this._rect = rect;
			this._size = size;
			this._scale = scale;
			var bmDataClass:Class = ResHandler.getClass(cname);
			if (null != bmDataClass)
			{
				this.loadAfter(bmDataClass);
			}
		}

		private function loadAfter(bmDataClass:Class):void
		{
			var bmData:BitmapData = new bmDataClass();
			var overBmData:BitmapData = new BitmapData(this._size.x, this._size.y);
			overBmData.copyPixels(bmData, this._rect, new Point(0, 0));
			
			this.bitmapData = overBmData;
			
			this.scaleX = this.scaleY = this._scale;
			
			//销毁图像数据
			bmData.dispose();
			bmData = null;
		}
	}
}