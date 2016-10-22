package com.game.manager.timerManage
{
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	

	/**
	 * 
	 * @author  
	 * 
	 */	
	public class TimerManagerImpl implements ITimerManagerImpl {
		
		private var _started:Boolean = false;
		private var _beginTimeMs:Number = 0;
		private var _globalTimer:Timer;
		private var _pollEventHandlers:Array = [];
		private var _timeEventHandlers:Array = [];
		
		public function TimerManagerImpl() {
			this.init();
		}
		private function init():void{
			_beginTimeMs = 0;
			_globalTimer = new Timer( 100 );
			_globalTimer.addEventListener( TimerEvent.TIMER, timerEventHandler );
			_globalTimer.start();
			_started = true;
		}
		
		/**
		 * @param interval
		 * @param method
		 * @param context
		 */		
		public function regPollEventHandler( interval:Number, 
									  method:Function,
									  context:Object ):void{
			var o:TimeInfo = new TimeInfo();
			o.rcTimeMs = currentTimeMs;
			o.acTimeMs = interval;
			o.method = method;
			o.context = context;
			_pollEventHandlers.push( o );
		}
		
		/**
		 * @param timeMs
		 * @param method
		 * @param context
		 */		
		public function regTimeEventHandler( timeMs:Number,
											 method:Function,
											 context:Object ):void{
			var o:TimeInfo = new TimeInfo();
			o.rcTimeMs = currentTimeMs;
			o.acTimeMs = timeMs;
			o.method = method;
			o.context = context;
			_timeEventHandlers.push( o );
		}
		
		/**
		 * @param event
		 */		
		private function timerEventHandler( event:TimerEvent ):void{
			var cms:Number = currentTimeMs;
			var t:TimeInfo;
			var i:int = 0;
			//var l:int = 0;
			//这里的数组长度是变的，有可能在遍历时 _pollEventHandlers的长度变了？
			for ( i = 0; i < _pollEventHandlers.length; i++ ){
				t = _pollEventHandlers[i];
				if( cms - t.rcTimeMs >= t.acTimeMs ){
					t.action();
					t.rcTimeMs = cms;
				}
			}
			for ( i = 0 ; i <_timeEventHandlers.length; i++ ){
				t = _timeEventHandlers[i];
				if( t.acTimeMs <= cms ){
					t.action();
					_timeEventHandlers.splice(i, 1);
					t.method = null;
					t.context = null;
					t = null;
				}
			}
		}
		
		/**
		 * @param timeMs
		 * @param method
		 * @param context
		 * @return 
		 */		
		public function unregTimeEventHandler( timeMs:Number,
											   method:Function,
											   context:Object ):Boolean{
			var t:TimeInfo;
			for ( var i:int = 0,l:int = _timeEventHandlers.length; i < l; i++ ){
				t = _timeEventHandlers[i];
				if( t.method == method ){
					if( t.context == context ){
						if( t.acTimeMs == timeMs ){
							_timeEventHandlers.splice(i, 1);
							t.method = null;
							t.context = null;
							t = null;
							return true;
						}
					}
				}
			}
			trace("没找到可删除的EventHandler");
			return false;
		}
		
		/**
		 * @param interval
		 * @param method
		 * @param context
		 * @return 
		 */		
		public function unregPollEventHandler( interval:Number,
											   method:Function,
											   context:Object ):Boolean{
			var t:TimeInfo;
			for ( var i:int = 0,l:int = _pollEventHandlers.length; i < l; i++ ){
				t = _pollEventHandlers[i];
				if( t.method == method ){
					if( t.context == context ){
						if( t.acTimeMs == interval ){
							_pollEventHandlers.splice(i, 1);
							t.method = null;
							t.context = null;
							t = null;
							return true;
						}
					}
				}
			}
			trace("没找到可删除的PollEventHandler");
			return false;
		}
		
		/**
		 * @return 
		 */
		public function get beginTimeMs():Number {
			return _beginTimeMs;
		}
		
		/**
		 * @return 
		 */		
		public function get currentTimeMs():Number{
			return beginTimeMs + getTimer();
		}
	}
}

internal class TimeInfo{
	public var rcTimeMs:Number;
	public var acTimeMs:Number;
	public var method:Function;
	public var context:Object;
	
	public function action():void{
		if( method != null ){
			if( context != null ){
				method.call( context );
			}
		}
	}
}
