package com.hch.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;

	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-6-19 下午4:18:39 
	 */
	public class CImgUtil
	{
		/**
		 * 获取bitmap的二值
		 */
		public static function getGrayBmd(bmd:BitmapData):BitmapData
		{
			var ourEdgeData:BitmapData = new BitmapData(bmd.width , bmd.height , bmd.transparent);
			for(var w:int = 0; w<bmd.width; w++)
			{
				for(var h:int = 0; h<bmd.height; h++)
				{
					var pixelValue270:uint = getGray(bmd.getPixel(w-1, h));
					var pixelValue90:uint = getGray(bmd.getPixel(w+1, h));
					
					var pixelValue0:uint = getGray(bmd.getPixel(w, h-1));
					var pixelValue180:uint = getGray(bmd.getPixel(w, h+1));
					
					var pixelValue315:uint = getGray(bmd.getPixel(w-1, h-1));
					var pixelValue45:uint = getGray(bmd.getPixel(w+1, h-1));
					var pixelValue135:uint = getGray(bmd.getPixel(w+1, h+1));
					var pixelValue225:uint = getGray(bmd.getPixel(w-1, h+1));
					
					// Applying the following convolution mask matrix to the pixel
					//    GX        GY  
					// -1, 0, 1   1, 2, 1
					// -2, 0, 2   0, 0, 0
					// -1, 0, 1  -1,-2,-1
					
					var gx:int = (pixelValue45 + (pixelValue90 * 2) + pixelValue135)-(pixelValue315 + (pixelValue270 * 2) + pixelValue225);
					var gy:int = (pixelValue315 + (pixelValue0 * 2) + pixelValue45)-(pixelValue225 + (pixelValue180 * 2 ) + pixelValue135);
					
					var gray:uint = Math.abs(gx) + Math.abs(gy);
					
					// Decrease the grays a little or else its all black and white.
					// You can play with this value to get harder or softer edges.
					gray *= .2;
					
					// Check to see if values aren't our of bounds
					if(gray > 255)
						gray = 255;
					
					if(gray < 0)
						gray = 0;
					
					// Build New Pixel
					var newPixelValue:uint = (gray << 16) + (gray << 8) + (gray);
					
					// Copy New Pixel Into Edge Data Bitmap
					ourEdgeData.setPixel(w,h,newPixelValue);	
				}	
			}
			return ourEdgeData;
		}
		
		
		
		/**
		 * 单个颜色的黑白二值
		 */
		public static function getGray(pixelValue:uint):uint
		{
			var red:uint = (pixelValue >> 16 & 0xFF) * 0.30;
			var green:uint = (pixelValue >> 8 & 0xFF) * 0.59;
			var blue:uint = (pixelValue & 0xFF) * 0.11;
			return (red + green + blue);
		}
		
		/**
		 * 加载PNG
		 */	
		public static function loadPng(path:String , callback:Function):void
		{
			var ldr:Loader = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE , function(e:Event):void
				{
					var bitmap:Bitmap = new Bitmap(Bitmap(e.target.content).bitmapData);
					e.target.loader.unload();
					callback(bitmap.bitmapData);
				}
			);
			
			var urlReq:URLRequest = new URLRequest(path);
			var lc:LoaderContext = new LoaderContext(true);
			ldr.load(urlReq , lc);
		}
		
		/**
		 * 导出PNG
		 */
		public static function exportPng(path:String , bmd:BitmapData):void
		{
			var byteArray:ByteArray = new PNGEncoder().encode(bmd);
			var f:FileStream = new FileStream();
			var resultFile:String = path;
			f.open(new File(resultFile) , FileMode.WRITE);
			f.writeBytes(byteArray);
			f.close();
		}
		
		/**
		 * 检测边界
		 */
		public static function checkEdge(bmd:BitmapData , Pos:Point):Rectangle
		{
			var srcPoint:Point = Pos.clone();
			var bottom:int,top:int,left:int,right:int;
			var mcolor:uint;
			
			//检测当前点是否为空
			mcolor = bmd.getPixel32(srcPoint.x,srcPoint.y);
			if((mcolor & 0xFF000000) == 0x00000000)
			{
				return new Rectangle(Pos.x,Pos.y,0,0);
			}
			bmd.lock();
			bottom = srcPoint.y;
			while(true)
			{
				mcolor = bmd.getPixel32(srcPoint.x,bottom);
				if((mcolor & 0xFF000000) == 0x00000000)
				{
					break;
				}
				bottom++;
			}
			
			top = srcPoint.y;
			while(true)	
			{
				mcolor = bmd.getPixel32(srcPoint.x,top - 1);
				if((mcolor & 0xFF000000) == 0x00000000)
				{
					break;
				}
				top--;
			}
			
			
			right = srcPoint.x;
			while(true)
			{
				mcolor = bmd.getPixel32(right,srcPoint.y);
				if((mcolor & 0xFF000000) == 0x00000000)
				{
					break;
				}
				right++;
			}
			
			left = srcPoint.x;
			while(true)
			{
				mcolor = bmd.getPixel32(left - 1,srcPoint.y);
				if((mcolor & 0xFF000000) == 0x00000000)
				{
					break;
				}
				left--;
			}
			
			bmd.unlock();
			
			
			//				进行2次扩充检测
			for(var j:int = 0;j<3;j++)
			{
				var _srcRect:Rectangle = new Rectangle(left,top,right-left,bottom-top);
				//进行2次线性检测
				var i:int;
				//是否包含内容
				var hasContent:Boolean = false;
				//检测左线
				while(true)
				{
					hasContent = false;
					for(i = _srcRect.top;i<_srcRect.bottom;i++)
					{
						//该线上还有其它颜色,也就是包含内容
						mcolor = bmd.getPixel32(left - 1,i);
						if((mcolor & 0xFF000000) != 0x00000000)
						{
							
							hasContent = true;
							break;
						}
					}
					if(!hasContent)
						break;
					left --;
				}
				
				//检测右线
				while(true)
				{
					hasContent = false;
					for(i = _srcRect.top;i<_srcRect.bottom;i++)
					{
						//该线上还有其它颜色,也就是包含内容
						mcolor = bmd.getPixel32(right,i);
						if((mcolor & 0xFF000000) != 0x00000000)
						{
							
							hasContent = true;
							break;
						}
					}
					if(!hasContent)
						break;
					right ++;
				}
				
				//检测上线
				while(true)
				{
					hasContent = false;
					for(i = _srcRect.left;i<_srcRect.right;i++)
					{
						//该线上还有其它颜色,也就是包含内容
						mcolor = bmd.getPixel32(i,top - 1);
						if((mcolor & 0xFF000000) != 0x00000000)
						{
							
							hasContent = true;
							break;
						}
					}
					if(!hasContent)
						break;
					top --;
				}
				
				
				//检测下线
				while(true)
				{
					hasContent = false;
					for(i = _srcRect.left;i<_srcRect.right;i++)
					{
						//该线上还有其它颜色,也就是包含内容
						mcolor = bmd.getPixel32(i,bottom);
						if((mcolor & 0xFF000000) != 0x00000000)
						{
							
							hasContent = true;
							break;
						}
					}
					if(!hasContent)
						break;
					bottom ++;
					
				}
			}
			return new Rectangle(left,top,right-left,bottom-top);
		}
		
		/**
		 * 位图缩放
		 */
		public static function scaleBitmapdata(scalx:Number , scaly:Number , originalbmd:BitmapData):BitmapData
		{
			var width:int = (originalbmd.width * scalx) || 1;
			var height:int = (originalbmd.height * scaly) || 1;
			var transparent:Boolean = originalbmd.transparent;
			var result:BitmapData = new BitmapData(width, height, transparent);
			var matrix:Matrix = new Matrix();
			matrix.scale(scalx, scaly);
			result.draw(originalbmd, matrix);
			return result;
		}
	}
}