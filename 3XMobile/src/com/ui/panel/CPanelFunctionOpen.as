package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemAbstract;
	import com.ui.item.CItemFunctionEntry;
	import com.ui.item.CItemOnlineAward;
	import com.ui.util.CBaseUtil;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.resource.faxb.functionopen.FunctionConfig;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 功能开启
	 * 创建时间：2014-9-19 下午8:42:00 
	 */
	public class CPanelFunctionOpen extends CPanelAbstract
	{
		private var _config:FunctionConfig;
		
		private var _alreadyExecute:Boolean = false;
		
		public function CPanelFunctionOpen()
		{
			super("common.function.open");
		}
		
		override protected function drawContent():void
		{
			_config = datagramView.injectParameterList["config"];
			
			__drawBtn();
			
			__drawFunctionEntry();
			
			CBaseUtil.delayCall(function():void
			{
				CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView("common.function.open"));
				
				if(!_alreadyExecute)
				{
					CBaseUtil.sendEvent(GameNotification.EVENT_FUNCTION_OPEN_ANI , new DatagramViewNormal("common.function.open" , true ,{config:_config}));
				}
			} , 2 );
		}
		
		private function __drawFunctionEntry():void
		{
			var item:CItemAbstract = new CItemFunctionEntry();
			var key:String = _config.key;
			
			if(key == "func_invite")
			{
				item = new CItemFunctionEntry()
				CItemFunctionEntry(item).setEntryBtn("main_morefriend");
			}
			else if(key == "func_mail")
			{
				CItemFunctionEntry(item).setEntryBtn("z_main_mail");
			}
			else if(key == "func_forum")
			{
				CItemFunctionEntry(item).setEntryBtn("z_n1_main_forum");
			}
			else if(key == "func_friendmessage")
			{
				CItemFunctionEntry(item).setEntryBtn("main_friendmessage");
			}
			else if(key == "func_honor")
			{
				CItemFunctionEntry(item).setEntryBtn("z_main_honor");
			}
			else if(key == "func_gift")
			{
				CItemFunctionEntry(item).setEntryBtn("main_giftcenter");
			}
			else if(key == "func_activity")
			{
				CItemFunctionEntry(item).setEntryBtn("z_n92_activity");
			}
			else if(key == "func_match")
			{
				CItemFunctionEntry(item).setEntryBtn("z_n4_area");
				CItemFunctionEntry(item).setBackEffect("shiningEffect", new Point(-15, -18));
				CItemFunctionEntry(item).setEffect("starEffect", new Point(0, 0));
			}
			else if(key == "func_onkeyfillup")
			{
				CItemFunctionEntry(item).setEntryBtn("z_n2_main_onekeyfillup");
			}
			else if(key == "func_serieslogin")
			{
				CItemFunctionEntry(item).setEntryBtn("z_n95_serieslogin");
			}
			else if(key == "func_online")
			{
				item = new CItemOnlineAward();
			}
			
			item.mouseEnabled = false;
			item.mouseChildren = false;
			mc.itempos.addChild(item);
		}
		
		private function __drawBtn():void
		{
			var openBtn:CButtonCommon = new CButtonCommon("z_n97_yellow" , "开启");
			mc.openpos.addChild(openBtn);
			openBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0 , true);
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView("common.function.open"));
			CBaseUtil.sendEvent(GameNotification.EVENT_FUNCTION_OPEN_ANI , new DatagramViewNormal("common.function.open" , true ,{config:_config}));
			_alreadyExecute = true;
		}
	}
}