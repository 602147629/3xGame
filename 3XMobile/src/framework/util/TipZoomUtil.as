package framework.util
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public class TipZoomUtil
	{
		private var activedTips:Dictionary = new Dictionary(true);
//		private var nextTickTime:Number = -1;
		private var lastCameraScale:Number = -1;

		private static var _instance:TipZoomUtil;

		public function TipZoomUtil()
		{
//			TickHandler.getInstance().addToTickQueue(this);
//			getNextTickTime();
		}

//		private function getNextTickTime():void
//		{
//			nextTickTime = getTimer() + 100;
//		}

		public static function getInstance():TipZoomUtil
		{
			if(_instance == null)
			{
				_instance = new TipZoomUtil();
			}
			return _instance;
		}


		public function correctScale():void
		{
			CONFIG::debug
			{
				var currentScale:Number = ZoomHandle.getGameScale();
				ASSERT(currentScale != lastCameraScale);
				lastCameraScale = currentScale;
			}
//			var cameraDirty:Boolean = updateCameraScaleDirty();

			for(var key:Object in activedTips)
			{
				var tip:DisplayObject = key as DisplayObject;
				fixScale(tip);
			}

		}

		
		private function fixScale(tip:DisplayObject):void
		{
		}

		public function addTip(tip:DisplayObject):void
		{
			CONFIG::debug
			{
				ASSERT(activedTips[tip] == null);
				ASSERT(tip != null);
			}

			activedTips[tip] = new Object();
			fixScale(tip);
		}

		public function removeTip(tip:DisplayObject):void
		{
			CONFIG::debug
			{
				ASSERT(activedTips[tip] != null);
			}

			delete activedTips[tip];
		}


	}
}