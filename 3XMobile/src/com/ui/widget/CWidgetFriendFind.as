package com.ui.widget
{
	import com.game.module.CDataManager;
	import com.netease.protobuf.UInt64;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemFriendAdd;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.util.CStringUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.fibre.core.Notification;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 好友查找面板
	 * 创建时间：2014-7-2 下午2:33:00 
	 */
	public class CWidgetFriendFind extends CWidgetAbstract
	{
		private var _recommandPanel:Sprite = new Sprite();	

		private var addBtn:CButtonCommon;
		
		public function CWidgetFriendFind()
		{
			super(ConstantUI.ITEM_FRIEND_FIND);
		}
		
		override protected function drawContent():void
		{
			//输入框底
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_INPUT_BG , new Rectangle(13,14 ,1 ,1) , new Point(281,36));
			mc.inputbg.addChild(bg);
			
			mc.inputtxt = CBaseUtil.getTextField(mc.inputtxt , 16 ,0x7e0101);
			mc.suggesttxt = CBaseUtil.getTextField(mc.suggesttxt , 16 ,0x7e0101);
			
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xfcf895;
			addBtn = new CButtonCommon("green" , "加好友" , tf , 0x00);
			addBtn.setLabel("addBtn");
			mc.addpos.addChild(addBtn);
			addBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAdd , false, 0 ,true);
			addBtn.enabled = false;
			
			var changeBtn:CButtonCommon = new CButtonCommon("blue" , "换一换" , tf , 0x00);
			changeBtn.setLabel("changeBtn");
			mc.changepos.addChild(changeBtn);
			changeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onChange , false, 0 ,true);
			
			mc.addChild(_recommandPanel);
			
			mc.useridtf.restrict = "0-9";
			mc.useridtf.maxChars = 19;
			
			CBaseUtil.regEvent(GameNotification.EVENT_GET_RECOMMAND_BACK , __onRecommandBack);
			
			__getRecommandList();
			
			mc.useridtf.addEventListener(Event.CHANGE , __onTextInput);
		}
		
		protected function __onTextInput(event:Event):void
		{
			var content:String = mc.useridtf.text;
			if(!content || content.length == 0)
			{
				addBtn.enabled = false;
			}
			else
			{
				if(content.length >= 1 && content.length <= 19)
				{
					addBtn.enabled = true;
				}
				else
				{
					addBtn.enabled = false;
				}
			}
			
		}
		
		override public function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_GET_RECOMMAND_BACK , __onRecommandBack);
		}
		
		private function __getRecommandList():void
		{
			NetworkManager.instance.sendServerGetRecommandList(9);
			CBaseUtil.delayCall(function():void
			{
				unlock();
			},1 , 1);
		}
		
		private function __onRecommandBack(n:Notification):void
		{
			var d:Array = n.data.data as Array;
			if(d)
			{
				_recommandPanel.removeChildren();
				__drawFriendItems(d);
				mc.tiptf.visible = false;
			}
			else
			{
				mc.tiptf.visible = true;
			}
			
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
		
		
		private function __drawFriendItems(d:Array):void
		{
			//去重和自己
			var tempArray:Array = new Array();
			for(var i:int = 0 ; i < d.length ; i++ )
			{
				//自己过滤
				if(CBaseUtil.toNumber2(d[i].qid) == CBaseUtil.toNumber2(DataUtil.instance.myUserID))
				{
					continue;	
				}
				//过滤已经是好友的
				if(CDataManager.getInstance().dataOfFriendList.isFriend(d[i].qid))
				{
					continue;
				}
				
				//过滤重复
				if(!__inArray(d[i].qid , tempArray))
				{
					tempArray.push(d[i].qid);
				}
			}
			
			var startX:Number = mc.itemstartpos.x;
			var startY:Number = mc.itemstartpos.y;
			
			for(var k:int = 0 ; k < tempArray.length ;k++)
			{
				var item:CItemFriendAdd = new CItemFriendAdd(tempArray[k]);
				item.x = startX + int(k % 3) * 212;
				item.y = startY + int(k / 3)  * 75;
				_recommandPanel.addChild(item);
			}
		}
		
		protected function __onChange(event:TouchEvent):void
		{
			if((event.currentTarget as CButtonCommon).__label != "changeBtn")
			{
				return;
			}
			
			if(!this.entryLock())
			{
				return;
			}
			
			__getRecommandList();
		}
		
		protected function __onAdd(event:TouchEvent):void
		{
			if((event.currentTarget as CButtonCommon).__label != "addBtn")
			{
				return;
			}
			
			var inputId:String = mc.useridtf.text;
			
			
			if(!inputId || inputId == "")
			{
				return;
			}

			inputId = CStringUtil.trim(inputId);
			
			if(inputId.length < 1 || inputId.length > 19)
			{
				CWidgetFloatText.instance.showTxt("请输入正确位数的好友id");
				return;
			}
			trace("userid = " + DataUtil.instance.myUserID);
			
			//过滤是否已经是好友
			if(CDataManager.getInstance().dataOfFriendList.isFriend(CBaseUtil.fromNumber2(Number(inputId))))
			{
				CWidgetFloatText.instance.showTxt("已经是好友");
			}
			//过滤自己
			else if( Number(inputId) == CBaseUtil.toNumber2(DataUtil.instance.myUserID) )
			{
				CWidgetFloatText.instance.showTxt("不能加自己为好友");
			}
			else
			{
				//发请求加好友
				NetworkManager.instance.sendServerAddFriend(CBaseUtil.fromNumber2(Number(inputId)));
				
				CBaseUtil.showMessage("请求加好友成功！");
			}
		}
	}
}