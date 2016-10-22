package framework.resource
{
	import flash.display.Sprite;

	internal class InloadingThumbnail
	{
		private var _sprite:Sprite;
		private var _width:Number;
		private var _height:Number;
		private var _frame:String;
		private var _noNeedRefresh:Boolean;
		
		public function InloadingThumbnail(sprite:Sprite = null, width:Number = 1.0, height:Number = 1.0, frame:String = null, noNeedRefresh:Boolean = false)
		{
			_sprite = sprite;
			_width = width;
			_height = height;
			_frame = frame;
			_noNeedRefresh = noNeedRefresh;
		}

		public function get sprite():Sprite
		{
			return _sprite;
		}

		public function get width():Number
		{
			return _width;
		}

		public function get height():Number
		{
			return _height;
		}

		public function get frame():String
		{
			return _frame;
		}

		public function get noNeedRefresh():Boolean
		{
			return _noNeedRefresh;
		}
	}
}