package framework.util.listenerManager
{
	import flash.events.EventDispatcher;
	
	
	public class ListenerStruct
	{
		private var _dispatcher : EventDispatcher;
		private var _eventType : String;
		private var _listener : Function;
		
		public function ListenerStruct(dispatcher : EventDispatcher, type : String, listener : Function, priority : int)
		{
			this._dispatcher = dispatcher;
			this._eventType = type;
			this._listener = listener;
			dispatcher.addEventListener(type, listener, false, priority, false);
			//o.addEventListener(e, onEvent, false, p, false);
		}
		
		public function free() : void
		{
			_dispatcher.removeEventListener(_eventType, _listener, false);
			
			ClickEventListenerProxy.free(_dispatcher,_eventType)
			
			this._dispatcher = null;
			this._eventType = null;
			this._listener = null;
		}
		/*
		public function onEvent(e:Event):void
		{
		if(e.type==TouchEvent.TOUCH_TAP)
		{
		SoundHandler.instance.play(SoundList.EFFECT_CLICK,SoundElement.TYPE_SOUND);
		}
		f(e);
		}*/
		
		public function equal(dispatcher : EventDispatcher, type : String, listener : Function):Boolean
		{
			return (dispatcher==this._dispatcher && type==this._eventType && listener==this._listener);
		}	

		public function get dispatcher():EventDispatcher
		{
			return _dispatcher;
		}

		
	}
}