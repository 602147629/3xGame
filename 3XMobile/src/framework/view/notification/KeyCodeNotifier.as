package framework.view.notification
{
	import flash.events.*;
	
	/**
	 *  键盘通知 
	 * @author sunxiaobin
	 * 
	 */
	public class KeyCodeNotifier extends Object
	{
		private var _keyCodes:Array;
		private var _callback:Function;
		
		public function KeyCodeNotifier(keyCodes:Array, callback:Function)
		{
			this._keyCodes = keyCodes;
			this._callback = callback;
		}
		
		public function notify(event:KeyboardEvent) : void
		{
			var index:int = 0;
			while (index < this._keyCodes.length)
			{
				
				if (this._keyCodes[index] == event.keyCode)
				{
					this._callback.apply(null, [event, this._keyCodes[index]]);
					break;
				}
				index++;
			}
		}
	}
}