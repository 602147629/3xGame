package com.game.utils
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import framework.util.rsv.RsvFile;

	/**
	 *游戏工具类
	 * @author melody
	 * */

	public class Gutils
	{
		public function Gutils()
		{
		}
		//截取字符串中的值
		public static function reValueInStr(str:String,key:String):String
		{
			var arr:Array = str.split(",");
			for each (var s:String in arr)
			{
				if (s.slice(0,key.length) + "=" == key + "=")
				{
					return s.slice(key.length + 1,s.length);
				}
			}
			return "";
		}
		//把xml中的\换成/
		public static function replacePathString(str:String):String
		{
			var len:int = str.split("\\").length - 1;
			for(var i:int=0;i<len;i+=1)
			{
				str = str.replace("\\","/");
			}
			return str;
		}
		//把数字拆分成字符串
		public static function splitNumtoStr(num:int):Array
		{
			var arr:Array = [];
			var str:String = num.toString();
			for(var i:int=0;i<str.length;i+=1)
			{
				arr.push(str.slice(i,i + 1));
			}
			return arr;
		}
		//切图
		public static function cutImge(bitmapdata:BitmapData,px:Number,py:Number,w:Number,h:Number):BitmapData
		{
			var hNum:int = bitmapdata.width / w;
			var vNum:int = bitmapdata.height / h;
			var _tmpData:BitmapData = new BitmapData(w,h);
			for (var i:int = 0; i < hNum; i++)
			{
				for (var j:int = 0; j < vNum; j++)
				{
					_tmpData.copyPixels(bitmapdata,new Rectangle(px,py,w,h),new Point(0,0));
				}
			}
			return _tmpData;
		}
		//截取文件名的后缀
		public static function getStrSuffix(str:String):String
		{
			return RsvFile.fileExtension(str);
		}
		/**
		 * isDepth 是否深度克隆
		 */ 
		public static function clone(array:Object, isDepth:Boolean = false):Object 
		{
			if (isDepth) {
				var byteArray:ByteArray = new ByteArray();
				byteArray.writeObject(array);
				byteArray.position = 0;
				return (byteArray.readObject());
			} else {
				return array.concat();
			}
		}
		
		public static function  transRow_ColumnToPosition(row:int,columns:int):int
		{
			var value:uint = 0
			row = row << 4;
			value = value | row
			value = value | columns;
			/*var byteArr:ByteArray = new ByteArray();
			
			byteArr.writeByte(value);
			byteArr.position = 0;*/
			return value;
		}

		private function deCodeRow_Columns(pos:uint):Array {
			var row:uint = pos >> 4;
			var col:uint = pos & 0x0f
			var arr:Array = [row,col];
			return arr;
		}

	}
}