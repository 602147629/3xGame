package com.ui.panel
{
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetFriendFind;
	import com.ui.widget.CWidgetInviteGift;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 邀请好友
	 * 创建时间：2014-7-2 下午1:36:16 
	 */
	public class CPanelFriendInvite extends CPanelAbstract
	{
		private var _findBtn:CButtonCommon;
		private var _inviteBtn:CButtonCommon;
		
		private var _findItem:CWidgetFriendFind;
		
		private var _inviteItem:CWidgetInviteGift;
		
		//内容容器
		private var _content:Sprite;
		
		private var _currentLabel:String = "";
		
		public function CPanelFriendInvite()
		{
			super(ConstantUI.PANEL_FRIEND_INVITE);
		}
		
		override protected function drawContent():void
		{
			mc.bg1pos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_BIG_NOBORDER));
			
			_content = new Sprite();
			mc.itempos.addChild(_content);
			//大底版
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_TOOL_BG_SCALE , new Rectangle(14,15 ,1 ,1) , new Point(648,393));
			mc.bgpos.addChild(bg);
			__drawFriendItem();
			__drawInviteItem();
			__drawBtn();
			
		}
		
		private function __getRecommandList():void
		{
			NetworkManager.instance.sendServerGetRecommandList(9);
		}
		
		private function __drawFriendItem():void
		{
			_findItem = new CWidgetFriendFind();
			_content.addChild(_findItem);
		}
		
		private function __drawInviteItem():void
		{
			_inviteItem = new CWidgetInviteGift();
			_content.addChild(_inviteItem);
		}
		
		private function __drawBtn():void
		{
			//tab	
			
			var tf:TextFormat = CFontUtil.textFormatSmall;
			tf.color = 0xfcf895;
			tf.size = 15;
			tf.bold = true;
			
			_findBtn = new CButtonCommon("tab" , "账 号 查 找" , tf , 0x5e2f12);
			mc.findpos.addChild(_findBtn);
			
			_inviteBtn = new CButtonCommon("tab" , "邀 请 有 礼", tf , 0x5e2f12);
			mc.giftpos.addChild(_inviteBtn);
			
			_findBtn.setLabel("find");
			_inviteBtn.setLabel("invite");
			
			var closeBtn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(closeBtn);
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
			
			_findBtn.addEventListener(TouchEvent.TOUCH_TAP , __onTab , false, 0 ,true);
			_inviteBtn.addEventListener(TouchEvent.TOUCH_TAP , __onTab , false, 0 ,true);
			
			 mc.idtf.text = CBaseUtil.toNumber2( CDataManager.getInstance().dataOfGameUser.userId );
			 
			__setTab("find");
		}
		
		protected function __onTab(event:TouchEvent):void
		{
			__setTab((event.currentTarget as CButtonCommon).__label);
		}
		
		private function __setTab(l:String):void
		{
			_currentLabel = l;
			
			_findItem.visible = false;
			_inviteItem.visible = false;
			if(l == "find")
			{
				_findBtn.selected = true;
				_inviteBtn.selected = false;
				_findItem.visible = true;
			}
			else
			{
				_findBtn.selected = false;
				_inviteBtn.selected = true;
				_inviteItem.visible = true;
			}
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_FRIEND_INVITE));
		}
		
		override protected function dispose():void
		{
//			_findItem.dispose();
		}
	}
}