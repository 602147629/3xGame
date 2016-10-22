package com.ui.item
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	
	import framework.util.ResHandler;

	/**
	 * @author caihua
	 * @comment 倒计时321 go
	 * 创建时间：2014-7-21 下午3:19:51 
	 */
	public class CItem321Go extends CItemAbstract
	{
		private var img1:Bitmap;

		private var img2:Bitmap;

		private var img3:Bitmap;

		private var imgGo:Bitmap;
		
		private var _callback:Function;
		
		public function CItem321Go()
		{
			super("");
		}
		
		override protected function drawContent():void
		{
			var img1Cls:Class = ResHandler.getClass("bmd.digital.1");
			var img2Cls:Class = ResHandler.getClass("bmd.digital.2");
			var img3Cls:Class = ResHandler.getClass("bmd.digital.3");
			var imgGoCls:Class = ResHandler.getClass("bmd.digital.go");
			img1 = new Bitmap(new img1Cls());
			img1.visible = false;
			
			img2 = new Bitmap(new img2Cls());
			img2.visible = false;
			
			img3 = new Bitmap(new img3Cls());
			
			imgGo = new Bitmap(new imgGoCls());
			imgGo.visible = false;
			
			this.addChild(img1);
			this.addChild(img2);
			this.addChild(img3);
			this.addChild(imgGo);
			
			img1.x = (this.width - img1.width)/2;
			img1.y = (this.height - img1.height)/2;
			
			img2.x = (this.width - img2.width)/2;
			img2.y = (this.height - img2.height)/2;
			
			img3.x = (this.width - img3.width)/2;
			img3.y = (this.height - img3.height)/2;
	
			imgGo.x = (this.width - imgGo.width)/2;
			imgGo.y = (this.height - imgGo.height)/2;
		}
		
		public function play(callBack:Function = null):void
		{
			_callback = callBack;
			__show3();
		}
		
		private function __show3():void
		{
			TweenLite.to(img3 , 0.5 , {onComplete:__hide3});
		}
		
		private function __hide3():void
		{
			TweenLite.to(img3 , 0.5 , { onComplete:__show2});
		}
		
		private function __show2():void
		{
			img3.visible = false;
			img2.visible = true;
			TweenLite.to(img2 , 0.5 , {onComplete:__hide2});
		}
		
		private function __hide2():void
		{
			TweenLite.to(img2 , 0.5 , {onComplete:__show1});
		}
		
		private function __show1():void
		{
			img2.visible = false;
			img1.visible = true;
			TweenLite.to(img1 , 0.5 , {onComplete:__hide1});
		}
		
		private function __hide1():void
		{
			TweenLite.to(img1 , 0.5 , {onComplete:__showGo});
		}
		
		private function __showGo():void
		{
			img1.visible = false;
			imgGo.visible = true;
			TweenLite.to(imgGo , 0.5 , {onComplete:__hideGo});
		}
		
		private function __hideGo():void
		{
			TweenLite.to(imgGo , 0.5 , {onComplete:__callBack});
		}
		
		private function __callBack():void
		{
			imgGo.visible = false;
			if(_callback != null)
			{
				_callback();
			}
		}
	}
}