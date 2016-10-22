package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.events.TouchEvent;
	import flash.text.TextField;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.rpc.GameLobbySocketCallback;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	import qihoo.gamelobby.protos.CMsgLS2LCNotifyUserLingHongBao;
	import qihoo.gamelobby.protos.UserOrigin;

	/**
	 * @author caihua
	 * @comment 红包领取结果
	 * 创建时间：2014-7-1 下午3:39:54 
	 */
	public class CPanelRedGiftResult extends CPanelAbstract
	{
		private var _tips_visitor_0:String = "哎呀，一不小心抢了这么多银豆。";		
		private var _tips_visitor_1:String = "下雪炸鸡和啤酒，开心游戏好手气！Come on！";		
		private var _tips_visitor_2:String = "幸福就是猫吃鱼狗吃肉我抢到了大红包！耶！";		
		private var _tips_visitor_3:String = "伤不起啊伤不起，一抢就这么多白花花的银豆！";		
		private var _tips_visitor_4:String = "春风得意马蹄急，一日抢尽大红包。策马奔腾，走你！";
		
		private var _tips_user_0:String = "哎呦，人品大爆发！土豪，我们做朋友吧。";		
		private var _tips_user_1:String = "哇塞，运气这么好！都教授，带我走吧！";		
		private var _tips_user_2:String = "高端大气上档次，低调奢华有内涵！没错，这是你的大红包！";		
		private var _tips_user_3:String = "今儿的运气是极好的，抢到了这么大个的红包。";		
		private var _tips_user_4:String = "人生得意须尽欢，莫使红包空对月。好运气，抢莫停！";		

		public function CPanelRedGiftResult()
		{
			super(ConstantUI.PANEL_RED_GIFT_RESULT);
		}
		
		override protected function drawContent():void
		{
			var confirmBtn:CButtonCommon = new CButtonCommon("confirmyellow" , "确定");
			confirmBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false , 0 , true);
			mc.closepos.addChild(confirmBtn);
			
			var userRed:CMsgLS2LCNotifyUserLingHongBao = GameLobbySocketCallback.currentRed;
			
			var sytf:TextField = CBaseUtil.getTextField(mc.syTxt, 14, 0xffffff);
			
			if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
			{
				mc.gifttext.text = this["_tips_visitor_" + userRed.hongBaoIndex];
				sytf.htmlText = "今天还能抢<font color='#FFCF26'>"+userRed.todayLeft+"</font>次红包哦！想抢更多的红包？";
				
				sytf.x = 20;
			}else
			{
				mc.zcBtn.visible = false;
				mc.gifttext.text = this["_tips_user_" + userRed.hongBaoIndex];
				sytf.htmlText = "今天还能抢<font color='#FFCF26'>"+userRed.todayLeft+"</font>次红包哦！";
				
				sytf.x = 60;
			}
			
			mc.numTxt.text = Number(datagramView.injectParameterList["num"]);
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_RED_GIFT_RESULT));
			
			NetworkManager.instance.sendServerGetCoin();
		}
	}
}