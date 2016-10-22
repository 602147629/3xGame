package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 消息面板
	 * 创建时间：2014-6-24 下午6:31:44 
	 */
	public class CPanelMessage extends CPanelAbstract
	{
		private var _tf:TextFormat = null;
		
		public function CPanelMessage()
		{
			super(ConstantUI.DIALOG_COMMON_Message);
		}
		
		override protected function drawContent():void
		{
			__drawScaleBg();
			
			_tf = datagramView.injectParameterList["textFormat"];
			if(this._tf == null)
			{
				_tf = CFontUtil.textFormatMiddle;
			}
			_tf.color = 0;
			
			mc.tfcontent  = CBaseUtil.getTextField(mc.tfcontent , 16 , 0x7e0101);
			
			mc.tfcontent.mouseEnabled = false
			
			mc.tfcontent.autoSize=TextFieldAutoSize.LEFT;
				
			mc.tfcontent.htmlText = datagramView.injectParameterList["text"] ;
			
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xf6eab5;
			tf.align = "center";
			
			var confirmBtn:CButtonCommon = new CButtonCommon("greenshort" , "关闭" , tf , 0x00);
			mc.confirmpos.addChild(confirmBtn);
			
			confirmBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0  , true);
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_COMMON_Message));
			
		}
		
		private function __drawScaleBg():void
		{
			var bg:Sprite = CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_WARNING);
			
			mc.bgpos.addChild(bg);
		}
	}
}