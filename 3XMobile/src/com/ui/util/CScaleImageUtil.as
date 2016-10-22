package com.ui.util
{
	/**
	 * @author caihua
	 * @comment scale
	 * 创建时间：2014-6-24 上午10:18:27 
	 */
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.util.ResHandler;
	
	public class CScaleImageUtil
	{
		/**
		 * @param sourceBmd : 源数据
		 * @param rect : 9宫框
		 * @param destSize : 最终大小
		 *  
		 */
		public static function CScaleImageFromBitmapData(sourceBmd:BitmapData , rect:Rectangle , destSize:Point):Bitmap
		{
			var bmp:ScaleBitmap = new ScaleBitmap(sourceBmd);
			bmp.scale9Grid = rect;
			bmp.setSize(destSize.x , destSize.y);
			return bmp;
		}
		
		/**
		 * @param sourceBmd : 源数据
		 * @param rect : 9宫框
		 * @param destSize : 最终大小
		 */
		public static function CScaleImageFromBitmap(sourceBmp:Bitmap , rect:Rectangle , destSize:Point):Bitmap
		{
			var bmp:ScaleBitmap = new ScaleBitmap(sourceBmp.bitmapData);
			bmp.scale9Grid = rect;
			bmp.setSize(destSize.x , destSize.y);
			return bmp;
		}
		
		/**
		 * 从bitmapdata导出类中生成scaleImage
		 */
		public static function CScaleImageFromClass(clsKey:String , rect:Rectangle , destSize:Point):Bitmap
		{
			var cls:Class = ResHandler.getClass(clsKey);
			if(!cls)
			{
				return null;
			}
			return CScaleImageFromBitmapData(new cls(), rect , destSize);
		}
	}
}