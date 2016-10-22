package com.ui.item
{
	import com.game.consts.ConstFlowTipSize;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment tip框
	 * 创建时间：2014-6-24 下午9:03:47 
	 */
	public class CItemFlowTip extends CItemAbstract
	{
		private var _text:String = "";
		private var _size:Point = ConstFlowTipSize.FLOW_TIP_MIDDLE;
		private var _tf:TextFormat = CFontUtil.textFormatMiddle;
		
		private var _wordWrap:Boolean = false;
		
		public function CItemFlowTip(text:String = "" , size:Point = null , tf:TextFormat = null , wordWrap:Boolean = false)
		{
			_tf = tf ? tf : _tf;
			_size = size ? size : _size;
			
			_text = text;
			
			_wordWrap = wordWrap;
			
			super(ConstantUI.ITEM_FLOWTIP_UI_SCALE);
		}
		
		override protected function drawContent():void
		{
			__drawScaleBg();
			
			__drawText();
			
			mc.mouseEnabled = false;
		}
		
		private function __drawText():void
		{
			var tf:TextField = CFontUtil.textFieldSmall;
			mc.addChild(tf);
			tf.wordWrap = _wordWrap;
			
			tf.width = _size.x - 5;
			tf.text = _text;
			if(!_wordWrap)
			{
				tf.autoSize = TextFieldAutoSize.CENTER;
				tf.x = (_size.x - tf.textWidth) / 2;
			}
			tf.y = (_size.y - tf.textHeight) / 2;
			mc.addChild(tf);
		}
		
		private function __drawScaleBg():void
		{
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_FLOWTIP_UI_SCALE , 
				new Rectangle(14 , 14 , 2,2) , 
				_size);
			mc.bgpos.addChild(bg);
		}
	}
}