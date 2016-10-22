package com.game.module
{
	import com.ui.util.CBaseUtil;
	
	import framework.resource.faxb.award.MatchInfo;
	
	import qihoo.gamelobby.protos.Product_Status;

	public class CDataOfProduct extends CDataBase
	{
		private var _matchList:Array;
		
		public function CDataOfProduct()
		{
			super("CDataOfProduct");
			
			_matchList = new Array();
		}
		
		public function get matchList():Array
		{
			var index:int = 0;
			var len:int = _matchList.length;
			var matchData:CDataOfMatch;
			for(index = 0; index < len; index++)
			{
				matchData = _matchList[index];
				var matchAward:MatchInfo = CBaseUtil.getMatchAwardByID(matchData.productID);
				if(matchAward != null)
				{
					matchData.index = matchAward.index;
				}
			}
			_matchList.sortOn("index", Array.NUMERIC | Array.DESCENDING);
			return _matchList;
		}
		
		public function getFirstMatch():CDataOfMatch
		{
			if(matchList.length > 0)
			{
				var index:int = 0;
				var len:int = matchList.length;
				var matchData:CDataOfMatch;
				for(index = 0; index < len; index++)
				{
					matchData = matchList[index];
					if(matchData != null && CBaseUtil.getSignUpStatus(matchData.status))
					{
						return matchData;
					}
				}
			}
			return null;
		}
		
		public function getQuickMatch():CDataOfMatch
		{
			if(_matchList.length > 0)
			{
				var len:int = _matchList.length;
				var tempID:int;
				for(var i:int = 0; i < len; i++)
				{
					var matchData:CDataOfMatch = _matchList[i];
					var curCost:Object = CBaseUtil.getCurrentSignUpCost(matchData.productID);
					var flog:Boolean = false;
					if(matchData.currentRobNum < matchData.totalRobNum + 1
						&& curCost
						&& CDataManager.getInstance().dataOfMoney.silver >= curCost.num
						&& matchData.matchCD - matchData.matchEndTime > 0)
					{
						flog = true;
					}
					if(tempID == 0)
					{
						if(matchData.status == Product_Status.Product_Status_SustainedSignup
							&& flog)
						{
							tempID = matchData.productID;
						}
					}else
					{
						var matchAward:MatchInfo = CBaseUtil.getMatchAwardByID(matchData.productID);
						var tempAward:MatchInfo = CBaseUtil.getMatchAwardByID(tempID);
						if(matchAward && tempAward && matchAward.quick > tempAward.quick 
							&& matchData.status == Product_Status.Product_Status_SustainedSignup
							&& flog)
						{
							tempID = matchData.productID;
						}
					}
				}
				
				var tempMatchData:CDataOfMatch = getMatchByID(tempID);
				if(tempMatchData)
				{
					return tempMatchData;
				}
			}
			return null;
		}
		
		public function getMatchByID(productID:int):CDataOfMatch
		{
			var matchData:CDataOfMatch;
			for each(matchData in _matchList)
			{
				if(productID == matchData.productID)
				{
					return matchData;
				}
			}
			
			return null;
		}
		
		public function pushMatch(matchData:CDataOfMatch):void
		{
			if(matchData == null)
			{
				return;
			}
			if(getMatchByID(matchData.productID) != null)
			{
				return;
			}
			_matchList.push(matchData);
		}
		
		public function delMatch(productID:int):void
		{
			var index:int = 0;
			var len:int = _matchList.length;
			var matchData:CDataOfMatch;
			for(index = 0; index < len; index++)
			{
				matchData = _matchList[index];
				if(productID == matchData.productID)
				{
					_matchList.splice(index, 1);
					break;
				}
			}
		}

	}
}