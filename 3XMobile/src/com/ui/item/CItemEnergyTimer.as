package com.ui.item
{
	/**
	 * @author caihua
	 * @comment 体力倒计时
	 * 创建时间：2014-7-11 上午11:01:30 
	 */
	import com.game.consts.ConstGlobalConfig;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.ui.util.CBaseUtil;
	
	import framework.fibre.core.Notification;
	import framework.rpc.NetworkManager;
	import framework.view.notification.GameNotification;
	
	public class CItemEnergyTimer extends CItemAbstract
	{
		private var item:CItemTimer;
		private var _userData:CDataOfGameUser;
		private var _color:uint;
		
		public function CItemEnergyTimer(color:uint = 0xffffff)
		{
			_color = color;
			super("");
		}
		
		override protected function drawContent():void
		{
			_userData = CDataManager.getInstance().dataOfGameUser;
			
			item = new CItemTimer(0 , getRemainTime , null , true , _color);
			this.addChild(item);
			item.mouseChildren = false;
			
			CBaseUtil.regEvent(GameNotification.EVENT_ENERGY_RECOVER_REMAIN_TIME , __onEnergyRecoverTime);
			
			CBaseUtil.regEvent(GameNotification.EVENT_GAME_DATA_UPDATE , __onEnergyChange);
			getRemainTime();
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
		}
		
		private function __onEnergyChange(d:Notification):void
		{
			if(_userData.curEnergy >= ConstGlobalConfig.MAX_ENERGY)
			{
				item.visible = false;
			}
			else
			{
				item.visible = true;
			}
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_ENERGY_RECOVER_REMAIN_TIME , __onEnergyRecoverTime);
			CBaseUtil.removeEvent(GameNotification.EVENT_GAME_DATA_UPDATE , __onEnergyChange);
		}
		
		public function getRemainTime():void
		{
			NetworkManager.instance.sendServerEnergyRecoverRemainTime();
		}
		
		private function __onEnergyRecoverTime(d:Notification):void
		{
			item.seconds = _userData.recoveryTime;
			
			if(_userData.curEnergy >= ConstGlobalConfig.MAX_ENERGY)
			{
				item.visible = false;
			}
			else
			{
				item.visible = true;
			}
		}
		
		public function showBg(b:Boolean):void
		{
			item.showBg(b);	
		}
	}
}