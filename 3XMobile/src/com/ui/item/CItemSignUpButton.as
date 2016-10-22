package com.ui.item
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import framework.util.ResHandler;

	public class CItemSignUpButton extends CItemAbstract
	{
		public var isEnabled:Boolean;
		private var _signUpBtn:CButtonCommon;
		private var _size:int;
		private var _btnTxt:TextField;
		
		public function CItemSignUpButton(size:int = 20)
		{
			_size = size;
			super("panel.signup.btnItem");
			this.buttonMode = true;
		}
		
		override protected function drawContent():void
		{
			_signUpBtn = new CButtonCommon("yellowlong");
			mc.btn.addChild(_signUpBtn);
			
			mc.icon.y += 1;
			mc.icon.mouseChildren = false;
			mc.icon.mouseEnabled = false;
			mc.btnTxt.mouseEnabled = false;
			
			_btnTxt = CBaseUtil.getTextField(mc.btnTxt, _size, 0xffffff, "left");
			if(_size < 20)
			{
				_btnTxt.y += (20 - _size) * 1.5;
			}
			_btnTxt.mouseEnabled = false;
		}
		
		public function setIcon(index:int):void
		{
			if(index == 0)
			{
				mc.icon.visible = false;
				return;
			}
			
			mc.icon.visible = true;
			while(mc.icon.numChildren)
			{
				mc.icon.removeChild(mc.icon.getChildAt(0));
			}
			var icon:MovieClip = ResHandler.getMcFirstLoad("common.icon");
			icon.gotoAndStop(index);
			mc.icon.addChild(icon);
		}
		
		public function setSignUpBtnText(textStr:String):void
		{
			_btnTxt.text = textStr;
		}
		
		public function set enabled(value:Boolean):void
		{
			_signUpBtn.enabled = value;
			this.isEnabled = value;
		}
		
		public function set isShowIcon(value:Boolean):void
		{
			mc.icon.visible = value;
		}
	}
}