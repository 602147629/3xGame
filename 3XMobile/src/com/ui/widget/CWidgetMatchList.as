package com.ui.widget
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemMatchList;
	import com.ui.util.CBaseUtil;
	
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.fibre.core.Notification;
	import framework.model.ListInfo;
	import framework.rpc.DataUtil;
	import framework.view.notification.GameNotification;

	public class CWidgetMatchList extends CWidgetTurnPageBase
	{
		public function CWidgetMatchList()
		{
			super("panel.signup.matchList");
		}
		
		/**
		 * 设置属性
		 */
		override protected function setPara():void
		{
			//每页横竖项数
			this._NUM_PER_PAGE = new Point(4, 1);
			//遮罩位置
			this._MASK_ZONE = new Rectangle(40, 0, 520, 200);
			//每项间隔
			this._ITEM_SPAN = new Point(125, 200);
			//最后一页填满模式
			this._dataListLastMode = ListInfo.MODE_KEEP_REMAIN;
			//item开始位置
			this._containerOldPos = new Point(50, 0);
		}
		
		override protected function drawItem(data:Object):Sprite
		{
			return new CItemMatchList(data as int);
		}
		
		override protected function drawContent():void
		{
			super.drawContent();
			
			__drawButton();
			
			var data:Array = [];
			
			var matchList:Array = CDataManager.getInstance().dataOfProduct.matchList;
			if(matchList == null)
			{
				matchList =[];
			}
			
			for(var i:int = 0 ; i < matchList.length ; i++)
			{
				var matchData:CDataOfMatch = matchList[i];
				if(matchData != null && CBaseUtil.getSignUpStatus(matchData.status))
				{
					data.push(matchData.productID);
				}
			}
			
			this._dataList.setData(data);
			
			this.drawInit();
			
			CBaseUtil.regEvent(GameNotification.EVENT_UPDATE_MATCH_LIST , __update);
		}
		
		override protected function drawInit():void
		{
			while (this._container.numChildren > 0)
			{
				this._container.removeChildAt(0);
			}
			drawItems(0, 0, false);
			
			var len:int = CDataManager.getInstance().dataOfProduct.matchList.length;
			var index:int;
			var page:int;
			for(index = 0; index < len; index++)
			{
				var match:CDataOfMatch = CDataManager.getInstance().dataOfProduct.matchList[index];
				if(match.productID == DataUtil.instance.selectMatchProductID)
				{
					page = int(index / this._NUM_PER_PAGE.x);
					break;
				}
			}
			
			gotoPage(page, false, false);
		}
		
		override public function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_UPDATE_MATCH_LIST , __update);
		}
		
		private function __update(d:Notification):void
		{
			var data:Array = [];
			
			var matchList:Array = CDataManager.getInstance().dataOfProduct.matchList;
			if(matchList == null)
			{
				matchList =[];
			}
			
			for(var i:int = 0 ; i < matchList.length ; i++)
			{
				var matchData:CDataOfMatch = matchList[i];
				if(matchData != null && CBaseUtil.getSignUpStatus(matchData.status))
				{
					data.push(matchData.productID);
				}
			}
			
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