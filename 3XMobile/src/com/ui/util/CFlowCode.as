package com.ui.util
{
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.rpc.DataUtil;
	import framework.rpc.GameLobbySocketCallback;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 登陆流
	 * 创建时间：2014-8-12 下午8:42:33 
	 */
	public class CFlowCode
	{
		public static var LoginAckResult_code:int = 0;
		public static var Signup_Result_code:int = 0;
		public static var Pop_FCM_code:int = 0;
		public static var Pop_New_code:int = 0;
		public static var Pop_Red_code:int = 0;
		public static var Pop_Match_code:int = 0;
		
		public static var params:Object = null;
		
		public static function showWarning():void
		{
			if(!DataUtil.instance.isResReadey)
			{
				return;
			}
			//登陆
			if(LoginAckResult_code != 0)
			{
				CBaseUtil.delayCall(function():void{CBaseUtil.sendEvent(GameNotification.EVENT_SHOW_WARNING , {text:String(params)});} , 3);
				LoginAckResult_code = 0 ;
			}
			
			//报名
			if(Signup_Result_code != 0)
			{
				CBaseUtil.delayCall(function():void{CBaseUtil.sendEvent(GameNotification.EVENT_SHOW_WARNING , {text:String(params)});} , 3);
				Signup_Result_code = 0 ;
			}
			
			//防沉迷
			if(Pop_FCM_code != 0)
			{
				CBaseUtil.showConfirm(String(params),GameLobbySocketCallback.onFangChenMi, new Function());
				Pop_FCM_code = 0;
			}
		}
		
		public static function showPop():void
		{
			if(Pop_New_code != 0)
			{
				//弹出新手礼包
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramView(ConstantUI.PANEL_NEW_GIFT));
				
				Pop_New_code = 0;
			}
			
			if(Pop_Red_code != 0)
			{
				//弹出领红包
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_RED_GIFT));
				
				Pop_Red_code = 0;
			}
			
			if(Pop_Match_code != 0 && !NetworkManager.instance.isReplay)
			{
				//弹出比赛奖励
//				CBaseUtil.sendEvent(GameNotification.EVENT_DIPLOMA_TIPS);
				CBaseUtil.popDiploma();
				Pop_Match_code = 0;
			}
		}
	}
}