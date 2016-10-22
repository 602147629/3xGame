package com.ui.panel
{
	import com.game.consts.ConstToolIndex;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfFriendList;
	import com.netease.protobuf.UInt64;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemFriend;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetFloatText;
	import com.ui.widget.CWidgetScrollBar;
	
	import flash.display.Bitmap;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	/**
	 * @author caihua
	 * @comment 请好友帮忙送体力
	 * 创建时间：2014-7-3 下午12:21:41 
	 */
	public class CPanelFriendSendGift extends CPanelAbstract
	{
		private var _scrollPane:CWidgetScrollBar;
		
		private var _askFriendList:Array;
		
		private var _dataOfFriendList:CDataOfFriendList;

		private var bg1:Bitmap;

		private var askBtn:CButtonCommon;
		
		public function CPanelFriendSendGift()
		{
			super(ConstantUI.PANEL_FRIEND_SENDENERGY , false , false , true);
		}
		
		override protected function drawContent():void
		{
			_dataOfFriendList = CDataManager.getInstance().dataOfFriendList;
			
			_askFriendList = new Array();
			
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER));
			
			__drawScaleBg();	
			
			__drawBtn();
			var oldSize:Point = new Point(mc.width , mc.height);
			
			_scrollPane = CBaseUtil.createCWidgetScrollBar(ConstantUI.CONST_UI_BG_SCROLLBAR_2, 
				ConstantUI.CONST_UI_BG_SCROLLLINE_2,
				new Rectangle(0, 8, 20, 2) , 
				new Point(20 , 400),
				new Point(359 , 365),
				0 , true);
			
			mc.itempos.addChild(_scrollPane);
			_scrollPane.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0 , true);
			
			__drawItemFriend();
			
			mc.mc_select.duigou.visible = false;
			
			mc.mc_select.addEventListener(TouchEvent.TOUCH_TAP , __onSelectAll , false , 0 , true);
			
			CBaseUtil.centerUI(mc , oldSize);
		}
		
		protected function __onSelectAll(event:TouchEvent):void
		{
			mc.mc_select.duigou.visible = !mc.mc_select.duigou.visible;
			
			var itemNum:int = _scrollPane.source.numChildren;
			for(var i:int = 0 ; i < itemNum; i++)
			{
				var child:* = _scrollPane.source.getChildAt(i);
				if(child is CItemFriend)
				{
					child.selected = mc.mc_select.duigou.visible;
					
					if(child.selected)
					{
						_askFriendList.push(child.fid);
					}
					else
					{
						__delKeyInArray(child.fid);
					}
				}
			}
		}
		
		private function __drawBtn():void
		{
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xffffff;
			
			var closebtn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(closebtn);
			closebtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false , 0 , true);
			
			askBtn = new CButtonCommon("green" , "请好友帮忙" , tf , 0x00);
			mc.askpos.addChild(askBtn);
			
			askBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAsk , false , 0 , true);
		}
		
		protected function __onAsk(event:TouchEvent):void
		{
			if(!this.entryLock())
			{
				return;
			}
			
			askBtn.enabled = false;
			
			if(this._askFriendList.length == 0)
			{
				CBaseUtil.delayCall(function():void{askBtn.enabled = false ;unlock();} , 1 , 1);
				return;
			}
			
			//过滤发过请求的 好友列表
			for(var i:int = 0 ; i < _askFriendList.length ;i++)
			{
				_dataOfFriendList.addFriendToMeAskFrindToSendGiftList(this._askFriendList[i]);
			}
			
			NetworkManager.instance.sendServerRequestGift(this._askFriendList , ConstToolIndex.TOOL_TYPE_ENERTY_SMALL);
			
			CWidgetFloatText.instance.showTxt("发送请求成功！");
			
			CBaseUtil.delayCall(function():void{askBtn.enabled = true;unlock();} , 1 , 1);
			
			this._askFriendList = new Array();
			
			__refresh();
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			if(_scrollPane != null)
			{
				_scrollPane.clear();
			}
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.PANEL_FRIEND_SENDENERGY));
			
			//再次打开体力界面
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_ENERGY_LACK));
		}
		
		private function __drawItemFriend():void
		{
			var startX:Number = 0;
			var startY:Number = 10;
			
			var friendList:Array = _dataOfFriendList.getFriendList();
			
			//过滤已经送过的
			var tempArray:Array = new Array();
			for(var i:int = 0 ; i < friendList.length ; i++ )
			{
				//过滤请求过的
				if(__inArray(friendList[i] , _dataOfFriendList.msgMeAskFrindToSendGiftList))
				{
					continue;
				}
				
				//过滤重复
				if(!__inArray(friendList[i] , tempArray))
				{
					tempArray.push(friendList[i]);
				}
			}
			
			for(var j:int = 0 ; j< tempArray.length ;j++)
			{
				var item:CItemFriend = new CItemFriend(tempArray[j] , "item.friend.help");
				item.x = startX + int(j % 4) * 88;
				item.y = startY + int(j / 4) * 90;
				_scrollPane.addItem(item);
			}
			
			//没有好友，不显示滚动条
			if(tempArray.length == 0)
			{
				bg1.visible = false;
				_scrollPane.visible = false;
			}
			else
			{
				bg1.visible = true;
				_scrollPane.visible = true;
			}
		}
		
		private function __refresh():void
		{
			this.showLoading();
			_scrollPane.clear();
			__drawItemFriend()
			this.closeLoading();
		}
		
		private function __inArray(qid:UInt64 , arr:Array):Boolean
		{
			if(!arr || arr.length == 0)
			{
				return false;
			}
			for(var i:int = 0 ; i < arr.length ; i++ )
			{
				if(CBaseUtil.toNumber2(arr[i]) == CBaseUtil.toNumber2(qid))
				{
					return true;
				}
			}
			return false;
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			if(event.target is CItemFriend)
			{
				var item:CItemFriend = event.target as CItemFriend;
				
				item.selected = !item.selected;
				
				if(item.selected)
				{
					_askFriendList.push(item.fid);
				}
				else
				{
					__delKeyInArray(item.fid);
				}
			}
		}
		
		private function __delKeyInArray(fid:UInt64):void
		{
			for( var i:int =0 ; i < _askFriendList.length ; i ++)
			{
				if(CBaseUtil.toNumber2(_askFriendList[i]) == CBaseUtil.toNumber2(fid) )
				{
					mc.mc_select.duigou.visible = false;
					
					_askFriendList.splice(i-1 , 1);
					break;
				}
			}
		}
		
		private function __drawScaleBg():void
		{
			bg1 = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_COMMON_FRIEND , 
				new Rectangle(29 , 29 , 1,1) , 
				new Point(359 , 366));
			
			mc.panelpos.addChild(bg1);
		}
	}
}