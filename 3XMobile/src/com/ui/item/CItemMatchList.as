package com.ui.item
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CTimer;
	
	
	import flash.events.TouchEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.resource.faxb.award.MatchInfo;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	public class CItemMatchList extends CItemAbstract
	{
		private var _signUpBtn:CButtonCommon;
		
		private var _timeTxt:TextField;
		private var _numTxt:TextField;
		private var _nameTxt:TextField;
		
		private var _currentMatchAward:MatchInfo;
		private var _currentMatchData:CDataOfMatch;
		private var _currentProductID:int;
		
		private var _startCD:Number;
		
		private var _startTime:CTimer;
		
		private var _isSelected:Boolean;
		
		public function CItemMatchList(productID:int)
		{
			this._currentProductID = productID;
			
			super("panel.signup.matchItem");
		}
		
		override protected function drawContent():void
		{
			mc.buttonMode = true;
			
			mc.selectback.visible = false;
			
			_timeTxt = CBaseUtil.getTextField(mc.timeTxt, 12, 0xffffff);
			_timeTxt.visible = false;
			
			_nameTxt = CBaseUtil.getTextField(mc.nameTxt, 16, 0xFCF895);
			
			_numTxt = CBaseUtil.getTextField(mc.numMC.numTxt, 12, 0xFCF895, "left");
			__changeNumPos();
			
			var tf:TextFormat = CFontUtil.getTextFormat(14);
			_signUpBtn = new CButtonCommon("green", "报名参赛", tf);
			_signUpBtn.visible = false;
			mc.signupBtn.addChild(_signUpBtn);
			_signUpBtn.addEventListener(TouchEvent.TOUCH_TAP, __onSignUpClick);
			
			mc.addEventListener(TouchEvent.TOUCH_OVER, __onMouseOver);
			mc.addEventListener(TouchEvent.TOUCH_OUT, __onMouseOut);
			mc.addEventListener(TouchEvent.TOUCH_TAP, __onMouseClick);
			
			__setItemData(_currentProductID);
			
			__defaultSelect();
			
			CBaseUtil.regEvent(GameNotification.EVENT_CHANGE_MATCH_ITEM, __changeMatchItem);
			CBaseUtil.regEvent(GameNotification.EVENT_MATCH_UPDATA, __updateMatchInfo);
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_CHANGE_MATCH_ITEM, __changeMatchItem);
			CBaseUtil.removeEvent(GameNotification.EVENT_MATCH_UPDATA, __updateMatchInfo);
			mc.removeEventListener(TouchEvent.TOUCH_OVER, __onMouseOver);
			mc.removeEventListener(TouchEvent.TOUCH_OUT, __onMouseOut);
			mc.removeEventListener(TouchEvent.TOUCH_TAP, __onMouseClick);
		}
		
		private function __defaultSelect():void
		{
			if(_currentProductID == DataUtil.instance.selectMatchProductID)
			{
				__onMouseClick(null);
			}
		}
		
		private function __changeMatchItem(d:Notification):void
		{
			var productId:int = int(d.data);
			if(productId != _currentProductID)
			{
				mc.selectback.visible = false;
				_isSelected = false;
			}else
			{
				mc.selectback.visible = true;
				mc.selectback.gotoAndStop(2);
				_isSelected = true;
			}
		}
		
		private function __updateMatchInfo(d:Notification):void
		{
			if(int(d.data.id) != _currentProductID)
			{
				return;	
			}
			_currentMatchData = CDataManager.getInstance().dataOfProduct.getMatchByID(_currentProductID);
			if(_currentMatchData == null)
			{
				return;
			}
			_numTxt.text = String(_currentMatchData.signUpNum);
			__changeNumPos();
			
			if(!d.data.flog)
			{
				return;
			}
			if(_currentMatchData.waitCD > 0)
			{
				_startCD = _currentMatchData.waitCD;
				
				if(_startTime == null && _signUpBtn.visible)
				{
					_signUpBtn.visible = false;
					_timeTxt.text = "开赛倒计时：" + CBaseUtil.getTimeString(_startCD);
					_timeTxt.visible = true;
					_startTime = new CTimer();
					_startTime.addCallback(__onCoolDown, 1);
					_startTime.start();
				}
			}
		}
		
		protected function __onSignUpClick(event:TouchEvent):void
		{
			CBaseUtil.popSignUp(this._currentProductID, __popSignUp);
		}
		
		protected function __onMouseClick(event:TouchEvent):void
		{
			if(_isSelected)
			{
				return;
			}
			mc.selectback.visible = true;
			mc.selectback.gotoAndStop(2);
			_isSelected = true;
			
			DataUtil.instance.selectMatchProductID = _currentProductID;
			CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_MATCH_ITEM, _currentProductID);
		}
		
		protected function __onMouseOver(event:TouchEvent):void
		{
			if(!_isSelected)
			{
				mc.selectback.visible = true;
				mc.selectback.gotoAndStop(1);
			}
			_startCD = _currentMatchData.startTime - DataUtil.instance.systemTime * 1000;
			
			if(_startCD <= 0)
			{
				_startCD = _currentMatchData.waitCD;
			}
			
			if(_startCD > 0)
			{
				_timeTxt.text = "开赛倒计时：" + CBaseUtil.getTimeString(_startCD);
				_timeTxt.visible = true;
				_startTime = new CTimer();
				_startTime.addCallback(__onCoolDown, 1);
				_startTime.start();
			}else
			{
				_signUpBtn.visible = true;
			}
		}
		
		protected function __onMouseOut(event:TouchEvent):void
		{
			if(!_isSelected)
			{
				mc.selectback.visible = false;
			}
			
			_signUpBtn.visible = false;
			_timeTxt.visible = false;
			if(_startTime)
			{
				_startTime.delCallback(__onCoolDown);
				_startTime = null;
			}
		}
		
		private function __setItemData(productID:int):void
		{
			mc.icon.gotoAndStop(1);
			_currentMatchAward = CBaseUtil.getMatchAwardByID(productID);
			_currentMatchData = CDataManager.getInstance().dataOfProduct.getMatchByID(productID);
			if(_currentMatchAward == null || _currentMatchData == null)
			{
				return;
			}
			
			_nameTxt.text = _currentMatchAward.shortName;
			_numTxt.text = String(_currentMatchData.signUpNum);
			__changeNumPos();
			mc.icon.gotoAndStop(_currentMatchAward.matchIcon);
		}
		
		private function __changeNumPos():void
		{
			mc.numMC.x = 123 - (12 + _numTxt.textWidth) - 20;
		}
		
		private function __onCoolDown():void
		{
			_startCD -= 1000;
			_timeTxt.text = "开赛倒计时：" + CBaseUtil.getTimeString(_startCD);
			if(_startCD <= 0)
			{
				_timeTxt.visible = false;
				_signUpBtn.visible = true;
				if(_startTime)
				{
					_startTime.delCallback(__onCoolDown);
					_startTime = null;
				}
			}
		}
		
		private function __popSignUp(curCost:Object):void
		{
			if(curCost.id == 2)
			{
				if(CDataManager.getInstance().dataOfMoney.silver < curCost.num)
				{
					CBaseUtil.showConfirm("亲爱的玩家，您的银豆不足！");
					return;
				}
			}
			
			CBaseUtil.showLoading();
			WebJSManager.setPropValue(1);
			NetworkManager.instance.isMatching = true;
			NetworkManager.instance.sendLobbySignUpMatch(DataUtil.instance.selectMatchProductID);
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_SIGNUP));
		}
	}
}