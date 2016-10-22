package com.game.event
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	/**
	 * ... 
	 * @author yangrui
	 */
	public class GameDispather extends EventDispatcher implements IEventDispatcher
	{
		
		public function GameDispather(targer:IEventDispatcher = null) 
		{
			super(targer);
		}
		
		private static var _instance:GameDispather;
		
		static public function get instance():GameDispather 
		{
			if (_instance == null) {
				_instance = new GameDispather();
			}
			return _instance;
		}
		
		
		public static function sendEvent(evtType:String, evtObj:Object = null):void
		{
			instance.dispatchEvent(new GameEvent(evtType, evtObj));
		}
		
		
		static public function listenEvent(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			instance.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		static public function removeEvent(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			instance.removeEventListener(type, listener, useCapture);
		}
	}
	
}