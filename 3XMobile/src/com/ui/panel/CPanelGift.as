package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.widget.CWidgetFriendFind;
	import com.ui.widget.CWidgetFriendGift;
	
	import flash.display.Sprite;
	
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	/**
	 * @author caihua
	 * @comment 好友礼物
	 * 创建时间：2014-7-14  下午18:36:16 
	 */
	public class CPanelGift extends CPanelAbstract
	{
		private var _getBtn:CButtonCommon;
		private var _sendAndReceiveBtn:CButtonCommon;
		private var _askBtn:CButtonCommon;
		
		private var _getItem:CWidgetFriendFind;
		
		private var _sendAndReceiveItem:CWidgetFriendGift;
		
		private var _askItem:CWidgetFriendGift;
		
		//内容容器
		private var _content:Sprite;
		
		private var _currentLabel:String = "";
		
		public function CPanelGift()
		{
			super(ConstantUI.PANEL_FRIEND_GIFT);
		}
		
		override protected function drawContent():void
		{
			mc.bg1pos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_BIG_WITHBORDER));
			
			_content = new Sprite();
			mc.itempos.addChild(_content);
			__drawGetItem();
			__drawSendAndReceiveItem();
			__drawAskItem();
			__drawBtn();
			
		}
		
		private function __drawAskItem():void
		{
			_askItem = new CWidgetFriendGift();
			_content.addChild(_askItem);
		}
		
		private function __getRecommandList():void
		{
			NetworkManager.instance.sendServerGetRecommandList(9);
		}
		
		private function __drawGetItem():void
		{
			_getItem = new CWidgetFriendFind();
			_content.addChild(_getItem);
		}
		
		private function __drawSendAndReceiveItem():void
		{
			_sendAndReceiveItem = new CWidgetFriendGift();
			_content.addChild(_sendAndReceiveItem);
		}
		
		private function __drawBtn():void
		{
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xfcf895;
			
			_getBtn = new CButtonCommon("tab" , "领取" , tf , 0x00);
			mc.findpos.addChild(_getBtn);
			
			_sendAndReceiveBtn = new CButtonCommon("tab" , "收发礼物", tf , 0x00);
			mc.giftpos.addChild(_sendAndReceiveBtn);
			
			_askBtn = new CButtonCommon("tab" , "索要", tf , 0x00);
			mc.askpos.addChild(_askBtn);
			
			_getBtn.setLabel("get");
			_sendAndReceiveBtn.setLabel("sendandreceive");
			_askBtn.setLabel("ask");
			
			var closeBtn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(closeBtn);
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
			
			_getBtn.addEventListener(TouchEvent.TOUCH_TAP , __onTab , false, 0 ,true);
			_sendAndReceiveBtn.addEventListener(TouchEvent.TOUCH_TAP , __onTab , false, 0 ,true);
			_askBtn.addEventListener(TouchEvent.TOUCH_TAP , __onTab , false, 0 ,true);
			
			__setTab("sendandreceive");
		}
		
		protected function __onTab(event:TouchEvent):void
		{
			__setTab((event.currentTarget as CButtonCommon).__label);
		}
		
		private function __setTab(l:String):void
		{
			_currentLabel = l;
			
			_getItem.visible = false;
			_askItem.visible = false;
			_sendAndReceiveItem.visible = false;
			
			_getBtn.selected = false;
			_sendAndReceiveBtn.selected = false;
			_askBtn.selected = false;
			
			if(l == "get")
			{
				_getBtn.selected = true;
				_getItem.visible = true;
			}
			else if(l == "sendandreceive")
			{
				_sendAndReceiveBtn.selected = true;
				_sendAndReceiveItem.visible = true;
			}
			else
			{
				_askBtn.selected = true;
				_askItem.visible = true;
			}
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_FRIEND_INVITE));
		}
	}
}


