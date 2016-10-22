package com.ui.item
{
	import com.ui.iface.ICursor;

	/**
	 * @author caihua
	 * @comment 鼠标
	 * 创建时间：2014-8-25 下午8:00:08 
	 */
	public class CItemCursor extends CItemAbstract implements ICursor
	{
		public function CItemCursor(id:String="common.cursor.finger")
		{
			super(id);
		}
		
		override protected function drawContent():void
		{
			mc.stop();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		public function mouseDown() : void
		{
			mc.gotoAndStop(mc.totalFrames - 1);
		}
		
		public function mouseUp() : void
		{
			mc.gotoAndStop(1);
		}
		
		private function __playOnce():void
		{
//			mc.add
		}
	}
}