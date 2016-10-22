package com.ui.util
{
	import com.game.module.CDataManager;
	
	import framework.model.DataManager;
	import framework.resource.faxb.notice.Update;
	import framework.resource.faxb.starreward.Levels;

	/**
	 * @author caihua
	 * @comment 配置数据组装
	 * 创建时间：2014-8-27 上午11:27:38 
	 */
	public class CConfigUtil
	{
		/**
		 * 获取当前能领取的星值奖励
		 * 最多 getNum 个
		 */
		public static function getNextFiveReward(level:int , getNum:int = 5):Array
		{
			var result:Array = new Array();
			var curStarNum:int = CDataManager.getInstance().dataOfGameUser.totalStar;
			
			var rewardList:Vector.<Levels> = DataManager.getInstance().starRewards.levels;
			
			var tempNum:int = 0 ;
			
			for(var i:int = 0 ;i < rewardList.length ; i++)
			{
				var l:Levels = rewardList[i];
				if(l.level <= level)
				{
					continue;
				}
				else
				{
					if(tempNum++ < getNum)
					{
						result.push(l);
					}
				}
			}
			return result;
		}
		
		/**
		 * 获取最新的公告
		 */
		public static function getNewNotice():Update
		{
			var configList:Vector.<Update> = DataManager.getInstance().noticeList.update;
			var result:Update = configList[0];
			for(var i:int = 0 ; i< configList.length;i++)
			{
				var update:Update = configList[i];
				if(result.id <= update.id)
				{
					result = update;
				}
			}
			return result;
		}
	}
}