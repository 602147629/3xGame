package com.ui.panel
{
	import framework.view.ConstantUI;

	public class CPanelLoadingSamll extends CPanelAbstract
	{
		public function CPanelLoadingSamll()
		{
			super(ConstantUI.ICON_LOADING);
		}
		
		override protected function drawContent():void
		{
			this.mc.content.play();
		}
	}
}