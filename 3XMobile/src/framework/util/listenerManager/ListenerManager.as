package framework.util.listenerManager
{
	import framework.util.listenerManager.ListenerStruct;
	
	import flash.events.EventDispatcher;

	public class ListenerManager
	{
		private var _listeners : Vector.<ListenerStruct> = new Vector.<ListenerStruct>();
		
		public function ListenerManager()
		{
		}

		public function addListener(dispatcher : EventDispatcher, type : String, listener : Function, priority : int = 0) : void
		{
//			ClickEventListenerProxy.stopEventListener(dispatcher, type, listener);
			ClickEventListenerProxy.preEventListener(dispatcher, type, listener);
			var struct : ListenerStruct = new ListenerStruct(dispatcher, type, listener, priority);
			_listeners.push(struct);
//			ClickEventListenerProxy.afterEventListener(dispatcher,type,listener);
		}

		public function removeListener(dispatcher : EventDispatcher, type : String, listener : Function):int
		{
			var count:int=0;
			for (var i : int = 0; i < _listeners.length; ++i)
			{
				var struct : ListenerStruct = _listeners[i];
				if(struct.equal(dispatcher,type,listener))
				{
					struct.free();
					_listeners.splice(i--, 1);
					++count;
				}
			}
			return count;
		}

		public function freeAll() : void
		{
			for each(var struct : ListenerStruct in _listeners)
			{
				struct.free();
			}
			_listeners = new Vector.<ListenerStruct>();
		}
		
		public function freeListeners(dispatcher : EventDispatcher) : void
		{
			for (var i : int = _listeners.length - 1; i >= 0 ; i --)
			{
				var struct : ListenerStruct = _listeners[i];
				if(struct.dispatcher == dispatcher)
				{
					struct.free();
					_listeners.splice(i--, 1);
				}
			}
		}
	}
}
