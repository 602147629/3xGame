package framework.view.mediator
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import framework.core.panel.PanelsHandle;
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.fibre.patterns.Mediator;
	import framework.model.DialogManagerProxy;
	import framework.rpc.DataUtil;
	import framework.util.DisplayUtil;
	import framework.util.UIUtil;
	import framework.view.ConstantLayer;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;
	
	public class ApplicationMediator extends Mediator
	{
		public static const AM_WORLD_ADD_TO_LAYER:String = GameNotification.AM_WORLD_ADD_TO_LAYER;
		public static const AM_LAYER_CLEAR:String = GameNotification.AM_LAYER_CLEAR;
		public static const AM_PANEL_POPUP_FROM_LAYER:String = GameNotification.AM_PANEL_POPUP_FROM_LAYER;
		public static const AM_PANEL_REMOVE:String = GameNotification.AM_PANEL_REMOVE;
		public static const AM_WORLD_REMOVE:String = GameNotification.AM_WORLD_REMOVE;
		
		public static const NAME:String = "ApplicationMediator"
		
		public static var inst:ApplicationMediator;
		private var _isDrawBlack:Boolean;
		
		private var _popsCount:int = 0;
		
		
		public function ApplicationMediator(app:MovieClip)
		{
			inst = this;
			super(NAME)
			mc = app;
			
//			GlobalTicker.add(mc, tick);
//			mc.addEventListener(Event.ENTER_FRAME,tick)
		}
		
		public function canPopPanelFromQueue():Boolean
		{
			return _popsCount == 0;
		}
		
		public function notifyPanelPopUp():void
		{
			_popsCount ++;
		}
		
		public function notifyPanelClose(viewId:String):void
		{
			_popsCount --;
			CONFIG::debug
			{
				ASSERT(_popsCount >= 0, "ASSERT");
			}

			sendNotification(GameNotification.PANEL_CLOSE, new DatagramView(viewId), Fibre.NORMAL_NOTIFICATION);
		}
		
		public function isAnyPanelPopedUp():Boolean
		{
			return _popsCount > 0;
		}

		public function tick(e:Event):void
		{
			
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			registerObserver(MediatorBase.G_CHANGE_WORLD,changeWorld)
			registerObserver(MediatorBase.G_POP_UP_PANEL,popUpPanel)
			registerObserver(MediatorBase.G_CLOSE_PANEL,closePanel)
			registerObserver(MediatorBase.G_REMOVE_WORLD,removeWorld);
		}
		
		private function changeWorld(notification:Notification):void
		{
			var datagram:DatagramView = notification.data as DatagramView
				
			if(datagram.viewID == ConstantUI.SCENE_MAIN)	
			{
				DataUtil.instance.isInWorld = true;
			}
			else
			{
				DataUtil.instance.isInWorld = false;
			}
				
			var layer:Sprite = mc.getLayer(ConstantLayer.getLayerName(datagram.viewID));
			//clear
			var newDatagram:DatagramView = new DatagramView(null);
			newDatagram.layer = layer;
			sendNotification(AM_LAYER_CLEAR,newDatagram, Fibre.NORMAL_NOTIFICATION);
			
			//add
			newDatagram = new DatagramView(datagram.viewID);
			newDatagram.layer = layer;
			newDatagram.injectParameterList = datagram.injectParameterList;
			sendNotification(AM_WORLD_ADD_TO_LAYER,newDatagram, Fibre.SOUND_NOTIFICATION);
			PanelsHandle.updateCover();
		}
		
		private function popUpPanel(notification:Notification):void
		{
			var newDatagram:DatagramView = getPreparedDatagram(notification);
			DialogManagerProxy.inst.popPanel(newDatagram);

		}
		
		private function getPreparedDatagram(notification:Notification):DatagramView
		{
			var datagram:DatagramView = notification.data as DatagramView;
			var newDatagram:DatagramView = new DatagramView(datagram.viewID);
			
			if(datagram.layer == null)
			{
				if(datagram.layerID != null)
				{
					newDatagram.layer = mc.getLayer(datagram.layerID);
				}
				else
				{
					var layerId:String = ConstantLayer.getLayerName(datagram.viewID);
					if(layerId == ConstantLayer.LAYER_DEFAULT)
					{
						layerId = ConstantLayer.LAYER_TOP_PANEL;
					}
					newDatagram.layer = mc.getLayer(layerId);
				}
			}else
			{
				newDatagram.layer = datagram.layer;
			}
			newDatagram.injectParameterList = datagram.injectParameterList;
			newDatagram.popUpImmediately = datagram.popUpImmediately;
			newDatagram.canIgnore = datagram.canIgnore;
			
			return newDatagram;
		}
		
		private function closePanel(notification:Notification):void
		{
			var datagram:DatagramView = notification.data as DatagramView
			
			var newDataGram:DatagramView = new DatagramView(datagram.viewID);
			
			sendNotification(AM_PANEL_REMOVE,newDataGram, Fibre.SOUND_NOTIFICATION);
			PanelsHandle.updateCover();
		}
		
		private function removeWorld(notification:Notification):void
		{
			var datagram:DatagramView = notification.data as DatagramView
			var newDataGram:DatagramView = new DatagramView(datagram.viewID);
			sendNotification(AM_WORLD_REMOVE,newDataGram, Fibre.NORMAL_NOTIFICATION);
			PanelsHandle.updateCover();
		}
		
		
		public function blurMode(on:Boolean):void
		{
			if(on)
			{
				CONFIG::debug
				{
					TRACE_LOG("show doIt");
				}
				
				var bmd:BitmapData = new BitmapData(ConstantUI.currentScreenWidth,ConstantUI.currentScreenHeight,false);
				//draw all layer behind Blur layer
				
				
				for(var i:int = 0 ; i < ConstantLayer.LAYERS.length ; i++)
				{
					bmd.draw(mc.getLayer(ConstantLayer.LAYERS[i].name));
				}
				
				var bm:Bitmap = new Bitmap(bmd);
					
				mc.getLayer(ConstantLayer.LAYER_BLUR).addChild(bm);
				var bg:MovieClip = new MovieClip();
				UIUtil.drawDarkBG(bg);
				mc.getLayer(ConstantLayer.LAYER_BLUR).addChild(bg);
				
			}else
			{
				
				CONFIG::debug
				{
					TRACE_LOG("hide doIt");
				}
				
				DisplayUtil.removeAllChildren(mc.getLayer(ConstantLayer.LAYER_BLUR));
				mc.getLayer(ConstantLayer.LAYER_BLUR).filters = null;
			}
		}
		
		
	}
}