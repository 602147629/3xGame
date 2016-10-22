package com.ui.panel
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.TouchEvent;
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 公共确认面板
	 * 创建时间：2014-7-17 下午12:01:01 
	 */
	public class CPanelCommonConfirm extends CPanelAbstract
	{
		private var _okCallBack:Function; 
		
		private var _cancelCallBack:Function; 
		
		private var _okParams:Object = null;
		
		private var _cancelParams:Object = null;

		private var bmd:BitmapData;
		
		public function CPanelCommonConfirm()
		{
			super(ConstantUI.PANEL_COMMON_CONFIRM , true , false , true);
		}
		
		override protected function drawContent():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_WARNING));
			
			_okCallBack = datagramView.injectParameterList["confirmFunc"];
			
			_cancelCallBack = datagramView.injectParameterList["cancelFunc"];
			
			_okParams = datagramView.injectParameterList["confirmParams"];
			
			_cancelParams = datagramView.injectParameterList["cancelParams"];
			
			mc.tfcontent.mouseEnabled = false;
			
			mc.tfcontent = CBaseUtil.getTextField(mc.tfcontent , 16 , 0x7e0101 , "left");
			mc.tfcontent.wordWrap = true;
			mc.tfcontent.width = 320;
			mc.tfcontent.height = 98;
			
			mc.tfcontent.htmlText = datagramView.injectParameterList["msg"];
			
			mc.tfcontent.visible = false;
			bmd = new BitmapData(mc.tfcontent.textWidth + 10 , mc.tfcontent.textHeight , true , 0x00FFFFFF );
			var mat:Matrix = new Matrix();
			bmd.draw(mc.tfcontent , mat);
			var tfBmp:Bitmap = new Bitmap(bmd);
			tfBmp.x = mc.tfcontent.x;
			tfBmp.y = mc.tfcontent.y;
			mc.addChild(tfBmp);
			
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xffffff;
			
			var confirmBtn:CButtonCommon = new CButtonCommon("green" , "确定" , tf , 0x00);
			confirmBtn.x = mc.confirmpos.x;
			confirmBtn.y = mc.confirmpos.y;
			mc.addChild(confirmBtn);
			confirmBtn.addEventListener(TouchEvent.TOUCH_TAP , __onConfirm , false , 0  , true);
			
			var cancelBtn:CButtonCommon = new CButtonCommon("blueshort" , "取消" , tf , 0x00);
			cancelBtn.x = mc.cancelpos.x;
			cancelBtn.y = mc.cancelpos.y;
			mc.addChild(cancelBtn);
			cancelBtn.addEventListener(TouchEvent.TOUCH_TAP , __onCancel , false , 0  , true);
			
			if(_okCallBack == null)
			{
				confirmBtn.visible = false;
			}
			
			if(_cancelCallBack == null)
			{
				cancelBtn.visible = false;
				confirmBtn.x = (mc.width - confirmBtn.width) / 2
			}
		}
		
		protected function __onConfirm(event:TouchEvent):void
		{
			//关闭自己
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramViewNormal(ConstantUI.PANEL_COMMON_CONFIRM));
			
			if(_okCallBack != null)
			{
				if(_okParams)
				{
					_okCallBack(_okParams);
				}
				else
				{
					_okCallBack();
				}
			}
		}
		
		protected function __onCancel(event:TouchEvent):void
		{
			//关闭自己
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramViewNormal(ConstantUI.PANEL_COMMON_CONFIRM));
			
			if(_cancelCallBack != null)
			{
				if(_cancelParams)
				{
					_cancelCallBack(_cancelParams);
				}
				else
				{
					_cancelCallBack();
				}
			}
		}
		
		override protected function dispose():void
		{
			bmd.dispose();
		}
	}
}