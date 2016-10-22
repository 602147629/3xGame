package com.game.manager.PopupManage {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;

	public interface IPopupManagerImpl {

		function get dispatch() : EventDispatcher;

		function addPopup(window : DisplayObject, toContainer : DisplayObjectContainer = null, easy : Boolean = true, center : Boolean = true, modal : Boolean = true, bgColor : int = 0x000000, bgAlpha : Number = 0.3) : DisplayObject;

		function addPopupInQueue(dis : DisplayObject, priority : int = 0, p : Object = null) : void;

		function get isCurrent() : Boolean;

		function removePopup(window : DisplayObject, ease : Boolean = true) : void;

		function bringToFront(window : DisplayObject) : void;
	}
}