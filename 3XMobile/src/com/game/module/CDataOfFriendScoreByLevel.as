package com.game.module
{
	import com.ui.util.CBaseUtil;
	
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgGetFriendScoreResponse;
	import qihoo.triplecleangame.protos.PBFriendLevelScore;

	/**
	 * @author caihua
	 * @comment 好友的分数信息
	 * 创建时间：2014-8-16 下午4:35:16 
	 */
	public class CDataOfFriendScoreByLevel extends CDataBase
	{
		// level -> array[PBFriendLevelScore]
		//PBFriendLevelScore -> qid , score
		private var _scoreList:Array ;
		
		private var _triggerNumber:int = 12;
		
		public function CDataOfFriendScoreByLevel()
		{
			super("CDataOfFriendScore");
			
			init();
		}
		
		public function init():void
		{
			_scoreList = new Array();
		}
		
		public function saveData(level:int , msg:CMsgGetFriendScoreResponse):void
		{
			//没有这些数据
			if(getListByLevel(level).length == 0)
			{
				_scoreList[level] = msg.friendLevelScore;
			}
			//有数据，合并
			else
			{
				__mergeData(level , msg.friendLevelScore);
			}
			
			//排序
			__sortArray(level);
			
			//消息触发
			__checkTrigger(level);
		}
		
		private function __checkTrigger(level:int):void
		{
//			if(_scoreList[level].length >= _triggerNumber)
			{
				CBaseUtil.sendEvent(GameNotification.EVENT_FRIEND_SCORE_INFO , {});
			}
		}
		
		private function __sortArray(level:int):void
		{
			var levelData:Array = _scoreList[level];
			
			levelData.sort(__mysort);
		}
		
		private function __mysort(a:PBFriendLevelScore , b :PBFriendLevelScore):int
		{
			if(a.score >b.score)
			{
				return 1;
			}
			else if(a.score  == b.score)
			{
				return 0
			}
			else
			{
				return -1;
			}
		}
		
		private function __mergeData(level:int , friendLevelScore:Array):void
		{
			var oldList:Array = _scoreList[level];
			
			for(var i:int = 0 ; i < friendLevelScore.length ; i++)
			{
				var newData:PBFriendLevelScore = friendLevelScore[i];
				if(inArray(oldList , newData))
				{
					continue;
				}
				
				(oldList[level] as Array).unshift(newData);
			}
		}	
		
		public function inArray(oldList:Array , newData:PBFriendLevelScore):Boolean
		{
			for( var i:int =0 ; i < oldList.length ; i ++)
			{
				if(CBaseUtil.toNumber2(oldList[i].qid) == CBaseUtil.toNumber2(newData.qid) )
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 通过关卡获取列表
		 */	
		public function getListByLevel(level:int):Array
		{
			if(!_scoreList[level])
			{
				return new Array();
			}
			else
			{
				return _scoreList[level];
			}
		}
	}
}