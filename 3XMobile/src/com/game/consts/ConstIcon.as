package com.game.consts
{
	/**
	 * @author caihua
	 * @comment 小图标
	 * 创建时间：2014-7-21 上午11:42:54 
	 */
	public class ConstIcon
	{
		//体力
		public static const ICON_TYPE_ENERTY:int = 0;
		//银豆
		public static const ICON_TYPE_SILVER:int = 1;
		//金豆
		public static const ICON_TYPE_GOLD:int = 2;
		//星星
		public static const ICON_TYPE_STAR:int = 12;
		//混合
		public static const ICON_TYPE_MIXTURE:int = 13;
		
		//消除体icon列表
		public static const ICON_OBSTACLES:Array = [51,52,53,54, 104 ,103,102, 101,   151,  105,106,107,108,  56,69,152 , 55];
		
		//获取消除体的icon
		public static function getOBSIconById(itemid:int):int
		{
			for(var i:int = 0 ;i < ICON_OBSTACLES.length ; i++)
			{
				if(ICON_OBSTACLES[i] == itemid)
				{
					return i;
				}
			}
			return -1;
		}
	}
}