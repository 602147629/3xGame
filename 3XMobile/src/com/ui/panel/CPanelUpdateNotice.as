package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CConfigUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.datagram.DatagramView;
	import framework.resource.faxb.notice.Update;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 更新面板
	 * 创建时间：2014-9-17  下午22:33:41 
	 */
	public class CPanelUpdateNotice extends CPanelAbstract
	{
		private var _textArea:TextField;
		private var _notice:Update;
		
		private var _line:Bitmap;
		private var _slider:MovieClip;
		
		public function CPanelUpdateNotice()
		{
			super(ConstantUI.PANEL_UPDATE_NOTICE);
		}
		
		override protected function drawContent():void
		{
			_notice = CConfigUtil.getNewNotice();
			
			__drawBtn();
			
			__drawSlider();
			
			__drawArea();
		}
		
		private function __drawSlider():void
		{
			_line = CScaleImageUtil.CScaleImageFromClass(ConstantUI.CONST_UI_BG_SCROLLLINE , 
				new Rectangle(1, 50, 1, 80) , 
				new Point(1 , 300));
			mc.scrollBG.addChild(_line);
			
			var cls:Class = ResHandler.getClass(ConstantUI.CONST_UI_BG_SCROLLBAR);
			_slider = new cls();
			mc.slider.addChild(_slider);
		}
		
		private function __drawArea():void
		{
			_textArea = CFontUtil.getTextField(CFontUtil.getTextFormat(16, 0, false, "left"));
			_textArea.selectable = false;
			_textArea.wordWrap = true;
			_textArea.multiline = true;
			_textArea.width = 335;
			_textArea.height = 300;
			_textArea.condenseWhite = true;
			_textArea.defaultTextFormat.indent = 12;
			
			mc.textareapos.addChild(_textArea);
			
			mc.title.htmlText = _notice.title;
			
			_line.visible = false;
			_slider.visible = false;
			
			if(mc.title.textHeight > _textArea.height - 10)
			{
				_textArea.addEventListener(TouchEvent.TOUCH_ROLL_OVER , __OnWheel);
				_line.visible = true;
				_slider.visible = true;
			}
			
			mc.title = CBaseUtil.getTextField(mc.title , 20 ,0xff0000);
			
			_textArea.htmlText = _notice.content;
		}
		
		protected function __OnWheel(event:TouchEvent):void
		{
			_slider.y = Number(_textArea.scrollV/_textArea.maxScrollV) * (300 - _slider.height);
			if(_textArea.scrollV == 1)
			{
				_slider.y = 0;
			}
		}
		
		override protected function dispose():void
		{
			super.dispose();
		}
		
		private function __drawBtn():void
		{
			//关闭按钮
			var closeBtn:CButtonCommon = new CButtonCommon("z_n96_close");
			mc.closepos.addChild(closeBtn);
			
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_UPDATE_NOTICE)); 
		}
	}
}