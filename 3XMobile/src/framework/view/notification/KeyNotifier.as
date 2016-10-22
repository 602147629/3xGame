package framework.view.notification
{
    import flash.events.*;

	/**
	 *  键盘通知 
	 * @author sunxiaobin
	 * 
	 */	
    public class KeyNotifier extends Object
    {
        private var _keys:String;
        private var _callback:Function;
        private var _disabled:Boolean;

        public function KeyNotifier(keys:String, callback:Function)
        {
            this._keys = keys;
            this._callback = callback;
        }

        public function notify(event:KeyboardEvent) : void
        {
            var index:int = 0;
            while (index < this._keys.length)
            {
                
                if (this._keys.charCodeAt(index) == event.charCode)
                {
                    this._callback.apply(null, [this._keys.charAt(index)]);
                    break;
                }
				index++;
            }
        }

        public function get keys() : String
        {
            return this._keys;
        }

        public function get callback() : Function
        {
            return this._callback;
        }

		/**
		 *  是否可以启动 
		 * @param disabled
		 * 
		 */		
        public function set disabled(disabled:Boolean) : void
        {
            this._disabled = disabled;
        }

        public function get disabled() : Boolean
        {
            return this._disabled;
        }

    }
}
