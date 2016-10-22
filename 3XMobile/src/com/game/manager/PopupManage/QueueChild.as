/**
 * MSN/E-mail:lost_player@163.com
 */
package com.game.manager.PopupManage {
	import flash.display.DisplayObject;

	/**
	 * @author melody
	 * 2012-11-26
	 * 队列的子项
	 */
	public class QueueChild {
		//目标
		private var _target:*;
		//标示
		private var _key:*;
		//优先级
		private var _priority:uint;
		//附加参数
		private var _parameter:Object;

		public function QueueChild(t:* = null, pr:uint = 0, pa:Object = null) {
			_target = t;
			_priority = pr;
			_parameter = pa;
		}

		/**
		 * ------set------
		 */
		public function set target(t:*):void {
			_target = t;
		}

		public function set priority(p:uint):void {
			_priority = p;
		}

		public function set parameter(p:Object):void {
			_parameter = p;
		}

		public function set key(k:*):void {
			_key = k;
		}

		/**
		 * ------get------
		 */
		public function get target():* {
			return _target;
		}

		public function get priority():uint {
			return _priority;
		}

		public function get parameter():Object {
			return _parameter;
		}

		public function get key():* {
			return _key;
		}
	}
}