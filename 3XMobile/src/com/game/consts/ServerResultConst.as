package com.game.consts
{
	/**
	 * 服务返回常量
	 * @author melody
	 */	
	public class ServerResultConst
	{
		/**
		 * 成功
		 */ 
		public static const SUCCESS:int = 0;
		/**
		 * 系统错误
		 */ 
		public static const SYS_ERROR:int = -1;
		public static const SYS_ERROR_SEND:int = -2;
		/**
		 * 根据不同请求而失败的原因
		 */ 
		public static const ERROR:int = 1;
		
		/**
		 * 进入游戏时，与玩家和场景相关部分
		 * */
		public static var WRONG_SCENE_ID:int = 1;
		public static var SYSTEM_ERROR_MSG:String = "系统错误";
		public static var WRONG_SCENE_ID_MSG:String = "不正确的场景ID";
		public static var FAILED_MSG:String = "失败";
		
		public function ServerResultConst()
		{
		}
	}
}