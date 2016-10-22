package com.ui.item
{
	import com.greensock.TweenLite;
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import framework.fibre.core.Notification;
	import framework.model.DataManager;
	import framework.model.DataRecorder;
	import framework.resource.faxb.elements.Element;
	import framework.resource.faxb.levelproperty.ElementDemand;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 任务面板的收集
	 * 创建时间：2014-7-7 下午6:41:38 
	 */
	public class CItemTaskCollectBar extends CItemAbstract
	{
		private var _startX:Number = -128;
		
		private var _endX:Number = 0;
		
		private var _element:ElementDemand;
		
		private var _d:DataRecorder;
		
		private var _removeItemList:Array = new Array();
		
		private var _elementConfig:Element;
		
		public function CItemTaskCollectBar(element:ElementDemand , d:DataRecorder)
		{
			_element = element;
			_d = d;
			super("item.task.collect");
		}
		
		override protected function drawContent():void
		{
			mc.duigou.visible = false;
			
			mc.progress.stop();
			
			var cardMc:Sprite = CBaseUtil.getCardMc(_element.showIcon);
			
			cardMc.scaleX = cardMc.scaleY = 0.5;
			
			mc.iconpos.addChild(cardMc);
			if(cardMc is MovieClip)
			{
				MovieClip(cardMc).stop();	
			}
			
			mc.progresstext.text = "0/" + _element.num ;
			
			CBaseUtil.regEvent(GameNotification.EVENT_GAME_REMOVE_ITEM , update);
			
			var len:int = DataManager.getInstance().elements.element.length
			
			for(var i:int = 0 ; i < len ; i ++)
			{
				var element:Element = DataManager.getInstance().elements.element[i];
				if(element.id == int(_element.id))
				{
					_elementConfig = element;
					break;
				}
			}
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_GAME_REMOVE_ITEM , update);
		}
		
		public function update(n:Notification):void
		{
			var num:int = _d.getCollectItemNum(_element);
			
			var percent:Number = num / _element.num ;
			
			percent = percent > 1 ? 1 : percent;
			
			var endX:Number = percent * (_endX - _startX) + _startX;
			
			TweenLite.to(mc.progress.bar , 0.4 , {x:endX , y: mc.progress.bar.y});
			
			mc.progresstext.text = "" + num  + "/" + _element.num ;
			
			if(percent == 1)
			{
				mc.duigou.visible = true;
			}
		}
		
		public function get elementConfig():Element
		{
			return _elementConfig;
		}

	}
}