package framework.util.playControl
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import framework.core.tick.GlobalTicker;
	
	public class ListenMovieClipToEnd
	{
		private var target:MovieClip;
		private var callBack:Function;
		private var totalFrames:int;
		
		public function ListenMovieClipToEnd(target:MovieClip, callBack:Function)
		{
			this.target = target;
			this.callBack = callBack;
			
			totalFrames = target.totalFrames;
			
			GlobalTicker.add(target, lsnEvent);
			//target.addFrameScript(target.totalFrames - 1, lsnEvent);
		}
		
		private function lsnEvent(e:Event):void
		{
			
			if(target.currentFrame == totalFrames)
			{
				if(callBack != null)
				{
					callBack(target);
					callBack = null;
				}
				
				GlobalTicker.remove(target);
				target = null;
				
			}
		}
		
	}
}


