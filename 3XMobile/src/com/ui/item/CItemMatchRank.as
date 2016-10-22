package com.ui.item
{
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.widget.CWidgetFloatText;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import framework.fibre.core.Notification;
	import framework.resource.faxb.award.MatchAward;
	import framework.resource.faxb.award.MatchInfo;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.util.ResHandler;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.MatchOrder;
	import qihoo.gamelobby.protos.UserOrigin;

	public class CItemMatchRank extends CItemAbstract
	{
		private var _nameSpr:Sprite;
		private var _addFriendBtn:CButtonCommon;
		
		private var _data:MatchOrder;
		
		public function CItemMatchRank(id:String)
		{
			super(id);
		}
		
		public function setRankData(data:MatchOrder , productID:int):void
		{
			if(data == null || data.nickName == null)
			{
				this.visible = false;
				return;
			}
			
			this._data = data;
			if(data.order > 3)
			{
				mc.order.visible = false;
				mc.order.stop();
			}else
			{
				mc.order.visible = true;
				mc.order.gotoAndStop(data.order);
			}
			
			if(CBaseUtil.toNumber2(data.userID) == CBaseUtil.toNumber2(CDataManager.getInstance().dataOfGameUser.userId))
			{
				mc.myPos.visible = true;
				mc.order.visible = false;
			}else
			{
				mc.myPos.visible = false;
			}
			
			mc.rankTxt.text = data.order;
			mc.nameTxt.htmlText = "<u>" + data.nickName + "</u>";
			mc.scoreTxt.text = data.score;
			
			var tfBmp1:Bitmap = CBaseUtil.textFieldToBitmap(mc.rankTxt);
			mc.addChild(tfBmp1);
			
			CBaseUtil.regEvent(GameNotification.EVENT_SHOW_ADDFRIEND, __onShowAddFriend);
			
			_nameSpr = new Sprite();
			_nameSpr.buttonMode = true;
			mc.addChild(_nameSpr);
			var tfBmp2:Bitmap = CBaseUtil.textFieldToBitmap(mc.nameTxt);
			_nameSpr.addChild(tfBmp2);
			mc.addEventListener(TouchEvent.TOUCH_OVER, onNameOver);
			
			var tfBmp3:Bitmap = CBaseUtil.textFieldToBitmap(mc.scoreTxt);
			mc.addChild(tfBmp3);
			
			_addFriendBtn = new CButtonCommon("z_n94_addfriend");
			_addFriendBtn.x = tfBmp2.x + tfBmp2.width + 3;
			_addFriendBtn.y = -3;
			_nameSpr.addChild(_addFriendBtn);
			_addFriendBtn.visible = data.order == 1;
			
			_addFriendBtn.addEventListener(TouchEvent.TOUCH_TAP, __addFriendClick);
			_addFriendBtn.addEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_addFriendBtn.addEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
			
			var matchInfo:MatchInfo = CBaseUtil.getMatchAwardByID(productID);
			if(matchInfo == null)
			{
				return;
			}
			
			var awardList:Vector.<MatchAward> = matchInfo.award;
			var matchAward:MatchAward;
			for each(matchAward in awardList)
			{
				if(data.order <= matchAward.min && data.order >= matchAward.max)
				{
					break;
				}
			}
			if(!matchAward)
			{
				return;
			}
			var icon:MovieClip = ResHandler.getMcFirstLoad("common.match.item");
			icon.gotoAndStop(matchAward.icon);
			var scale:Number = matchAward.icon > 1 ? 0.4 : 0.5;
			icon.scaleX = icon.scaleY = scale;
			icon.x = mc.icon.width - icon.width >> 1;
			icon.y = mc.icon.height - icon.height >> 1;
			mc.icon.addChild(icon);
		}
		
		private function __onShowAddFriend(d:Notification):void
		{
			if((d.data as Number) == CBaseUtil.toNumber2(_data.userID))
			{
				this._addFriendBtn.visible = true;
			}
			else
			{
				this._addFriendBtn.visible = false;
			}
		}
		
		protected function onNameOver(event:Event):void
		{
			CBaseUtil.sendEvent(GameNotification.EVENT_SHOW_ADDFRIEND, CBaseUtil.toNumber2(_data.userID));
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_SHOW_ADDFRIEND, __onShowAddFriend);
			
			mc.removeEventListener(TouchEvent.TOUCH_OVER, onNameOver);
			_addFriendBtn.removeEventListener(TouchEvent.TOUCH_TAP, __addFriendClick);
			_addFriendBtn.removeEventListener(TouchEvent.TOUCH_OVER, __btnMouseOver);
			_addFriendBtn.removeEventListener(TouchEvent.TOUCH_OUT, __btnMouseOut);
		}
		
		protected function __btnMouseOut(event:TouchEvent):void
		{
			CBaseUtil.closeTip();
		}
		
		protected function __btnMouseOver(event:TouchEvent):void
		{
			switch(event.currentTarget)
			{
				case _addFriendBtn:
					var pos:Point = _addFriendBtn.localToGlobal(new Point(-_addFriendBtn.width /2 - 5  , _addFriendBtn.y));
					CBaseUtil.showTip("添加好友" , pos , new Point(80,25) , true);
					break;
			}
		}
		
		protected function __addFriendClick(event:TouchEvent):void
		{
			//游客
			if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
			{
				CWidgetFloatText.instance.showTxt("请先注册为正式用户");
			}
			//过滤是否已经是好友
			else if(CDataManager.getInstance().dataOfFriendList.isFriend(_data.userID))
			{
				CWidgetFloatText.instance.showTxt("已经是好友");
			}
				//过滤自己
			else if( CBaseUtil.toNumber2(_data.userID) == CBaseUtil.toNumber2(DataUtil.instance.myUserID) )
			{
				CWidgetFloatText.instance.showTxt("不能加自己为好友");
			}
			else
			{
				//发请求加好友
				NetworkManager.instance.sendServerAddFriend(_data.userID);
				
				//加好友成功
				CWidgetFloatText.instance.showTxt("发送加好友请求成功,等待对方同意！");
			}
		}
	}
}