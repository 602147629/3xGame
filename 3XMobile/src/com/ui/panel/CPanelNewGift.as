package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 新手礼包
	 * 创建时间：2014-7-1 下午1:13:01 
	 */
	public class CPanelNewGift extends CPanelAbstract
	{
		public function CPanelNewGift()
		{
			super(ConstantUI.PANEL_NEW_GIFT);
		}
		
		override protected function drawContent():void
		{
			var confirmBtn:CButtonCommon = new CButtonCommon("blue" , "确定");
			confirmBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0 , true);
			mc.confirmpos.addChild(confirmBtn);
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_NEW_GIFT));
			//更新UI
		}
	}
}