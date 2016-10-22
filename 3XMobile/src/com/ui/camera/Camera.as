package com.ui.camera
{
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	
	/**
	 * @author caihua
	 * @comment 摄像机
	 * 创建时间：2014-6-8 上午9:10:01 
	 */
	public class Camera extends Sprite
	{
		private var _target:Sprite;
		private const MAX_X:Number = 1024;
		private var _isDragging:Boolean = false;
		
		public function Camera(mc:Sprite)
		{
			super();
			
			_target = mc;
			
//			addChild(_target);
		}
		
		public function start():void
		{
			addEventListener(TouchEvent.TOUCH_BEGIN , __onMouseDown , false, 0 ,true);
			addEventListener(TouchEvent.TOUCH_END , __onMouseUp , false, 0 ,true);
			addEventListener(TouchEvent.TOUCH_MOVE , __onMouseMove , false, 0 ,true);
		}
		
		protected function __onMouseMove(event:TouchEvent):void
		{
			if(_isDragging)
			{
				trace("111111111111");
			}
		}
		
		public function stop():void
		{
			removeEventListener(TouchEvent.TOUCH_BEGIN , __onMouseDown);
			removeEventListener(TouchEvent.TOUCH_END , __onMouseUp);
		}
		
		protected function __onMouseUp(event:TouchEvent):void
		{
			_target.stopDrag();
			_isDragging = false
		}
		
		protected function __onMouseDown(event:TouchEvent):void
		{
			_target.startDrag();
			_isDragging = true;
		}

		override public function get x():Number
		{
			return _target.x;
		}

		override public function set x(value:Number):void
		{
			_target.x = value;
		}

	}
}