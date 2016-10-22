package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.events.TouchEvent;
	import flash.text.TextField;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.resource.faxb.award.MatchInfo;
	import framework.rpc.DataUtil;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	public class CpanelMatchRule extends CPanelAbstract
	{
		public function CpanelMatchRule()
		{
			super("panel.match.rule");
		}
		
		override protected function drawContent():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_WARNING));
			
			var closeBtn:CButtonCommon = new CButtonCommon("close");
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 , true);
			mc.closepos.addChild(closeBtn);
			
			var tf:TextField = CBaseUtil.getTextField(mc.tfcontent, 14, 0x7e0101, "left");
			
			var matchAward:MatchInfo = CBaseUtil.getMatchAwardByID(DataUtil.instance.selectMatchProductID);
			tf.width = 350;
			tf.wordWrap = true;
			tf.multiline = true;
			tf.htmlText = matchAward.rule;
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView("panel.match.rule"));
		}
	}
}