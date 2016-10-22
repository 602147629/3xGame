package com.ui.panel
{
	import com.game.consts.ConstIcon;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.game.module.CDataOfMatch;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.resource.faxb.award.MatchAward;
	import framework.resource.faxb.award.MatchInfo;
	import framework.rpc.ConfigManager;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	import qihoo.gamelobby.protos.UserOrigin;
	
	public class CPanelMatchDiploma extends CPanelAbstract
	{
		private var _iconType:int;
		private var _matchData:CDataOfMatch;
		private var _currentRank:int;
		private var _startTime:Number;
		
		public function CPanelMatchDiploma()
		{
			super(ConstantUI.PANEL_MATCH_DIPLOMA);
		}
		
		override protected function drawContent():void
		{
			var id:int = datagramView.injectParameterList["productID"];
			_matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(id);
			
			_startTime = datagramView.injectParameterList["startTime"];
			_currentRank = datagramView.injectParameterList["rank"];
			
			var closeBtn:CButtonCommon = new CButtonCommon("close");
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 , true);
			mc.closepos.addChild(closeBtn);
			
			var rewardBtn:CButtonCommon = new CButtonCommon("green", "领奖");
			rewardBtn.addEventListener(TouchEvent.TOUCH_TAP, __onReward, false, 0, true);
			mc.btn.addChild(rewardBtn);
			
			__showContent();
			__showAward();
		}
		
		private function __showAward():void
		{
			var matchInfo:MatchInfo = CBaseUtil.getMatchAwardByID(_matchData.productID);
			if(matchInfo == null)
			{
				return;
			}
			var awardList:Vector.<MatchAward> = matchInfo.award;
			var matchAward:MatchAward;
			for each(matchAward in awardList)
			{
				if(_currentRank <= matchAward.min && _currentRank >= matchAward.max)
				{
					break;
				}
			}
			//added by caihua
			if(!matchAward)
			{
				return;
			}
			var icon:MovieClip = ResHandler.getMcFirstLoad("common.match.item");
			icon.gotoAndStop(matchAward.icon);
			this.mc.itempos.addChild(icon);
			this.mc.descTxt.text = matchAward.desc;
			
			this._iconType = matchAward.icon;
		}
		
		private function __showContent():void
		{
			//用户昵称
			var user:CDataOfGameUser = CDataManager.getInstance().dataOfGameUser;
			var nameTxt:String = this.mc.nameTxt.htmlText;
			nameTxt = nameTxt.replace("%name", user.nickName);
			this.mc.nameTxt.htmlText = nameTxt;
			
			var matchName:String;
			var currentMatchAward:MatchInfo = CBaseUtil.getMatchAwardByID(_matchData.productID);
			if(currentMatchAward != null)
			{
				matchName = currentMatchAward.shortName;
			}
			else
			{
				matchName = _matchData.matchName;
			}
			
			//比赛开始时间
			var startDate:Date = new Date(_startTime);
			var contentTxt:String = this.mc.contentTxt.htmlText;
			contentTxt = contentTxt.replace("%y", startDate.fullYear);
			contentTxt = contentTxt.replace("%m", startDate.month + 1);
			contentTxt = contentTxt.replace("%d", startDate.date);
			
			var minutes:String = "" + startDate.minutes;
			if(minutes.length == 1) 
			{
				minutes = "0" + minutes;
			}
			var hours:String = "" + startDate.hours;
			if(hours.length == 1) 
			{
				hours = "0" + hours;
			}
			
			contentTxt = contentTxt.replace("%h", hours);
			contentTxt = contentTxt.replace("%f", minutes);
			contentTxt = contentTxt.replace("%name", "<b>" + matchName + "</b>");
			contentTxt = contentTxt.replace("%r", "<b>" + _currentRank + "</b>");
			this.mc.contentTxt.htmlText = contentTxt;
			//当前时间
			var date:Date = new Date();
			var dateTxt:String = this.mc.dateTxt.htmlText;
			dateTxt = dateTxt.replace("%y", date.fullYear);
			dateTxt = dateTxt.replace("%m", date.month + 1);
			dateTxt = dateTxt.replace("%d", date.date);
			
			minutes = "" + date.minutes;
			if(minutes.length == 1) 
			{
				minutes = "0" + minutes;
			}
			hours = "" + date.hours;
			if(hours.length == 1) 
			{
				hours = "0" + hours;
			}
			
			dateTxt = dateTxt.replace("%t", hours + ":" + minutes);
			this.mc.dateTxt.htmlText = dateTxt;
			
			var tfBmp1:Bitmap = CBaseUtil.textFieldToBitmap(mc.nameTxt);
			mc.addChild(tfBmp1);
			
			var tfBmp2:Bitmap = CBaseUtil.textFieldToBitmap(mc.contentTxt);
			mc.addChild(tfBmp2);
			
			var tfBmp3:Bitmap = CBaseUtil.textFieldToBitmap(mc.dateTxt);
			mc.addChild(tfBmp3);
		}
		
		protected function __onReward(event:TouchEvent):void
		{
			if(!Debug.inLobby)
			{
				return;
			}
			
			if(this._iconType == ConstIcon.ICON_TYPE_SILVER)
			{
				__onClose(null);
				
				return;
			}
			
			if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
			{
				WebJSManager.loginEnrol();
			}else
			{
				WebJSManager.navigateByTab(ConfigManager.REWARD_URL);
				__onClose(null);
			}
			
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			NetworkManager.instance.sendServerGetCoin();
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_MATCH_DIPLOMA));
			
			CBaseUtil.popDiploma();
		}
	}
}