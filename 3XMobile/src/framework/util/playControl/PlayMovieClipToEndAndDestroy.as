package framework.util.playControl
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import framework.core.tick.GlobalTicker;
	import framework.util.DisplayUtil;
	
	public class PlayMovieClipToEndAndDestroy
	{
		private var target:MovieClip;
		private var callBack:Function;
		private var totalFrames:int;
		private var isRemoved:Boolean;
		private var updateFunction:Function;
		private var _isHasDestoryed:Boolean;
		
		private var _isDestoryMc:Boolean;
		public function PlayMovieClipToEndAndDestroy(target:MovieClip, callBack:Function = null, isRemoved:Boolean = true, updateFunction:Function = null, isDestoryMc:Boolean = false)
		{
			
			this.target = target;
			this.callBack = callBack;
			this.updateFunction = updateFunction;
			
			totalFrames = target.totalFrames;
			
			GlobalTicker.add(target, lsnEvent);
			
			this.isRemoved = isRemoved;
			
			_isDestoryMc = isDestoryMc;
		}
		
		private function lsnEvent(e:Event):void
		{
			if(updateFunction != null)
			{
				updateFunction(target);
			}
			
			if(_isDestoryMc)
			{
				if(target.currentFrame == 9)
				{
					if(callBack != null)
					{
						callBack(target);
						callBack = null;
						updateFunction = null;
					}
				}
			}
			
			if(target.currentFrame == totalFrames)
			{
				if(callBack != null)
				{
					callBack(target);
					callBack = null;
					updateFunction = null;
				}
							
				if(isRemoved)
				{					
					DisplayUtil.stopAllAnim(target);
					DisplayUtil.removeFromDisplayTree(target);
					target.visible = false;
				}

				GlobalTicker.remove(target);
				target = null;
				
			}
		}
	}
}