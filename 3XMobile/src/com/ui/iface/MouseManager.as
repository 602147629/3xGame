package com.ui.iface
{
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.TouchEvent;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.ui.MouseCursorData;
    
    import framework.util.ResHandler;

    public class MouseManager extends Object
    {
		public static const CURSOR_KEY_ARROW:String = "arrow";
		public static const CURSOR_KEY_FINGER:String = "finger";
		public static const CURSOR_KEY_MAGICWOOD:String = "magicwood";
		public static const CURSOR_KEY_FORCESWAP:String = "forceswap";
		public static const CURSOR_KEY_HUMMER:String = "hummer";
		
        private var _stage:Stage;
        private var _parent:DisplayObjectContainer;
        private var _update:Boolean = false;
		private static var _instance:MouseManager;
		
		private var _cursorType:String = MouseCursor.ARROW;

        public function MouseManager()
        {
            this._stage = GameEngine.getInstance().stage;
			this._stage.addEventListener(TouchEvent.TOUCH_OVER , this.__onMouseOver);
			this._stage.addEventListener(TouchEvent.TOUCH_OUT , this.__onMouseOut);
        }
		
		public static function get instance() : MouseManager
		{
			if ( _instance == null ) _instance = new MouseManager();
			return _instance;
		}
		
		public function initAfterLoad():void
		{
			__registerCursor(MouseCursor.ARROW , "bmd.cursor.arrow");
			__registerCursor(MouseCursor.BUTTON , "bmd.cursor.finger");
			__registerCursor(MouseManager.CURSOR_KEY_HUMMER , "bmd.cursor.hummer");
			__registerCursor(MouseManager.CURSOR_KEY_MAGICWOOD , "bmd.cursor.magicwood");
			__registerCursor(MouseManager.CURSOR_KEY_FORCESWAP , "bmd.cursor.forceswap");
			
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		private function __registerCursor(key:String , clsKey:String):void
		{
			var cls:Class = ResHandler.getClass(clsKey);
			var mouseData:MouseCursorData = new MouseCursorData();
			var v:Vector.<BitmapData> = new Vector.<BitmapData>();
			v.push(new cls());
			mouseData.data = v;
			mouseData.frameRate = 1;
			Mouse.registerCursor(key , mouseData);
		}
		
		protected function __onMouseOut(event:TouchEvent):void
		{
			mouseOut(event.target);
		}
		
		protected function __onMouseOver(event:TouchEvent):void
		{
			mouseOver(event.target);
		}
		
        public function get parent():DisplayObjectContainer
        {
            return this._parent || this._stage;
        }

        public function set parent(container:DisplayObjectContainer) : void
        {
            this._parent = container;
            return;
        }

        public function get update() : Boolean
        {
            return this._update;
        }

        public function set update(param1:Boolean) : void
        {
            this._update = param1;
            return;
        }

        private function hideCursor() : void
        {
			_cursorType = MouseCursor.AUTO;
            Mouse.cursor = MouseCursor.AUTO;
            Mouse.hide();
        }

        private function showCursor() : void
        {
			Mouse.show();
			Mouse.cursor = MouseCursor.AUTO;
        }
		
		public function setCursorByKey(key:String , lock:Boolean = false):void
		{
			Mouse.cursor = key;
		}

		public function removeCursorByKey(key:String, usePre:Boolean = false) : void
		{
			Mouse.cursor = MouseCursor.ARROW;
			_cursorType = Mouse.cursor;
		}

        public function mouseOver(param1:Object) : void
        {
			//如果当前正在使用特别的手势
			if(_cursorType == "special")
			{
				return;
			}
			
			if(param1 is SimpleButton)
			{
				__useButtonCursor();
			}
			
			if((param1 is Sprite) &&(param1 as Sprite).buttonMode)
			{
				__useButtonCursor(); 
			}
        }
		
		private function __useButtonCursor():void
		{
			Mouse.cursor = MouseCursor.BUTTON;
		}
		
		private function __useDefaultCursor():void
		{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		public function useSpecialCursor(key:String):void
		{
			this.setCursorByKey(key);
			_cursorType = "special";
		}

        public function mouseOut(param1:Object) : void
        {
            if (Mouse.cursor == MouseCursor.BUTTON)
            {
				__useDefaultCursor();
            }
        }
    }
}
