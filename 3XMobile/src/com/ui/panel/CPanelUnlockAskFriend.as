package com.ui.panel
{
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemFriend;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.util.ScrollBar;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 请好友帮忙
	 * 创建时间：2014-7-3 下午12:21:41 
	 */
	public class CPanelUnlockAskFriend extends CPanelAbstract
	{
		private var _scrollPane:ScrollBar;
		
		public function CPanelUnlockAskFriend()
		{
			super(ConstantUI.PANEL_UNLOCK_ASK_FRIEND , false);
		}
		
		override protected function drawContent():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER));
			
			__drawScaleBg();	
			
			__drawBtn();
			var oldSize:Point = new Point(mc.width , mc.height);
			
			__drawItemFriend();
			
			CBaseUtil.centerUI(mc , oldSize);
		}
		
		private function __drawBtn():void
		{
			var tf:TextFormat = new TextFormat();
			tf.align = "center";
			tf.size = 18;
			tf.color = 0xf6eab5;
			
			var closebtn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(closebtn);
			closebtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false , 0 , true);
			
			var askBtn:CButtonCommon = new CButtonCommon("green" , "请好友帮忙" , tf , 0x00);
			mc.askpos.addChild(askBtn);
			askBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAsk , false , 0 , true);
		}
		
		protected function __onAsk(event:TouchEvent):void
		{
			trace("__onAsk");
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			if(_scrollPane != null)
			{
				_scrollPane.destory();
			}
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.PANEL_UNLOCK_ASK_FRIEND));
		}
		
		private function __drawItemFriend():void
		{
			var source:Sprite = new Sprite();
			
			var startX:Number = 15;
			var startY:Number = 10;
			
			var friendList:Array = CDataManager.getInstance().dataOfFriendList.getFriendList();
			
			for(var i:int = 0 ; i< 30 ;i++)
			{
				var item:CItemFriend = new CItemFriend(friendList[i] , "item.friend.help");
				item.x = startX + int(i % 4) * 88;
				item.y = startY + int(i / 4) * 90;
				source.addChild(item);
			}
			mc.itempos.addChild(source);
			
			_scrollPane = CBaseUtil.createScrollBar(mc.itempos, mc.slider, mc.scrollBG, new Point(359 , 350), 350, true);
		}
		
		private function __drawScaleBg():void
		{
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_COMMON_FRIEND , 
				new Rectangle(29 , 29 , 1,1) , 
				new Point(359 , 366));
			
			mc.panelpos.addChild(bg1);
		}
	}
}