package com.ui.panel
{
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemOnline;
	import com.ui.util.CBaseUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.model.DataManager;
	import framework.resource.faxb.onlineActivity.Activity;
	import framework.resource.faxb.onlineActivity.ActivityLevel;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	public class CPanelOnlineAward extends CPanelAbstract
	{
		private var _cdTxt:TextField;
		
		private var _itemList:Sprite;
		
		public function CPanelOnlineAward()
		{
			super(ConstantUI.PANEL_ONLINE);
		}
		
		override protected function drawContent():void
		{
			var closeBtn:CButtonCommon = new CButtonCommon("close1");
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 , true);
			mc.closepos.addChild(closeBtn);
			
			_cdTxt = CBaseUtil.getTextField(mc.cdTxt, 14, 0xffffff);
			
			_itemList = new Sprite();
			mc.items.addChild(_itemList);
			
			CBaseUtil.regEvent(GameNotification.EVENT_ACTIVITY_ONLINE , __onShowOnline);
			mc.addEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		protected function onEnter(event:Event):void
		{
			this._cdTxt.text = CBaseUtil.getTimeString(CDataManager.getInstance().dataOfGameUser.onlineTime);
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_ACTIVITY_ONLINE , __onShowOnline);
			mc.removeEventListener(Event.ENTER_FRAME, onEnter);
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_ONLINE));
		}
		
		private function __onShowOnline(d:Notification):void
		{
			while(_itemList.numChildren)
			{
				_itemList.removeChildAt(0);
			}
			
			var activityLv:ActivityLevel;
			var index:int;
			var levels:Vector.<ActivityLevel>;
			for each(var activity:Activity in DataManager.getInstance().activitys.activity)
			{
				if(activity.type == 0)
				{
					levels = activity.level;
					break;
				}
			}
			if(levels == null)
			{
				return;
			}
			var len:int = levels.length;
			var curlv:int = d.data.curlv;
			for(index = 0; index < len; index++)
			{
				activityLv = levels[index];
				var data:Object = new Object();
				data.lv = activityLv.id;
				data.curlv = curlv;
				if(data.lv <= curlv)
				{
					data.cd = 0;
				}
				else if(data.lv == curlv + 1)
				{
					data.cd = d.data.cd;
				}
				else
				{
					data.cd = activityLv.num * 1000 - CDataManager.getInstance().dataOfGameUser.onlineTime;
				}
				if(activityLv.silver == 0)
				{
					data.type = "common.tool.img";
					data.id = activityLv.item[0].id;
					data.num = activityLv.item[0].num;
				}
				else
				{
					data.type = "common.icon";
					data.id = 1;
					data.num = activityLv.silver;
				}
				var item:CItemOnline = new CItemOnline(data);
				_itemList.addChild(item);
				item.x = index % 3 * 140;
				item.y = int(index / 3) * 135;
			}
		}
	}
}