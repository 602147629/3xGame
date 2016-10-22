package com.ui.item
{
	import com.game.consts.ConstIcon;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import framework.util.ResHandler;
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment 开始游戏之前的弹板
	 * 创建时间：2014-7-9 上午10:29:37 
	 */
	public class CItemStartAnimate extends CItemAbstract
	{
		public function CItemStartAnimate()
		{
			super("item.game.beforestart");
		}
		
		override protected function drawContent():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_WARNING));
			
			mc.targettf = CBaseUtil.getTextField(mc.targettf , 16 , 0x7e0101);
			
			mc.targettf.text = CDataManager.getInstance().dataOfLevel.levelConfig.desc;
			
			//图标
			var levelData:CDataOfLevel = CDataManager.getInstance().dataOfLevel;
			
			var iconId:int = CDataManager.getInstance().dataOfLevel.levelConfig.starIcon;
			var icon:MovieClip = ResHandler.getMcFirstLoad("common.icon");;
			if(iconId == 50)
			{
				icon.gotoAndStop(ConstIcon.ICON_TYPE_MIXTURE);
				icon.width = icon.height = 54;
				mc.imgpos.addChild(icon);
			}
			else if(iconId == 100)
			{
				icon.gotoAndStop(ConstIcon.ICON_TYPE_STAR);
				icon.width = icon.height = 54;
				mc.imgpos.addChild(icon);
			}
			else
			{
				var cardMc:Sprite = CBaseUtil.getCardMc(iconId);
				cardMc.scaleX = cardMc.scaleY = 0.8;
				mc.imgpos.addChild(cardMc);
			}
		}
	}
}