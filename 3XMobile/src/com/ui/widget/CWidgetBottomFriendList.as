package com.ui.widget
{
	import com.game.module.CDataManager;
	import com.netease.protobuf.UInt64;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemFriend;
	import com.ui.util.CBaseUtil;
	
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.fibre.core.Notification;
	import framework.model.ListInfo;
	import framework.rpc.DataUtil;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 好友头像滑动面板
	 * 创建时间：2014-6-10 下午2:10:38 
	 */
	public class CWidgetBottomFriendList extends CWidgetTurnPageBase
	{
		public function CWidgetBottomFriendList()
		{
			super("panel.friend");
		}
		
		/**
		 * 设置属性
		 */
		override protected function setPara():void
		{
			//每页横竖项数
			this._NUM_PER_PAGE = new Point(9, 1);
			//遮罩位置
			this._MASK_ZONE = new Rectangle(50, 0, 900, 120);
			//每项间隔
			this._ITEM_SPAN = new Point(100, 110);
			//最后一页填满模式
			this._dataListLastMode = ListInfo.MODE_KEEP_REMAIN;
			//item开始位置
			this._containerOldPos = new Point(60, 0);
		}
		
		override protected function drawItem(data:Object):Sprite
		{
			return new CItemFriend(data as UInt64 , "item.friend");
		}
		
		override protected function drawContent():void
		{
			super.drawContent();
			
			__drawButton();
			
			var data:Array = [];
			
			var friendList:Array = CDataManager.getInstance().dataOfFriendList.getFriendList();
			if(friendList == null)
			{
				friendList =[];
			}
			
			for(var i:int = 0 ; i < friendList.length ; i++)
			{
				if(friendList[i] != null && CBaseUtil.toNumber2(friendList[i]) != 0)
				{
					data[i] = friendList[i];
				}
			}
			
			//自己
			data.unshift(DataUtil.instance.myUserID);
			
			this._dataList.setData(data);
			
			this.drawInit();
			
			CBaseUtil.regEvent(GameNotification.EVENT_GET_FRIENDLIST , __update);
		}
		
		override public function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_GET_FRIENDLIST , __update);
		}
		
		private function __update(d:Notification):void
		{
			var data:Array = [];
			
			var friendList:Array = CDataManager.getInstance().dataOfFriendList.getFriendList();
			
			for(var i:int = 0 ; i < friendList.length ; i++)
			{
				if(friendList[i] != null && CBaseUtil.toNumber2(friendList[i]) != 0)
				{
					data[i] = friendList[i];
				}
			}
			
			data.unshift(DataUtil.instance.myUserID);
			
			this._dataList.setData(data);
			
			this.drawInit();
		}
		
		private function __drawButton():void
		{
			_prevPageBtn = new CButtonCommon("prev");
			this.mc.prevbtnpos.addChild(_prevPageBtn);
			
			_nextPageBtn = new CButtonCommon("next");
			this.mc.nextbtnpos.addChild(_nextPageBtn);
			
			//翻页
			_prevPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onFriendListPrev , false , 0 , true);
			_nextPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onFriendListNext , false , 0 , true);
		}
		
		protected function __onFriendListNext(event:TouchEvent):void
		{
			this.nextPage();
		}
		
		protected function __onFriendListPrev(event:TouchEvent):void
		{
			this.prevPage();
		}
	}
}