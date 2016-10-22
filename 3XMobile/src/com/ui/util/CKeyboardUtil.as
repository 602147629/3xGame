package com.ui.util
{
    import flash.events.KeyboardEvent;
    import flash.text.TextField;
    
    import framework.view.notification.KeyCodeNotifier;
    import framework.view.notification.KeyNotifier;

	/**
	 *  键盘管理 
	 * @author sunxiaobin
	 * 
	 */	
    public class CKeyboardUtil extends Object
    {
        public static var KEY_DOWN:String = "keyDown";
        public static var KEY_UP:String = "keyUp";
        private static var _keyNotifiers:Vector.<KeyNotifier>;
        private static var _keyCodeNotifiers:Vector.<KeyCodeNotifier>;

        public function CKeyboardUtil()
        {
            return;
        }

        public static function init() : void
        {
            _keyNotifiers = new Vector.<KeyNotifier>;
            _keyCodeNotifiers = new Vector.<KeyCodeNotifier>;
			
            GameEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			GameEngine.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
        }
		
        public static function setKeyDown(keys:String, callback:Function) : void
        {
            var keyNotifier:KeyNotifier = findKeyNotifier(keys, callback);
            if (keyNotifier == null)
            {
                _keyNotifiers.push(new KeyNotifier(keys, callback));
            }
            else
            {
				keyNotifier.disabled = false;
            }
        }

		/**
		 *  废除键盘注册 
		 * @param keys
		 * @param callback
		 * 
		 */		
        public static function disabledKeyDown(keys:String, callback:Function) : void
        {
            var keyNotifier:KeyNotifier = findKeyNotifier(keys, callback);
            if (keyNotifier != null)
            {
				keyNotifier.disabled = true;
            }
        }

        public static function findKeyNotifier(keys:String, callback:Function) : KeyNotifier
        {
            var keyNotifier:KeyNotifier;
            for each (keyNotifier in _keyNotifiers)
            {
                if (keyNotifier.keys == keys && keyNotifier.callback == callback)
                {
                    return keyNotifier;
                }
            }
            return null;
        }

        public static function setkeyCodeDownUp(keycodes:Array, callback:Function) : void
        {
            _keyCodeNotifiers.push(new KeyCodeNotifier(keycodes, callback));
        }

        public static function focusStage() : void
        {
			GameEngine.getInstance().stage.focus = GameEngine.getInstance().stage;
        }

        private static function checkEnabled() : Boolean
        {
            var child:* = GameEngine.getInstance().stage.focus;
            if (child != null && child is TextField && (child as TextField).type == "input")
            {
                return false;
            }
            return true;
        }

        private static function keyDown(event:KeyboardEvent) : void
        {
            var keyNotifier:KeyNotifier;
            var keyCodeNotifier:KeyCodeNotifier;
			
            if (!checkEnabled())
            {
                return;
            }
            for each (keyNotifier in _keyNotifiers)
            {
                if (!keyNotifier.disabled)
                {
					keyNotifier.notify(event);
                }
            }
            for each (keyCodeNotifier in _keyCodeNotifiers)
            {
				keyCodeNotifier.notify(event);
            }
        }

        private static function keyUp(event:KeyboardEvent) : void
        {
            var keyCodeNotifier:KeyCodeNotifier;
            if (!checkEnabled())
            {
                return;
            }
            for each (keyCodeNotifier in _keyCodeNotifiers)
            {
				keyCodeNotifier.notify(event);
            }
        }

    }
}
