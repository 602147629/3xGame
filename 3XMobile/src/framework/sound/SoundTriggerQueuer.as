package framework.sound
{	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import framework.types.SingletonBase;
	
	public class SoundTriggerQueuer extends SingletonBase
	{
		private var queuedFunctions : Dictionary;
		
		public function SoundTriggerQueuer()
		{
			queuedFunctions = new Dictionary();
		}
		
		public function queueFunctionCall(category : int, func : Function, delay : uint, ... args) : void
		{
			var timer : Timer = new Timer(delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			timer.start();
			
			queuedFunctions[timer] = [category, func, args];
		}
		
		private function onTimerComplete(event : TimerEvent) : void
		{
			var timer : Timer = event.target as Timer;
			var data : Array = getTriggerData(timer);
			var category : int = data[0] as int;
			var func : Function = data[1] as Function;
			var args : Array = data[2] as Array;
			
			func.apply(null, args);
			
			deleteQueuedTrigger(timer, func);
		}
		
		public function clearQueuedTriggersByCategory(targetCategory : int) : void
		{
			for (var key : Object in queuedFunctions)
			{
				var timer : Timer = key as Timer;
				var data : Array = getTriggerData(timer);
				var category : int = data[0] as int;
				
				if (category == targetCategory)
				{
					var func : Function = data[1] as Function;
					deleteQueuedTrigger(timer, func);
				}
			}
		}
		
		private function deleteQueuedTrigger(timer : Timer, func : Function) : void
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, func);
			delete queuedFunctions[timer];
		}
		
		private function getTriggerData(timer : Timer) : Array
		{
			return queuedFunctions[timer] as Array;
		}
		
		public static function get instance() : SoundTriggerQueuer
		{
			if (!SingletonBase.singletonExists(SoundTriggerQueuer))
			{
				new SoundTriggerQueuer();
			}
			
			return SingletonBase.getInstance(SoundTriggerQueuer);
		}
	}
}
