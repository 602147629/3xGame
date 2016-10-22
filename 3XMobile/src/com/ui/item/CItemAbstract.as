package com.ui.item
{
	import com.ui.util.CLoadImage;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getDefinitionByName;
	
	import framework.util.ResHandler;

	/**
	 * 显示item的基类
	 */
	public class CItemAbstract extends Sprite
	{
		protected var mc:MovieClip;
		protected var _loadComplete:Boolean = false;
		private var _drawCompleteCallback:Function;
		private var _id:String;
		protected var _isLock:Boolean;

		/**
		 * 构造函数
		 * @param dir:swf目录
		 * @param id:类名
		 */
		public function CItemAbstract(id:String, drawCompleteCallback:Function = null)
		{
			this._drawCompleteCallback = drawCompleteCallback;
			
			this._id = id;
			var cls:Class = ResHandler.getClass(id);
			if (cls != null)
			{
				this.loadAfter(cls);
			}
			else
			{
				loadAfterSimple();
			}
			
			this.addEventListener(Event.REMOVED_FROM_STAGE , __onRemoved);
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT
		}
		
		protected function __onRemoved(event:Event):void
		{
			dispose();
		}
		
		protected function dispose():void
		{
			
		}
		
		private function loadAfter(cls:Class):void
		{
			this._loadComplete = true;
			this.mc = new cls();
			this.addChild(this.mc);
			this.drawContent();
			if (null != this._drawCompleteCallback)
			{
				this._drawCompleteCallback.call();
			}
		}
		
		private function loadAfterSimple():void
		{
			this._loadComplete = true;
			this.drawContent();
			if (null != this._drawCompleteCallback)
			{
				this._drawCompleteCallback.call();
			}
		}

		/**
		 * 派生类重载
		 */
		protected function drawContent():void
		{
		}

		/**
		 * 在容器中加载按钮
		 * @param type:按钮所属类名
		 * @param name:按钮名称
		 */
		protected function drawBtn(type:String, name:String, pos:String = null):*
		{
			var cls:Class = getDefinitionByName("main.button." + type) as Class;
			var btn:DisplayObject = new cls(name);
			if (pos)
			{
				btn.x = this.mc[pos].x;
				btn.y = this.mc[pos].y;
			}
			else
			{
				btn.x = this.mc[name + "pos"].x;
				btn.y = this.mc[name + "pos"].y;
			}

			//[背景,内容]跟[按钮]分离
			this.addChild(btn);
			return btn;
		}

		/**
		 * 将图片载入到指定的位置
		 * @param	url
		 * @param	posName
		 */
		protected function drawImgInItem(url:String, posName:String):CLoadImage
		{
			var img:CLoadImage = new CLoadImage(url);
			img.x = this.mc[posName + "pos"].x;
			img.y = this.mc[posName + "pos"].y;
			this.mc.addChild(img);
			return img;
		}

		public function get __cname():String
		{
			return this._id;
		}
		
		/**
		 * 尝试进入锁定状态
		 */
		protected function entryLock():Boolean
		{
			if (this._isLock)
			{
				return false;
			}
			else
			{
				this._isLock = true;
				return true;
			}
		}

		/**
		 * 解锁
		 */
		protected function unlock():void
		{
			this._isLock = false;
		}

		public function get id():String
		{
			return _id;
		}

	}
}
