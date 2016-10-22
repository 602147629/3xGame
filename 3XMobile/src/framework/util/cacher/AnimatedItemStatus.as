package framework.util.cacher
{
	public class AnimatedItemStatus
	{
		public static const APPLY_TO_ALL_ITEM:String = "APPLY_TO_ALL_ITEM";
		
		private var _targetName:String;
		
		private var _visible:Boolean = false;
		private var _playing:Boolean = false;
		private var _gotoAndStopFrame:int = -1;
		
		private var _dirtyVisible:Boolean = false;
		private var _dirtyPlaying:Boolean = false;
		private var _dirtyGoToStop:Boolean = false;
		
		public function AnimatedItemStatus(name:String)
		{
			_targetName = name;
		}
		
		public function canApplyToItem(name:String):Boolean
		{
			return _targetName == APPLY_TO_ALL_ITEM || _targetName == name;
		}
		
		public function get dirtyVisible():Boolean
		{
			return _dirtyVisible;
		}
		
		public function get dirtyPlaying():Boolean
		{
			return _dirtyPlaying;
		}
		
		public function get dirtyGoToStop():Boolean
		{
			return _dirtyGoToStop;
		}
		
		public function get targetName():String
		{
			return _targetName; 
		}
		
		public function get gotoAndStopFrame():int
		{
			return _gotoAndStopFrame;
		}
		
		public function set gotoAndStopFrame(frame:int):void
		{
			 _gotoAndStopFrame = frame;
			 _dirtyGoToStop = true;
			 
			 playing = false;
		}
		
		public function get visible():Boolean
		{
			return _visible;
		}

		public function set visible(value:Boolean):void
		{
			_visible = value;
			_dirtyVisible = true;
		}

		public function get playing():Boolean
		{
			return _playing;
		}

		public function set playing(value:Boolean):void
		{
			_playing = value;
			_dirtyPlaying = true;
		}


	}
}