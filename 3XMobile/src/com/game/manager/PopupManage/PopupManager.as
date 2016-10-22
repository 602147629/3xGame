package com.game.manager.PopupManage{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;


	/**
	 * 浮动窗口管理
	 *
	 */
	public class PopupManager {

		public function PopupManager() {
		}
		
		/**
		 * 实现类
		 */
		private static var _impl : IPopupManagerImpl;

		/**
		 * 添加浮动对象
		 * @param window
		 * @param toContainer
		 * @param center
		 * @param modal
		 * @param bgColor
		 * @param bgAlpha
		 * @return
		 */
		public static function addPopup(window : DisplayObject,
			toContainer : DisplayObjectContainer = null,
			center : Boolean = true,
			modal : Boolean = true,
			ease : Boolean = true,
			bgColor : int = 0x000000,
			bgAlpha : Number = 0.6) : DisplayObject {
			_impl.addPopup(window, toContainer, ease, center, modal, bgColor, bgAlpha);
			return window;
		}

		/**
		 * 队列弹窗 priority 优先级
		 */
		public static function addPopupInQueue(dis : DisplayObject, priority : int = 0, p : Object = null) : void {
			_impl.addPopupInQueue(dis, priority, p);
		}

		/**
		 *移除浮动对象
		 * @param window
		 *
		 */
		public static function removePopup(window : DisplayObject, ease : Boolean = true) : void {
			_impl.removePopup(window, ease);
		}

		/**
		 *将浮动对象升至其所处的显示子树最高层
		 * @param window
		 *
		 */
		public static function bringToFront(window : DisplayObject) : void {
			_impl.bringToFront(window);
		}

		public static function set impl(i : IPopupManagerImpl) : void {
			_impl = i;
		}

		public static function get impl() : IPopupManagerImpl {
			return _impl;
		}
	}
}