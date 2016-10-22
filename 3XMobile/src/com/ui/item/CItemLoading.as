package com.ui.item
{
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment loading加载别人界面上的
	 * 创建时间：2014-8-13 上午11:28:41 
	 */
	public class CItemLoading extends CItemAbstract
	{
		public function CItemLoading()
		{
			super(ConstantUI.ICON_LOADING);
		}
		
		public function show():void
		{
			mc.visible = true;
		}
		
		public function close():void
		{
			mc.visible = false;
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
		}
	}
}