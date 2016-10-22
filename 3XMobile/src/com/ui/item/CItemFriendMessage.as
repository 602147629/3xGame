package com.ui.item
{
	import com.game.consts.ConstFriendMessageType;
	import com.game.consts.ConstGlobalConfig;
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetFloatText;
	
	import flash.display.Bitmap;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.PBRequestInfo;

	/**
	 * @author caihua
	 * @comment 好友消息item
	 * 创建时间：2014-7-7 下午9:47:58 
	 */
	public class CItemFriendMessage extends CItemAbstract
	{
		private var _data:*;
		
		private var _arr:Array;

		private var agreeBtn:CButtonCommon;

		private var ignorBtn:CButtonCommon;
		
		private var _msg:*;
		private var _tf:TextField;
		
		public function CItemFriendMessage(data:Object)
		{
			_data = data;
			super(ConstantUI.ITEM_FRIEND_MESSAGE);
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
			ignorBtn = new CButtonCommon("blueshort", "忽略" , CFontUtil.getTextFormat(14 , 0xffffff) );
			mc.ignorpos.addChild(ignorBtn);
			ignorBtn.addEventListener(TouchEvent.TOUCH_TAP , __onIgnore , false, 0 ,true);
			ignorBtn.visible = true;
			
			agreeBtn = new CButtonCommon("greenshort", "同意" ,  CFontUtil.getTextFormat(14 , 0xffffff));
			mc.agreepos.addChild(agreeBtn);
			agreeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAgreen , false, 0 ,true);
			
			mc.addfriendicon.visible = false;
			mc.unlockicon.visible = false;
			mc.energyicon.visible = false;
			
			_tf = CFontUtil.getTextField(CFontUtil.getTextFormat(14 , 0x5e2f12 , true , "left"));
			_tf.x = mc.tiptf.x;
			_tf.y = mc.tiptf.y;
			_tf.width = mc.tiptf.width;
			_tf.height = 20;
			mc.addChild(_tf);
			
			mc.tiptf.visible = false;
			
			_msg = _data.msg;
			
			if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ADDFRIEND)
			{
				mc.addfriendicon.visible = true;
				_tf.text = "可以加你一起玩么？";
				_arr = CDataManager.getInstance().dataOfFriendList.msgFriendSendMeGift;
			}
			else if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_SEND_GIFT)
			{
				var itemName:String = CBaseUtil.getToolConfigById(PBRequestInfo(_msg).itemID).itemName
				
				mc.energyicon.visible = true;
				_tf.text = "送你" + PBRequestInfo(_msg).itemNum + "个" + itemName;
				ignorBtn.visible = false;
				agreeBtn.textField.text = "领取";
				
				_arr = CDataManager.getInstance().dataOfFriendList.msgFriendSendMeGiftList;
				
				if(CDataManager.getInstance().dataOfFriendList.dayGetCount >= ConstGlobalConfig.RECEIVE_GIFT_LIMIT)
				{
					agreeBtn.textField.text = "明天领取";
					agreeBtn.enabled = false;
				}
				
			}
			else if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ASKSEND_GIFT)
			{
				var itemName2:String = CBaseUtil.getToolConfigById(PBRequestInfo(_msg).itemID).itemName
				mc.energyicon.visible = true;
				_tf.text = "请你赠送" + PBRequestInfo(_msg).itemNum + "个" + itemName2 ;
				_arr = CDataManager.getInstance().dataOfFriendList.msgFriendAskMeToSendList;
				
				if(CDataManager.getInstance().dataOfFriendList.daySendCount >= ConstGlobalConfig.SEND_GIFT_LIMIT)
				{
					agreeBtn.textField.text = "明天赠送";
					agreeBtn.enabled = false;
				}
			}
			else
			{
				mc.unlockicon.visible = true;
				_tf.text = "我被卡了，救我？";
			}
		}
		
		protected function __onAgreen(event:TouchEvent):void
		{
			agree();
			
			CWidgetFloatText.instance.showTxt("已同意");
		}
		
		protected function __onIgnore(event:TouchEvent):void
		{
			ignore();
			CWidgetFloatText.instance.showTxt("已忽略");
		}
		
		private function __drawBg():void
		{
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_COMMON_FRIEND_2 , 
				new Rectangle(15 , 15 , 2,2) , 
				new Point(351 , 88));
			
			mc.bgpos.addChild(bg1);
		}
		
		
		public function agree():void
		{
			if(!agreeBtn.enabled)
			{
				return;
			}
			
			if(_arr)
			{
				//直接删除添加
				CDataManager.getInstance().dataOfFriendList.delKeyInArray(_arr , _data.fid);
				agreeBtn.textField.text = "已同意";
				agreeBtn.enabled = false;
				ignorBtn.visible = false;
			}
			
			if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ADDFRIEND)
			{
				NetworkManager.instance.sendServerAcceptAddFriend(_data.fid);
			}
			//送给我体力的消息
			else if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_SEND_GIFT)
			{
				NetworkManager.instance.sendServerFetchGift(_data.fid , PBRequestInfo(_msg).itemID , 1);
				agreeBtn.textField.text = "已领取";
			}
			//送好友礼物
			else if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ASKSEND_GIFT)
			{
				NetworkManager.instance.sendServerAcceptRequestGift(_data.fid , PBRequestInfo(_msg).itemID , 1);
			}
			else
			{
				//请求解锁
			}
			
			CBaseUtil.sendEvent(GameNotification.EVENT_MESSAGE_NUM_CHANGE , {});
		}
		
		public function ignore():void
		{
			ignorBtn.textField.text = "已忽略";
			ignorBtn.enabled = false;
			
			agreeBtn.enabled = false;
			agreeBtn.visible = false;
			
			if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ADDFRIEND)
			{
				NetworkManager.instance.sendServerAcceptAddFriend(_data.fid , 1);
			}
			//送给我体力的消息
			else if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_SEND_GIFT)
			{
				
			}
			else if(_data.type == ConstFriendMessageType.MESSAGE_TYPE_ASKSEND_GIFT)
			{
				NetworkManager.instance.sendServerAcceptRequestGift(_data.fid , PBRequestInfo(_msg).itemID , 1 , 1);
			}
			else
			{
				//请求解锁
			}
			
			CBaseUtil.sendEvent(GameNotification.EVENT_MESSAGE_NUM_CHANGE , {});
		}
	}
}