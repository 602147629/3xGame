package com.ui.item
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetAniNumber;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;

	public class CitemSeriesLogin extends CItemAbstract
	{
		private var _data:Object;
		
		private var _itemSpr:Sprite;
		
		private var _awardBtn:CButtonCommon;
		
		public function CitemSeriesLogin(data:Object)
		{
			this._data = data;
			super("function.login.item");
		}
		
		override protected function drawContent():void
		{
			__drawScaleBg();
			__drawItem();
		}
		
		private function __drawItem():void
		{
			var numFrames:Array = CBaseUtil.getFramesByBmp("function.login.daynum", new Point(30, 34), 10);
			
			var levelMc:CWidgetAniNumber = new CWidgetAniNumber(numFrames, _data.id);
			mc.numpos.addChild(levelMc);
			
			this._itemSpr = new Sprite();
			mc.itemlist.addChild(this._itemSpr);
			
			var index:int;
			var len:int = _data.itemList.length;
			for(index = 0; index < len; index++)
			{
				var itemObj:Object = _data.itemList[index];
				var item:Sprite = new Sprite();
				var itemIcon:CItemIcon = new CItemIcon(itemObj.id, 0, true, itemObj.type, false);
				item.addChild(itemIcon);
				item.scaleX = item.scaleY = 0.9;
				var itemNumTxt:TextField = CFontUtil.getTextField(CFontUtil.getTextFormat(14, 0x760B03, true, "left"));
				itemNumTxt.text = "X" + itemObj.num;
				itemNumTxt.x = 10;
				itemNumTxt.y = 46;
				item.addChild(itemNumTxt);
				
				item.x = index * 60;
				this._itemSpr.addChild(item);
			}
			
			mc.awarded.visible = false;
			
			var numFrames1:Array = CBaseUtil.getFramesByBmp("function.moneynum", new Point(16, 22), 10);
			
			var moneymc:CWidgetAniNumber = new CWidgetAniNumber(numFrames1, _data.money);
			mc.money.num.addChild(moneymc);
			
			var curlv:int = _data.curlv;
			if(_data.lv <= curlv)
			{
				mc.awarded.visible = true;
			}
			else if(_data.lv == curlv + 1 && _data.curlv != _data.dayNum)
			{
				_awardBtn = new CButtonCommon("blueshort", "领取");
				mc.btn.addChild(_awardBtn);
				
				_awardBtn.addEventListener(TouchEvent.TOUCH_TAP, onAward);
			}
		}
		
		protected function onAward(event:TouchEvent):void
		{
			_awardBtn.removeEventListener(TouchEvent.TOUCH_TAP, onAward);
			
			NetworkManager.instance.sendServerLoginAward(_data.id);
		}
		
		private function __drawScaleBg():void
		{
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_FRIEND_UI_SCALE , 
				new Rectangle(50 , 30 , 4,4) , 
				new Point(423 , 60));
			
			mc.bgpos.addChild(bg);
		}
	}
}