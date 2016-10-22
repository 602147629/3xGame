package com.ui.button
{
	import com.ui.util.CFilterUtil;
	import com.ui.util.CFontUtil;
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * @author caihua
	 * @comment 按钮基类
	 * 按钮分up/over/down/disabled/selected五种状态
	 * 素材准备:
	 * 1.按钮尺寸象素取整
	 * 2.按钮各状态放成一排，以up/over/down/disabled/selected为顺序
	 * 3.某状态没有直接跳过
	 * 创建时间：2014-6-10 上午11:32:10 
	 */
	public class CButton extends Sprite
	{
		private var _button:SimpleButton
		
		protected var _upState:CButtonShape;
		protected var _overState:CButtonShape;
		protected var _downState:CButtonShape;
		protected var _disabledState:CButtonShape;
		protected var _selectedState:CButtonShape;
		protected var _hitTestState:CButtonShape;
		
		private var _isSelected:Boolean = false;
		
		private var _tf:TextField;
		
		private var _textFormat:TextFormat;
		
	
		// bmDataCname ：导出类名   bmDataSize :无坐标图片大小  buttonInfo:按钮状态 
		public function CButton(bmDataCname:String , bmDataSize:Point , buttonInfo:CButtonInfo , text:String ="" , tf:TextFormat = null , glowColor:uint = 0xff0000)
		{
			//按钮尺寸
			var size:Point = buttonInfo.__size;

			
			//up
			var upRect:Rectangle = new Rectangle(buttonInfo.__upPos.x, buttonInfo.__upPos.y, size.x, size.y);
			this._upState = new CButtonShape(bmDataCname, size, upRect);
			
			//over
			if(buttonInfo.__overPos != null)
			{
				var overRect:Rectangle = new Rectangle(buttonInfo.__overPos.x, buttonInfo.__overPos.y, size.x, size.y);
				this._overState = new CButtonShape(bmDataCname, size, overRect);
			}
			else
			{
				this._overState = this._upState;
				
//				this._overState = new CButtonShape(bmDataCname, size, upRect , 1.1); 
			}
			
			//down
			if(buttonInfo.__downPos != null)
			{
				var downRect:Rectangle = new Rectangle(buttonInfo.__downPos.x, buttonInfo.__downPos.y, size.x, size.y);
				this._downState = new CButtonShape(bmDataCname, size, downRect);
			}
			else
			{
				this._downState = this._upState;
			}
			
			//disabled
			if(buttonInfo.__disabledPos != null)
			{
				var disabledRect:Rectangle = new Rectangle(buttonInfo.__disabledPos.x, buttonInfo.__disabledPos.y, size.x, size.y);
				this._disabledState = new CButtonShape(bmDataCname, size, disabledRect);
			}
			else
			{
				this._disabledState = this._upState;
			}
			
			//selected
			if(buttonInfo.__selectedPos != null)
			{
				var selectedRect:Rectangle = new Rectangle(buttonInfo.__selectedPos.x, buttonInfo.__selectedPos.y, size.x, size.y);
				this._selectedState = new CButtonShape(bmDataCname, size, selectedRect);
			}
			else
			{
				this._selectedState = this._upState;
			}
			
			this._hitTestState = this._upState;
			
			_button = new SimpleButton(this._upState , this._overState , this._downState , this._hitTestState);
			
			this.addChild(_button);
			
			if(tf == null)
			{
				tf = CFontUtil.textFormatBig;
				tf.color = 0xFFFFFF;
			}
			
			_textFormat = tf;
			
			_tf = CFontUtil.getTextField(_textFormat);
			_tf.width = size.x;
			_tf.height = _upState.height;
			_tf.text = text;
			_tf.mouseEnabled = false;
			
			_tf.filters = [CFilterUtil.getTextGlowFilter(glowColor)];
			
			_tf.autoSize = TextFieldAutoSize.CENTER;
			_tf.y = (size.y - _tf.textHeight) / 2;
			_tf.y -= 2;
			
			this.addChild(_tf);
		}
		
		public function set enabled(value:Boolean):void
		{
			_button.enabled = value;
			this.mouseEnabled = value;
			_button.mouseEnabled = value;
			_button.upState= value ? this._upState:this._disabledState;
		}
		
		public function get enabled():Boolean
		{
			return _button.enabled;
		}
		
		/**
		 * fake enabled
		 */
		public function set fakeenabled(value:Boolean):void
		{
			_button.upState = value ? this._upState:this._disabledState;
			_button.downState = value ? this._downState:this._disabledState;
			_button.overState = value ? this._overState:this._disabledState;
		}
		
		/**
		 * selected
		 */
		public function set selected(value:Boolean):void
		{
			_isSelected = value;
			
			_button.upState = value ? this._selectedState:this._upState;
			_button.downState = value ? this._selectedState:this._downState;
			_button.overState = value ? this._selectedState:this._overState;	//selected时over失效
			//this.mouseEnabled = value ? false:true;
		}
		
		/**
		 * overed
		 */
		public function set overed(value:Boolean):void
		{
			_button.upState = value ? _button.overState:this._upState;
			_button.downState = value ? _button.overState:this._downState;
			_button.overState = value ? _button.overState:this._overState;
		}
		
		/**
		 * selected
		 */
		public function get selected():Boolean
		{
			return _isSelected;
		}
		
		private function __overScaled():void
		{
			
		}

		public function get textField():TextField
		{
			return _tf;
		}

	}
}
