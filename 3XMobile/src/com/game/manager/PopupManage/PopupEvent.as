package com.game.manager.PopupManage
{
	import flash.events.Event;

	/**
	 * 弹出框的事件
	 */
	public class PopupEvent extends Event {
		public static const EMPTY : String = "empty";

		public function PopupEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}