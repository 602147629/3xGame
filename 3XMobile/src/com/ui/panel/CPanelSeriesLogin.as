package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.item.CitemSeriesLogin;
	import com.ui.util.CBaseUtil;
	
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.model.DataManager;
	import framework.resource.faxb.onlineActivity.Activity;
	import framework.resource.faxb.onlineActivity.ActivityItem;
	import framework.resource.faxb.onlineActivity.ActivityLevel;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	public class CPanelSeriesLogin extends CPanelAbstract
	{
		private var _itemList:Sprite;
		
		public function CPanelSeriesLogin()
		{
			super("function.login");
		}
		
		override protected function drawContent():void
		{
			__drawScaleBg();
			__drawPanel();
			
			CBaseUtil.regEvent(GameNotification.EVENT_ACTIVITY_LOGIN , __onShowItemList);
		}
		
		private function __onShowItemList(d:Notification):void
		{
			var levels:Vector.<ActivityLevel>;
			for each(var activity:Activity in DataManager.getInstance().activitys.activity)
			{
				if(activity.type == 1)
				{
					levels = activity.level;
					break;
				}
			}
			if(levels == null)
			{
				return;
			}
			
			while(_itemList.numChildren)
			{
				_itemList.removeChildAt(0);
			}
			var activityLv:ActivityLevel;
			var index:int;
			var len:int = levels.length;
			var curlv:int = d.data.curlv;
			var dayNum:int = d.data.dayNum;
			for(index = 0; index < len; index++)
			{
				activityLv = levels[index];
				
				var data:Object = new Object();
				data.id = activityLv.id;
				data.lv = activityLv.num;
				data.money = activityLv.money;
				data.curlv = curlv;
				data.dayNum = dayNum;
				data.itemList = new Array();
				if(activityLv.silver != 0)
				{
					data.itemList.push({type : "common.icon", id : 1, num : activityLv.silver});
				}
				for(var i:int = 0; i < activityLv.item.length; i++)
				{
					var acItem:ActivityItem = activityLv.item[i];
					data.itemList.push({type : "common.tool.img", id : acItem.id, num : acItem.num});
				}
				
				var item:CitemSeriesLogin = new CitemSeriesLogin(data);
				item.y = index * 70;
				
				_itemList.addChild(item);
			}
		}
		
		private function __drawPanel():void
		{
			var closeBtn:CButtonCommon = new CButtonCommon("close1");
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 , true);
			mc.closepos.addChild(closeBtn);
			
			_itemList = new Sprite();
			mc.content.addChild(_itemList);
		}
		
		private function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.PANEL_SERIES_LOGIN));
		}
		
		private function __drawScaleBg():void
		{
			mc.bgpos.addChild(CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , 
				new Rectangle(195,50,2,2) , 
				new Point(471 , 571)));
		}
	}
}