package framework.util.cacher
{
	import flash.display.MovieClip;

	public class AnimatedItem
	{
		private var _name:String;
		private var _item:MovieClip;
		
		public function AnimatedItem(name:String, item:MovieClip)
		{
			this._name = name;
			this._item = item;
		}

		public function get name():String
		{
			return _name;
		}

		public function get movieclip():MovieClip
		{
			return _item;
		}

		public function hide():void
		{
			_item.stop();
			_item.visible = false;
		}
		
		public function show():void
		{
			_item.play();
			_item.visible = true;
		}
		
	}
}