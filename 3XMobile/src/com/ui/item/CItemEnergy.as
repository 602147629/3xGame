package com.ui.item
{
	import com.game.consts.ConstGlobalConfig;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.rpc.DataUtil;
	import framework.rpc.WebJSManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.UserOrigin;
	
	/**
	 * @author caihua
	 * @comment 体力
	 * 创建时间：2014-7-9 下午2:09:34 
	 */
	public class CItemEnergy extends CItemAbstract
	{
		private var _aniStartX:Number = -50.5;
		private var _aniEndX:Number = 50.5;
		private var _userData:CDataOfGameUser;
		
		private var _flowTipText:String = "";
		
		private var _hasTip:Boolean;
		private var _tf:TextField;
		
		public function CItemEnergy()
		{
			super("item.main.star");
		}
		
		override protected function drawContent():void
		{
			mc.staricon.visible = false;
			mc.progress.yellowp.visible = false;
			
			_userData = CDataManager.getInstance().dataOfGameUser;
			mc.progress.stop();
			
			(mc.progress as MovieClip).addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
			(mc.progress as MovieClip).addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			
			_tf = CBaseUtil.getTextField(mc.num, 14, 0xFCF895);
			_tf.width = 90;
			_tf.height = 20;
			_tf.mouseEnabled = false;
			
			_tf.filters = [new GlowFilter( 0x5e2f12, 1, 3, 3, 100, 1)];
			
			mc.staricon.mouseEnabled = false;
			mc.energyicon.mouseEnabled = false;
				
			mc.mc_gift.visible = false;
			
			update();
			
			var addButton:CButtonCommon = new CButtonCommon("add");
			mc.addpos.addChild(addButton);
			
			mc.buttonMode = true;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT
			mc.addEventListener(TouchEvent.TOUCH_TAP , this.__onClick);
			
			CBaseUtil.regEvent(GameNotification.EVENT_ENERGY_RECOVER_REMAIN_TIME , function(d:Notification):void{update()});
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			if(CDataManager.getInstance().dataOfGameUser.curEnergy < 5)
			{
				//游客引导
				if(DataUtil.instance.userType == UserOrigin.UserOrigin_Visitor)
				{
					CBaseUtil.showConfirm("注册立即获赠30点体力,现在前往注册吗?" , 
						function():void{WebJSManager.loginEnrol();} , 
						function():void{Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_ENERGY_LACK));});
				}
				else
				{
					Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_ENERGY_LACK));
				}
			}
			else
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_ENERGY_LACK));
			}
			
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_hasTip)
			{
				_hasTip = true;
				
				var pos:Point = this.localToGlobal(new Point(0 , 50));
				
				CBaseUtil.showTip(_flowTipText ,pos,new Point(154,30) , true , "down");
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
		
		override protected function dispose():void
		{
			Fibre.getInstance().removeObserver(GameNotification.EVENT_ENERGY_RECOVER_REMAIN_TIME , update);
		}
		
		public function update():void
		{
			var p:Number = _userData.curEnergy / ConstGlobalConfig.MAX_ENERGY;
			
			p = p > 1 ? 1 : p;
				
			mc.progress.bar.x = _aniStartX + (_aniEndX - _aniStartX) *  p ; 
			
			//显示
			_tf.text = _userData.curEnergy + "/" + ConstGlobalConfig.MAX_ENERGY;
			
			_flowTipText = "每场游戏消耗5点体力";
		}
	}
}

