package com.ui.item
{
	import com.ui.util.CFontUtil;
	import com.ui.util.CStringUtil;
	import com.ui.util.CTimer;
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	
	import framework.util.ResHandler;

	/**
	 * @author caihua
	 * @comment 倒计时控件
	 * 创建时间：2014-7-4 下午12:11:15 
	 */
	public class CItemTimer extends CItemAbstract
	{
		private var _timer:CTimer;
		private var _callbackOnComplete:Function;
		private var _callbackPerSeconds:Function;
		private var _seconds:int = 0;
		
		private var _loopSeconds:int = 0;
		
		private var _loop:Boolean = false;
		
		private var _tf:TextField;
		
		private var _color:uint = 0x00;
		
		private var _bg:Bitmap;
		
		public function CItemTimer(seconds:int = 0 , callbackOnComplete:Function = null , callbackPerSeconds:Function = null , loop:Boolean = false ,color:uint = 0xffffff)
		{
			_loopSeconds = _seconds = seconds;
			_callbackOnComplete = callbackOnComplete;
			_callbackPerSeconds = callbackPerSeconds;
			
			_loop = loop;
			
			_timer = new CTimer();
			
			if(_loop)
			{
				_timer.addCallback(__onTime , 1 );
			}
			else
			{
				_timer.addCallback(__onTime , 1 , 1);
			}
			
			_color = color;
			
			super("");
		}
		
		override protected function drawContent():void
		{
			var cls:Class = ResHandler.getClass("bmd.common.cooldownbg");
			_bg = new Bitmap(new cls());
			this.addChild(_bg);
			
			_tf = CFontUtil.textFieldMiddle;
			_tf.textColor = _color;
			_tf.width = 60;
			_tf.height = 25;
			this.addChild(_tf);
			_tf.x = (_bg.width - _tf.width)/2;
			
			_timer.start();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		private function __onTime():void
		{
			_tf.text = CStringUtil.s2ms(_seconds);
			
			if(_callbackPerSeconds != null)
			{
				_callbackPerSeconds();
			}
			
			//仅仅调用一次
			if(_seconds-- == 0)
			{
				_callbackOnComplete();
				if(_loop && _loopSeconds > 0)
				{
					_seconds = _loopSeconds;
				}
				else
				{
					_timer.delCallback(__onTime);
				}
			}
		}
		
		override protected function dispose():void
		{
			_timer.delCallback(__onTime);
		}

		public function get seconds():int
		{
			return _seconds;
		}

		public function set seconds(value:int):void
		{
			if(value == 0)
			{
				_timer.delCallback(__onTime);
			}
			_loopSeconds = _seconds = value;
		}
		
		public function showBg(b:Boolean):void
		{
			_bg.visible = b;	
		}
	}
}