package framework.util
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.MovieClip;
	
	public class AnimUtility
	{

		public static function animPopUpSinglePanel(cc:MovieClip,motionEndCallBack:Function = null):void
		{
			cc.scaleX = 0.5;
			cc.scaleY = 0.5;
			TweenLite.to(cc,6,{scaleX: 1,scaleY :1,ease:Back.easeOut,onComplete:motionEndCallBack,useFrames:true});
		}
		
		public static function animPopUpMultiPanel(cc:MovieClip,motionEndCallBack:Function = null):void
		{
			TweenLite.to(cc,6,{x: 1,ease:Back.easeOut,onComplete:motionEndCallBack,useFrames:true});
		}
		
		public static function animPopDownMultiPanel(cc:MovieClip,motionEndCallBack:Function = null):void
		{
			cc.scaleX = 1;
			cc.scaleY = 1;
			TweenLite.to(cc,3,{scaleX: 0.3,scaleY :0.3,onComplete:motionEndCallBack,useFrames:true});
		}
		
		public static function animPopDownSinglePanel(cc:MovieClip,motionEndCallBack:Function = null):void
		{
			cc.scaleX = 1;
			cc.scaleY = 1;
			TweenLite.to(cc,3,{scaleX: 0.3,scaleY :0.3,onComplete:motionEndCallBack,useFrames:true});
		}
		
	}
}