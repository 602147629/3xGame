package com.ui.util
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	
	import framework.model.DataManager;
	import framework.resource.faxb.levelproperty.Level;
	import framework.resource.faxb.levelproperty.Levels;

	/**
	 * @author caihua
	 * @comment 关卡配置工具类
	 * 创建时间：2014-6-13 下午5:07:45 
	 */
	public class CLevelConfigUtil
	{
		/**
		 * 当前关卡配置
		 */
		public static function getCurrentLevelConfig():Level
		{
			var userData:CDataOfGameUser = CDataManager.getInstance().dataOfGameUser;
			return CLevelConfigUtil.getLevelConfig(userData.curLevel);
		}
		
		/**
		 * 获取关卡的配置
		 * @param l : 层级id
		 */
		public static function getLevelConfig(l:int):Level
		{
			var levelsList:Vector.<Levels> = DataManager.getInstance().levelproperty.levels;
			
			for each(var levels:Levels in levelsList)
			{
				//判断组
				if(levels.startlevel <= l && levels.endlevel >= l )
				{
					//判断关卡
					for each( var level:Level in levels.level)
					{
						if(level.id == l)
						{
							return level;
						}
					}
				}
			}
			return null;
		}
		
		/**
		 * 获取关卡组配置
		 */
		public static function getLevelGroupConfig(groupid:int):Levels
		{
			var userData:CDataOfGameUser = CDataManager.getInstance().dataOfGameUser;
			
			var levelsList:Vector.<Levels> = DataManager.getInstance().levelproperty.levels;
			
			for each(var levelGroup:Levels in levelsList)
			{
				if(levelGroup.id ==  groupid)
				{
					return levelGroup;
				}
			}
			return null;
		}
		
		/**
		 * 当前关卡是否解锁
		 */
		public static function isCurlevelGroupUnlocked():Boolean
		{
			var levelsList:Vector.<Levels> = DataManager.getInstance().levelproperty.levels;
			var curLevel:int = CDataManager.getInstance().dataOfGameUser.curLevel;
			var curGroup:int =CDataManager.getInstance().dataOfGameUser.maxLevelGroup;
			
			for each(var levels:Levels in levelsList)
			{
				//判断组
				if(levels.startlevel <= curLevel && levels.endlevel >= curLevel )
				{
					if(levels.id <= curGroup)
					{
						return true
					}
				}
			}
			return false;
		}
	}
}