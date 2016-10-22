package framework.view.animation
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	import framework.resource.ResourceManager;
	import framework.resource.faxb.animation.Action;
	import framework.resource.faxb.animation.Animation;
	import framework.resource.faxb.animation.Frame;
	import framework.util.cacher.CachePlaceholder;

	public class ActionCache
	{
		public var frames:Vector.<FrameCache>;
		public var name:String;
		public var totalFrame:int;
		private var _swfId:String;
		private var _mc:DisplayObjectContainer;
		private var _loadSwfComplete:Function;
		private var _currentFrame:int;
		
		
		public function ActionCache(actionData:Action, animation:Animation, loadSwfComplete:Function = null, swfId:String = null)
		{
			name = actionData.name;
			_loadSwfComplete = loadSwfComplete;
			
			if(loadSwfComplete != null)
			{
				_swfId = swfId;
				
				_mc = ResourceManager.getInstance().getResource(_swfId).getContent("1",loadSwfAnimationComplete) as DisplayObjectContainer;
			}
			else
			{				
				frames = new Vector.<FrameCache>();
				
				totalFrame = actionData.frame.length;
				initFrames(actionData, animation);
			}
		}
		
		private function loadSwfAnimationComplete(mc:MovieClip):void
		{
			_loadSwfComplete(mc, name);
			if(_currentFrame > 0)
			{
				gotoAndPlay(_currentFrame);
				
				_currentFrame = 0;
			}
		}
		
		public function gotoAndPlay(frame:int = 1):void
		{
			if(_mc is CachePlaceholder)
			{
				var child:DisplayObject = _mc.getChildAt(0);
				if(child is MovieClip)
				{
					(child as MovieClip).gotoAndPlay(frame);
				}
				else
				{
					_currentFrame = frame;
				}
			}
			else if(_mc is MovieClip)
			{
				(_mc as MovieClip).gotoAndPlay(frame);
			}
		}
		
		public function gotoAndStop(frame:int = 1):void
		{
			if(_mc is CachePlaceholder)
			{
				var child:DisplayObject = _mc.getChildAt(0);
				if(child is MovieClip)
				{
					(child as MovieClip).gotoAndStop(frame);
				}
			}
			else if(_mc is MovieClip)
			{
				(_mc as MovieClip).gotoAndStop(frame);
			}
		}
		
		private function initFrames(actionData:Action, animation:Animation):void
		{
			for each(var frameData:Frame in actionData.frame)
			{
				frames.push(new FrameCache(frameData, animation));
			}
		}
		
		public function getFrame(frame:int):FrameCache
		{
			return frames[frame - 1];
		}
		
		public function getMc():DisplayObjectContainer
		{
			
			return _mc;
		}
	}
}