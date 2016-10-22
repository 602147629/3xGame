package com.ui.item
{
	import com.game.consts.ConstToolIndex;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.game.module.CDataOfUserTool;
	import com.ui.util.CBaseUtil;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import framework.fibre.core.Notification;
	import framework.resource.faxb.levelproperty.Item;
	import framework.resource.faxb.levelproperty.ShowItem;
	import framework.rpc.DataUtil;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 游戏界面右边的道具列表
	 * 创建时间：2014-7-23 下午7:28:30 
	 */
	public class CItemRightItemList extends CItemAbstract
	{
		private var _levelData:CDataOfLevel;
		private var _dataOfUserTool:CDataOfUserTool;
		
		private var _posDic:Dictionary;
		
		private var _itemList:Dictionary;
		
		public function CItemRightItemList()
		{
			super("tool.ingame.list");
		}
		
		override protected function drawContent():void
		{
			_posDic = new Dictionary();
			_itemList = new Dictionary();
			
			_levelData = CDataManager.getInstance().dataOfLevel;
			
			var startItemList:Vector.<ShowItem> = _levelData.startItems;
			var gameItemList:Vector.<Item> = _levelData.gameItems;
			
			_dataOfUserTool = CDataManager.getInstance().dataOfUserTool;
			
			//游戏中的道具，不在普通道具列表中
			for(var i:int = 0 ; i < startItemList.length ; i++)
			{
				var id:int = startItemList[i].id;
				
				//过滤 3种
				if(id == ConstToolIndex.TOOL_TYPE_TOOL_ADD_THREE_STEP 
					|| id == ConstToolIndex.TOOL_TYPE_TOOL_ADD_FIVE_STEP
					||id == ConstToolIndex.TOOL_TYPE_TOOL_BLOB_AND_LINE)
				{
					continue;
				}
				else
				{
					var item:CItemToolInGame = new CItemToolInGame(id);
					item.x = mc.itemoncepos.x;
					item.y = mc.itemoncepos.y - item.height * i;
					
					mc.addChild(item);
					
					_itemList[id] = item;
				}
				
			}
			
			for(var j:int = 0 ; j < gameItemList.length ; j++)
			{
				var id2:int = gameItemList[j].id;
				var num2:int = _dataOfUserTool.getToolNumById(id2);
				
				var item2:CItemToolInGame = new CItemToolInGame(id2, num2, true , "TYPE_ALL");
				item2.x = mc.itemallpos.x;
				item2.y = mc.itemallpos.y + item2.height * j;
				mc.addChild(item2);
				_posDic[id2] = new Point(item2.x , item2.y);
				
				_itemList[id2] = item2;
			}
			
			CBaseUtil.regEvent(GameNotification.EVENT_GAME_REMOVE_GIFT_COMPLETE , __onGiftRemoved);
		}
		
		private function __onGiftRemoved(d:Notification):void
		{
			var item:CItemToolInGame = _itemList[DataUtil.instance.giftId];
			if(!item)
			{
				return;
			}
			item.shine();
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_GAME_REMOVE_GIFT_COMPLETE , __onGiftRemoved);
		}
		
		/**
		 * 获取道具的位置
		 */
		public function getPosById(id:int):Point
		{
			if(_posDic[id])
			{
				return _posDic[id];
			}
			
			return new Point(0,0);
		}
	}
}