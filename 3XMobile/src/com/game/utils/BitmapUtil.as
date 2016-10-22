package com.game.utils
{
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author zhangxin
	*/
	public class BitmapUtil
	{
		/**
		 * 获取九宫格缩放后的位图数据，速度要比方法2快25%
		 * @param oriData 原始位图数据
		 * @param width 缩放后的宽度
		 * @param height 缩放后的高度
		 * @param top 九宫格之高
		 * @param bottom 九宫格之底
		 * @param left 九宫格之左
		 * @param right 九宫格之右
		 * @return BitmapData 新的位图数据
		 */
		public static function getScale9Data(oriData:BitmapData, width:int, height:int, top:int, bottom:int, left:int, right:int):BitmapData
		{
			//获取中心点颜色值
			var centerColor:uint = oriData.getPixel32(left, top);
			var data:BitmapData = new BitmapData(width, height, true, 0);
			
			//简化区域运算
			var oriArr:Array = [oriData.width - right, oriData.height - bottom];
			var newArr:Array = [width - oriArr[0], height - oriArr[1]];
			
			//放四个角的
			var rect:Rectangle = new Rectangle(0, 0, left, top);
			var pt:Point = new Point();
			
			data.copyPixels(oriData, rect, pt);
			
			rect.x = right, rect.width = oriArr[0];
			pt.x = newArr[0], pt.y = 0;
			data.copyPixels(oriData, rect, pt);
			
			rect.x = 0, rect.y = bottom, rect.width = left, rect.height = oriArr[1];
			pt.x = 0, pt.y = newArr[1];
			data.copyPixels(oriData, rect, pt);
			
			rect.x = right, rect.width = oriArr[0];
			pt.x = newArr[0], pt.y = newArr[1];
			data.copyPixels(oriData, rect, pt);
			
			//上下水平缩放的两个
			var matrix:Matrix = new Matrix();
			matrix.a = (newArr[0] - left) / (right - left), matrix.tx = left - left * matrix.a;
			rect.x = left, rect.y = 0, rect.width = newArr[0] - left, rect.height = top;
			data.draw(oriData, matrix, null, null, rect);
			//	Debugger.trace("ma: " + matrix.a + " mtx: " + matrix.tx );
			matrix.ty = height - oriData.height;
			rect.y = newArr[1], rect.height = oriArr[1];
			data.draw(oriData, matrix, null, null, rect);
			
			//左右垂直缩放的两个
			matrix.identity(), matrix.d = (newArr[1] - top) / (bottom - top), matrix.ty = top - top * matrix.d;
			rect.x = 0, rect.y = top, rect.width = left, rect.height = newArr[1] - top;
			data.draw(oriData, matrix, null, null, rect);
			
			matrix.tx = width - oriData.width;
			rect.x = newArr[0], rect.width = oriArr[0];
			data.draw(oriData, matrix, null, null, rect);
			
			//填充中间部分
			rect.x = left, rect.y = top, rect.width = newArr[0] - left, rect.height = newArr[1] - top;
			data.fillRect(rect, centerColor);
			
			//返回新的位图数据
			return data;
		}
		
		/**
		 * 获取九宫格缩放后的位图数据，方法速度稍慢，但简洁，可以处理误设位置的九宫格
		 * @param oriData 原始位图数据
		 * @param width 缩放后的宽度
		 * @param height 缩放后的高度
		 * @param top 九宫格之高
		 * @param bottom 九宫格之底
		 * @param left 九宫格之左
		 * @param right 九宫格之右
		 * @return BitmapData 新的位图数据
		 */
		public static function getScale9Data2(oriData:BitmapData, width:int, height:int, top:int, bottom:int, left:int, right:int):BitmapData
		{
			var bmpData:BitmapData = new BitmapData(width, height,true, 0x0);
			
			var rows:Array = [0, top, bottom, oriData.height];
			var cols:Array = [0, left, right, oriData.width];
			
			var dRows:Array = [0, top, height - (oriData.height - bottom), height];
			var dCols:Array = [0, left, width - (oriData.width - right), width];
			
			var origin:Rectangle;
			var draw:Rectangle;
			var mat:Matrix = new Matrix();
			
			for(var cx:int = 0; cx < 3; cx++)
			{
				for(var cy:int = 0; cy < 3; cy++)
				{
					origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw = new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
					mat.identity();
					mat.a = draw.width / origin.width;
					mat.d = draw.height / origin.height;
					mat.tx = draw.x - origin.x * mat.a;
					mat.ty = draw.y - origin.y * mat.d;
					bmpData.draw(oriData, mat, null, null, draw);
				}
			}

			return bmpData;
		}
	}
}