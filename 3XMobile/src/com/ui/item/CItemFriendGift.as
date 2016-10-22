package com.ui.item
{
	import com.game.consts.ConstFriendGiftType;
	import com.game.consts.ConstFriendMessageType;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	

	/**
	 * @author caihua
	 * @comment 好友礼物item
	 * 创建时间：2014-7-14 下午6:54:14 
	 */
	public class CItemFriendGift extends CItemAbstract
	{
		private var _data:*;
		
		public function CItemFriendGift(data:Object)
		{
			_data = data;
			super("item.friend.gift");
		}
		
		override protected function drawContent():void
		{
			__drawBg();
			
			__drawBtn();
			
			__drawItem();
		}
		
		private function __drawItem():void
		{
			var item:CItemFriend = new CItemFriend(_data.fid , "item.friend.help");
			mc.itempos.addChild(item);
		}
		
		private function __drawBtn():void
		{
			var sendBtn:CButtonCommon = new CButtonCommon("blueshort", "赠送" , CFontUtil.simpleTextFormat(0xffffffff , 14) );
			mc.btnpos.addChild(sendBtn);
			sendBtn.addEventListener(TouchEvent.TOUCH_TAP , __onSend , false, 0 ,true);
			
			var getBtn:CButtonCommon = new CButtonCommon("greenshort", "领取" ,  CFontUtil.simpleTextFormat(0xffffffff , 14));
			mc.btnpos.addChild(getBtn);
			getBtn.addEventListener(TouchEvent.TOUCH_TAP , __onGet , false, 0 ,true);
			
			if(_data.type == ConstFriendGiftType.MESSAGE_FRIEND_GIFT_SEND)
			{
				//TODO
			}
			
			mc.addfriendicon.visible = false;
			mc.unlockicon.visible = false;
			mc.energyicon.visible = false;
			
			if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ADDFRIEND)
			{
				mc.addfriendicon.visible = true;
			}
			else if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_SEND_GIFT)
			{
				mc.energyicon.visible = true;
			}
			else
			{
				mc.unlockicon.visible = true;
			}
		}
		
		protected function __onGet(event:TouchEvent):void
		{
			trace("__onGet");
		}
		
		protected function __onSend(event:TouchEvent):void
		{
			if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ADDFRIEND)
			{
				NetworkManager.instance.sendServerAddFriend(_data.fid);
			}
		}
		
		private function __drawBg():void
		{
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_COMMON_FRIEND , 
				new Rectangle(15 , 15 , 2,2) , 
				new Point(410 , 56));
			
			mc.bgpos.addChild(bg1);
		}
	}
}