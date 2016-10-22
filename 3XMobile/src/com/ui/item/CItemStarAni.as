package com.ui.item
{
	import com.ui.util.CBaseUtil;

	/**
	 * @author caihua
	 * @comment 星星带动画
	 * 创建时间：2014-8-28 上午10:22:27 
	 */
	public class CItemStarAni extends CItemAbstract
	{
		public function CItemStarAni()
		{
			super("effect.star.success");
		}
		
		override protected function drawContent():void
		{
			mc.ani.stop();
			mc.star_liang.visible = false;
			mc.star_an.visible = false;
		}
		
		public function gray():void
		{
			mc.star_liang.visible = false;
			mc.star_an.visible = true;
		}
		
		public function shine():void
		{
			CBaseUtil.playToEndAndStop(mc.ani , function():void{
				mc.star_liang.visible = true;
				mc.star_an.visible = false;
			});
		}
	}
}