package com.ui.panel
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.ui.item.CItemLoading;
	
	import flash.events.Event;
	
	import framework.datagram.DatagramView;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 弹框
	 * 创建时间：2014-6-9 下午13:10:01 
	 */
	public class CPanelAbstract extends MediatorBase
	{
		public static const TWEEN_OPEN:String = "tween_open";
		public static const DIRECT_OPEN:String = "direct_open";
		private var _isBusy:Boolean;
		private var _datagramView:DatagramView;
		
		private var _centerUI:Boolean;
		
		private var _loading:CItemLoading;
		private var _open:String = TWEEN_OPEN;
		
		/**
		 * 构造函数
		 */
		public function CPanelAbstract(id:String  , centerUI:Boolean = true, isDrag:Boolean = false , withMask:Boolean = true)
		{
			_centerUI = centerUI;
			
			super(id , id , isDrag , withMask);
		}
		
		public function setOpen(open:String):void
		{
			this._open = open;
		}
		
		protected function __onRemoved(event:Event):void
		{
			dispose();
		}
		
		protected function dispose():void
		{
			
		}
		
		/**
		 * 定位
		 */
		protected function locate():void
		{
			var x:int = (ConstantUI.currentScreenWidth  - this.mc.width )/ 2;
			var y:int = (ConstantUI.currentScreenHeight - this.mc.height )/ 2;

			this.mc.x = x;
			this.mc.y = y;
		}
		
		override protected function start(d:DatagramView):void
		{
			super.start(d);
			_datagramView = d;
			
			__drawLoading();
			
			drawContent();
			
			if(_centerUI)
			{
				locate();
			}
			
			drawBackgroud();
			
			_loading.x = (mc.width - _loading.width) /2;
			_loading.y = (mc.height - _loading.height) /2;
			mc.addChild(_loading);
			
			mc.addEventListener(Event.REMOVED_FROM_STAGE , __onRemoved);
			
			this.open(); 
		}
		
		private function open():void
		{
			if (TWEEN_OPEN == this._open)
			{
				var endx:int = this.mc.x;
				var endy:int = this.mc.y;
				
				mc.x = ConstantUI.currentScreenWidth /2 ;
				mc.y = ConstantUI.currentScreenHeight / 2;
				mc.scaleX = 0;
				mc.scaleY = 0;
				
				TweenLite.to(mc, 0.5, {x: endx, y: endy, scaleX: 1, scaleY: 1, ease: Back.easeOut});
			}
		}
		
		public function showLoading():void
		{
			_loading.show();
		}
		
		public function closeLoading():void
		{
			_loading.close();
		}
		
		private function __drawLoading():void
		{
			_loading = new CItemLoading();
			_loading.close();
		}
		
		/**
		 * 子类重载
		 */
		protected function drawBackgroud():void
		{
			
		}

		/**
		 * 子类重载
		 */
		protected function drawContent():void
		{
		}


		
		public function entryLock():Boolean
		{
			if (this._isBusy)
			{
				return false;
			}
			this._isBusy = true;
			return true;
		}
		
		public function get isBusy():Boolean
		{
			return this._isBusy;
		}
		
		public function unlock():void
		{
			this._isBusy = false;
		}
		
		public function get datagramView():DatagramView
		{
			return _datagramView;
		}
	}
}
