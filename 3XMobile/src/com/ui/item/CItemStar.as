package com.ui.item
{
	import com.game.consts.ConstFlowTipSize;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CLevelConfigUtil;
	
	
	import flash.events.TouchEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import framework.fibre.core.Notification;
	import framework.resource.faxb.levelproperty.Levels;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 星值
	 * 创建时间：2014-7-9 下午2:09:34 
	 */
	public class CItemStar extends CItemAbstract
	{
		private var _aniStartX:Number = -52.5;
		private var _aniEndX:Number = 56.5;
		
		private var _userData:CDataOfGameUser;
		
		private var _flowTipText:String = "";
		
		private var _flowTipItem:CItemFlowTip;
		private var _tf:TextField;
		
		public function CItemStar()
		{
			super("item.main.star");
		}
		
		override protected function drawContent():void
		{
			mc.energyicon.visible = false;
			mc.progress.redp.visible = false;
			
			_userData = CDataManager.getInstance().dataOfGameUser;
			mc.progress.stop();
			
			mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
			mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			
			_tf = CFontUtil.getTextField(CFontUtil.getTextFormat(14 , 0xFCF895));
			_tf.x = mc.num.x;
			_tf.y = mc.num.y;
			_tf.width = 90;
			_tf.height = 20;
			mc.addChild(_tf);
			
			mc.num.visible = false;
			
			_tf.mouseEnabled = false;
			
			_tf.filters = [new GlowFilter( 0x5e2f12, 1, 3, 3, 50, 1)];
			
			mc.staricon.mouseEnabled = false
			mc.energyicon.mouseEnabled = false
			
			CBaseUtil.regEvent(GameNotification.EVENT_GROUP_UNLOCKED , __onUnlockGroup);
			
			mc.mouseChildren = false;
			mc.buttonMode = true;
				
			update();
		}
		
		private function __onUnlockGroup(notification:Notification):void
		{
			update();
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_GROUP_UNLOCKED , __onUnlockGroup);
		}
	
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_flowTipItem)
			{
				_flowTipText = "打关收星好礼相送";
				_flowTipItem = new CItemFlowTip(_flowTipText , ConstFlowTipSize.FLOW_TIP_MIDDLE);
				_flowTipItem.x = mc.x + 20;
				_flowTipItem.y = mc.y + mc.height;
				mc.addChild(_flowTipItem);
			}
			else
			{
				mc.removeChild(_flowTipItem);
				_flowTipItem = null;
			}
		}
		
		public function update():void
		{
			var groupConfig:Levels = CLevelConfigUtil.getLevelGroupConfig(_userData.maxLevelGroup);
			
			if(!groupConfig)
			{
				return;
			}
			
			var totalStar:Number = (groupConfig.endlevel + 1) * 3;
			
			var p:Number = _userData.totalStar / totalStar;
			
			p = p > 1 ? 1 : p;
			
			mc.progress.bar.x = _aniStartX + (_aniEndX - _aniStartX) *  p ; 
			
			//显示
			_tf.text = "" + _userData.totalStar + "/" + totalStar;
		}
	}
}