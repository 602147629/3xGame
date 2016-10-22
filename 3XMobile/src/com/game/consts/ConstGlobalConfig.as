package com.game.consts
{
	/**
	 * @author caihua
	 * @comment 全局配置
	 * 创建时间：2014-7-3 下午6:11:04 
	 */
	public class ConstGlobalConfig
	{
		//最大体力值
		public static const MAX_ENERGY:int = 30;
		//每次游戏消耗的体力
		public static const ENERGY_PER_GAME:int = 5;
		//5分钟恢复一点体力
		public static const ENERGY_RECOVER_TIME:int = 30;
		//每点体力对应的银豆
		public static const SILVER_PER_ENERGY:int = 5000;
		
		//获取好友的信息接口
		public static const USER_INTERFACE:String = "http://omega.rest.qipai.360.cn/user/{$qid}/profile";
		
		public static const SOCKET_LOBBY:int = 1;
		
		public static const SOCKET_GAME:int = 2;
		
		public static const SOCKET_MATCH:int = 3;
		
		//送出礼物上限
		public static const SEND_GIFT_LIMIT:int = 20;
		//接受礼物上限
		public static const RECEIVE_GIFT_LIMIT:int = 10;
		
		public static const DESIGN_WIDTH:Number = 1020;
		
		public static const DESIGN_HEIGHT:Number = 648;
		
		public static const STAGE_WIDTH:Number = 480;
		
		public static const STAGE_HEIGHT:Number = 320;
		
	}
}