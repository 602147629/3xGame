package com.ui.panel
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemSignUpButton;
	import com.ui.util.CBaseUtil;
	
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.SignCost;
	import qihoo.gamelobby.protos.UDV;

	public class CPanelMatchResult extends CPanelAbstract
	{
		private var _signUpBtn:CItemSignUpButton;
		private var _addCountBtn:CButtonCommon;
		private var _matchData:CDataOfMatch;
		
		private var _scoreTxt:TextField;
		private var _curscoreTxt:TextField;
		private var _rankTxt:TextField;
		private var _robTxt:TextField;
		
		private var _currentCost:Object;
		
		private var _isRemoveEvent:Boolean;
		private var _isHasRegister:Boolean = false;
		
		public function CPanelMatchResult()
		{
			super(ConstantUI.PANEL_MATCH_RESULT);
		}
		
		override protected function drawContent():void
		{
			if(!NetworkManager.instance.isMatchOver)
			{
				var closeBtn:CButtonCommon = new CButtonCommon("close");
				closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 , true);
				mc.closepos.addChild(closeBtn);
				
				this._signUpBtn = new CItemSignUpButton();
				this._signUpBtn.addEventListener(TouchEvent.TOUCH_TAP, _signUpMatch);
				mc.btn.addChild(this._signUpBtn);
				
				this._addCountBtn = new CButtonCommon("blue", "购买次数");
				this._addCountBtn.visible = false;
				mc.addpos.addChild(this._addCountBtn);
				_addCountBtn.addEventListener(TouchEvent.TOUCH_TAP, __addCountClick);
				_addCountBtn.addEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
				_addCountBtn.addEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			}
			
			var exitBtn:CButtonCommon = new CButtonCommon("yellowlong","退出比赛");
			exitBtn.addEventListener(TouchEvent.TOUCH_TAP, __onExit, false, 0 , true);
			exitBtn.x = NetworkManager.instance.isMatchOver ? 105 : 200;
			mc.btn.addChild(exitBtn);
			
			var tf:TextField = CBaseUtil.getTextField(mc.tipsTxt, 14, 0xFAFA95, "left");
			tf.text = mc.tipsTxt.text;
			
			_scoreTxt = CBaseUtil.getTextField(mc.scoreTxt, 16, 0xcf5e02, "left");
			_scoreTxt.text = "0";
			
			_curscoreTxt = CBaseUtil.getTextField(mc.curscoreTxt, 16, 0xcf5e02, "left");
			_curscoreTxt.text = "0";
			
			_rankTxt = CBaseUtil.getTextField(mc.rankTxt, 16, 0xcf5e02, "left");
			_rankTxt.text = "--";
			
			_robTxt = CBaseUtil.getTextField(mc.robTxt, 16, 0xcf5e02, "left");
			_robTxt.text = "--";
			
			__drawScaleBg();
			
			CBaseUtil.regEvent(GameNotification.EVENT_MATCH_UPDATA, _onUpdataMatch);
			_isRemoveEvent = false;
			_isHasRegister = true;
			
			_onUpdataMatch(null);
			
		}
		
		override protected function dispose():void
		{
			if(_isHasRegister)
			{				
				CBaseUtil.removeEvent(GameNotification.EVENT_MATCH_UPDATA, _onUpdataMatch);
				_isHasRegister = false;
			}
			
			_addCountBtn.removeEventListener(TouchEvent.TOUCH_TAP, __addCountClick);
			_addCountBtn.removeEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_addCountBtn.removeEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			_signUpBtn.removeEventListener(TouchEvent.TOUCH_TAP, _signUpMatch);
		}
		
		protected function _onUpdataMatch(n:Notification):void
		{
			if(_isRemoveEvent)
			{
				return;
			}
			_matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			
			if(_matchData == null)
			{
				return;
			}
			var currentScore:int = CDataManager.getInstance().dataOfLevel.d.score;
			_scoreTxt.text = "" + Math.max(_matchData.maxScore, currentScore);
			_curscoreTxt.text = "" + currentScore;
			_rankTxt.text = "" + _matchData.matchRank;
			
			
			if(_matchData.matchCD == 0)
			{
				if(mc != null)
				{					
					mc.closepos.visible = false;
				}
				
				if(_signUpBtn != null)
				{
					this._signUpBtn.enabled = false;
				}
				
				if(_addCountBtn != null)
				{
					this._addCountBtn.visible = false;
				}
			
				_isRemoveEvent = true;
			}
		}
		
		protected function __drawScaleBg():void
		{
			mc.bgpos.addChild(CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , 
				new Rectangle(195,50,2,2) , 
				new Point(450 , 288)));
			
			_matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			
			var btnStr:String = "";
			var btnID:int;
			var udv:UDV;
			
			var reNum:int = Math.max(_matchData.currentRobNum, 0);
			
			var signCost:SignCost = _matchData.replayCost[reNum];
			
			var list:Array = signCost ? signCost.udv : new Array();
			
			var replayStr:String = "";
			for each(udv in list)
			{
				var reObj:Object = CBaseUtil.signUpCostToNum(udv);
				replayStr += CBaseUtil.num2text(reObj.num, 10000) + " ";
				btnID = reObj.id;
				
				_currentCost = new Object();
				_currentCost.num = reObj.num;
				_currentCost.id = reObj.id;
			}
			
			if(list.length == 0)
			{
				_currentCost = new Object();
				_currentCost.num = 0;
				_currentCost.id = 2;
			}
			
			replayStr = replayStr == "" || replayStr == "0 " ? "免费" : replayStr;
			
			var max:Number = _matchData.maxRobNum + 1;
			var total:Number = _matchData.totalRobNum + 1;
			var cur:Number = _matchData.isPlaying ? (_matchData.currentRobNum + 1) : _matchData.currentRobNum;
			_robTxt.text = cur + "/" + total;
			
			if(cur >= total && cur < max && !NetworkManager.instance.isMatchOver)
			{
				this._addCountBtn.visible = true;
			}
			else
			{
				this._addCountBtn.visible = false;
			}
			
			btnStr = replayStr;
			
			btnStr += " " + "重新挑战";
			
			if(this._signUpBtn)
			{
				this._signUpBtn.setIcon(btnID);
				this._signUpBtn.setSignUpBtnText(btnStr);
				if(cur >= total)
				{
					this._signUpBtn.setSignUpBtnText("挑战次数已用尽");
					this._signUpBtn.isShowIcon = false;
					this._signUpBtn.enabled = false;
				}else
				{
					this._signUpBtn.isShowIcon = true;
					this._signUpBtn.enabled = true;
				}
			}
		}
		
		protected function __addCountClick(event:TouchEvent):void
		{
			__replayMatch();
		}
		
		protected function __btnMouseOut(event:TouchEvent):void
		{
			CBaseUtil.closeTip();
		}
		
		protected function __btnMouseOver(event:TouchEvent):void
		{
			switch(event.currentTarget)
			{
				case _addCountBtn:
					var pos2:Point = _addCountBtn.localToGlobal(new Point(-_addCountBtn.width /2 - 15  , _addCountBtn.y));
					CBaseUtil.showTip("增加挑战次数" , pos2 , new Point(80,25) , true);
					break;
			}
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_MATCH_RESULT));
			
			if(event != null)
			{
				var remainStepNumber:int = CDataManager.getInstance().dataOfLevel.stepLimit - CDataManager.getInstance().dataOfLevel.d.swapStep;
				if(remainStepNumber <= 0)
				{
					CBaseUtil.showLoading();
					NetworkManager.instance.isActiveStop = true;
					NetworkManager.instance.sendMatchStopMatch();
				}
			}
		}
		
		protected function __onExit(event:TouchEvent):void
		{
			CBaseUtil.popSignUpWin();
			
			if(NetworkManager.instance.isPassiveStop)
			{
				NetworkManager.instance.isPassiveStop = false;
				NetworkManager.instance.isMatching = false;
				Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
				Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
			}else
			{
				CBaseUtil.showLoading();
				NetworkManager.instance.isActiveStop = true;
				NetworkManager.instance.sendMatchStopMatch();
			}
			this.__onClose(null);
			
			
			CDataManager.getInstance().dataOfLevel.reset();
			
			NetworkManager.instance.sendServerGetFriendList();
			
			NetworkManager.instance.sendServerGetCoin();
			
			NetworkManager.instance.isMatchOver = false;
		}
		
		protected function _signUpMatch(event:TouchEvent):void
		{
			if(!this._signUpBtn.isEnabled)
			{
				return;
			}
			
			__replayMatch();
		}
		
		private function __replayMatch():void
		{
			var nums:Array = _robTxt.text.split("/");
			if(int(nums[0]) >= int(nums[1]))
			{
				CBaseUtil.showConfirm("您的挑战次数已用尽", new Function());
				return;
			}
			
			_matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			
			if(_matchData.matchCD - _matchData.matchEndTime <= 0)
			{
				CBaseUtil.showConfirm("当前比赛马上结束了，请等待报名下一场比赛", new Function());
				return;
			}
			
			if(_currentCost)
			{
				if(_currentCost.id == 2)
				{
					if(CDataManager.getInstance().dataOfMoney.silver < _currentCost.num)
					{
						CBaseUtil.showConfirm("亲爱的玩家，您的银豆不足！", new Function());
						return;
					}
				}
				else if(_currentCost.id == 1)
				{
					if(CDataManager.getInstance().dataOfMoney.gold < _currentCost.num)
					{
						CBaseUtil.showConfirm("亲爱的玩家，您的金豆不足！", new Function());
						return;
					}
				}
			}
			
			this.__onClose(null);
			
			CBaseUtil.showLoading();
			
			NetworkManager.instance.isPassiveStop = false;
			NetworkManager.instance.isReplay = true;
			NetworkManager.instance.sendMatchStopMatch();
		}
	}
}