package com.ui.panel
{
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemStarReward;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CConfigUtil;
	
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 星值奖励的面板
	 * 创建时间：2014-8-26  下午6:21:07 
	 */
	public class CPanelStarReward extends CPanelAbstract
	{
		private var _rewardBtn:Object;
		
		private var _source:Sprite;
		public function CPanelStarReward()
		{
			super(ConstantUI.PANEL_STAR_REWARD);
		}
		
		override protected function drawContent():void
		{
			__specMc();
			
			__drawItems();
			
			__drawBg();
			
			__initEvents();
		}
		
		private function __drawItems():void
		{
			_source.removeChildren();
			var rewards:Array = CConfigUtil.getNextFiveReward(CDataManager.getInstance().dataOfGameUser.rewardLevel);
			
			for(var i:int = 0 ; i< rewards.length ; i++)
			{
				var item:CItemStarReward = new CItemStarReward(rewards[i]);
				item.y += i * 60
				_source.addChild(item);
			}
		}
		
		private function __drawBg():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_BIG_WITHBORDER));
		}
		
		private function __specMc():void
		{
			var btn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(btn);
			btn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false , 0 , true);
			
			_source = new Sprite();
			_source.x = 30 ;
			_source.y = 68;
			mc.addChild(_source);
		}
		
		private function __initEvents():void
		{
			CBaseUtil.regEvent(GameNotification.EVENT_STAR_REWARD_UPDATE  , __update);
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_STAR_REWARD_UPDATE  , __update);
		}
		
		private function __update(d:Notification):void
		{
			this.showLoading();
			__drawItems();
			this.closeLoading();
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_STAR_REWARD));
		}
	}
}