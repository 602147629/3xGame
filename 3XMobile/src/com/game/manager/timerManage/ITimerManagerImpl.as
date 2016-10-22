package com.game.manager.timerManage{
	import flash.events.TimerEvent;

	public interface ITimerManagerImpl {
		function regPollEventHandler(interval : Number, method : Function, context : Object) : void;
		function regTimeEventHandler(timeMs : Number, method : Function, context : Object) : void;
		function unregTimeEventHandler(timeMs : Number, method : Function, context : Object) : Boolean;
		function unregPollEventHandler(interval : Number, method : Function, context : Object) : Boolean;
		function get beginTimeMs() : Number;
		function get currentTimeMs() : Number;
	}
}