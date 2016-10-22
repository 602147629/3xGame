package com.ui.item
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CTimer;
	
	import flash.events.Event;
	import flash.events.TouchEvent;
	import flash.text.TextField;
	
	import framework.rpc.NetworkManager;

	public class CItemOnline extends CItemAbstract
	{
		private var _awardBtn:CButtonCommon;
		private var _numTxt:TextField;
		private var _cdTxt:TextField;
		private var _cdTimer:CTimer;
		private var _data:Object;
		
		public function CItemOnline(data:Object)
		{
			this._data = data;
			super("function.online.item");
		}
		
		override protected function drawContent():void
		{
			mc.awarded.visible = false;
			
			_numTxt = CBaseUtil.getTextField(mc.numTxt, 12, 0xffffff);
			_cdTxt = CBaseUtil.getTextField(mc.cdTxt, 14, 0x760B03);
			
			var item:CItemIcon = new CItemIcon(_data.id, 0, true, _data.type, false);
			mc.icon.addChild(item);
			
			if(_data.type == "common.icon")
			{
				_numTxt.text = _data.num;
			}
			else if(_data.type == "common.tool.img")
			{
				_numTxt.text = "X" + _data.num;
			}
			
			var curlv:int = _data.curlv;
			if(_data.lv <= curlv)
			{
				mc.awarded.visible = true;
			}
			else if(_data.lv == curlv + 1)
			{
				if(_data.cd <= 0)
				{
					_awardBtn = new CButtonCommon("blueshort", "领取");
					_awardBtn.x = 0;
					_awardBtn.y = 90;
					mc.addChild(_awardBtn);
					
					_awardBtn.addEventListener(TouchEvent.TOUCH_TAP, onAward);
				}else
				{
					_cdTxt.text = CBaseUtil.getTimeString(_data.cd);
					if(_cdTimer == null)
					{
						_cdTimer = new CTimer();
						_cdTimer.addCallback(onCoolDown, 1);
						_cdTimer.start();
					}
				}
			}
			else
			{
				_cdTxt.text = CBaseUtil.getTimeString(_data.cd);
				if(_cdTimer == null && _data.cd > 0)
				{
					_cdTimer = new CTimer();
					_cdTimer.addCallback(onCoolDown, 1);
					_cdTimer.start();
				}
			}
			
			mc.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		protected function onRemove(event:Event):void
		{
			if(_awardBtn != null)
			{
				_awardBtn.addEventListener(TouchEvent.TOUCH_TAP, onAward);
			}
			mc.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
			
			if(_cdTimer != null)
			{
				_cdTimer.delCallback(onCoolDown);
				_cdTimer = null;
			}
		}
		
		protected function onAward(event:TouchEvent):void
		{
			NetworkManager.instance.sendServerOnlineAward(_data.lv);			
		}
		
		private function onCoolDown():void
		{
			_data.cd -= 1000;
			_cdTxt.text = CBaseUtil.getTimeString(_data.cd);
			
			if(_data.cd < 0)
			{
				NetworkManager.instance.sendServerActivity(0);
				_cdTimer.delCallback(onCoolDown);
				_cdTimer = null;
			}
		}
	}
}