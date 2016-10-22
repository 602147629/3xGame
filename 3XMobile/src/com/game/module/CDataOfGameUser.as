package com.game.module
{
	import com.netease.protobuf.UInt64;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CTimer;
	
	import framework.fibre.core.Fibre;
	import framework.rpc.DataUtil;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgGetUserInfoResponse;

	/**
	 * @author caihua
	 * @comment 数据封装处理类
	 * 创建时间：2014-6-12 下午2:34:37 
	 */
	public class CDataOfGameUser extends CDataBase
	{
		private var _msgUserInfo:CMsgGetUserInfoResponse;
		
		private var _nickName:String;
		
		private var _headUrl:String;
		
		private var _recoveryTime:int = 600;
		
		private var _isFirstNext:Boolean;
		
		private var _rewardLevel:int = -1;
		
		private var _dayCount:int;
		
		private var _onlineTime:Number;
		
		private var _onlineTimer:CTimer;
		
		public function CDataOfGameUser()
		{
			super("CDataOfGameUser");
			if(!Debug.ISONLINE)
			{
				this._msgUserInfo = new CMsgGetUserInfoResponse();
				this._msgUserInfo.curEnergy = 100;
			}
		}
		
		public function init(d:CMsgGetUserInfoResponse):void
		{
			if(this._msgUserInfo)
			{
				if(d.curLevel > this._msgUserInfo.curLevel)
				{
					this._isFirstNext = true;
				}
			}
			
			this._msgUserInfo = d;
			
			if(!this._msgUserInfo)
			{
				this._msgUserInfo = new CMsgGetUserInfoResponse();
			}
			
			//更新信息
			Fibre.getInstance().sendNotification(GameNotification.EVENT_GAME_DATA_UPDATE  , {});
		}
		
		public function get msgUserInfo():CMsgGetUserInfoResponse
		{
			return _msgUserInfo;
		}
		
		public function get userId():UInt64
		{
			if(Debug.ISONLINE)
			{
				return DataUtil.instance.myUserID;
			}
			else
			{
				return CBaseUtil.fromNumber2( Number(CDataManager.getInstance().dataOfLocal.getKey("visitorID")) ) || new UInt64(10001 , 0);
			}
		}

		public function get curLevel():int
		{
			if(!this._msgUserInfo)
			{
				return 0;
			}
			
			return this._msgUserInfo.curLevel;
		}

		public function set curLevel(value:int):void
		{
			this._msgUserInfo.curLevel = value;
		}

		public function get curTimes():int
		{
			if(!this._msgUserInfo)
			{
				return 0;
			}
			
			return this._msgUserInfo.curTimes;
		}

		public function set curTimes(value:int):void
		{
			this._msgUserInfo.curTimes = value;
		}

		public function get curEnergy():int
		{
			if(!this._msgUserInfo)
			{
				return 0;
			}
			return this._msgUserInfo.curEnergy;
		}

		public function set curEnergy(value:int):void
		{
			if(!this._msgUserInfo)
			{
				return;
			}
			
			this._msgUserInfo.curEnergy = value;
		}

		public function get curExp():int
		{
			if(!this._msgUserInfo)
			{
				return 0;
			}
			return this._msgUserInfo.curExp;
		}

		public function set curExp(value:int):void
		{
			this._msgUserInfo.curExp = value;
		}

		public function get maxLevel():int
		{
			if(!_msgUserInfo)
			{
				return 0;
			}
			return _msgUserInfo.maxLevel;
		}
		
		public function set maxLevel(value:int):void
		{
			_msgUserInfo.maxLevel = value;
		}
		
		public function get maxLevelGroup():int
		{
			if(!this._msgUserInfo)
			{
				return 0;
			}
			return this._msgUserInfo.levelGroup;
		}
		
		public function set maxLevelGroup(value:int):void
		{
			//todo 最大组限制
			if(value == this._msgUserInfo.levelGroup)
			{
				return;
			}
			
			this._msgUserInfo.levelGroup = value;
		}
		
		public function get totalStar():Number
		{
			if(!this._msgUserInfo)
			{
				return 0;
			}
			return _msgUserInfo.totalStar;
		}
		
		public function set totalStar(value:Number):void
		{
			_msgUserInfo.totalStar = value;
		}

		public function get nickName():String
		{
			return _nickName;
		}

		public function set nickName(value:String):void
		{
			_nickName = value;
		}

		public function get headUrl():String
		{
			return _headUrl;
		}

		public function set headUrl(value:String):void
		{
			_headUrl = value;
		}

		public function get recoveryTime():int
		{
			return _recoveryTime;
		}

		public function set recoveryTime(value:int):void
		{
			//不需要恢复
			if(value == 0)
			{
				_recoveryTime = 0;
			}
			else
			{
				_recoveryTime = value;
			}
		}

		public function get isFistNext():Boolean
		{
			return _isFirstNext;
		}

		public function set isFistNext(value:Boolean):void
		{
			_isFirstNext = value;
		}
		
		/**
		 * 判断某关卡是否通关了
		 */
		public function isLevelPassed(level:int):Boolean
		{
			return level <= maxLevel && level < curLevel;
		}

		public function get rewardLevel():int
		{
			if(!this._msgUserInfo)
			{
				return -1;
			}
			return _msgUserInfo.starRewardLevel; 
		}

		public function set rewardLevel(value:int):void
		{
			_rewardLevel = value;
			
			_msgUserInfo.starRewardLevel = _rewardLevel;
		}

		public function get onlineTime():Number
		{
			return _onlineTime;
		}

		public function set onlineTime(value:Number):void
		{
			_onlineTime = value;
			
			if(_onlineTimer == null)
			{
				_onlineTimer = new CTimer();
				_onlineTimer.addCallback(addOnline, 1);
				_onlineTimer.start();
			}
		}
		
		private function addOnline():void
		{
			_onlineTime += 1000;
		}

		public function get dayCount():int
		{
			return _dayCount;
		}

		public function set dayCount(value:int):void
		{
			_dayCount = value;
		}

	}
}