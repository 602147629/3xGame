package com.ui.panel
{
	import com.ui.item.CItemFriend;
	
	import flash.geom.Point;
	
	import framework.resource.faxb.sceneui.Level;
	import framework.rpc.DataUtil;

	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-8-16 下午8:54:58 
	 */
	public class CPanelLevelLogo extends CPanelAbstract
	{
		private var logo:CItemFriend;
		public function CPanelLevelLogo()
		{
			super("panel.level.logo" , true ,false ,false);
		}
		
		override protected function drawContent():void
		{
			var l:Level = datagramView.injectParameterList["pos"];
			var size:Point = datagramView.injectParameterList["size"];
			
			logo = new CItemFriend(DataUtil.instance.myUserID , "item.friend.logo" , new Point(36,36));
			mc.addChild(logo);
			
			this.mc.x = l.x;
			this.mc.y = l.y;
		}
	}
}