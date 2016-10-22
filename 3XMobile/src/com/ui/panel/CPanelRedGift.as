package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.rpc.GameLobbySocketCallback;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	import qihoo.gamelobby.protos.CMsgLS2LCNotifyUserLingHongBao;

	/**
	 * @author caihua
	 * @comment 红包
	 * 创建时间：2014-7-1 下午1:23:25 
	 */
	public class CPanelRedGift extends CPanelAbstract
	{
		public function CPanelRedGift()
		{
			super(ConstantUI.PANEL_RED_GIFT);
		}
		
		override protected function drawContent():void
		{
			var confirmBtn:CButtonCommon = new CButtonCommon("confirmyellow" , "打开");
			confirmBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0 , true);
			mc.openpos.addChild(confirmBtn);
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_RED_GIFT));
			//请求领红包
			var userRed:CMsgLS2LCNotifyUserLingHongBao = GameLobbySocketCallback.currentRed;
			//开启红包
			NetworkManager.instance.sendOpenRed(userRed.transID);
		}
	}
}