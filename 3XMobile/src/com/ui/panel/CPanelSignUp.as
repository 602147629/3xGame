package com.ui.panel
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.netease.protobuf.UInt64;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemMatchAward;
	import com.ui.item.CItemMatchRank;
	import com.ui.item.CItemSignUpButton;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CTimer;
	import com.ui.widget.CWidgetMatchList;
	import com.ui.widget.CWidgetPageTool;
	import com.ui.widget.CWidgetScrollBar;
	
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.resource.faxb.award.MatchAward;
	import framework.resource.faxb.award.MatchInfo;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.MatchOrder;
	import qihoo.gamelobby.protos.SignCost;
	import qihoo.gamelobby.protos.UDV;
	
	public class CPanelSignUp extends CPanelAbstract
	{
		private var _awardBtn:CButtonCommon;
		private var _rankBtn:CButtonCommon;
		private var _quickBtn:CButtonCommon;
		private var _ruleBtn:CButtonCommon;
		private var _posBtn:CButtonCommon;
		private var _addCountBtn:CButtonCommon;
		private var _signUpBtn:CItemSignUpButton;
		
		private var _awardScrollPane:CWidgetScrollBar;
		
		private var _rankPane:Sprite;
		private var _rankPageTool:CWidgetPageTool;
		private static const RANK_PAGE_NUM:int = 8;
		
		private var _nameTxt:TextField;
		private var _timeTxt:TextField;
		
		private var _signUpNumTxt:TextField;
		private var _rankNumTxt:TextField;
		private var _gameNumTxt:TextField;
		
		private var _hourNumTxt:TextField;
		private var _minuteNumTxt:TextField;
		private var _secondNumTxt:TextField;
		
		private var _matchList:CWidgetMatchList;
			
		/**
		 * 比赛开始倒计时 
		 */		
		private var _cdTimer:CTimer;
		
		private var _isUpdating:Boolean;
		/**
		 * 发送请求 
		 */		
		private var _sendTimer:CTimer;
		/**
		 * 比赛时间 
		 */		
		private var _cdTime:Number;
		
		private var _timeCount:int;
		
		/**
		 * 当前比赛的信息 
		 */		
		private var _currentMatchAward:MatchInfo;
		
		public function CPanelSignUp()
		{
			super(ConstantUI.PANEL_SIGNUP, false);
		}
		
		override protected function drawContent():void
		{
			var oldSize:Point = new Point(mc.width , mc.height);
			
			var closeBtn:CButtonCommon = new CButtonCommon("close1");
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 , true);
			mc.closepos.addChild(closeBtn);
			
			this._sendTimer = new CTimer();
			this._sendTimer.addCallback(__onSendReq, 1);
			this._sendTimer.start();
			
			_currentMatchAward = CBaseUtil.getMatchAwardByID(DataUtil.instance.selectMatchProductID);
			
			__initLeftTop();
			
			__initRightTop();
			
			__initBottom();
			
			__initMatch();
			
			CBaseUtil.centerUI(mc , oldSize);
			
			CBaseUtil.regEvent(GameNotification.EVENT_MATCH_UPDATA, __onUpdataMatch);
			CBaseUtil.regEvent(GameNotification.EVENT_MATCH_UPDATA_ORDER, __onUpdataMatchOrder);
			CBaseUtil.regEvent(GameNotification.EVENT_CHANGE_MATCH_ITEM, __onChangeMatchInfo);
			CBaseUtil.regEvent(GameNotification.EVENT_CHANGE_PAGE, __onChangePage);
		}
		
		private function __onChangePage(d:Notification):void
		{
			var currentPage:int = _rankPageTool.currentPage;
			var min:int = RANK_PAGE_NUM * (currentPage - 1) + 1;
			var max:int = RANK_PAGE_NUM * currentPage;
			NetworkManager.instance.sendLobbyMatchOrder(DataUtil.instance.selectMatchProductID, new UInt64(0,0), min, max);
		}
		
		private function __initBottom():void
		{
			_matchList = new CWidgetMatchList();
			mc.list.addChild(_matchList);
			
			_quickBtn = new CButtonCommon("z_n5_quickstart");
			mc.quickBtn.addChild(_quickBtn);
			_quickBtn.addEventListener(TouchEvent.TOUCH_TAP, __onQuick);
		}
		
		protected function __onQuick(event:TouchEvent):void
		{
			var quickMatchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getQuickMatch();
			if(quickMatchData)
			{
				DataUtil.instance.selectMatchProductID = quickMatchData.productID;
				CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_MATCH_ITEM, DataUtil.instance.selectMatchProductID);
				CBaseUtil.popSignUp(DataUtil.instance.selectMatchProductID, __popSignUp);
			}else
			{
				CBaseUtil.showConfirm("当前没有可以开始的比赛", new Function());
			}
			
		}
		
		private function __initRightTop():void
		{
			var tf:TextFormat = CFontUtil.getTextFormat(14, 0xffffff);
			_awardBtn = new CButtonCommon("z_n6_tab", "奖励", tf, 0x043362);
			mc.btn1.addChild(_awardBtn);
			_awardBtn.addEventListener(TouchEvent.TOUCH_OVER, __awardBtnClick);
			
			_rankBtn = new CButtonCommon("z_n6_tab", "英雄榜", tf, 0x043362);
			mc.btn2.addChild(_rankBtn);
			_rankBtn.addEventListener(TouchEvent.TOUCH_OVER, __rankBtnClick);
			
			_rankPageTool = new CWidgetPageTool();
			_rankPageTool.currentPage = 1;
			_rankPageTool.totalPage = 1;
			mc.page.addChild(_rankPageTool);
			
			__awardBtnClick();
			
			CBaseUtil.delayCall(__rankBtnClick, 5, 1);
		}
		
		protected function __awardBtnClick(event:TouchEvent = null):void
		{
			if(_awardBtn.selected)
			{
				return;			
			}
			mc.rank.gotoAndStop(1);
			_awardBtn.selected = true;
			_rankBtn.selected = false;
			_awardScrollPane = CBaseUtil.createCWidgetScrollBar(ConstantUI.CONST_UI_BG_SCROLLBAR, 
				ConstantUI.CONST_UI_BG_SCROLLLINE,
				new Rectangle(1, 50, 1, 80) , 
				new Point(3 , 200),
				new Point(300, 8 * 28),
				-5);
			mc.rank.awardPanel.addChild(_awardScrollPane);
			mc.page.visible = false;
			__showAward();
		}
		
		protected function __rankBtnClick(event:TouchEvent = null):void
		{
			if(_rankBtn.selected)
			{
				return;			
			}
			if(mc == null)
			{
				return;
			}
			mc.rank.gotoAndStop(2);
			_rankBtn.selected = true;
			_awardBtn.selected = false;
			_rankPane = new Sprite();
			mc.rank.rankPanel.addChild(_rankPane);
			mc.page.visible = true;
			__onUpdataMatchOrder(null);
		}
		
		private function __initLeftTop():void
		{
			this._signUpBtn = new CItemSignUpButton();
			mc.btn.addChild(this._signUpBtn);
			this._signUpBtn.addEventListener(TouchEvent.TOUCH_TAP, __signUpMatch);
			
			this._posBtn = new CButtonCommon("z_n93_gps");
			this._posBtn.visible = false;
			mc.pos.addChild(this._posBtn);
			_posBtn.addEventListener(TouchEvent.TOUCH_TAP, __posClick);
			_posBtn.addEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_posBtn.addEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			this._ruleBtn = new CButtonCommon("z_n8_rule");
			mc.rule.addChild(this._ruleBtn);
			_ruleBtn.addEventListener(TouchEvent.TOUCH_TAP, __ruleClick);
			_ruleBtn.addEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_ruleBtn.addEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			this._addCountBtn = new CButtonCommon("blue", "购买次数");
			this._addCountBtn.visible = false;
			mc.addpos.addChild(this._addCountBtn);
			_addCountBtn.addEventListener(TouchEvent.TOUCH_TAP, __addCountClick);
			_addCountBtn.addEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_addCountBtn.addEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			_nameTxt = CBaseUtil.getTextField(mc.titleTxt, 20, 0xffffff);
			_timeTxt = CBaseUtil.getTextField(mc.timeTxt, 16, 0xffffff, "left");
			
			_signUpNumTxt = CBaseUtil.getTextField(mc.signUpNum, 18, 0xffff00, "left");
			_signUpNumTxt.text = "--";
			
			_rankNumTxt = CBaseUtil.getTextField(mc.rankNum, 16, 0xffffff, "left");
			_rankNumTxt.text = "--";
			
			_gameNumTxt = CBaseUtil.getTextField(mc.gameNum, 16, 0xffffff, "left");
			_gameNumTxt.text = "--";
			
			_hourNumTxt = CBaseUtil.getTextField(mc.hourNum, 25, 0xFAFA95);
			_hourNumTxt.text = "--";
			
			_minuteNumTxt = CBaseUtil.getTextField(mc.minuteNum, 25, 0xFAFA95);
			_minuteNumTxt.text = "--";
			
			_secondNumTxt = CBaseUtil.getTextField(mc.secondNum, 25, 0xFAFA95);
			_secondNumTxt.text = "--";
		}
		
		protected function __addCountClick(event:TouchEvent):void
		{
			CBaseUtil.popSignUp(DataUtil.instance.selectMatchProductID, __popSignUp);
		}
		
		protected function __posClick(event:TouchEvent):void
		{
			__rankBtnClick();
			
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			_rankPageTool.currentPage = Math.ceil(matchData.matchRank / RANK_PAGE_NUM);
			
			var currentPage:int = _rankPageTool.currentPage;
			var min:int = RANK_PAGE_NUM * (currentPage - 1) + 1;
			var max:int = RANK_PAGE_NUM * currentPage;
			NetworkManager.instance.sendLobbyMatchOrder(DataUtil.instance.selectMatchProductID, new UInt64(0,0), min, max);
		}
		
		protected function __btnMouseOut(event:TouchEvent):void
		{
			CBaseUtil.closeTip();
		}
		
		protected function __btnMouseOver(event:TouchEvent):void
		{
			switch(event.currentTarget)
			{
				case _ruleBtn:
					var pos:Point = _ruleBtn.localToGlobal(new Point(-_ruleBtn.width /2 - 5  , _ruleBtn.y));
					CBaseUtil.showTip("比赛规则" , pos , new Point(80,25) , true);
					break;
				case _posBtn:
					var pos1:Point = _posBtn.localToGlobal(new Point(-_posBtn.width /2 - 15  , _posBtn.y));
					CBaseUtil.showTip("我的位置" , pos1 , new Point(80,25) , true);
					break;
				case _addCountBtn:
					var pos2:Point = _addCountBtn.localToGlobal(new Point(-_addCountBtn.width /2 - 15  , _addCountBtn.y));
					CBaseUtil.showTip("增加挑战次数" , pos2 , new Point(80,25) , true);
					break;
			}
		}
		
		private function __ruleClick(e:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,new DatagramViewNormal("panel.match.rule"));
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_MATCH_UPDATA, __onUpdataMatch);
			CBaseUtil.removeEvent(GameNotification.EVENT_MATCH_UPDATA_ORDER, __onUpdataMatchOrder);
			CBaseUtil.removeEvent(GameNotification.EVENT_CHANGE_MATCH_ITEM, __onChangeMatchInfo);
			CBaseUtil.removeEvent(GameNotification.EVENT_CHANGE_PAGE, __onChangePage);
			
			_awardBtn.removeEventListener(TouchEvent.TOUCH_OVER, __awardBtnClick);
			_rankBtn.removeEventListener(TouchEvent.TOUCH_OVER, __rankBtnClick);
			_signUpBtn.removeEventListener(TouchEvent.TOUCH_TAP, __signUpMatch);
			_ruleBtn.removeEventListener(TouchEvent.TOUCH_TAP, __ruleClick);
			_ruleBtn.removeEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_ruleBtn.removeEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			_posBtn.removeEventListener(TouchEvent.TOUCH_TAP, __posClick);
			_posBtn.removeEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_posBtn.removeEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			_addCountBtn.removeEventListener(TouchEvent.TOUCH_TAP, __addCountClick);
			_addCountBtn.removeEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_addCountBtn.removeEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			this._signUpBtn = null;
			this._timeCount = 0;
			if(this._cdTimer != null)
			{
				this._cdTimer.delCallback(__onCountDown);
				this._cdTimer = null;
			}
			if(this._sendTimer != null)
			{
				this._sendTimer.delCallback(__onSendReq);
				this._sendTimer = null;
			}
		}
		
		protected function __initMatch():void
		{
			_isUpdating = false;
			
			mc.icon.gotoAndStop(1);
			_currentMatchAward = CBaseUtil.getMatchAwardByID(DataUtil.instance.selectMatchProductID);
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			if(_currentMatchAward == null)
			{
				return;
			}
			mc.icon.gotoAndStop(_currentMatchAward.matchIcon);
			
			_nameTxt.text = _currentMatchAward.name;
			
			var startStr:String = CBaseUtil.getHourString(matchData.startTime);
			var endStr:String = CBaseUtil.getHourString(matchData.endTime);
			
			_timeTxt.text = "每天 " + startStr + " - " + endStr + " 开赛";
		}
		
		protected function __onUpdataMatch(n:Notification):void
		{
			if(int(n.data.id) != DataUtil.instance.selectMatchProductID)
			{
				return;	
			}
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			if(matchData.matchCD == 0)
			{
				mc.cdTitle.gotoAndStop(2);
			}else
			{
				mc.cdTitle.gotoAndStop(1);
			}
			this.__matchInfo(matchData);
			this.__showSignUpBtn(matchData);
			
			if(n.data.flog)
			{
				this.__showMatchCD(matchData);
			}
		}
		
		protected function __onUpdataMatchOrder(n:Notification):void
		{
			if(_rankPane == null)
			{
				if(_rankPageTool != null)
				{
					_rankPageTool.visible = false;
				}
				return;
			}
			
			while(_rankPane.numChildren)
			{
				_rankPane.removeChildAt(0);
			}
			
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			if(matchData.rankList == null || matchData.rankList.length == 0)
			{
				if(_rankPageTool != null)
				{
					_rankPageTool.visible = false;
				}
				return;
			}
			
			_rankPageTool.visible = true;
			matchData.rankList.sortOn("order", Array.NUMERIC);
			var index:int;
			var len:int = matchData.rankList.length;
			var matchOrder:MatchOrder;
			var matchRankItem:CItemMatchRank;
			for(index = 0; index < len; index++)
			{
				matchOrder = matchData.rankList[index];
				matchRankItem = new CItemMatchRank("panel.signup.rank");
				matchRankItem.setRankData(matchOrder, matchData.productID);
				matchRankItem.y = index * 25;
				_rankPane.addChild(matchRankItem);
			}
			
			var totalPageNum:int = Math.ceil(matchData.remainCount / RANK_PAGE_NUM);
			_rankPageTool.totalPage = totalPageNum;
		}
		
		protected function __onChangeMatchInfo(d:Notification):void
		{
			__initMatch();
			_rankPageTool.currentPage = 1;
			NetworkManager.instance.reqMatchInfo(1, 8);
			
			__showAward();
			__onUpdataMatchOrder(null);
		}
		
		private function __showMatchCD(matchData:CDataOfMatch):void
		{
			if(this._cdTimer == null)
			{
				_cdTimer = new CTimer();
				_cdTimer.addCallback(__onCountDown , 1);
				this._cdTimer.start();
			}
//			else
//			{
//				_isUpdating = true;
//			}
			
			var startCD:Number = matchData.startTime - DataUtil.instance.systemTime * 1000;
			
			if(startCD > 0)
			{
				this._cdTime = startCD;
			}else
			{
				this._cdTime = matchData.matchCD == 0 ? matchData.waitCD : matchData.matchCD;
			}
			
			if(!_isUpdating)
			{
				var timeStr:String = CBaseUtil.getTimeString(this._cdTime);
				var timeArr:Array = timeStr.split(":");
				this._hourNumTxt.text = timeArr[0] == null ? "00" : timeArr[0];
				this._minuteNumTxt.text = timeArr[1] == null ? "00" : timeArr[1];
				this._secondNumTxt.text = timeArr[2] == null ? "00" : timeArr[2];
				
				_isUpdating = true;
			}
			
//			CBaseUtil.delayCall(function ():void{_isUpdating = false;}, 1, 1);
		}
		
		/**
		 * 比赛倒计时 
		 * 
		 */		
		private function __onCountDown():void
		{
//			if(_isUpdating)
//			{
//				return;
//			}
			this._cdTime -= 1000;
			var timeStr:String = CBaseUtil.getTimeString(this._cdTime);
			var timeArr:Array = timeStr.split(":");
			this._hourNumTxt.text = timeArr[0] == null ? "00" : timeArr[0];
			this._minuteNumTxt.text = timeArr[1] == null ? "00" : timeArr[1];
			this._secondNumTxt.text = timeArr[2] == null ? "00" : timeArr[2];
			if(this._cdTime <= 0)
			{
//				this._isUpdating = false;
				NetworkManager.instance.sendLobbyPlayerMatchInfo(DataUtil.instance.selectMatchProductID);
				NetworkManager.instance.sendLobbyMatchInfo(DataUtil.instance.selectMatchProductID);
				
				this._cdTimer.delCallback(__onCountDown);
				this._cdTimer = null;
			}
		}
		
		private function __onSendReq():void
		{
			if(this._timeCount % 30 == 0)
			{
				if(DataUtil.instance.selectMatchProductID != 0)
				{
					//更新比赛信息
					NetworkManager.instance.sendLobbyPlayerMatchInfo(DataUtil.instance.selectMatchProductID);
					
					var currentPage:int = _rankPageTool.currentPage;
					var min:int = RANK_PAGE_NUM * (currentPage - 1) + 1;
					var max:int = RANK_PAGE_NUM * currentPage;
					NetworkManager.instance.sendLobbyMatchOrder(DataUtil.instance.selectMatchProductID, new UInt64(0,0), min, max);
				}
			}
			if(this._timeCount % 5 == 0)
			{
				for each(var matchData:CDataOfMatch in CDataManager.getInstance().dataOfProduct.matchList)
				{
					NetworkManager.instance.sendLobbyMatchInfo(matchData.productID);
				}
			}
			
			_timeCount++;
		}
		
		private function __showSignUpBtn(matchData:CDataOfMatch):void
		{
			var btnStr:String = "";
			var btnID:int;
			
			var str:String = "";
			var id:int;
			var udv:UDV;
			for each(udv in matchData.signUpCost)
			{
				var obj:Object = CBaseUtil.signUpCostToNum(udv);
				str += CBaseUtil.num2text(obj.num, 10000) + " ";
				id = obj.id;
			}
			str = str == "" || str == "0 " ? "免费 " : str;
			
			var reNum:int = Math.max(matchData.currentRobNum - 1, 0);
			
			var signCost:SignCost; 
			if(matchData.replayCost)
			{
				signCost = matchData.replayCost[reNum];
			}
			
			var list:Array = signCost ? signCost.udv : new Array();
			
			var replayStr:String = "";
			var reID:int;
			for each(udv in list)
			{
				var reObj:Object = CBaseUtil.signUpCostToNum(udv);
				replayStr += CBaseUtil.num2text(reObj.num, 10000) + " ";
				reID = reObj.id;
			}
			replayStr = replayStr == "" || replayStr == "0 " ? "免费 " : replayStr;
			
			var max:Number = matchData.maxRobNum + 1;
			var total:Number = matchData.totalRobNum + 1;
			var cur:Number = matchData.currentRobNum;
			
			if(matchData.totalRobNum == 0)
			{
				_gameNumTxt.text = "--";
				total = 0;
			}else
			{
				_gameNumTxt.text = cur + "/" + total;
				
				if(cur >= total && cur < max)
				{
					this._addCountBtn.visible = true;
				}
				else
				{
					this._addCountBtn.visible = false;
				}
			}
			
			btnStr = matchData.currentRobNum == 0 ? str : replayStr;
			btnID = matchData.currentRobNum == 0 ? id : reID;
			
			if(matchData.currentRobNum == 0)
			{
				btnStr += " " + "立即报名";
			}else if(matchData.currentRobNum > 0)
			{
				btnStr += " " + "重新挑战";
			}
			this._signUpBtn.setIcon(btnID);
			
			if(cur >= total)
			{
				if(matchData.totalRobNum == 0)
				{
					this._signUpBtn.setSignUpBtnText("等待比赛开始");
				}else
				{
					this._signUpBtn.setSignUpBtnText("挑战次数已用尽");
				}
				this._signUpBtn.isShowIcon = false;
				this._signUpBtn.enabled = false;
			}else
			{
				this._signUpBtn.isShowIcon = true;
				this._signUpBtn.setSignUpBtnText(btnStr);
				this._signUpBtn.enabled = true;
			}
		}
		
		private function __matchInfo(matchData:CDataOfMatch):void
		{
			_signUpNumTxt.text = "" + matchData.signUpNum + "人";
			_rankNumTxt.text = "" + matchData.matchRank;
			if(matchData.matchRank == 0)
			{
				this._posBtn.visible = false;
			}
			else
			{
				this._posBtn.visible = true;
			}
		}
		
		protected function __showAward():void
		{
			if(_currentMatchAward == null)
			{
				return;
			}
			_awardScrollPane.clear();
			
			var awardList:Vector.<MatchAward> = _currentMatchAward.award;
			var index:int;
			var len:int = awardList.length;
			var matchAward:MatchAward;
			var matchAwardItem:CItemMatchAward;
			for(index = 0; index < len; index++)
			{
				matchAward = awardList[index];
				matchAwardItem = new CItemMatchAward("panel.signup.award");
				matchAwardItem.setAwardData(matchAward);
				_awardScrollPane.addItem(matchAwardItem);
			}
		}
		
		protected function __signUpMatch(event:TouchEvent):void
		{
			if(!this._signUpBtn.isEnabled)
			{
				return;
			}
			CBaseUtil.popSignUp(DataUtil.instance.selectMatchProductID, __popSignUp);
		}
		
		private function __popSignUp(curCost:Object):void
		{
			if(curCost.id == 2)
			{
				if(CDataManager.getInstance().dataOfMoney.silver < curCost.num)
				{
					CBaseUtil.showConfirm("亲爱的玩家，您的银豆不足！", new Function());
					return;
				}
			}
			else if(curCost.id == 1)
			{
				if(CDataManager.getInstance().dataOfMoney.gold < curCost.num)
				{
					CBaseUtil.showConfirm("亲爱的玩家，您的金豆不足！", new Function());
					return;
				}
			}
			
			CBaseUtil.showLoading();
			WebJSManager.setPropValue(1);
			NetworkManager.instance.isMatching = true;
			NetworkManager.instance.sendLobbySignUpMatch(DataUtil.instance.selectMatchProductID);
			__onClose(null);
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_SIGNUP));
		}
	}
}