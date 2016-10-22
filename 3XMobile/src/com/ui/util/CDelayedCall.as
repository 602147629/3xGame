package com.ui.util
{
	/**
	 * @author caihua
	 * @comment 延迟执行类
	 * 创建时间：2014-9-11 下午2:26:47 
	 */
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CDelayedCall extends EventDispatcher
	{
		private var _f:Function;
		private var _delayTime:Number = 0.3;
		private var _repeateCount:int = 1;
		private var _callback:Function = null;

		private var _t:Timer;
		
		public function CDelayedCall(f:Function , delayTime:Number = 0.3 , repeatCount:int = 1 ,callback:Function = null)
		{
			_f = f;
			_delayTime = delayTime;
			_repeateCount = repeatCount;
			_callback = callback;
			
			_t = new Timer(_delayTime * 1000 , _repeateCount);
			_t.addEventListener(TimerEvent.TIMER , function():void{
				_f();
				if(--_repeateCount <= 0)
				{
					if(_callback != null)
					{
						trace("  _callback "  );
						
						_callback();
					}
				}
			});
			
			super();
		}
		
		public function start():void
		{
			_t.start();
		}
	}
}