package framework.model
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.geom.Point;
	
	import framework.core.panel.PanelsHandle;
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.util.UIUtil;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	public class FullScreenHandler
	{
		private static var _instance:FullScreenHandler;
		
		private static var _isFullScreenMode:Boolean;
		
		public function FullScreenHandler()
		{
			GameEngine.getInstance().stage.addEventListener(Event.RESIZE,resizeHandle);
		}
		
		public static function get instance() : FullScreenHandler
		{
			if(_instance == null)
			{
				_instance = new FullScreenHandler();
			}
			return _instance;
		}
		
		public function initialScreenSize():void
		{
			resizeHandle();
		}
//		
//		private function getLayerOffset():Point
//		{
//			var point:Point = new Point();
//			
//			if(ConstantUI.currentScreenHeight > ConstantUI.HEIGHT)
//			{
//				point.y = (ConstantUI.currentScreenHeight - ConstantUI.HEIGHT) >> 1;
//			}
//			else
//			{
//				point.y = 0;
//			}
//			
//			if(ConstantUI.currentScreenWidth > ConstantUI.WIDTH)
//			{
//				point.x = (ConstantUI.currentScreenWidth - ConstantUI.WIDTH) >> 1;
//				
//			}
//			else
//			{
//				point.x = 0;
//			}
//			
//			return point;
//		}
//
//		
		public function resizeHandle(e:Event = null):void
		{	
			if(isFullScreenMode)
			{
				ConstantUI.currentScreenWidth = GameEngine.getInstance().stage.stageWidth;
				ConstantUI.currentScreenHeight = GameEngine.getInstance().stage.stageHeight;
			}
			else
			{
				ConstantUI.currentScreenWidth = ConstantUI.WIDTH;
				ConstantUI.currentScreenHeight = ConstantUI.HEIGHT;
			}
			
			TRACE_LOG("currentScreenWidth = " + ConstantUI.currentScreenWidth + " currentScreenHeight = " + ConstantUI.currentScreenHeight);

//			var point:Point = getLayerOffset();
//			GameEngine.getInstance().moveLayerTo(point.x, point.y);
			
//			updateBg(point);
			
//			if(ConstantUI.currentScreenHeight > ConstantUI.HEIGHT)
//			{	
//				ConstantUI.currentScreenHeight = ConstantUI.HEIGHT;
//			}
//			else if(ConstantUI.currentScreenHeight < ConstantUI.HEIGHT/2)
//			{
//				ConstantUI.currentScreenHeight = ConstantUI.HEIGHT/2;
//			}
//			
//			if(ConstantUI.currentScreenWidth > ConstantUI.WIDTH)
//			{
//				ConstantUI.currentScreenWidth = ConstantUI.WIDTH;
//			}
//			else if(ConstantUI.currentScreenWidth < ConstantUI.WIDTH/2)
//			{
//				ConstantUI.currentScreenWidth = ConstantUI.WIDTH/2;
//			}
			
			updateMask();
			
			
			Fibre.getInstance().sendNotification(MediatorBase.G_FLUID_SCREEN,new DatagramView(null));
		}
		
		private function updateMask():void
		{
			GameEngine.getInstance().maskLayer.width = ConstantUI.currentScreenWidth;
			GameEngine.getInstance().maskLayer.height = ConstantUI.currentScreenHeight;
			
//			GameEngine.getInstance().maskLayer.x = (GameEngine.getInstance().stage.stageWidth - ConstantUI.currentScreenWidth ) /2;
//			GameEngine.getInstance().maskLayer.y = (GameEngine.getInstance().stage.stageHeight - ConstantUI.currentScreenHeight ) /2;
		}
		
//		private var _cover:Sprite;
		
//		private function updateBg(point:Point):void
//		{
//			if(_cover == null)
//			{
//				_cover = new Sprite();
//				var container:DisplayObjectContainer = GameEngine.getInstance().maskLayer;
//				container.addChild(_cover);
//			}
//			UIUtil.drawDarkMask(_cover, point.x, point.y);
//		}
		
	/*	private function adjustCoretechPopupPositions():void
		{
			var popups:Array = Popup.activePopUp;
			
			var stageWidth:Number = GameEngine.getInstance.stage.stageWidth;
			var stageHeight:Number = GameEngine.getInstance.stage.stageHeight;
			
			for(var i:int =0; i < Popup.activePopUp.length; i++)
			{
				var popup:Sprite = Popup.activePopUp[i] as Sprite;
				if(popup != null)
				{
					popup.x = stageWidth / 2;
					popup.y = stageHeight / 2;
				}
			}
			
		}*/
		
		public function fullScreenIn():void
		{
			GameEngine.getInstance().stage.displayState =  StageDisplayState.FULL_SCREEN;
			_isFullScreenMode = true;
		}
		
		public function fullScreenOut():void
		{
			GameEngine.getInstance().stage.displayState = StageDisplayState.NORMAL;
			_isFullScreenMode = false;
		}
		
		public static function get isFullScreenMode():Boolean
		{
			// Fixed by Sang Tian: StageDisplayState could be either FULL_SCREEN or FULL_SCREEN_INTERACTIVE when it's in FullScreenMode
			return _isFullScreenMode;	
		}
		
		
//		private function refreshCenterMapBounding():void
//		{
//
//		}
//		
//		
//		
//		public function adjustUiTopLeft(mc:Sprite,viewId:String):void
//		{
//			if(mc != null)
//			{
//				if(ConstantLayer.isPanel(viewId))
//				{
//					adjustUIAsPanel(mc, viewId);
//				}
//				else
//				{	
//					var alignV:int = ConstantUI.getVerticalAlignInfomation(viewId);
//					var alignH:int = ConstantUI.getHorizontalAlignInfomation(viewId);
//					
//					adjustUIAlignVertical(mc, alignV);
//					adjustUIAlignHorizontal(mc, alignH);
//				}
//			}
//		}
		
//		public function getScreenXOffset():Number
//		{
//			var widthOffset:Number = (ConstantUI.currentScreenWidth - ConstantUI.WIDTH);
//			return widthOffset;
//		}
//		
//		public function getScreenYOffset():Number
//		{
//			var heightOffset:Number =(ConstantUI.currentScreenHeight - ConstantUI.HEIGHT);
//			return heightOffset;
//		}
//		
//		private function adjustUIAsPanel(mc:Sprite, viewId:String):void
//		{
//			mc.x = getScreenXOffset()/2 + ConstantUI.WIDTH/2;
//			mc.y = getScreenYOffset()/2 + ConstantUI.HEIGHT/2;
//			
//			PanelsHandle.updatePanelPosition(mc, viewId);
//		}
//		
//		/**
//		 * 缓动定位
//		 * */
//		public function tweenToAnchorPosition(mc:Sprite, viewId:String):void
//		{
//			var targetX:int = getScreenXOffset()/2 + ConstantUI.WIDTH/2;
//			var targetY:int = getScreenYOffset()/2 + ConstantUI.HEIGHT/2;
//			
//			PanelsHandle.tweenToAnchorPosition(mc, viewId,targetX,targetY);
//		}
//		
//		private function adjustUIAlignHorizontal(mc:Sprite, alignH:int):void
//		{
//			switch(alignH)
//			{
//				case ConstantUI.ALIGN_HORIZONTAL_LEFT:
//					break;
//				case ConstantUI.ALIGN_HORIZONTAL_RIGHT:
//					mc.x = ConstantUI.currentScreenWidth;						
//					break;
//				case ConstantUI.ALIGN_HORIZONTAL_NORMAL:
//					mc.x = ConstantUI.currentScreenWidth/2;
//					break;
//				default:
//					break;
//			}
//		}
//		
//		private function adjustUIAlignVertical(mc:Sprite, alignV:int):void
//		{
//			switch(alignV)
//			{
//				case ConstantUI.ALIGN_VERTIVAL_TOP:
//					break;
//				case ConstantUI.ALIGN_VERTIVAL_BOTTOM:
//					mc.y =  ConstantUI.currentScreenHeight;
//					break;
//				case ConstantUI.ALIGN_VERTIVAL_CENTER:
//					mc.y = ConstantUI.currentScreenHeight/2;
//					break;
//				default:
//					
//					break;
//			}
//		}
	}
}