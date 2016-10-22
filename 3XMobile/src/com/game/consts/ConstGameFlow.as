package com.game.consts
{
	/**
	 * @author caihua
	 * @comment 大厅流程
	 * 创建时间：2014-6-30 下午4:46:32 
	 */
	public class ConstGameFlow
	{
		//js
		public static const GAME_ENGINE_INIT:String = "gameEngine init -------- 1";
		public static const AS_CALL_JS_READY:String = "通知JS ready -------- 2";
		public static const JS_CALLBACK_AS_DOM_READY:String = "回调as ，获取mac -------- 3";
		public static const START_LOAD_RESOURCE:String = "开始加载游戏资源 -------- 4";
		public static const CONNECT_LOBBY:String = "连接lobby -------- 6";
		
		//lobby
		public static const LOBBY_GET_QT:String = "lobby连接成功，请求QT -------- 7";
		public static const LOBBY_LOGIN:String = "请求QT成功，登陆lobby -------- 8";
		public static const LOBBY_GET_AREA_INFO:String = "登陆lobby成功，请求频道信息 -------- 9";
		public static const LOBBY_GET_PRODUCT:String = "请求频道信息成功，请求产品信息 -------- 10";
		public static const LOBBY_SIGN_UP_MATCH:String = "请求产品信息成功，报名比赛 -------- 11";
		//同时下发12 13
		public static const LOBBY_SIGN_UP_MATCH_SUCC:String = "报名比赛成功，等待下发游戏服务器地址 -------- 12";
		public static const LOBBY_CONNECT_SERVER_GAME:String = "收到游戏服务器地址，连接游戏服务器 -------- 13";
		
		//server
		public static const SERVER_ENTER_MATCH:String = "游戏服务器连接成功，请求加入比赛 -------- 14";
		//同时下发 15 16
		public static const SERVER_ENTER_MATCH_SUCC:String = "请求加入比赛成功 , 等待开始游戏消息(start_game) -------- 15";
		
		public static const SERVER_USER_STATUS_EXCEPTION:String = "用户状态异常 USER_ACTION";
		
		public static const SERVER_GET_GAME_USER_DATA:String = "收到开始游戏消息(start_game)，请求游戏用户数据 -------- 16";
		
		public static const SERVER_GET_GAME_STARINFO:String = "请求游戏用户数据成功，请求关卡数据-------- 17";
		
		public static const SERVER_ENTER_SCENE:String = "请求关卡数据成功，进入场景 -------- 18";
		
		public static const END_GAME_EXIT_MATCH:String = "退出游戏 -------- 19";
		
		public static const REENTER_GAME:String = "重新开始游戏 -------- 20";
	}
}