package com.ui.panel
{
	import com.game.consts.ConstFriendMessageType;
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemFriendMessage;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CBatchExecute;
	import com.ui.util.CFontUtil;
	import com.ui.widget.CWidgetScrollBar;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	/**
	 * @author caihua
	 * @comment 好友消息面板
	 * 创建时间：2014-7-3 下午12:21:41 
	 */
	public class CPanelFriendMessage extends CPanelAbstract
	{
		private var _scrollPane:CWidgetScrollBar;

		private var agreeAllBtn:CButtonCommon;

		private var ignoreAllBtn:CButtonCommon;

		public function CPanelFriendMessage()
		{
			super(ConstantUI.PANEL_FRIEND_MESSAGE , false);
		}
		
		override protected function drawContent():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER));
			
			__drawBtn();
			
			var oldSize:Point = new Point(mc.width , mc.height);
			CBaseUtil.centerUI(mc , oldSize);
			
			_scrollPane = CBaseUtil.createCWidgetScrollBar(ConstantUI.CONST_UI_BG_SCROLLBAR_2, 
				ConstantUI.CONST_UI_BG_SCROLLLINE_2,
				new Rectangle(0, 8, 20, 2) , 
				new Point(20 , 380),
				new Point(375, 380),
				6);
			
			mc.itempos.addChild(_scrollPane);
			
			registerObserver(GameNotification.EVENT_GET_FRIENDLIST , __init);
			getFriend();
		}
		
		private function getFriend():void
		{
			this.showLoading();
			NetworkManager.instance.sendServerGetFriendList();
		}
		
		private function __init(d:Notification):void
		{
			_scrollPane.clear();
			
			CBaseUtil.delayCall(function():void{
				__drawItemFriend();
			} , 0.2 , 1);
		}
		
		private function __drawBtn():void
		{
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xffffff;
			
			var closebtn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(closebtn);
			closebtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false , 0 , true);
			
			agreeAllBtn = new CButtonCommon("green" , "全部同意" , tf , 0x00);
			mc.agreeallpos.addChild(agreeAllBtn);
			agreeAllBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAgreeAll , false , 0 , true);
			
			ignoreAllBtn = new CButtonCommon("blue" , "全部忽略" , tf , 0x00);
			mc.ignorallpos.addChild(ignoreAllBtn);
			ignoreAllBtn.addEventListener(TouchEvent.TOUCH_TAP , __onIgnorAll , false , 0 , true);
		}
		
		protected function __onIgnorAll(event:TouchEvent):void
		{
			this.entryLock();
			
			var all:int = _scrollPane.source.numChildren;
			for(var i:int = 0 ; i < all  ; i++)
			{
				var child:CItemFriendMessage = _scrollPane.source.getChildAt(i) as CItemFriendMessage;
				if(child)
				{
					CBaseUtil.delayCall(child.ignore , 0.1);
				}
			}
			
			agreeAllBtn.enabled = false;
			ignoreAllBtn.enabled = false;
			
			this.unlock();
		}
		
		protected function __onAgreeAll(event:TouchEvent):void
		{
			this.entryLock();
			
			var all:int = _scrollPane.source.numChildren;
			for(var i:int = 0 ; i < all ; i++)
			{
				var child:CItemFriendMessage = _scrollPane.source.getChildAt(i) as CItemFriendMessage;
				if(child)
				{
					CBaseUtil.delayCall(child.agree , 0.1);
				}
			}
			
			agreeAllBtn.enabled = false;
			ignoreAllBtn.enabled = false;
			
			this.unlock();
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.PANEL_FRIEND_MESSAGE));
		}
		
		override protected function dispose():void
		{
			removeObserver(GameNotification.EVENT_GET_FRIENDLIST , __init);
		}
		
		private function __drawItemFriend():void
		{
			var dataList:Array = new Array();
			var friendAddRequestList:Array = CDataManager.getInstance().dataOfFriendList.msgFriendAskToMakeFriendsList;
			
			//添加好友的消息
			for(var i:int = 0 ; i< friendAddRequestList.length ;i++)
			{
				dataList.push({type:ConstFriendMessageType.MESSAGE_TYPE_ADDFRIEND , fid:friendAddRequestList[i].qid , msg:friendAddRequestList[i]});
			}
			
			//索要礼物消息
			var msgFriendAskMeToSendList:Array = CDataManager.getInstance().dataOfFriendList.msgFriendAskMeToSendList;
			for(var j:int = 0 ; j< msgFriendAskMeToSendList.length ;j++)
			{
				dataList.push({type:ConstFriendMessageType.MESSAGE_TYPE_ASKSEND_GIFT , fid:msgFriendAskMeToSendList[j].qid, msg:msgFriendAskMeToSendList[j]});
			}
			
			//赠送给我道具的消息
			var msgFriendSendMeGiftList:Array = CDataManager.getInstance().dataOfFriendList.msgFriendSendMeGiftList;
			
			for(var k:int = 0 ; k< msgFriendSendMeGiftList.length ;k++)
			{
				dataList.push({type:ConstFriendMessageType.MESSAGE_TYPE_SEND_GIFT , fid:msgFriendSendMeGiftList[k].qid, msg:msgFriendSendMeGiftList[k]});
			}
			
			var totalMessageNum:int = dataList.length;
			var item:CItemFriendMessage;
			
			var currentY:Number = 0;
			
//			没有消息
			if(totalMessageNum == 0)
			{
				agreeAllBtn.visible = false;
				ignoreAllBtn.visible = false;
			}
			else
			{
				if(totalMessageNum > 20)
				{
					new CBatchExecute(__drawOnce , dataList , 1 , 0.1 , __drawComplete);
					
					function __drawOnce(d:Object):void
					{
						item = new CItemFriendMessage(d);
						item.y = currentY;
						_scrollPane.addItem(item);
						currentY += 99;
					}
				}
				else
				{
					for(var index:int = 0; index < totalMessageNum ; index++ )
					{
						item = new CItemFriendMessage(dataList[index]);
						item.y = index * 99;
						_scrollPane.addItem(item);
					}
					
					__drawComplete();
				}
			}
			
			this.closeLoading();
		}
		
		private function __drawComplete():void
		{
			agreeAllBtn.visible = true;
			ignoreAllBtn.visible = true;
		}
	}
}
