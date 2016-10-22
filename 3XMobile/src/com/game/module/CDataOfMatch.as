package com.game.module
{
	import com.netease.protobuf.UInt64;

	public class CDataOfMatch extends CDataBase
	{
		private var _matchData:Object;
		
		public function CDataOfMatch()
		{
			super("CDataOfMatch");
			
			this._matchData = new Object();
		}
		
		public function get productID():int
		{
			return this._matchData.productID;
		}
		
		public function set productID(value:int):void
		{
			this._matchData.productID = value;
		}
		
		public function get status():int
		{
			return this._matchData.status;
		}
		
		public function set status(value:int):void
		{
			this._matchData.status = value;
		}
		
		public function set matchID(value:UInt64):void
		{
			this._matchData.matchID = value;
		}
		
		public function get matchID():UInt64
		{
			return this._matchData.matchID;
		}
		
		public function get tableID():int
		{
			return this._matchData.tableID;
		}
		
		public function set tableID(value:int):void
		{
			this._matchData.tableID = value;
		}
		
		public function get stageID():int
		{
			return this._matchData.stageID;
		}
		
		public function set stageID(value:int):void
		{
			this._matchData.stageID = value;
		}
		
		public function set signUpNum(value:int):void
		{
			this._matchData.signUpNum = value;
		}
		
		public function get signUpNum():int
		{
			return this._matchData.signUpNum;
		}
		
		public function set remainCount(value:int):void
		{
			this._matchData.remainCount = value;
		}
		
		public function get remainCount():int
		{
			return this._matchData.remainCount;
		}
		
		public function set visitorCanEnter(value:int):void
		{
			this._matchData.visitorCanEnter = value;
		}
		
		public function get visitorCanEnter():int
		{
			return this._matchData.visitorCanEnter;
		}
		
		public function set itemList(value:Array):void
		{
			this._matchData.itemList = value;
		}
		
		public function get itemList():Array
		{
			return this._matchData.itemList;
		}
		
		public function set matchRank(value:int):void
		{
			this._matchData.matchRank = value;
		}
		
		public function get matchRank():int
		{
			return this._matchData.matchRank;
		}
		
		public function set maxScore(value:int):void
		{
			this._matchData.maxScore = value;
		}
		
		public function get maxScore():int
		{
			return this._matchData.maxScore;
		}
		
		public function set currentRobNum(value:int):void
		{
			this._matchData.currentRobNum = value;
		}
		
		public function get currentRobNum():int
		{
			return this._matchData.currentRobNum;
		}
		
		public function set totalRobNum(value:int):void
		{
			this._matchData.totalRobNum = value;
		}
		
		public function get totalRobNum():int
		{
			return this._matchData.totalRobNum;
		}
		
		public function set maxRobNum(value:int):void
		{
			this._matchData.maxRobNum = value;
		}
		
		public function get maxRobNum():int
		{
			return this._matchData.maxRobNum;
		}
		
		public function set isPlaying(value:Boolean):void
		{
			this._matchData.isPlaying = value;
		}
		
		public function get isPlaying():Boolean
		{
			return this._matchData.isPlaying;
		}
		
		public function set matchName(value:String):void
		{
			this._matchData.matchName = value;
		}
		
		public function get matchName():String
		{
			return this._matchData.matchName;
		}
		
		public function set matchType(value:int):void
		{
			this._matchData.matchType = value;
		}
		
		public function get matchType():int
		{
			return this._matchData.matchType;
		}
		
		public function set startTime(value:Number):void
		{
			this._matchData.startTime = value;
		}
		
		public function get startTime():Number
		{
			return this._matchData.startTime;
		}
		
		public function set matchCD(value:int):void
		{
			this._matchData.matchCD = value;
		}
		
		public function get matchCD():int
		{
			return this._matchData.matchCD;
		}
		
		public function set waitCD(value:int):void
		{
			this._matchData.waitCD = value;
		}
		
		public function get waitCD():int
		{
			return this._matchData.waitCD;
		}
		
		public function set index(value:int):void
		{
			this._matchData.index = value;
		}
		
		public function get index():int
		{
			return this._matchData.index;
		}
		
		public function set matchStartTime(value:Number):void
		{
			this._matchData.matchStartTime = value;
		}
		
		public function get matchStartTime():Number
		{
			return this._matchData.matchStartTime;
		}
		
		public function set matchEndTime(value:Number):void
		{
			this._matchData.matchEndTime = value;
		}
		
		public function get matchEndTime():Number
		{
			return this._matchData.matchEndTime;
		}
		
		public function get endTime():Number
		{
			return this._matchData.endTime;
		}
		
		public function set endTime(value:Number):void
		{
			this._matchData.endTime = value;
		}
		
		public function set rankList(value:Array):void
		{
			this._matchData.rankList = value;
		}
		
		public function get rankList():Array
		{
			return this._matchData.rankList;
		}
		
		public function set signUpCost(value:Array):void
		{
			this._matchData.signUpCost = value;
		}
		
		public function get signUpCost():Array
		{
			return this._matchData.signUpCost;
		}
		
		public function set replayCost(value:Array):void
		{
			this._matchData.replayCost = value;
		}
		
		public function get replayCost():Array
		{
			return this._matchData.replayCost;
		}
	}
}