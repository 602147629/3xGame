package com.game.manager.timerManage
{
	/**
	 * 时钟计时管理 
	 * @author  
	 */	
	public class TimerManager {
		public function TimerManager()
		{
		}
		private static var _impl:ITimerManagerImpl;
		
		/**
		 * @return 
		 */		
		public static function get currentTimeMs():Number{
			return _impl.currentTimeMs;
		}

		public static function set impl(i : ITimerManagerImpl) : void {
			_impl = i;
		}
		
		/**
		 * @param interval
		 * @param method
		 * @param context
		 */		
		public static function regPollEventHandler( interval:Number, 
													method:Function,
													context:Object ):void{
			_impl.regPollEventHandler( interval, method, context );
		}
		
		/**
		 * @param timeMs
		 * @param method
		 * @param context
		 */		
		public static function regTimeEventHandler( timeMs:Number,
													method:Function,
													context:Object ):void{
			_impl.regTimeEventHandler( timeMs, method, context );
		}
		
		/**
		 * @param timeMs
		 * @param method
		 * @param context
		 * @return 
		 */		
		public static function unregTimeEventHandler( timeMs:Number,
													  method:Function,
													  context:Object ):Boolean{
			return _impl.unregTimeEventHandler( timeMs, method, context );
		}
		
		/**
		 * @param interval
		 * @param method
		 * @param context
		 * @return 
		 */		
		public static function unregPollEventHandler( interval:Number,
													  method:Function,
													  context:Object ):Boolean{
			return _impl.unregPollEventHandler( interval, method, context );
		}
	}
}