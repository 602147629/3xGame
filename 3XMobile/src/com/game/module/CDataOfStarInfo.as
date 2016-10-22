package com.game.module
{
	import framework.fibre.core.Fibre;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgGetLevelsInfoResponse;
	import qihoo.triplecleangame.protos.PBStarArray;

	/**
	 * @author caihua
	 * @comment 关卡数据 1.用户信息里面不下 2. 0关时候 没有数据，不下   3. 打完关卡下一次数据
	 * 创建时间：2014-7-26 上午10:56:04 
	 */
	public class CDataOfStarInfo extends CDataBase
	{
		private var _starInfo:CMsgGetLevelsInfoResponse;
		
		public function CDataOfStarInfo()
		{
			super("CDataOfStarInfo");
			
			if(!Debug.ISONLINE)
			{
				this._starInfo = new CMsgGetLevelsInfoResponse();
			}
		}
		
		public function init(d:CMsgGetLevelsInfoResponse = null):void
		{
			if(!d)
			{
				d = new CMsgGetLevelsInfoResponse();
			}
			
			this._starInfo = d;
			
			CONFIG::debug
			{
				__traceStarInfo();
			}
			
			//更新信息
			Fibre.getInstance().sendNotification(GameNotification.EVENT_STAR_INFO  , {});
		}
		
		/**
		 * 关卡整体数据信息
		 */
		public function get levelInfoList():Array
		{
			return this._starInfo.starInfo;
		}
		
		/**
		 * 关卡数据信息
		 */
		public function getLevelInfo(level:int):PBStarArray
		{
			//错误数据
			if(!this._starInfo)
			{
				this._starInfo = new CMsgGetLevelsInfoResponse();
			}
			
			for(var i:int = 0 ; i < this._starInfo.starInfo.length ; i++ )
			{
				if( (this._starInfo.starInfo[i] as PBStarArray).level == level )
				{
					return (this._starInfo.starInfo[i] as PBStarArray);
				}
			}
			return null;
		}
		
		/**
		 * 找到第一个不满星的关卡
		 */
		public function getFirstUnfullLevel():int
		{
			var level:int = 0;
			for(var i:int = 0 ; i < this._starInfo.starInfo.length ; i++ )
			{
				if( (this._starInfo.starInfo[i] as PBStarArray).maxStar < 3 )
				{
					level = (this._starInfo.starInfo[i] as PBStarArray).level;
					break;
				}
			}
			
			return level;
		}
		
		private function __traceStarInfo():void
		{
			for(var i:int = 0 ; i < this._starInfo.starInfo.length ; i++ )
			{
				var star:PBStarArray = (this._starInfo.starInfo[i] as PBStarArray);
				TRACE("关卡: "+star.level+" star : " + star.maxStar + "score : "+star.maxScore , "STAR_INFO");
			}
		}
	}
}