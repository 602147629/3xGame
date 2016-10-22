package com.ui.widget
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment 滚动面板
	 * 创建时间：2014-7-2 下午12:42:19 
	 */
	public class CWidgetScollPane extends CWidgetAbstract
	{
		private var _size:Point;
		private var _source:Sprite;
		
		public function CWidgetScollPane(size:Point , source:Sprite = null)
		{
			_size = size;
			_source = source;
			super(ConstantUI.FL_SCROLLPANE);
		}
		
		override protected function drawContent():void
		{
			mc.setSize(_size.x , _size.y);
			
			mc.horizontalScrollPolicy = "off";
			mc.source = source;
		}

		public function get source():Sprite
		{
			return _source;
		}
		
		public function setSize():void
		{
			mc.setSize(_size.x , _size.y);
		}

		public function set source(value:Sprite):void
		{
			_source = value;
			mc.source = _source;
		}
	}
}