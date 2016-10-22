package com.ui.item
{
	import com.ui.util.CBaseUtil;
	import com.ui.util.CTimer;
	
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	public class CItemOnlineAward extends CItemAbstract
	{
		private var _cdTxt:TextField;
		private var _cdTimer:CTimer;
		private var _cd:int;
		private var _flowTipText:String;
		private var _hasTip:Boolean;
		
		public function CItemOnlineAward()
		{
			super("onlineAward");
		}
		
		override protected function drawContent():void
		{
			mc.effect.mouseChildren = false;
			mc.effect.mouseEnabled = false;
			mc.backEffect.mouseChildren = false;
			mc.backEffect.mouseEnabled = false;
			mc.backEffect.visible = false;
			mc.effect.visible = false;
			mc.time.visible = false;
			
			mc.buttonMode = true;
			mc.addEventListener(TouchEvent.TOUCH_TAP, onOnlineClick);
			
			_cdTxt = CBaseUtil.getTextField(mc.time.cdTxt, 12, 0xffffff);
			
			mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
			mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_hasTip)
			{
				_hasTip = true;
				
				var pos:Point  = mc.localToGlobal(new Point(-mc.width /2   , 62));
				
				CBaseUtil.showTip("每日在线，道具免费拿" , pos , new Point(150,25) , true , "down");
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
		
		public function setStatue(time:int):void
		{
			if(time <= 0)
			{
				mc.backEffect.visible = true;
				mc.effect.visible = true;
				mc.time.visible = false;
				
			}else
			{
				mc.backEffect.visible = false;
				mc.effect.visible = false;
				mc.time.visible = true;
				
				_cd = time;
				_cdTxt.text = CBaseUtil.getTimeString(time);
				if(_cdTimer == null)
				{
					_cdTimer = new CTimer();
					_cdTimer.addCallback(onCoolDown, 1);
					_cdTimer.start();
				}
			}
		}
		
		protected function onOnlineClick(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_ONLINE));
			
			NetworkManager.instance.sendServerActivity(0);
		}
		
		private function onCoolDown():void
		{
			_cd -= 1000;
			_cdTxt.text = CBaseUtil.getTimeString(_cd);
			
			if(_cd < 0)
			{
				NetworkManager.instance.sendServerActivity(0);
				_cdTimer.delCallback(onCoolDown);
				_cdTimer = null;
			}
		}
	}
}