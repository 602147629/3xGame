package framework.core.panel
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.model.FullScreenHandler;
	import framework.util.UIUtil;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	public class PanelsHandle
	{
		private static var panels:Vector.<PanelContainer>;
		private static var cover:MovieClip;
		
		private static const MULTI:int = 1;
		private static const SINGLE:int = -1;
		
		private static const WHITE_LIST:Vector.<String> = Vector.<String>([ConstantUI.LOADING_UI,ConstantUI.SPLIT_THE_NUMBER_OF_ITEMS_UI, ConstantUI.DISABLE_MSG_UI, 
															ConstantUI.MONEYTREE_PAY_UI,ConstantUI.ARENA_UI,ConstantUI.CONFIRM_PANEL,ConstantUI.SLAVE_PANEL_UI,
															ConstantUI.RUB_AND_BULLY_UI,ConstantUI.CONFIRM_PANEL_2_UI,ConstantUI.DONATE_RESULT,ConstantUI.ROLE_DETAIL_INFO_UI,
															ConstantUI.TRAINING_CONFIRM_PANEL,ConstantUI.EQUIP_SHOP_TIP_MENU, ConstantUI.SINGLE_OPTION_MENU,
															ConstantUI.CAN_NOT_BUY_MSG]);
		
		public function PanelsHandle()
		{
		}
		
		public static function getScreenPanelNum():int
		{
			return panels != null ? panels.length : 0;
		}
		
		public static function push(panel:Sprite, id:String):int
		{
			if(panels == null)
			{
				panels = new Vector.<PanelContainer>();
			}
			panels.push(new PanelContainer(id, panel));
			
			updateShowPanel(id);
			
			//FullScreenHandler.instance.tweenToAnchorPosition(panels[panels.length - 1].container, panels[panels.length - 1].id);
			if(!isInWhiteList(id))
			{				
				var panelAnother:PanelContainer = getAnotherPanel(id);
				if(panelAnother != null)
				{
					//FullScreenHandler.instance.adjustUiTopLeft(panelAnother.container, panelAnother.id);
//					FullScreenHandler.instance.tweenToAnchorPosition(panelAnother.container, panelAnother.id);
					return MULTI;
				}
			}
			return SINGLE;
		}
		
		private static function isInWhiteList(id:String):Boolean
		{
			for each(var uiId:String in WHITE_LIST)
			{
				if(id == uiId)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private static function getAnotherPanel(id:String):PanelContainer
		{
			for each(var panel:PanelContainer in panels)
			{
				if(panel.id != id)
				{
					return panel;
				}
			}
			
			return null;
		}
		
		private static function updatePosition(mc:Sprite, id:String):void
		{
			var align:int = ConstantUI.getMultiPanelAlign(id);
			
			switch(align)
			{
				case ConstantUI.ALIGN_HORIZONTAL_LEFT:
					mc.x -= ConstantUI.PANEL_DISTANCE + mc.width/mc.scaleX/2;
					break;
				case ConstantUI.ALIGN_HORIZONTAL_RIGHT:
					mc.x += ConstantUI.PANEL_DISTANCE + mc.width/mc.scaleX/2;
					break;
				
			}

		}

		public static function updatePanelPosition(mc:Sprite, id:String):void
		{
			if(getScreenPanelNum() > 1 && !isInWhiteList(id))
			{
				updatePosition(mc, id);
			}
		}
		
		public static function tweenToAnchorPosition(mc:Sprite, id:String,targetX:int,targetY:int):void
		{
			if(getScreenPanelNum() > 1 && !isInWhiteList(id))
			{
				var align:int = ConstantUI.getMultiPanelAlign(id);
				
				switch(align)
				{
					case ConstantUI.ALIGN_HORIZONTAL_LEFT:
						if(id != ConstantUI.ROLE_PANEL && id != ConstantUI.EQUIP_STORE_PANEL_UI)
						{
							targetX -= ConstantUI.PANEL_DISTANCE + mc.width/mc.scaleX/2;
						}
						else
						{
							targetX -= mc.width/mc.scaleX/3;
						}
						break;
					case ConstantUI.ALIGN_HORIZONTAL_RIGHT:
						targetX += ConstantUI.PANEL_DISTANCE + mc.width/mc.scaleX/2;
						break;
				}
				
			}
			TweenLite.to(mc,0.3,{x:targetX, y:targetY });
		}
		
	/*	private static function isCanMultiShow(id:String):Boolean
		{
			if(id == ConstantUI.ROLE_PANEL && isActive(ConstantUI.PACK_PANEL))
			{
				return true;
			}
			else if(id == ConstantUI.PACK_PANEL && isActive(ConstantUI.ROLE_PANEL))
			{
				return true;
			}
			else if(id == ConstantUI.EQUIP_STORE_PANEL_UI && isActive(ConstantUI.PACK_PANEL))
			{
				return true;
			}
			else if(id == ConstantUI.PACK_PANEL && isActive(ConstantUI.EQUIP_STORE_PANEL_UI))
			{
				return true;
			}
			else if(id == ConstantUI.DISABLE_MSG_UI )
			{
				return true;
			}
			return false;
			
		}
		*/
		
		public static function updateShowPanel(id:String):void
		{
			
			if(getScreenPanelNum() > 1)
			{
				var canNotClosePanelNameList:Vector.<String> = new Vector.<String>();
				if(id == ConstantUI.EQUIP_STORE_PANEL_UI)
				{
					canNotClosePanelNameList.push(ConstantUI.PACK_PANEL);
				}
				else if(id == ConstantUI.ROLE_PANEL)
				{
					canNotClosePanelNameList.push(ConstantUI.PACK_PANEL);
				}
				else if(id == ConstantUI.PACK_PANEL)
				{
					canNotClosePanelNameList.push(ConstantUI.ROLE_PANEL);
					canNotClosePanelNameList.push(ConstantUI.EQUIP_STORE_PANEL_UI);
					canNotClosePanelNameList.push(ConstantUI.STAGE_CLEAR_UI);
				}
				/*else if(id == ConstantUI.ROLE_DETAIL_INFO_UI)
				{
					canNotClosePanelNameList.push(ConstantUI.TRAIN_ROOM);
				}*/
				else if(isInWhiteList(id) )
				{
					return;
				}
				/*else if(id == ConstantUI.LOADING_UI)
				{
					canNotClosePanelNameList.push(ConstantUI.FORMATION_PANEL);
				}*/
				for(var i:int = panels.length-1; i >= 0; i--) 
				{
					var panel:PanelContainer = panels[i];
					if(panel.id != id)
					{
						var canCloseIt:Boolean = true;
						for each(var panelName:String in canNotClosePanelNameList)
						{
							if(panel.id == panelName)
							{
								canCloseIt = false;
							}
						}
						if(canCloseIt)
						{
							Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL, new DatagramView(panel.id));						
						}
					}
				}
			}
		}
		
		public static function isActive(id:String):Boolean
		{
			for each(var panel:PanelContainer in panels)
			{
				if(panel.id == id)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function remove(id:String):void
		{		
			for each(var panel:PanelContainer in panels)
			{
				if(panel.id == id)
				{
					var index:int = panels.indexOf(panel);
					if(index != -1)
					{
						panels.splice(index, 1);
					}
					break;
				}
			}
			
			var panelAnother:PanelContainer = getAnotherPanel(id);
			if(panelAnother != null && id != ConstantUI.TIP_PANEL_1 && id != ConstantUI.DISABLE_MSG_UI)
			{
				//FullScreenHandler.instance.adjustUiTopLeft(panelAnother.container, panelAnother.id);
//				FullScreenHandler.instance.tweenToAnchorPosition(panelAnother.container, panelAnother.id);
			}
		}
		
		
		public static function updateCover():void
		{
			/*var root:DisplayObjectContainer = GameEngine.getInstance();

			if(cover == null)
			{
				cover = new MovieClip();//ResHandler.getMc("CoverUI");
				UIUtil.drawDarkBG(cover);
			}
			
			if(cover.parent != null)
			{
				cover.parent.removeChild(cover);
			}
				
			var topPanel:Sprite;
			
			var maxNodeChildIndex:Array = [];
			
			for(var panelIndex:int = 0 ; panelIndex < panels.length; panelIndex++)
			{
				var panel:Sprite = panels[panelIndex] as Sprite;
				
				// Store the childIndex of each node in this panel's display tree
				var currentMovie:DisplayObjectContainer = panel;
				var nodeChildIndex:Array = [];
				while(true)
				{
					nodeChildIndex.unshift(currentMovie.parent.getChildIndex(currentMovie));
					
					if (nodeChildIndex.length > maxNodeChildIndex.length)
					{
						maxNodeChildIndex.push(0);
					}
					
					currentMovie = currentMovie.parent;
					if(currentMovie == root)
					{
						break;
					}
				}
				
				// Find the panel with the highest childIndex in each parent layer, starting at the highest level and moving down if required
				var panelHasHighestChildIndex:Boolean;
				var layerIndex:int;
				
				for(layerIndex = 0; layerIndex < nodeChildIndex.length; layerIndex++)
				{
					if(nodeChildIndex[layerIndex] > maxNodeChildIndex[layerIndex])
					{
						panelHasHighestChildIndex = true;
						topPanel = panel;
						break;
					}
					else if(nodeChildIndex[layerIndex] == maxNodeChildIndex[layerIndex])
					{
						// Continue looping and check the next layer
					}
					else
					{
						// Panel has a lower child index, will never be the top one
						break;
					}
				}
				
				if(panelHasHighestChildIndex)
				{
					for(layerIndex = 0; layerIndex < nodeChildIndex.length; layerIndex++)
					{
						maxNodeChildIndex[layerIndex] = nodeChildIndex[layerIndex];
					}
				}
			}
			
			
			if(topPanel != null)
			{
				topPanel.parent.addChildAt(cover, topPanel.parent.getChildIndex(topPanel));
				UIUtil.drawDarkBG(cover);
			}*/
		}
	}
}
import flash.display.Sprite;


class PanelContainer
{
	public var id:String;
	public var container:Sprite;
	public function PanelContainer(panelId:String, panel:Sprite)
	{
		id = panelId;
		container = panel;
	}
}