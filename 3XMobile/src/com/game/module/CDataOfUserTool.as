package com.game.module
{
	import com.ui.util.CBaseUtil;
	
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgGetPlayerItemInfoResponse;
	import qihoo.triplecleangame.protos.PBItemInfo;

	/**
	 * @author caihua
	 * @comment 用户道具
	 * 创建时间：2014-7-21 下午5:41:33 
	 */
	public class CDataOfUserTool extends CDataBase
	{
		private var _data:CMsgGetPlayerItemInfoResponse;
		
		private var _canUseAllList:Array;
		
		public function CDataOfUserTool()
		{
			super("CDataOfUserTool");
			if(!Debug.ISONLINE)
			{
				this._data = new CMsgGetPlayerItemInfoResponse();
				
				_canUseAllList = new Array();
			}
			else
			{
				_canUseAllList = [];
			}
		}
		
		public function init(d:CMsgGetPlayerItemInfoResponse):void
		{
			this._data = d;
			
			_canUseAllList = [3,4,5,6];
			
			CBaseUtil.sendEvent(GameNotification.EVENT_TOOL_DATA_UPDATE , {});
		}
		
		public function getAllItemNum(id:int):int
		{
			for(var i:int =0 ; i < _canUseAllList.length ; i++)
			{
				if(_canUseAllList[i] == id)
				{
					return 1;
				}
			}
			return 0;
		}
		
		/**
		 * 获取数量
		 */
		public function getToolNumById(id:int):int
		{
			if(!this._data)
			{
				return 0;
			}
			
			var num:int = 0 ;

			if(this._data.giftItemArray)
			{
				for(var i:int =0 ; i < this._data.giftItemArray.length ; i++)
				{
					var item:PBItemInfo = this._data.giftItemArray[i];
					if(item.itemID == id)
					{
						num += item.itemNum;
						break;
					}
				}
			}
			
			if(this._data.itemArray)
			{
				for(var j:int =0 ; j < this._data.itemArray.length ; j++)
				{
					var item2:PBItemInfo = this._data.itemArray[j];
					if(item2.itemID == id)
					{
						num += item2.itemNum;
						break;
					}
				}
			}
			
			return num;
		}
		
		/**
		 * 获取道具的内容
		 */
		public function getToolById(id:int):PBItemInfo
		{
			if(!this._data.itemArray)
			{
				return null;
			}
			
			for(var i:int =0 ; i < this._data.itemArray.length ; i++)
			{
				var item:PBItemInfo = this._data.itemArray[i];
				if(item.itemID == id)
				{
					return item;
				}
			}
			return null;
		}
	}
}