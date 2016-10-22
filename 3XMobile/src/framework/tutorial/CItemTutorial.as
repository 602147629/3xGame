package framework.tutorial
{
	import com.game.event.GameEvent;
	import com.greensock.TweenLite;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemAbstract;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.resource.faxb.tutorial.Panel;
	
	public class CItemTutorial extends CItemAbstract
	{
		public function CItemTutorial(id:String, drawCompleteCallback:Function=null)
		{
			super(id, drawCompleteCallback);
		}
		
		public function showContent(d:Panel):void
		{
			var dx:int = d.x;
			var filp:int = int(d.filp);
			this.x = dx - 100;
			this.y = d.y;
			
			switch(id)
			{
				case "tutorial.txtFrame":
					dx = d.x;
					if(filp == 1)
					{
						this.x = dx - 100;
					}else
					{
						this.x = dx + 100;
					}
					__drawTxtFrame(d);
					break;
				case "tutorial.girlFrame":
					if(filp == 1)
					{
						this.scaleX = -1;
						
						dx = d.x + mc.width;
						this.x = dx + 100;
					}
					break;
			}
			
			TweenLite.to(this, 0.3, {x : dx});
		}
		
		private function __drawTxtFrame(d:Panel):void
		{
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass("bmd.txtFrame" , 
				new Rectangle(90 , 56 , 10 , 10) , 
				new Point(d.width , d.height));
			
			mc.addChild(bg);
			
			var tf:TextField = CFontUtil.getTextField(CFontUtil.getTextFormat(14, 0, false, "left"));
			tf.width = d.width - 40;
			tf.wordWrap = true;
			tf.multiline = true;
			tf.x = tf.y = 20;
			tf.htmlText = d.desc;
			mc.addChild(tf);
			
			if(d.showConfirmButton == "true")
			{
				var confirmBtn:CButtonCommon = new CButtonCommon("greenshort" , "确定");
				confirmBtn.x = d.width - confirmBtn.width >> 1;
				confirmBtn.y = d.height - confirmBtn.height / 2;
				mc.addChild(confirmBtn);
				
				confirmBtn.addEventListener(TouchEvent.TOUCH_TAP, function():void
				{
					CBaseUtil.sendEvent(GameEvent.EVENT_TUTORIAL_CONFIRM,d)
				});
			}
		}	
		
	}
}