package com.ui.item
{
	import com.game.consts.ConstMoneyType;
	import com.game.consts.ConstString;
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	
	import flash.events.TouchEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 货币展示类
	 * 创建时间：2014-6-16 下午3:48:12 
	 */
	public class CItemMoney extends CItemAbstract
	{
		private var _type:String ;
		
		private var _flowTipText:String = "";
		
		private var _flowTipItem:CItemFlowTip;
		
		private var _tf:TextField;
		
		public function CItemMoney(type:String)
		{
			this._type = type;
			super("item.main.money");
		}
		
		override protected function drawContent():void
		{
			__drawIcon();
			
			__drawMoney();
			
			mc.progress.stop();
			
			CBaseUtil.regEvent(GameNotification.EVENT_MONEY_DATA_UPDATE , __onMoneyUpdate);
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_MONEY_DATA_UPDATE , __onMoneyUpdate);
		}
		
		private function __onMoneyUpdate(d:Notification):void
		{
			update();
		}
		
		private function __drawMoney():void
		{
			(mc.progress as MovieClip).addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
			(mc.progress as MovieClip).addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			
			var addButton:CButtonCommon = new CButtonCommon("add");
			mc.addpos.addChild(addButton);
			
			mc.buttonMode = true;
			
			mc.addEventListener(TouchEvent.TOUCH_TAP , this.__onClick , false, 0 ,true);
			
			_tf = CBaseUtil.getTextField(mc.num, 14, 0xFCF895);
			_tf.width = 90;
			_tf.height = 20;
			
			_tf.mouseEnabled = false;
			mc.gold.mouseEnabled = false;
			mc.silver.mouseEnabled = false;
				
			_tf.filters = [new GlowFilter( 0x5e2f12, 1, 3, 3, 100, 1)];
			
			update();
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_flowTipItem)
			{
				_flowTipItem = new CItemFlowTip(_flowTipText , new Point(154,30));
				_flowTipItem.x = mc.x+5;
				_flowTipItem.y = mc.y + mc.height;
				mc.addChild(_flowTipItem);
			}
			else
			{
				mc.removeChild(_flowTipItem);
				_flowTipItem = null;
			}
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			if(!Debug.inLobby)
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , 
					new DatagramViewNormal(ConstantUI.DIALOG_COMMON_Message , true , 
						{text:"网络不通啊，请稍后再试"}));
			}
			else
			{
				if(_type == ConstMoneyType.MONEY_TYPE_GOLD)
				{
					CBaseUtil.showGoldExchange();
				}
				else
				{
					CBaseUtil.showSilverExchange();
				}
			}
		}
		
		private function __showIncCoin():void
		{
			trace("__showIncCoin");
		}
		
		private function __drawIcon():void
		{
			mc.silver.visible = false;
			mc.gold.visible = false;
			
			if(_type == ConstMoneyType.MONEY_TYPE_GOLD)
			{
				mc.gold.visible = true;
			}
			else
			{
				mc.silver.visible = true;
			}
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			
			__drawIcon();
		}
		
		public function update():void
		{
			if(_type == ConstMoneyType.MONEY_TYPE_GOLD)
			{
				_tf.text = CBaseUtil.num2text(CDataManager.getInstance().dataOfMoney.gold);
				_flowTipText = ConstString.FLOW_TIP_GOLD + ":" + CDataManager.getInstance().dataOfMoney.gold;
			}
			else
			{
				_tf.text = CBaseUtil.num2text(CDataManager.getInstance().dataOfMoney.silver);
				
				_flowTipText = ConstString.FLOW_TIP_SILVER + ":" + CDataManager.getInstance().dataOfMoney.silver;
			}	
		}
	}
}