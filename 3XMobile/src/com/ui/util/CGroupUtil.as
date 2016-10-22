package com.ui.util
{
	import framework.model.DataManager;
	import framework.resource.faxb.sceneui.Level;
	import framework.resource.faxb.sceneui.Levels;

	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-7-8 下午4:08:22 
	 */
	public class CGroupUtil
	{
		/**
		 * 获取关卡组配置
		 */
		public static function getLevelPos(l:int):Level
		{
			var levelsList:Vector.<Levels> = DataManager.getInstance().sceneConfig.levels;
			
			for(var i:int = 0 ; i < levelsList.length ; i++)
			{
				var levels:Vector.<Level> = levelsList[i].level;
				for(var j:int = 0 ; j < levels.length ;j++)
				{
					if(levels[j].id == l)
					{
						return levels[j];
					}
				}
			}
			
			return null;
		}
		
		/**
		 *  获取关卡组的长度 
		 * @return 
		 * 
		 */		
		public static function getGroupLen():int
		{
			var levelsList:Vector.<Levels> = DataManager.getInstance().sceneConfig.levels;
			
			return levelsList.length;
		}
		
	}
}