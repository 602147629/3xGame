package com.ui.panel
{
	import com.game.consts.ConstFlowTipSize;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import framework.util.ResHandler;
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment 上层tip框
	 * 创建时间：2014-7-25 下午8:39:17 
	 */
	public class CPanelTip extends CPanelAbstract
	{
		private var _text:String = "";
		private var _size:Point = ConstFlowTipSize.FLOW_TIP_MIDDLE;
		
		private var _wordWrap:Boolean = false;
		
		private var _direction:String = "up";
		
		private var _embedFont:Boolean = false;
		
		private var _x:int = 0; 
		private var _y:int = 0;
		private var _iconId:int;
		private var _iconPos:Point;
		private var _iconSize:Point;
		
		private var _currentX:Number = 0;
		
		public function CPanelTip()
		{
			super(ConstantUI.ITEM_FLOWTIP_UI_SCALE ,  false , false , false);
		}
		
		override protected function drawContent():void
		{
			this.setOpen(CPanelAbstract.DIRECT_OPEN);
			
			var size:Point = datagramView.injectParameterList["size"];
			
			_size = size ? size : _size;
			
			_text = datagramView.injectParameterList["text"];
			
			_wordWrap = datagramView.injectParameterList["wordWrap"];
			
			_x = datagramView.injectParameterList["x"];
			_y = datagramView.injectParameterList["y"];
			
			_direction = datagramView.injectParameterList["direction"];
			
			_embedFont = datagramView.injectParameterList["embedFont"];
			
			_iconId = datagramView.injectParameterList["iconId"];
			_iconPos = datagramView.injectParameterList["iconPos"];
			_iconSize = datagramView.injectParameterList["iconSize"];
			
			if(_iconId != -1)
			{
				__drawIcon();
			}
			
			__drawScaleBg();
			
			__drawText();
			
			mc.mouseEnabled = false;
			
			__locatePos();
			
			mc.mouseChildren = false;
		}
		
		private function __drawIcon():void
		{
			var cls:Class = ResHandler.getClass("common.icon");
			var item:MovieClip = new cls();
			item.gotoAndStop(_iconId + 1);
			
			if(_iconSize)
			{
				item.width = _iconSize.x;
				item.height = _iconSize.y;
			}
			mc.addChild(item);
			
			//调整整体高度
			if(_size.y <= item.height)
			{
				_size.y = item.height + 4;
			}
			
			if(_iconPos)
			{
				item.x = _iconPos.x;
				item.y = _iconPos.y;
			}
			else
			{
				item.x = 2;
				item.y = (_size.y - item.height) / 2;
			}
			
			_currentX = item.x + item.width;
		}
		
		private function __locatePos():void
		{
			if(_direction == "up")
			{
				mc.x = _x;
				mc.y = _y - _size.y;
			}
			else if(_direction == "down")
			{
				mc.x = _x;
				mc.y = _y;
			}
			else if(_direction == "left")
			{
				mc.x = _x - _size.x;
				mc.y = _y;
			}
			else
			{
				mc.x = _x;
				mc.y = _y;
			}
		}
		
		private function __drawText():void
		{
			var tf:TextField;
			if(_embedFont)
			{
				tf = CFontUtil.textFieldSmall;
			}
			else
			{
				tf = new TextField();
				tf.selectable = false;
				tf.defaultTextFormat = new TextFormat("宋体" , 12 , null ,true ,null ,null ,null ,null , "center");
			}
			
			mc.addChild(tf);
			tf.wordWrap = _wordWrap;
			
			tf.width = _size.x - 5;
			tf.text = _text;
			
			//暂时的
			if(_iconId != -1)
			{
				var t:TextField = new TextField();
				t.defaultTextFormat = new TextFormat("宋体" , 12 , null ,true ,null ,null ,null ,null , "center");
				t.text = _text;
				tf.width = t.textWidth + 2;
			}
			tf.x = _currentX;
			
			if(!_wordWrap)
			{
				tf.autoSize = TextFieldAutoSize.CENTER;
				tf.x = (_size.x - tf.textWidth) / 2;
			}
			
			tf.y = (_size.y - tf.textHeight) / 2;
			mc.addChild(tf);
		}
		
		override protected function dispose():void
		{
			_currentX = 0;
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