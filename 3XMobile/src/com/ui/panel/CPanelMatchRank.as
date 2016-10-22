package com.ui.panel
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.netease.protobuf.UInt64;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemMatchAward;
	import com.ui.item.CItemMatchRank;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetPageTool;
	import com.ui.widget.CWidgetScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.resource.faxb.award.MatchAward;
	import framework.resource.faxb.award.MatchInfo;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.MatchOrder;

	public class CPanelMatchRank extends CPanelAbstract
	{
		private var _awardBtn:CButtonCommon;
		private var _rankBtn:CButtonCommon;
		private var _awardScrollPane:CWidgetScrollBar;
		
		private var _rankPane:Sprite;
		private var _rankPageTool:CWidgetPageTool;
		private static const RANK_PAGE_NUM:int = 14;
		
		/**
		 * 当前比赛的信息 
		 */		
		private var _currentMatchAward:MatchInfo;
		
		public function CPanelMatchRank()
		{
			super(ConstantUI.PANEL_MATCH_RANK);
		}
		
		override protected function drawContent():void
		{
			__initData();
			__drawScaleBg();
			__drawContent();
		}
		
		override protected function dispose():void
		{
			_awardBtn.removeEventListener(TouchEvent.TOUCH_TAP, __awardBtnClick);
			_rankBtn.removeEventListener(TouchEvent.TOUCH_TAP, __rankBtnClick);
			CBaseUtil.removeEvent(GameNotification.EVENT_MATCH_UPDATA_ORDER, __onUpdataMatchOrder);
			CBaseUtil.removeEvent(GameNotification.EVENT_CHANGE_PAGE, __onChangePage);
		}
		
		private function __initData():void
		{
			_currentMatchAward = CBaseUtil.getMatchAwardByID(DataUtil.instance.selectMatchProductID);
			CBaseUtil.regEvent(GameNotification.EVENT_MATCH_UPDATA_ORDER, __onUpdataMatchOrder);
			CBaseUtil.regEvent(GameNotification.EVENT_CHANGE_PAGE, __onChangePage);
		}
		
		private function __drawContent():void
		{
			var closeBtn:CButtonCommon = new CButtonCommon("close");
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 , true);
			mc.closepos.addChild(closeBtn);
			
			var tf:TextFormat = CFontUtil.getTextFormat(14, 0xffffff);
			_awardBtn = new CButtonCommon("tab", "奖励", tf);
			mc.awardpos.addChild(_awardBtn);
			_awardBtn.addEventListener(TouchEvent.TOUCH_TAP, __awardBtnClick);
			
			_rankBtn = new CButtonCommon("tab", "英雄榜", tf);
			mc.rankpos.addChild(_rankBtn);
			_rankBtn.addEventListener(TouchEvent.TOUCH_TAP, __rankBtnClick);
			
			_rankPageTool = new CWidgetPageTool();
			_rankPageTool.currentPage = 1;
			_rankPageTool.totalPage = 1;
			mc.pagepos.addChild(_rankPageTool);
			
			__rankBtnClick();
		}
		
		protected function __awardBtnClick(event:TouchEvent = null):void
		{
			if(_awardBtn.selected)
			{
				return;			
			}
			mc.rank.gotoAndStop(2);
			_awardBtn.selected = true;
			_rankBtn.selected = false;
			_awardScrollPane = CBaseUtil.createCWidgetScrollBar(ConstantUI.CONST_UI_BG_SCROLLBAR, 
				ConstantUI.CONST_UI_BG_SCROLLLINE,
				new Rectangle(1, 50, 1, 80) , 
				new Point(3 , 200),
				new Point(355, 346),
				-5);
			mc.rank.awardPanel.addChild(_awardScrollPane);
			mc.pagepos.visible = false;
			__showAward();
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
				matchAwardItem = new CItemMatchAward("panel.match.awarditem");
				matchAwardItem.setAwardData(matchAward);
				_awardScrollPane.addItem(matchAwardItem);
			}
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
			mc.rank.gotoAndStop(1);
			_rankBtn.selected = true;
			_awardBtn.selected = false;
			_rankPane = new Sprite();
			mc.rank.rankPanel.addChild(_rankPane);
			mc.pagepos.visible = true;
			__onUpdataMatchOrder(null);
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
				matchRankItem = new CItemMatchRank("panel.match.rankitem");
				matchRankItem.setRankData(matchOrder, matchData.productID);
				matchRankItem.y = index * 25;
				_rankPane.addChild(matchRankItem);
			}
			
			var totalPageNum:int = Math.ceil(matchData.remainCount / RANK_PAGE_NUM);
			_rankPageTool.totalPage = totalPageNum;
		}
		
		private function __onChangePage(d:Notification):void
		{
			var currentPage:int = _rankPageTool.currentPage;
			var min:int = RANK_PAGE_NUM * (currentPage - 1) + 1;
			var max:int = RANK_PAGE_NUM * currentPage;
			NetworkManager.instance.sendLobbyMatchOrder(DataUtil.instance.selectMatchProductID, new UInt64(0,0), min, max);
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_MATCH_RANK));
		}
		
		private function __drawScaleBg():void
		{
			mc.bgpos.addChild(CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , 
				new Rectangle(195,50,2,2) , 
				new Point(416 , 510)));
			
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_TOOL_BG_SCALE , 
				new Rectangle(15 , 15 , 2,2) , 
				new Point(375 , 390));
			
			mc.toolbgpos.addChild(bg1);
		}
	}
}