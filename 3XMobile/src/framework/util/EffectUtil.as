package framework.util
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	import flash.display.Sprite;
	
	import framework.util.geom.Vec;
	import framework.view.ConstantLayer;

	public class EffectUtil
	{
		public function EffectUtil()
		{
		}
		
		public static function shakeScreen(time:int,force:Number = 10,isToWeak:Boolean = false):void
		{
			var layer:Sprite = GameEngine.getInstance().getLayer(ConstantLayer.LAYER_CORE);
			
			var v:Vec = new Vec(force,0);
			
			var myTimeline:TimelineLite = new TimelineLite();
			
			for(var i:int = 0 ; i < time ; i += 200)
			{
				v.rotate(Math.PI * 2 * Math.random());
				myTimeline.append(new TweenLite(layer,0.1,{x:v.xV,y:v.yV,ease:Bounce.easeIn}));
				myTimeline.append(new TweenLite(layer,0.1,{x:0,y:0,ease:Bounce.easeIn}));
				
				if(isToWeak)
				{
					v.scale(0.8);
				}
			}
			myTimeline.play();
			
		}
	}
}