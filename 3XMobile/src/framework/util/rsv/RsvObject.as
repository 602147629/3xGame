package framework.util.rsv
{
	import flash.events.EventDispatcher;
	
	/**
	 * comments by Ding Ning
	 * in construction function, it register it self to Rsv instance pool
	 */
	
	public class RsvObject// extends EventDispatcher
	{
		private var _id:String;
		protected var _cb:Function;
		
		public function RsvObject(id:String=null, autoRegist:Boolean=true)
		{
			this.id = id;
			if(autoRegist && _id != null)
				regist();
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(s:String):void
		{
			_id = s;
		}
		
		private function regist():Object
		{
			CONFIG::debug
			{
				ASSERT(Rsv.geto_s(_id) == null, "ASSERT");
			}
			return Rsv.add_s(_id, this);
//			return foceReplace ? Rsv.addow_s(_id, this) : Rsv.add_s(_id, this);
		}
		
		public function get isRegisted():Boolean
		{
			return Rsv.geto_s(_id) == this;
		}
		
		public function destroy():void
		{
			// override this function
			clearProp("_cb");
		}
		
		protected function sendCallBack(itype:int):void
		{
//			dispatchEvent(new RsvEvent(itype, this, null));
			if(_cb != null)
				_cb(new RsvEvent(itype, this, null));
		}
		
		protected function clearProp(s:String, call:String=null):void
		{
			if(this[s] != null)
			{
				if(call != null && this[s].hasOwnProperty(call))
					this[s][call]();
				this[s] = null;
			}
		}

	}
}