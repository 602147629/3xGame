package com.game.consts
{
	/**
	 * @author caihua
	 * @comment 关卡组状态常量
	 * 创建时间：2014-6-24 下午4:07:17 
	 */
	public class ConstUIGroupStatus
	{
		//初始
		public static const GROUP_STATUS_INIT:int = -1;
		//已解锁
		public static const GROUP_STATUS_UNLOCK:int = 1;
		//锁住
		public static const GROUP_STATUS_LOCK:int = 2;
		//需要解锁才能玩下一个
		public static const GROUP_STATUS_CURRENTLOCK:int = 3;
	}
}