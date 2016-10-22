package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemTool;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Notification;
	import framework.resource.faxb.items.Item;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgQuickBuyResponse;

	/**
	 * @author caihua
	 * @comment 道具购买
	 * 创建时间：2014-7-23 下午12:33:41 
	 */
	public class CPanelBuy extends CPanelAbstract
	{
		private var _id:int ;
		private var __buyBtn:CButtonCommon;
		private var __decBtn:CButtonCommon;
		private var __incBtn:CButtonCommon;
		
		private var _toolConfig:Item;
		
		private var _buyNum:int = 1;
		//2 - 银豆  1- 金豆
		private var _buyType:int = 0;
		
		private var _inputKey:String = "" ;
		
		public static const BUY_TYPE_SILVER:int = 2;
		public static const BUY_TYPE_GOLD:int = 1;
		public static const MAX_NUM:int = 99;
		
		public function CPanelBuy()
		{
			super(ConstantUI.PANEL_COMMON_BUY);
		}
		
		override protected function drawContent():void
		{
			var bp:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.CONST_UI_BG_SCALE , 
				new Rectangle(195,50,2,2) ,new Point(413,288))
			
			mc.bgpos.addChild(bp);
			
			__drawBtn();
		
			_id = datagramView.injectParameterList["id"];
			
			_toolConfig = CBaseUtil.getToolConfigById(_id);
			
			if(!_toolConfig)
			{
				return;
			}
			
			_buyNum = 1;
			
			__drawText();
			
			__drawItem();
			
			__update();
			
			CBaseUtil.regEvent(GameNotification.EVENT_TOOL_DATA_UPDATE , __onBuyComplete);
			CBaseUtil.regEvent(GameNotification.EVENT_TOOL_BUY_FAIL , __onFail);
			CBaseUtil.regEvent(GameNotification.EVENT_USER_CHANGE_LOGIN , __onChangeLogin);
			
			mc.buynumtf.restrict = "0-9";
			
			mc.buynumtf.addEventListener(Event.CHANGE , __onChangeNum , false , 0 , true);
			
			mc.buynumtf.addEventListener(TextEvent.TEXT_INPUT, __textInputCapture); 
		}
		
		private function __onChangeLogin(d:Notification):void
		{
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_ENERGY_LACK));
		}
		
		//处理默认为0 ，优化输入问题。
		protected function __textInputCapture(event:TextEvent):void 
		{ 
			_inputKey = event.text;
			
			_buyNum = int(mc.buynumtf.text);
		} 
		
		protected function __onChangeNum(event:Event):void
		{
			if(_buyNum == 0)
			{
				mc.buynumtf.text = _inputKey;
			}
			
			_buyNum = int(mc.buynumtf.text);
			
			__update();
		}
		
		override protected function dispose():void
		{
			super.dispose();
			CBaseUtil.removeEvent(GameNotification.EVENT_TOOL_DATA_UPDATE , __onBuyComplete);
			CBaseUtil.removeEvent(GameNotification.EVENT_TOOL_BUY_FAIL , __onFail);
			CBaseUtil.removeEvent(GameNotification.EVENT_USER_CHANGE_LOGIN , __onChangeLogin);
		}
		
		private function __onFail(d:Notification):void
		{
			CBaseUtil.hideLoading();
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_COMMON_BUY));
			var msg:CMsgQuickBuyResponse = d.data as CMsgQuickBuyResponse;
			
			CBaseUtil.showConfirm("购买失败，银豆不足！是否立即获取银豆？" , CBaseUtil.showSilverExchange , function():void{});
		}
		
		private function __onBuyComplete(d:Notification):void
		{
			CBaseUtil.hideLoading();
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_COMMON_BUY));
			var msg:CMsgQuickBuyResponse = d.data.message as CMsgQuickBuyResponse;
			if(msg != null)
			{
				
				CBaseUtil.showMessage("恭喜您，购买成功！获得" + msg.buyNum + "个" + _toolConfig.itemName);
			}
			else
			{
				CONFIG::debug
				{
					TRACE_LOG("use Item but enter to buy logic");
				}
			}
		}
		
		private function __drawItem():void
		{
			var item:CItemTool = new CItemTool(_id , false , false , false , false , false , false);
			
			mc.itempos.addChild(item);
		}
		
		private function __drawText():void
		{
			//单价
			if(_toolConfig.cost.gold != 0 )
			{
				_buyType = BUY_TYPE_GOLD;
				mc.singalpricetf.text = _toolConfig.cost.gold;
				mc.coinicon1.silver.visible = false;
				mc.coinicon2.silver.visible = false;
			}
			else
			{
				mc.singalpricetf.text = _toolConfig.cost.silver;
				mc.coinicon1.gold.visible = false;
				mc.coinicon2.gold.visible = false;
				_buyType = BUY_TYPE_SILVER;
			}
			mc.nametf.text = _toolConfig.itemName;
			
			mc.desctf.text = _toolConfig.desc;
			//总价
			mc.totalpricetf.text = _buyNum * int(mc.singalpricetf.text);
			
			mc.buynumtf.text = _buyNum;
		}
		
		private function __drawBtn():void
		{
			//关闭按钮
			var closeBtn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(closeBtn);
			
			//购买按钮
			__buyBtn = new CButtonCommon("short" , "购 买");
			mc.buypos.addChild(__buyBtn);
			
			//dec
			__decBtn = new CButtonCommon("subtract");
			mc.decpos.addChild(__decBtn);
			
			//inc
			__incBtn = new CButtonCommon("add2");
			mc.incpos.addChild(__incBtn);
			
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
			__buyBtn.addEventListener(TouchEvent.TOUCH_TAP , __onBuy , false, 0 ,true);
			__decBtn.addEventListener(TouchEvent.TOUCH_TAP , __onDec , false, 0 ,true);
			__incBtn.addEventListener(TouchEvent.TOUCH_TAP , __onInc , false, 0 ,true);
		}
		
		protected function __onInc(event:TouchEvent):void
		{
			if(_buyNum < MAX_NUM)
			{
				_buyNum ++;
				__update();
			}
		}
		
		protected function __onDec(event:TouchEvent):void
		{
			if(_buyNum > 1)
			{
				_buyNum--;
				__update();
			}
		}
		
		protected function __update():void
		{
			if(_buyNum <= 0)
			{
				__buyBtn.enabled = false;
			}
			else
			{
				__buyBtn.enabled = true;
			}
			
			if(_buyNum <= 1)
			{
				__decBtn.enabled = false;
				__incBtn.enabled = true;
			}
			else if(_buyNum >= MAX_NUM)
			{
				__incBtn.enabled = false;
			}
			else
			{
				__decBtn.enabled = true;
				__incBtn.enabled = true;
			}
			
			mc.buynumtf.text = _buyNum;
			mc.totalpricetf.text = _buyNum * int(mc.singalpricetf.text);
		}
		
		protected function __onBuy(event:TouchEvent):void
		{
			CBaseUtil.showLoading();
			
			NetworkManager.instance.sendServerBuyTool(_id , _buyNum ,_buyType);
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_COMMON_BUY)); 
		}
	}
}