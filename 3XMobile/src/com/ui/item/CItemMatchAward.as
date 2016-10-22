package com.ui.item
{
	import com.ui.util.CBaseUtil;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import framework.resource.faxb.award.MatchAward;
	import framework.util.ResHandler;

	public class CItemMatchAward extends CItemAbstract
	{
		public function CItemMatchAward(id:String)
		{
			super(id);
		}
		
		public function setAwardData(matchAward:MatchAward):void
		{
			if(matchAward.id > 3)
			{
				mc.order.visible = false;
				mc.order.stop();
			}else
			{
				mc.order.visible = true;
				mc.order.gotoAndStop(matchAward.id);
			}
			
			var icon:MovieClip = ResHandler.getMcFirstLoad("common.match.item");
			icon.gotoAndStop(matchAward.icon);
			var scale:Number = matchAward.icon > 1 ? 0.4 : 0.5;//mc.icon.width / icon.width;
			icon.scaleX = icon.scaleY = scale;
			icon.x = mc.icon.width - icon.width >> 1;
			icon.y = mc.icon.height - icon.height >> 1;
			mc.icon.addChild(icon);
			
			var rankStr:String = matchAward.max == 0 ? "" + matchAward.min : matchAward.max +"-"+ matchAward.min;
			
			mc.rankTxt.text = String(mc.rankTxt.text).replace("%d", rankStr);
			
			mc.contentTxt.text = "" + matchAward.desc;
			
			var tfBmp1:Bitmap = CBaseUtil.textFieldToBitmap(mc.rankTxt);
			mc.addChild(tfBmp1);

			var tfBmp2:Bitmap = CBaseUtil.textFieldToBitmap(mc.contentTxt);
			mc.addChild(tfBmp2);
		}
	}
}