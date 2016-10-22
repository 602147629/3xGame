package com.ui.item
{
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.events.TouchEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.rpc.WebJSManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 警告面板
	 * 创建时间：2014-7-28 下午7:20:03 
	 */
	public class CItemWarning extends CItemAbstract
	{
		private var _tf:TextFormat = null;
		
		private var _text:String = "主意事项";
		
		public function CItemWarning(text:String)
		{
			_text = text;
			super(ConstantUI.DIALOG_COMMON_Message);
		}
		
		override protected function drawContent():void
		{
			__drawScaleBg();
			
			_tf = CFontUtil.textFormatMiddle;
			
			mc.tfcontent  = CBaseUtil.getTextField(mc.tfcontent , 16 , 0x7e0101);
			
			mc.tfcontent.mouseEnabled = false
				
			mc.tfcontent.autoSize=TextFieldAutoSize.LEFT;
//			mc.tfcontent.defaultTextFormat = _tf;
			mc.tfcontent.htmlText = _text ;
			mc.tfcontent.textColor = 0;
			mc.tfcontent.selectable = true;
			mc.tfcontent.addEventListener(TextEvent.LINK, onTextLink);
			
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xf6eab5;
			tf.align = "center";
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_COMMON_Message));
			
		}
		
		private function onTextLink(e:TextEvent):void
		{
			if(Debug.inLobby)
			{
				WebJSManager.navigateByTab(e.text);
			}
		}
		
		private function __drawScaleBg():void
		{
			var bg:Sprite = CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_WARNING);
			if(bg)
			{
				mc.bgpos.addChild(bg);
			}
		}
	}
}