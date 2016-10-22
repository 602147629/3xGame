package com.ui.item
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.game.module.CDataOfMatch;
	import com.netease.protobuf.UInt64;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CStringUtil;
	import com.ui.util.CTimer;
	import com.ui.widget.CWidgetCDNumber;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import framework.fibre.core.Notification;
	import framework.model.DataRecorder;
	import framework.resource.faxb.award.MatchInfo;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.sound.MediatorAudio;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;

	/**
	 *  比赛中的任务面板 
	 * @author sunxiaobin
	 * 
	 */	
	public class CItemMatchTaskPanel extends CItemAbstract
	{
		private var _dataOfLevel:CDataOfLevel;
		private var _decreaseMc:MovieClip;
		private var _decreaseTimeMc:MovieClip;
		private var _d:DataRecorder;
		private var _matchData:CDataOfMatch;
		
		private var _cls:Class;
		
		private var _timer:CTimer;
		
		private var _cdTimer:CTimer;
		
		private var _sendTimer:CTimer;
		private var _timeCount:int;
		
		private var _itemList:Array;
		
		private var _timeRemain:Number;
		
		private var _stepNumber_0:CWidgetCDNumber;
		private var _stepNumber_1:CWidgetCDNumber;
		private var _stepNumber_2:CWidgetCDNumber;
		private var _stepNumber_3:CWidgetCDNumber;
		
		private var _cdNumber_0:CWidgetCDNumber;
		private var _cdNumber_1:CWidgetCDNumber;
		private var _cdNumber_2:CWidgetCDNumber;
		private var _cdNumber_3:CWidgetCDNumber;
		private var _cdNumber_4:CWidgetCDNumber;
		private var _cdNumber_5:CWidgetCDNumber;
		
		private var _rankTxt:TextField;
		
		private var _soundWarningLimitTime:int = 11;
		private var _soundWarningLimitStep:int = 6;
		
		private var _lastStep:int;
		
		private var _lastPlayedStep:int = _soundWarningLimitStep;
		
		private var _lastPlayedTime:int = _soundWarningLimitTime;
		
		private var _warningPlayed:Boolean = false;
		
		private var _isRemoveEvent:Boolean;
		
		public function CItemMatchTaskPanel(d:DataRecorder)
		{
			_dataOfLevel = CDataManager.getInstance().dataOfLevel;
			
			_d = d;
			
			_cls = ResHandler.getClass("numberStep");
			
			_timer = new CTimer();
			
			_cdTimer = new CTimer();
			
			this._sendTimer = new CTimer();
			
			_itemList = new Array();
			
			_matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			
			this._timeRemain = _matchData.matchCD / 1000;
			
			super(ConstantUI.ITEM_BARRIER_MATCHTASK);
		}
		
		override protected function drawContent():void
		{
			var tf:TextField = CBaseUtil.getTextField(mc.level_num, 18, 0xFAFA95);
			var currentMatchAward:MatchInfo = CBaseUtil.getMatchAwardByID(DataUtil.instance.selectMatchProductID);
			if(currentMatchAward != null)
			{
				tf.text = currentMatchAward.shortName;
			}
			else
			{
				tf.text = _matchData.matchName;
			}
			
			this._rankTxt = CBaseUtil.getTextField(mc.rankTxt, 14, 0xFAFA95, "left");
			
			_decreaseMc = mc.mc_step;
			for(var i :int = 0 ;i < 4 ; i++)
			{
				_decreaseMc["pos"+i].removeChildren();
				
				this["_stepNumber_"+i] = new CWidgetCDNumber(24, 29);
				_decreaseMc["pos"+i].addChild(this["_stepNumber_"+i]);
			}
			updateStepMc();
			
			_decreaseTimeMc = mc.mc_time;
			for(var j :int = 0 ;j < 6 ; j++)
			{
				_decreaseTimeMc["pos"+j].removeChildren();
				
				this["_cdNumber_"+j] = new CWidgetCDNumber(23, 41, "matchNumberStep");
				_decreaseTimeMc["pos"+j].addChild(this["_cdNumber_"+j]);
			}
			updateTimeMc();
			
			updateRank(null);
			
			CBaseUtil.regEvent(GameNotification.EVENT_MATCH_UPDATA, updateRank);
		}
		
		public function updateTimeMc(isBingoTime:Boolean = false):void
		{
			var numArray:Array = new Array();
			
			if(_timeRemain < _soundWarningLimitTime && _timeRemain < _lastPlayedTime)
			{
				_lastPlayedTime = _timeRemain ; 
				
				if(!_warningPlayed && !isBingoTime)
				{
					CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_WARNING);
				}
			}
			
			if(_timeRemain <= 0)
			{
				_cdTimer.delCallback(updateTimeMc);
			}
			
			var hour:int = int(_timeRemain / 3600);
			var min:int = int(_timeRemain / 60) - hour *　60;
			var seconds:int = _timeRemain - min * 60;
			
			_timeRemain -= 1;
			
			if(hour < 10)
			{
				numArray.push(0);
				numArray.push(hour.toString());
			}
			else
			{
				var h:Array = CStringUtil.splitNumtoStr(hour);
				numArray.push(h[0] , h[1]);
			}
			
			if(min < 10)
			{
				numArray.push(0);
				numArray.push(min.toString());
			}
			else
			{
				var t:Array = CStringUtil.splitNumtoStr(min);
				numArray.push(t[0] , t[1]);
			}
			
			if(seconds < 10)
			{
				numArray.push(0);
				numArray.push(seconds.toString());
			}
			else
			{
				var p:Array = CStringUtil.splitNumtoStr(seconds);
				numArray.push(p[0] , p[1]);
			}
			
			_drawTimeArray(numArray);
		}
		
		public function updateStepMc(isBingoTime:Boolean = false):void
		{
			var remainStepNumber:int = _dataOfLevel.stepLimit - _d.swapStep;
			
			remainStepNumber = remainStepNumber > 0 ? remainStepNumber : 0;
			
			if(remainStepNumber % 2 == 0 && _lastStep != remainStepNumber)
			{
				_lastStep = remainStepNumber;
				NetworkManager.instance.reqMatchInfo(1, 8);
			}
			
			if(remainStepNumber < _soundWarningLimitStep && remainStepNumber < _lastPlayedStep)
			{
				_lastPlayedStep = remainStepNumber;
				
				if(!_warningPlayed && !isBingoTime)
				{
					CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_WARNING);
				}
			}
			
			if(remainStepNumber == 0)
			{
				_timer.delCallback(updateStepMc);
			}
			
			var numArray:Array = CStringUtil.splitNumtoStr(remainStepNumber);
			
			for(var i :int = numArray.length ;i < 4 ; i++)
			{
				numArray.unshift(0);
			}
			
			_drawArray(numArray);
		}
		
		private function _drawArray(numArray:Array):void
		{
			for(var i :int = 0 ;i < numArray.length ; i++)
			{
				this["_stepNumber_"+i].setNumber(numArray[i]);
			}	
		}
		
		private function _drawTimeArray(numArray:Array):void
		{
			for(var i :int = 0 ;i < numArray.length ; i++)
			{
				this["_cdNumber_"+i].setNumber(numArray[i]);
			}	
		}
		
		private function _onSendReq():void
		{
			if(DataUtil.instance.selectMatchProductID != 0)
			{
				if(this._timeCount % 30 == 0)
				{
					//更新比赛信息
					NetworkManager.instance.sendLobbyPlayerMatchInfo(DataUtil.instance.selectMatchProductID);
					NetworkManager.instance.sendLobbyMatchOrder(DataUtil.instance.selectMatchProductID, new UInt64(0,0), 1, 8);
				}
				if(this._timeCount % 5 == 0)
				{
					NetworkManager.instance.sendLobbyMatchInfo(DataUtil.instance.selectMatchProductID);
				}
			}
			_timeCount++;
		}
		
		public function startUpate():void
		{
			_timer.addCallback(updateStepMc , 1);
			_cdTimer.addCallback(updateTimeMc , 1);
			_sendTimer.addCallback(_onSendReq, 1);
			_timer.start();
			_cdTimer.start();
			_sendTimer.start();
		}
		
		public function updateRank(n:Notification):void
		{
			_matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID)
				
			if(_matchData.matchCD == 0)
			{
				CBaseUtil.removeEvent(GameNotification.EVENT_MATCH_UPDATA, updateRank);
				_isRemoveEvent = true;
				return;
			}
			
			this._timeRemain = _matchData.matchCD / 1000;
			_rankTxt.text = _matchData.matchRank + "/" + _matchData.signUpNum;
		}
		
		override protected function dispose():void
		{
			super.dispose();
			_timer.delCallback(updateStepMc);
			_cdTimer.delCallback(updateTimeMc);
			_sendTimer.delCallback(_onSendReq);
			_timeCount = 0;
			
			if(_isRemoveEvent)
			{
				return;
			}
			CBaseUtil.removeEvent(GameNotification.EVENT_MATCH_UPDATA, updateRank);
		}
	}
}