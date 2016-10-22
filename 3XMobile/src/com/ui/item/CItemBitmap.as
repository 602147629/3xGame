package com.ui.item
{
	import flash.display.MovieClip;
	
	import framework.util.ResHandler;

	/**
	 * @author caihua
	 * @comment 取特定的icon
	 * 创建时间：2014-7-28 下午8:33:40 
	 */
	public class CItemBitmap extends CItemAbstract
	{
		private var _index:int = 0;
		
		public function CItemBitmap(index:int)
		{
			_index = index;
			super("");
		}
		
		override protected function drawContent():void
		{
			var cls:Class = ResHandler.getClass("iconObstacle");
			var item:MovieClip = new cls();
			item.gotoAndStop(_index + 1);
			this.addChild(item);
			this.mouseChildren = false;
		}
	}
}