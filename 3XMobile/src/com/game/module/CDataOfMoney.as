package com.game.module
{
	import com.ui.util.CBaseUtil;
	
	import framework.fibre.core.Fibre;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgNotifyPlayerMoney;

	/**
	 * @author caihua
	 * @comment 货币
	 * 创建时间：2014-7-19 下午2:14:54 
	 */
	public class CDataOfMoney extends CDataBase
	{
		private var _silver:Number = 0;
		private var _gold:Number = 0;
		private var _moneyData:CMsgNotifyPlayerMoney;
		
		
		public function CDataOfMoney()
		{
			super("CDataOfMoney");
			if(!Debug.ISONLINE)
			{
				this._moneyData = new CMsgNotifyPlayerMoney();
			}
		}
		
		public function init(d:CMsgNotifyPlayerMoney):void
		{
			this._moneyData = d;
			
			Fibre.getInstance().sendNotification(GameNotification.EVENT_MONEY_DATA_UPDATE  , {});
		}

		
		public function get gold():Number
		{
			if(!_moneyData)
			{
				return 0;
			}
			return _moneyData == null ? 0:_moneyData.gold ;
		}
		
		public function set gold(value:Number):void
		{
			_moneyData.gold = value;
		}
		
		public function get silver():Number
		{
			if(!_moneyData)
			{
				return 0;
			}
			return _moneyData == null ? 0: CBaseUtil.toNumber2(_moneyData.silver);
		}
		
		public function set silver(value:Number):void
		{
			_moneyData.silver = CBaseUtil.fromNumber2(value);
		}
	}
}