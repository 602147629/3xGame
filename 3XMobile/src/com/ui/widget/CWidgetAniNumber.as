package com.ui.widget
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class CWidgetAniNumber extends Sprite
	{
		public function CWidgetAniNumber(frames:Array, num:int)
		{
			super();
			
			__drawNumber(frames, num)
		}
		
		private function __drawNumber(frames:Array, num:int):void
		{
			var str:String = num.toString();
			var bitmap:Bitmap;
			for(var i:int = 0; i<str.length; i++)
			{
				var index:int = int(str.substr(i,1));
				bitmap = new Bitmap(frames[index]);
				bitmap.x = i * (bitmap.width - 3);
				this.addChild(bitmap);
			}
		}		
		
	}
}