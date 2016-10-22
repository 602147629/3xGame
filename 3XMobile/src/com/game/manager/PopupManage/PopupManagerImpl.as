package com.game.manager.PopupManage {
	import com.game.manager.RootManager;
	import com.game.utils.DisplayObjectUtil;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	

	/**
	 *浮动窗口管理实现
	 */
//	[ExcludeClass]
	public class PopupManagerImpl implements IPopupManagerImpl {
		private var _queue : Queue;
		private var _arr_wins : Array; //弹框们
		private var _arr_backgrounds : Array; //背景们
		private var _arr_shell : Array; //外壳们
		//		private var _dty_shellToBackground : Dictionary; //shell  →  background 
		private var _dty_targetlToBgAndShell : Dictionary; //target →  {bg:,shell:}
		private var _dispatch : EventDispatcher;
		
		private var _popUpContainer:Sprite;

		public function PopupManagerImpl() {
			_arr_backgrounds = [];
			_arr_wins = [];
			_arr_shell = [];
			_dty_targetlToBgAndShell = new Dictionary(true);
			_dispatch = new EventDispatcher();
			_queue = new Queue();
			this.initEvent();
		}
		
		//增加舞台被缩放后mask和窗口位置的处理
		private function initEvent():void
		{
			RootManager.stage.addEventListener(Event.RESIZE,resizeHandler);
		}

		//舞台缩放的处理
		private function resizeHandler(event:Event):void {
			//遍历所有的已有窗口并处理其位置
			var tShell:DisplayObject;
			var tBg:Sprite;
			for each (var obj:Object in _dty_targetlToBgAndShell) 
			{
				tShell=obj.shell;
				tBg=obj.bg;
				if (tShell.stage) 
				{
					//在舞台上即处理
					tShell.x = tShell.stage.stageWidth >> 1;
					tShell.y = tShell.stage.stageHeight >> 1;
					tBg.width=tShell.stage.stageWidth;
					tBg.height=tShell.stage.stageHeight;
					
				}
			}
			
		}

		public function get dispatch() : EventDispatcher {
			return _dispatch;
		}

		/**
		 *  添加浮动对象
		 */
		public function addPopup(window : DisplayObject, toContainer : DisplayObjectContainer = null, easy : Boolean = true, center : Boolean = true, modal : Boolean = true, bgColor : int = 0x000000, bgAlpha : Number = 0.3) : DisplayObject {
			if (this.isTargetOnStage(window)) 
			{
				trace("已经弹出");
				return null;
			}
			if (toContainer == null){
				toContainer = getStage();
			}
			process(window, toContainer, center, modal, bgColor, bgAlpha);
			var obj : Object = _dty_targetlToBgAndShell[window];
			toContainer.addChild(obj.bg);
			toContainer.addChild(obj.shell);
			if (easy){
				this.scaleEaseIn(obj.shell);
			}
			return window;
		}

		/**
		 * p {isEasy,toContainer,center,modal,bgColor,bgAlpha}
		 */
		public function addPopupInQueue(dis : DisplayObject, priority : int = 0, p : Object = null) : void {
			if (this.isTargetOnStage(dis)) 
			{
				trace("已经弹出");
				return;
			}
			if (p == null){
				p = {};
			}
			var child : QueueChild = new QueueChild(dis, priority, p);
			_queue.addChild(child);
			next();
		}

		/**
		 * true 当前有弹框  false 当前没有弹框   先发送PopupEvent.EMPTY 事件后返回false
		 */
		public function get isCurrent() : Boolean {
			for (var i : int = 0, leni : int = _arr_shell.length; i < leni; i++) {
				var shell : DisplayObject = _arr_shell[i];
				if (shell.parent != null)
					return true;
			}
			_dispatch.dispatchEvent(new PopupEvent(PopupEvent.EMPTY));
			return false;
		}

		/**
		 * 移除
		 * @param window
		 */
		public function removePopup(window : DisplayObject, ease : Boolean = true) : void {
			if (window == null)
				return;
			window.cacheAsBitmap=false;
			var obj : Object = _dty_targetlToBgAndShell[window];
			if (obj == null)
				return;
			if (obj.bg != null)
				DisplayObjectUtil.removeSelf(obj.bg);
			if (ease)
				this.scaleEaseOut(obj.shell);
			else
				removeWin(obj.shell);
		}
		
		/**
		 * 获取对象是否是弹出状态 
		 * @param window
		 * @return 
		 */		
		public function isTargetOnStage(window:DisplayObject):Boolean
		{
			var obj : Object = _dty_targetlToBgAndShell[window];
			if (obj==null) 
			{
				return false;
			}
			if (window.stage) 
			{
				return true;
			}
			return false;
		}

		/**
		 * 获取win的壳
		 */
		private function getShellByWin(win : DisplayObject) : DisplayObjectContainer {
			for (var i : int = 0, leni : int = _arr_shell.length; i < leni; i++) {
				var doc : DisplayObjectContainer = _arr_shell[i];
				try {
					if (doc.getChildIndex(win) >= 0)
						return doc;
				} catch (e : ArgumentError) {
				}
			}
			return null;
		}

		/**
		 * 获取对应型号的弹框外套   {c:a:w:h:t,isU}
		 */
		private function getBackground(c : uint, a : Number, w : int, h : int) : Sprite {
			for (var i : int = 0, lenI : int = _arr_backgrounds.length; i < lenI; i++) {
				var obj : Object = _arr_backgrounds[i];
				if (obj.c == c && obj.a == a && obj.w == w && obj.h == h && obj.t.numChildren == 0 && obj.t.parent == null){
					obj.t.width=w;
					obj.t.height=h;
					return obj.t;
				}
			}
			var spt : Sprite = new Sprite();
			spt.graphics.beginFill(c, a);
			spt.graphics.drawRect(0, 0, 1, 1);
			spt.graphics.endFill();
			spt.width=w;
			spt.height=h;
			_arr_backgrounds.push({c: c, a: a, w: w, h: h, t: spt});
			return spt;
		}

		/**
		 * @param window
		 */
		public function bringToFront(window : DisplayObject) : void {
			var parent : DisplayObjectContainer = window.parent;
			if (parent) {
				if (parent.numChildren > 1)
					parent.setChildIndex(window, parent.numChildren - 1);
			}
		}

		/**
		 * 会被强行套壳
		 */
		private function process(window:*, toContainer : DisplayObjectContainer = null, center : Boolean = true, modal : Boolean = true, bgColor : int = 0x000000, bgAlpha : Number = 0.3) : void {
			this._sw=RootManager.stageWidth;
			this._sh=RootManager.stageHeight;
			var shell : Sprite = getShell();
			var bg:Sprite;
			shell.addChild(window);
			(window as Sprite).cacheAsBitmap=true;
			if (window.hasOwnProperty("bg")&&window.bg) 
			{
//				trace("it has bg");
				bg=window.bg;
				window.x=-bg.width >> 1;
				window.y=-bg.height >> 1;
			}else{
				window.x=-window.getRect(window).width >> 1;
				window.y=-window.getRect(window).height >> 1;
			}
			var containerWidth : int;
			var containerHeight : int;

			/*if (toContainer is Stage) {
				containerWidth = (toContainer as Stage).stageWidth;
				containerHeight = (toContainer as Stage).stageHeight;
			} else {
				containerWidth = toContainer.width;
				containerHeight = toContainer.height;
			}*/
			containerWidth = this._sw;
			containerHeight = this._sh;

			if (center) {
				shell.x = containerWidth >> 1;
				shell.y = containerHeight >> 1;
			}

			var popupTarget : DisplayObject;

			if (modal) {
				var wc : Sprite = getBackground(bgColor, bgAlpha, containerWidth, containerHeight);
					//				DisplayObjUtils.removeAllChildren(wc);
					//				wc.addChild(shell);
					//				popupTarget = wc;
					//				_dty_shellToBackground[shell] = wc;
			} else {
				popupTarget = shell;
			}
			_dty_targetlToBgAndShell[window] = {shell: shell, bg: wc};
			//			return {target: popupTarget, shell: shell};
		}

		/**
		 * 获取一个空闲shell
		 */
		private function getShell() : Sprite {
			var spt : Sprite;
			for (var i : int = 0, lenI : int = _arr_shell.length; i < lenI; i++) {
				spt = _arr_shell[i];
				if (_arr_shell[i].numChildren == 0)
					return spt;
			}
			spt = new Sprite();
			_arr_shell.push(spt);
			return spt;
		}

		private function scaleEaseIn(targetWin : DisplayObject, fromScale : Number = 0.5, toScale : Number = 1) : void {
			targetWin.scaleX = fromScale;
			targetWin.scaleY = fromScale;
			targetWin.alpha =1;
			if (targetWin is DisplayObjectContainer) 
			{
				(targetWin as DisplayObjectContainer).mouseChildren=true;
				(targetWin as DisplayObjectContainer).mouseEnabled=true;
			}
			var tw1:TweenLite=TweenLite.to(targetWin, 0.5, {scaleX: toScale, scaleY: toScale, alpha: 1, ease: Back.easeOut,onComplete: function():void{ tw1.kill();tw1=null } });
		}

		/**
		 * 传入的是壳
		 */
		private function scaleEaseOut(targetWin : DisplayObject, fromScale : Number = 1.02, toScale : Number = 0.6) : void {
			if (targetWin != null) {
				targetWin.scaleX = fromScale;
				targetWin.scaleY = fromScale;
				
				if (targetWin is DisplayObjectContainer) 
				{
					(targetWin as DisplayObjectContainer).mouseChildren=false;
					(targetWin as DisplayObjectContainer).mouseEnabled=false;
				}
				
				targetWin.alpha = .7;
				TweenLite.to(targetWin, 0.5,
					{scaleX: toScale, scaleY: toScale,
						alpha: 0, ease: Back.easeInOut,
						onComplete: removeWin,
						onCompleteParams: [targetWin]});
			}
		}

		/**
		 * 这里传入的是壳  移除壳里的东西并且重置壳的参数
		 */
		private function removeWin(doc : DisplayObjectContainer) : void {
			TweenLite.killTweensOf(doc);
			DisplayObjectUtil.removeAllChildren(doc);
			DisplayObjectUtil.removeSelf(doc);
			doc.mouseChildren=true;
			doc.mouseEnabled=true;
			
			//			doc.scaleX = doc.scaleY = 1;
			//			doc.alpha = 1;
			//			var bg : DisplayObjectContainer = _dty_shellToBackground[doc];
			//			if (bg != null) {
			//				DisplayObjUtils.removeSelf(bg);
			//				DisplayObjUtils.removeAllChildren(bg);
			//			}
			next();
		}

		private function next() : void {
			if (isCurrent)
				return;
			var child : QueueChild = _queue.next();
			if (child == null)
				return;
			var obj : Object = child.parameter;
			var func : Function = addPopup;
			var arr : Array = [child.target];
			if (obj.hasOwnProperty("toContainer"))
				arr[1] = obj.toContainer;
			arr[2] = (obj.hasOwnProperty("isEasy") && obj.isEasy == false) ? false : true;
			if (obj.hasOwnProperty("center"))
				arr[3] = obj.center;
			if (obj.hasOwnProperty("modal"))
				arr[4] = obj.toContainer;
			if (obj.hasOwnProperty("bgColor"))
				arr[5] = obj.toContainer;
			if (obj.hasOwnProperty("bgAlpha"))
				arr[8] = obj.toContainer;
			func.apply(this, arr);
		}

		/**
		 * @return
		 */
		private var _sw:int;
		private var _sh:int;
		private function getStage():Sprite {
			if(this._popUpContainer==null){
				this._popUpContainer=new Sprite;
			}
			if(this._popUpContainer.parent==null){
				RootManager.root.addChild(this._popUpContainer);
				this._sw=RootManager.stageWidth;
				this._sh=RootManager.stageHeight;
			}
			if(RootManager.root.getChildIndex(this._popUpContainer)!=RootManager.root.numChildren-1){
				RootManager.root.addChild(this._popUpContainer);
			}
			return this._popUpContainer;
			//return RootManager.stage;
		}
	}
}