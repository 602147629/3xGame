package com.ui.widget
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import framework.util.NumberSprite;
	import framework.util.ResHandler;
	
	/**
	 *  倒计时的数字 
	 * @author sunxiaobin
	 * 
	 */	
	public class CWidgetCDNumber extends Sprite
	{
		private var _oldNum:int;
		private var _oldSingle:NumberSprite;
		private var _newSingle:NumberSprite;
		private var _cls:Class;
		private var _isRunning:Boolean;
		
		public function CWidgetCDNumber(rectW:int, rectH:int, className:String = "numberStep")
		{
			super();
			
			this._oldNum = -1;
			this._cls = ResHandler.getClass(className);
			this.scrollRect = new Rectangle(0, 0, rectW, rectH);
		}
		
		public function setNumber(num:int):void
		{
			if(_oldNum == num)
			{
				return;
			}
			
			this._oldNum = num;
			if(_oldSingle == null)
			{
				this._oldSingle = new NumberSprite(_cls , num);
				this.addChild(this._oldSingle);
			}else
			{
				if(this._isRunning && this._newSingle)
				{
					TweenLite.killTweensOf(this._oldSingle);
					TweenLite.killTweensOf(this._newSingle);
					this.__onMoveOver();
				}
				this._newSingle = new NumberSprite(_cls, num);
				this._newSingle.y = this.height;
				this.addChild(this._newSingle);
				TweenLite.to(this._oldSingle, 0.5, {y: -this._oldSingle.height});
				TweenLite.to(this._newSingle, 0.5, {y: 0, onComplete:__onMoveOver});
				this._isRunning = true;
			}
		}
		
		private function __onMoveOver():void
		{
			if(_oldSingle != null && this.contains(_oldSingle))
			{
				this.removeChild(_oldSingle);
				_oldSingle = null;
			}
			_oldSingle = _newSingle;
			_newSingle = null;
			this._isRunning = false;
		}
		
	}
}