package com.hch.util
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-6-20 上午11:29:39 
	 */
	public class CCheckRectUtil
	{
		private static var _undoList:Array;
		private static var _doList:Array;
		private static var _grayBmd:BitmapData;
		private static var _grayBmdSize:Point;
		
		private static var _minX:int = 0 ;
		private static var _minY:int = 0 ;
		private static var _maxX:int = 0 ;
		private static var _maxY:int = 0 ;
		
		private static var _rectList:Array;
		
		private static var _lastX:Number = 0;
		private static var _lastY:Number = 0;
		
		public static function init(grayBmd:BitmapData):void
		{
			_grayBmd = grayBmd;
			_grayBmdSize = new Point(grayBmd.width , grayBmd.height);
			_undoList = new Array();
			_doList = new Array();
			
			_rectList = new Array();
			
			__reset();
		}
		
		/**
		 * 找到第一个不为0的点
		 */
		private static function __findFirstPos():Point
		{
			for(var x:int = _minX ; x < _grayBmdSize.x ; x += 3)
			{
				for(var y:int = _minY ; y < _grayBmdSize.y ; y += 3)
				{
					var pixelValue:uint = _grayBmd.getPixel(x, y);
					//是剧烈点
					if(pixelValue != 0)
					{
						_minX = x;
						_minY = y;
						return new Point(x , y);
					}
				}
			}
			return null;
		}
		
		/**
		 * 启发搜索
		 */
		public static function getMaxRectangle():Array
		{
			var first:Point = __findFirstPos();
			
			//结束条件，找不到突变点
			if(first == null)
			{
				return _rectList;
			}
			
//			trace(" 初始点 : ["+first.x +" , " + first.y+"]");
			
			if(first)
			{
				_undoList.push(first);
			}
			
			while(_undoList.length != 0)
			{
				__checkPos(_undoList.shift() as Point);
			}
			
			if(__checkRectIsValid())
			{
//				trace("找到矩形 = [" + _minX + ", " + _minY + "," + (_maxX - _minX) + ", " + ( _maxY - _minY) +"]");
				
				_rectList.push(new Rectangle(_minX -1  , _minY -1 , _maxX - _minX + 2 , _maxY - _minY + 2));
				
				__clearGrayBitmapData();
			}
			else
			{
				//清理不合法的矩形，可能是边框
				__clearInvalidRect();
			}
			
			__reset();
			return _rectList;
		}
		
		private static function __clearInvalidRect():void
		{
			var uselessRect:Rectangle = new Rectangle(_minX -1  , _minY -1  , _maxX - _minX + 2 , _maxY - _minY + 2);
//			trace("无用矩形清理 = [" + uselessRect.left + ", " + uselessRect.top + "," + uselessRect.width + ", " + uselessRect.height +"]");
			_grayBmd.fillRect(uselessRect , 0xFF000000);
		}
		
		private static function __reset():void
		{
			if(_rectList.length >= 100)
			{
				throw new Error("获取矩形列表异常");
			}
			
			_undoList = new Array();
			_doList = new Array();
			
			_lastX = _minX;
			_lastY = _minY;
			
			_minX = _minY = _maxX = _maxY = 0;
			
			getMaxRectangle();
		}
		
		//更新原有bitmap数据
		private static function __clearGrayBitmapData():void
		{
//			var arr:Array = new Array();
//			for(var y:int = _minY ; y <= _maxY ; y++)
//			{
//				for(var x:int = _minX ; x <= _maxX ; x++)
//				{
//					arr.push(_grayBmd.getPixel32(x , y));
//				}
//			}
			
			_grayBmd.fillRect(new Rectangle(_minX - 1  , _minY -1  , _maxX - _minX + 2 , _maxY - _minY  + 2) , 0xFF000000);
			
//			var arr2:Array = new Array();
//			for(var h:int = _minY ; h <= _maxY ; h++)
//			{
//				for(var w:int = _minX ; w <= _maxX ; w++)
//				{
//					arr2.push(_grayBmd.getPixel32(w , h));
//				}
//			}
			
			
		}
		
		private static function __checkPos(currentPos:Point):void
		{
//			trace(" 检测点 : ["+currentPos.x +" , " + currentPos.y+"]");
			
			//设置已检测标记位
			_doList[currentPos.x + currentPos.y * _grayBmdSize.x] = 1;
			
			//pixelValue270
			__checkPosIsUseful(new Point(currentPos.x -1 , currentPos.y));
			//pixelValue90
			__checkPosIsUseful(new Point(currentPos.x +1 , currentPos.y));
			//pixelValue0
			__checkPosIsUseful(new Point(currentPos.x  , currentPos.y - 1));
			//pixelValue180
			__checkPosIsUseful(new Point(currentPos.x  , currentPos.y + 1));
			//pixelValue315
			__checkPosIsUseful(new Point(currentPos.x -1 , currentPos.y - 1));
			//pixelValue45
			__checkPosIsUseful(new Point(currentPos.x + 1 , currentPos.y - 1));
			//pixelValue135
			__checkPosIsUseful(new Point(currentPos.x -1 , currentPos.y + 1));
			//pixelValue225
			__checkPosIsUseful(new Point(currentPos.x +1 , currentPos.y + 1));
			
		}
		
		/**
		 * 单个点是否是有效点
		 */
		private static function __checkPosIsUseful(pos:Point):Boolean
		{
			//检测过
			if(_doList[pos.x + pos.y * _grayBmdSize.x] == 1)
			{
//				trace(" 已检测点 : ["+pos.x +" , " + pos.y+"]");
				return false;
			}
			
			//pos pixel value	
			var pixelValue:uint = _grayBmd.getPixel(pos.x, pos.y);
			
			//是剧烈点
			if(pixelValue == 0)
			{
				return false;
			}
			
			//是否已在Undo表
			for each(var p:Point in _undoList)
			{
				if(p.x == pos.x && p.y == pos.y)
				{
//					trace(" 检测点已在新增点列表中 ::: ["+pos.x +" , " + pos.y+"]");
					return false;
				}
			}
			
			//满足检测条件，放入待检测列表
			_undoList.push(pos);
			
//			trace(" 新增点 ::: ["+pos.x +" , " + pos.y+"]");
			
			//更新矩形
			__updateRect(pos);
			
			return true;
		}
		
		/**
		 * 更新矩形边界
		 */
		private static function __updateRect(pos:Point):void
		{
			_minX = _minX < pos.x ? _minX : pos.x;
			_minY = _minY < pos.y ? _minY : pos.y;
			_maxX = _maxX < pos.x ? pos.x : _maxX;
			_maxY = _maxY < pos.y ? pos.y : _maxY;
			
		}
		
		/**
		 * 检测矩形有效
		 */
		private static function __checkRectIsValid():Boolean
		{
			if(Math.abs(_maxX - _minX ) < 2 ||  Math.abs(_maxY - _minY ) < 2 || _maxX > _grayBmdSize.x || _maxY > _grayBmdSize.y)
			{
				return false;
			}
			return true;
		}
	}
}