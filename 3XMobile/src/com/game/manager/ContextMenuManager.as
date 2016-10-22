package com.game.manager
{
	import flash.display.Sprite;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 右键菜单管理 
	 * @author Melody
	 */
	public class ContextMenuManager
	{

		public function ContextMenuManager()
		{
		}

		/**
		 * 增加一个menue  
		 * @param target
		 * @param hideDefault
		 * @param info
		 * @param separatorBefore
		 * @param enabled
		 */
		public static function addInfo(target:Sprite,hideDefault:Boolean,info:String,separatorBefore:Boolean=false,enabled:Boolean=false):void
		{
			if (target.contextMenu == null)
			{
				var cm:ContextMenu = new ContextMenu  ;
				target.contextMenu = cm;
			}
			if (hideDefault)
			{
				cm.hideBuiltInItems();
			}
			var infoItem:ContextMenuItem = new ContextMenuItem(info,separatorBefore,enabled);
			target.contextMenu.customItems.push(infoItem);
		}
	}
}