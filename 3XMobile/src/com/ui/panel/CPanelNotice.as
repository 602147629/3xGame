package com.ui.panel
{
	import com.greensock.TweenLite;
	import com.ui.util.CBaseUtil;
	
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.fibre.core.Notification;
	import framework.rpc.DataUtil;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;

	public class CPanelNotice extends CPanelAbstract
	{
		private var _tipsTxt:TextField;
		
		private var _tipsList:Array;
		private var _isPlaying:Boolean;
		
		public function CPanelNotice()
		{
			super(ConstantUI.PANEL_NOTICE, true, false, false);
		}
		
		override protected function drawContent():void
		{
			mc.mouseChildren = false;
			mc.mouseEnabled = false;
			mc.visible = false;
			
			_tipsList = new Array();
			
			_tipsTxt = CBaseUtil.getTextField(mc.content.tipsTxt, 14, 0xFCF895, "left", true);
			
			mc.content.scrollRect = new Rectangle(0, 0, mc.content.width, mc.content.height);
			
			CBaseUtil.regEvent(GameNotification.EVENT_SYSTEM_TIPS, __showSystemTips);
			CBaseUtil.regEvent(GameNotification.EVENT_CHANGE_SYSTEM_TIPS, __changeSystemTips);
		}
		
		private function __changeSystemTips(d:Notification):void
		{
			if(DataUtil.instance.isInWorld)
			{
				mc.x = 171;
				mc.y = 85;
			}else
			{
				mc.x = 250;
				mc.y = 20;
			}
		}
		
		override protected function drawBackgroud():void
		{
			__changeSystemTips(null);
		}
		
		private function __showSystemTips(d:Notification):void
		{
			if(d.data == null)
			{
				return;
			}
			_tipsList.push(d.data as String);
			
			__playSystemTips();
		}
		
		private function __playSystemTips():void
		{
			if(_isPlaying)
			{
				return;
			}
			
			mc.visible = true;
			_isPlaying = true;
			
			__alternatePlay();
		}
		
		private function __alternatePlay():void
		{
			var tstr:String = _tipsList.shift();
			
			if(tstr == "" || tstr == null)
			{
				mc.visible = false;
				_isPlaying = false;
				return;
			}
			
			_tipsTxt.htmlText = tstr;
			_tipsTxt.width = _tipsTxt.textWidth;
			_tipsTxt.x = mc.content.width;
			
			var d:Number = _tipsTxt.textWidth - mc.content.width;
			var dx:Number = d > 0 ? -d : 0;
			
			TweenLite.to(_tipsTxt, 10, {x: dx, onComplete : __onPlayComplete});
		}
		
		private function __onPlayComplete():void
		{
			CBaseUtil.delayCall(function ():void
			{
				__alternatePlay();
			}, 3, 1);
		}
	}
}