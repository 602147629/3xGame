package com.ui.widget
{
	import com.ui.item.CItemLoading;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	import framework.util.ResHandler;

	/**
	 * @author caihua
	 * @comment 面板基类
	 * 创建时间：2014-6-10 下午15:44:01
	 */
	public class CWidgetAbstract extends Sprite
	{
		private var _dir:String;
		private var _id:String;
		protected var mc:*;
		private var _isBusy:Boolean;
		private var _data:Object;
		
		private var _loading:CItemLoading;

		public function CWidgetAbstract(id:String, data:Object = null)
		{
			this._data = data;
			this._id = id;
			this.addEventListener(Event.ADDED, this.addHandler, false, 0, true);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE , __onRemoved);
		}
		
		protected function __onRemoved(event:Event):void
		{
			dispose();
			
		}
		
		public function dispose():void
		{
			
		}
		
		protected function addHandler(e:Event):void
		{
			if (e.target == this)
			{
				var cls:Class = ResHandler.getClass(this._id);
				if (cls != null)
				{
					this.loadAfter(cls);
				}
			}
		}

		private function loadAfter(cls:Class):void
		{
			if (null != cls)
			{
				this.mc = new cls();
				this.addChild(this.mc);
				
				__drawLoading();
				
				this.drawContent();
				
				_loading.x = (mc.width - _loading.width) /2;
				_loading.y = (mc.height - _loading.height) /2;
				mc.addChild(_loading);
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
	}
}