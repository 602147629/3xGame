/**
 * MSN/E-mail:lost_player@163.com
 */
package com.game.manager.PopupManage
{
	
	import flash.events.EventDispatcher;

	/**
	 * @author melody
	 * 2012-11-26
	 * 队列
	 *
	 * addChild 添加QueueChild
	 *
	 * dispatcher 获取事件发送器
	 *
	 * deleteChild 删除某个child
	 *
	 * deleteByKey 删除某个key下的所有child
	 *
	 * getChildrenByKey 通过key获取children
	 * 
	 * currentLength 获取当前队列长度
	 *
	 * has 查看队列是否有这个对象 isStrong:true 会当做child false 会当做target
	 *
	 * type 设置类型 0 上进下出  1 满而不进
	 *
	 * total 设置队列长度
	 *
	 * inFunc 压入时候会调用的function
	 *
	 * outFunc 挤出的时候会调用的function
	 *
	 * queue 获取队列数组引用（建议强复制后操作）
	 */

	public class Queue {
		public static const OUT_TOP : int = 1; //先进后出
		public static const OUT_BOTTOM : int = 2; //先进先出

		private var _arr_queue : Array;
		private var _int_total : int = -1;
		private var _int_type : int = 1;

		private var _func_in : Function
		private var _func_out : Function
		private var _dispatcher : EventDispatcher;

		public function Queue() {
			_arr_queue = [];
			_dispatcher = new EventDispatcher();
		}

		/**
		 * 把QueueChild压入队列     是否满员 — 发送事件 — 压入队列 — 触发回调方法
		 */
		public function addChild(child : QueueChild) : void {
			if (judgeFull()) {
				var event : QueueEvent = new QueueEvent(QueueEvent.IN);
				event.child = child;
				dispatcher.dispatchEvent(event);
				_arr_queue.push(child);
				if (_func_in != null) _func_in(child);
			} else {
				event = new QueueEvent(QueueEvent.FULL);
				event.child = child;
				dispatcher.dispatchEvent(event);
			}
		}

		public function get dispatcher() : EventDispatcher {
			return _dispatcher;
		}

		/**
		 * 先删除后调用out方法    触发出的事件 — 压出 — 触发压出回调函数
		 */
		public function deleteChild(child : QueueChild) : void {
			var index : int = _arr_queue.indexOf(child);
			var c : QueueChild = _arr_queue[index];
			var event : QueueEvent = new QueueEvent(QueueEvent.IN);
			event.child = c;
			dispatcher.dispatchEvent(event);
			_arr_queue.splice(index, 1);
			if (_func_out != null) _func_out(c);
		}

		/**
		 * 获取队列中下一个      判断出的方式并排序 — 走删除流程 — 返回child
		 */
		public function next() : QueueChild {
			if (_arr_queue.length <= 0) {
				var event : QueueEvent = new QueueEvent(QueueEvent.EMPTY);
				dispatcher.dispatchEvent(event);
				return null;
			}
			var child : QueueChild;
			switch (_int_type) {
				case Queue.OUT_BOTTOM:
					_arr_queue.sortOn("priority", Array.NUMERIC);
					child = _arr_queue[_arr_queue.length - 1];
					break;
				case Queue.OUT_TOP:
					_arr_queue.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
					child = _arr_queue[0];
					break;
				default:
					trace("Bad switch in Queue.deleteChild() => " + _int_type)
					return null;
			}
			deleteChild(child);
			return child;
		}

		/**
		 * 会走deleteChild
		 */
		public function deleteByKey(key : *) : void {
			var arr : Array = getChildrenByKey(key);
			for (var i : int = 0, lenI : int = arr.length; i < lenI; i++)
				deleteChild(arr[i]);
		}

		/**
		 * 判断队列是否满员（会对队列进行删减操作）   false  满了  true  没满
		 */
		private function judgeFull() : Boolean {
			if (_int_total < 0)	return true;
			else if (_arr_queue.length == _int_total) return false;
			else {
				var num : int = _arr_queue.length - _int_total;
				_arr_queue.splice(_int_total, num);
				return false;
			}
		}

		/**
		 * isStrong : true  对比队列中是否存在这个实例   false  比较实例中的target属性
		 */
		public function has(tag : QueueChild, isStrong : Boolean = false) : Boolean {
			if (isStrong) {
				if (_arr_queue.indexOf(tag) == -1) return false;
				else	return true;
			} else {
				var child : QueueChild;
				for (var i : int = 0, leni : int = _arr_queue.length; i < leni; i++) {
					child = _arr_queue[i];
					if (child.target == tag.target) return true;
					if (i == leni - 1) return false;
				}
			}
			return false;
		}

		/**
		 * 获取key下所有的实例
		 */
		public function getChildrenByKey(key : *) : Array {
			var child : QueueChild;
			var arr : Array = [];
			for (var i : int = 0, lenI : int = _arr_queue.length; i < lenI; i++) {
				child = _arr_queue[i];
				if (child.key == key)	arr.push(child);
			}
			return arr;
		}

		/**
		 * 获取队列当前长度
		 */
		public function get currentLength() : int {
			return _arr_queue.length;
		}

		/**
		 * 获取队列
		 */
		public function get queue() : Array {
			return _arr_queue;
		}

		/**
		 * 设置队列总长度  （会干掉多出的）
		 */
		public function set total(t : int) : void {
			_int_total = t;
			judgeFull();
		}

		/**
		 * 当对象进入数组的时候调用的方法 会传入child
		 */
		public function set inFunc(value : Function) : void {
			_func_in = value;
		}

		/**
		 * 当对象被挤出队列的时候调用
		 */
		public function set outFunc(value : Function) : void {
			_func_out = value;
		}

		/**
		 * 设置队列类型
		 */
		public function set outType(t : int) : void {
			_int_type = t;
		}
	}
}