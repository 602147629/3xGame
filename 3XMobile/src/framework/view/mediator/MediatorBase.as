package framework.view.mediator
{	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	
	import framework.core.panel.PanelsHandle;
	import framework.core.tick.GameTicker;
	import framework.core.tick.ITickObject;
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.fibre.patterns.Mediator;
	import framework.model.FileProxy;
	import framework.resource.Resource;
	import framework.resource.ResourceManager;
	import framework.util.DisplayUtil;
	import framework.util.ResHandler;
	import framework.util.UIUtil;
	import framework.util.ValidateUtil;
	import framework.util.listenerManager.ListenerManager;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;
	
	public class MediatorBase extends Mediator implements ITickObject
	{				
		public var lsnMan:ListenerManager = new ListenerManager();
		
		protected var isDialog:Boolean = false;		
		protected var id:String;
		protected var myMediatorName:String;
		protected var currentComponentName:String;
		protected var originalCompomentname:String;
		protected var assetEffectInfos:Array = [];
		protected var isCanDrag:Boolean;
		
		public static const G_CHANGE_WORLD:String = GameNotification.G_CHANGE_WORLD;//"G_CHANGE_WORLD";
		public static const G_REMOVE_WORLD:String = GameNotification.G_REMOVE_WORLD;//"G_REMOVE_WORLD";
		public static const G_POP_UP_PANEL:String = GameNotification.G_POP_UP_PANEL;//"G_POP_UP_PANEL";
		public static const G_CLOSE_PANEL:String = GameNotification.G_CLOSE_PANEL ;//"G_CLOSE_PANEL";
		public static const G_FLUID_SCREEN:String = GameNotification.G_FLUID_SCREEN;
		
		protected var extentionList:Array = [];
		private static const MC_DRAG:String = "mc_Drag";
		private static const MC_BG:String = "mc_bg";
		private var _bgMask:Sprite;
		
		protected function addExtention(ex:MediatorExBase):MediatorExBase
		{
			extentionList.push(ex);
			return ex;
		}
		
		protected function setViewComponent(viewComponent:MovieClip):void
		{
			if(isCanDrag)
			{
				//todo need setDragArea
				if(viewComponent != null && viewComponent[MC_DRAG] != null)
				{
					viewComponent[MC_DRAG].addEventListener(TouchEvent.TOUCH_BEGIN, mouseDownHandler);
					viewComponent[MC_DRAG].addEventListener(TouchEvent.TOUCH_END, mouseUpHandler);
				}
				else if(mc != null && mc[MC_DRAG] != null)
				{
					mc[MC_DRAG].removeEventListener(TouchEvent.TOUCH_BEGIN, mouseDownHandler);
					mc[MC_DRAG].removeEventListener(TouchEvent.TOUCH_END, mouseUpHandler);
				}
			}
			
			this.mc = viewComponent;
			
			if(mc != null)
			{
				var bg:MovieClip = mc[MC_BG];
				if(bg != null)
				{
					bg.mouseEnabled = false;
					bg.mouseChildren = false;
			
				}
			}
			
			DisplayUtil.stopAllAnim(mc);
			
			
			
			CONFIG::debug
			{
//				ValidateUtil.validateDisplayObjectContainerNameDefinationAboutRootName(mc);
				ValidateUtil.validateDisplayObjectContainerAboutDuplicateNamedChildren(mc);
			}
		}
		
		private function mouseDownHandler(e:TouchEvent):void
		{
			mc.startDrag();
		}
		
		private function mouseUpHandler(e:TouchEvent):void
		{
			mc.stopDrag();
		}
		
		public function MediatorBase(id:String, overrideComponentName:String = null, isDrag:Boolean = false , withMask:Boolean = true)
		{
			this._withMask = withMask;
			this.id = id;
			this.myMediatorName = ConstantUI.getMediatorName(id);
			if(overrideComponentName == null)
			{
				currentComponentName = ConstantUI.getUIName(id);
			}	
			else
			{	
				currentComponentName = overrideComponentName;
			}	
			
			originalCompomentname = currentComponentName;
			
			super(myMediatorName); // don'e set the view component
			
			isCanDrag = isDrag;
		}
		
		
		
		final protected function onLangChanged(notification:Notification):void
		{
			if(mc == null)
			{
				return;
			}
			changeLanguageContent();
		}
		
		protected function changeLanguageContent():void
		{
			
		}
		
		protected function addToLayer(notification:Notification):void
		{
			var data:DatagramView = notification.data as DatagramView;
			if(!mc && data.viewID == id)
			{
				setViewComponent(ResHandler.getMcFirstLoad(currentComponentName));
				if(mc)
				{
					data.layer.addChild(mc);
				}
				else
				{
					CONFIG::debug
					{
						ASSERT(false, "get resource is null! , resourceName: " + currentComponentName);
					}
				}
				startBase(data);
			}
		}
		
		protected function beforeSetViewComponent(d:DatagramView):void
		{
			
		}
		
		protected function popUpOnLayer(notification:Notification):void
		{
			var data:DatagramView = notification.data as DatagramView;
			if(!mc && data.viewID == id && canPopUp(data))
			{
				ApplicationMediator.inst.notifyPanelPopUp();
				beforeSetViewComponent(data);
				setViewComponent(ResHandler.getMcFirstLoad(currentComponentName));
				
				//遮罩
				if(this._withMask)
				{
					_bgMask = new Sprite();
					UIUtil.drawDarkBG(_bgMask);
					data.layer.addChild(_bgMask);
				}
				
				data.layer.addChild(mc);
				
//				var tweenFlag:int  = 0;
//				FullScreenHandler.instance.adjustUiTopLeft(mc,data.viewID);
//				if(ConstantLayer.isPanel(data.viewID))
//				{			
//					tweenFlag = PanelsHandle.push(mc, data.viewID);
//				}
//				
//				if(tweenFlag > 0 && ConstantLayer.isPanel(data.viewID))
//				{
//					FullScreenHandler.instance.tweenToAnchorPosition(mc,data.viewID);
//				}
//				else
//				{
//					FullScreenHandler.instance.adjustUiTopLeft(mc,data.viewID);
//				}
//				animPopUp();
				
				isDialog = !data.popUpImmediately;
				startBase(data);
			}
		}
		
		protected function canPopUp(data:DatagramView):Boolean
		{
			return true;
		}
		
		protected var isPanelPoped:Boolean = false;
		
		protected function animPopUp():void
		{			
			//AnimUtility.animPopUpSinglePanel(mc, onPopupAnimDone);
		
		}
		
		private function onPopupAnimDone():void
		{
			isPanelPoped = true;
			notifyPopupAnimDone();
		}
		
		protected function notifyPopupAnimDone():void
		{
			
		}
		
		protected function closePanel(notification:Notification):void
		{
			var data:DatagramView = notification.data as DatagramView;
			if(mc && data.viewID == id)
			{
				if(isActive())
				{
					CONFIG::debug
					{
						TRACE_LOG("close panel:" + id);
					}
					
					var tempMc:MovieClip = mc;
					lsnMan.freeAll();
					
					baseEnd();
					PanelsHandle.remove(data.viewID);
					tempMc.parent.removeChild(tempMc);
					
					if(this._withMask && _bgMask)
					{
						_bgMask.parent.removeChild(_bgMask);
					}
					
					PanelsHandle.updateCover();
					ApplicationMediator.inst.notifyPanelClose(id);			
					isPanelPoped = false;
					
					setViewComponent(null);
				}
			}
		}
		
		
		protected function removeWorld(notification:Notification):void
		{
			var data:DatagramView = notification.data as DatagramView;
			if(mc && data.viewID == id)
			{
				Fibre.getInstance().sendNotification(GameNotification.WORLD_REMOVE, new DatagramView(id), Fibre.SOUND_NOTIFICATION);
				baseEnd();
				DisplayUtil.removeFromParent(mc);
				setViewComponent(null);
				
			}
		}
		
		protected function removeFromLayer(notification:Notification):void
		{
			var data:DatagramView = notification.data as DatagramView;
			if(mc && data.layer == mc.parent)
			{
				baseEnd();
				DisplayUtil.removeFromParent(mc);
				PanelsHandle.remove(data.viewID);
				setViewComponent(null);
			}
		}
		
		override public function onRegister():void 
		{
			GameTicker.getInstance().addToTickQueue(this);
			
			registerObserver(ApplicationMediator.AM_WORLD_ADD_TO_LAYER, addToLayer);
			registerObserver(ApplicationMediator.AM_LAYER_CLEAR, removeFromLayer);
			registerObserver(ApplicationMediator.AM_PANEL_POPUP_FROM_LAYER, popUpOnLayer);
			registerObserver(ApplicationMediator.AM_PANEL_REMOVE, closePanel);
			registerObserver(ApplicationMediator.AM_WORLD_REMOVE, removeWorld);
			
			registerObserver(G_FLUID_SCREEN,fluidScreen);
		}
		
		protected function fluidScreen(notification:Notification):void
		{
//			FullScreenHandler.instance.adjustUiTopLeft(mc,id);
		}
		
		public function sendNtfToCloseThisPanel():void
		{
			var data:DatagramView = new DatagramView(id);
			data.isDialog = isDialog;
			sendNotification(MediatorBase.G_CLOSE_PANEL, data, Fibre.NORMAL_NOTIFICATION);
		}
		
		public function sendNtfToCloseWorld():void
		{
			var data:DatagramView = new DatagramView(id);
			data.isDialog = isDialog;
			sendNotification(MediatorBase.G_REMOVE_WORLD, data, Fibre.NORMAL_NOTIFICATION);
		}	
		
		
		protected final function initStaticText():void
		{
			
		}
		
		protected final function startBase(d:DatagramView):void
		{
			initStaticText();
			start(d);
			updateView(0);
			
			for(var i:int = 0 ; i < extentionList.length ; i++)
			{
				var ex:MediatorExBase = extentionList[i];
				ex.start(d);
				ex.updateView(0);
			}
			
			
			fibre.sendNotification(GameNotification.PANEL_POPUP, new DatagramView(id));
		}
		
		protected function start(d:DatagramView):void
		{
			
		}
		
		protected function end():void
		{
			
		}
		
		public function updateView(psdTickMs:Number):void
		{
			
		}
		
		protected final function baseEnd():void
		{
			
			
			end();
			for(var i:int = 0 ; i < extentionList.length ; i++)
			{
				var ex:MediatorExBase = extentionList[i];
				ex.end();
			}
			DisplayUtil.stopAllAnim(mc);
			DisplayUtil.removeAllChildrenTree(mc);
			lsnMan.freeAll();
		}
		
		public function tickObject(psdTickMs:Number):void
		{
			if(mc != null)
			{
				updateView(psdTickMs);
			}
			
			for(var i:int = 0 ; i < extentionList.length ; i++)
			{
				var ex:MediatorExBase = extentionList[i];
				ex.tick(psdTickMs);
			}
		}
		
		
		public function isTickPaused():Boolean
		{
			return false
		}
		
		public function getSpecChild(desc:String):DisplayObject
		{
			if(mc != null)
			{
				return UIUtil.getSpecChildByAssetAllocationString(desc, mc);
			}
			return null
		}		
		
		public function isActive():Boolean
		{
			return (mc != null);
		}
		
		private var _parent:DisplayObjectContainer;
		private var _withMask:Boolean;
		
		public function setRenderEnabled(on:Boolean):void
		{
			if(on == true)
			{
				_parent.addChild(mc);
			}else
			{
				_parent = mc.parent;
				_parent.removeChild(mc);
			}
		}
		
		CONFIG::debug
		{
			public function tryGetResource():void
			{
				if(currentComponentName != "flash.display.MovieClip"	)
				{
					var res:Resource = ResourceManager.getInstance().getResource(currentComponentName);
					ASSERT(res != null, "Can not get Resource config for: " + currentComponentName);
					
					if(res.getLoadType() == FileProxy.FIRST_LOADING_GROUP_ID)
					{
						ASSERT(res.getContent() != null, "Can not get asset for: " + currentComponentName);
					}
				}
			}
		}
	}
}


