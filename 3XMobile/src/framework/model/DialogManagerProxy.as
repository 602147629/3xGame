package framework.model
{
	import framework.core.panel.PanelsHandle;
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.patterns.Proxy;
	import framework.view.ConstantUI;
	import framework.view.mediator.ApplicationMediator;
	import framework.view.mediator.MediatorBase;
	import framework.view.mediator.MediatorPopupWhiteList;
	
	
	public class DialogManagerProxy extends Proxy
	{
		public static const NAME:String = "DialogManagerProxy";
		public static var inst:DialogManagerProxy;

		private var dialogPopUpTypeIdlyDatagramArr:Vector.<DatagramView>;
		private var dialogPopUpTypeImmediatelyDatagramArr:Vector.<DatagramView>;

		private var positionIndex:int;
		
		public function DialogManagerProxy(name:String = null)
		{
			super(NAME);
			
			dialogPopUpTypeIdlyDatagramArr = new Vector.<DatagramView>();
			dialogPopUpTypeImmediatelyDatagramArr = new Vector.<DatagramView>();
			inst = this;
		}
		
		private var _whiteList:MediatorPopupWhiteList;
		private function get whiteList():MediatorPopupWhiteList
		{
			if(_whiteList == null)
			{
				_whiteList = MediatorPopupWhiteList.instance; 
			}
			return _whiteList;
		}
		
		private function inQueue(viewId:String):Boolean
		{
			var data:DatagramView;
			for each(data in dialogPopUpTypeIdlyDatagramArr)
			{
				if(data.viewID == viewId)
				{
					return true;
				}
			}
			
			for each(data in dialogPopUpTypeImmediatelyDatagramArr)
			{
				if(data.viewID == viewId)
				{
					return true;
				}
			}
			
			return false;
		}
		
		override public function tickObject(psdTickMs:Number):void
		{
			if(dialogPopUpTypeImmediatelyDatagramArr.length > 0)
			{
				tryPopAllImmediatelyPanel();
			}
			
			if(dialogPopUpTypeIdlyDatagramArr.length > 0)
			{
				tryPopOne();
			}
		}
		
		public function isActive(viewId:String):Boolean
		{
			if(inQueue(viewId))
			{
				return true;
			}
			
			var mediator:MediatorBase = Fibre.getInstance().retrieveMediator(ConstantUI.getMediatorName(viewId)) as MediatorBase;
			if(mediator && mediator.isActive())
			{
				return true;
			}
			
			return false;
		}
		
		public function panelLeftNum():int
		{
			return dialogPopUpTypeIdlyDatagramArr.length + dialogPopUpTypeImmediatelyDatagramArr.length;
		}
		
		public function popPanel(datagram:DatagramView):void
		{
			if(whiteList.canPopup(datagram.viewID))
			{
				if(datagram.popUpImmediately)
				{
					sendNotification(ApplicationMediator.AM_PANEL_POPUP_FROM_LAYER, datagram, Fibre.SOUND_NOTIFICATION);
					PanelsHandle.updateCover();					
				}
				else
				{
//					if(whiteList.isActive
//						&& PanelsHandle.getScreenPanelNum() == 0)
//					{
//						sendNotification(ApplicationMediator.AM_PANEL_POPUP_FROM_LAYER, datagram, Fibre.SOUND_NOTIFICATION);
//					}
//					else
//					{
						pushDelayPopup(datagram);
//					}
//					tryPopOne();
				}
			}
			else if(!datagram.canIgnore)
			{
				if(datagram.popUpImmediately)
				{
					dialogPopUpTypeImmediatelyDatagramArr.push(datagram);
				}
				else
				{
					pushDelayPopup(datagram);
//					tryPopOne();
				}
			}
		}
		
		private function tryPopOne():void
		{
			if(ApplicationMediator.inst.canPopPanelFromQueue())
			{
				popOneIdlePanel();
			}
			
			PanelsHandle.updateCover();
		}
		
		private function popOneIdlePanel():void
		{
			var datagram:DatagramView;
			var count:int = dialogPopUpTypeIdlyDatagramArr.length;
			//find first canpop datagram
			for(var i:int = 0; i < count; ++i)
			{
				datagram = dialogPopUpTypeIdlyDatagramArr[i];
				if(whiteList.canPopup(datagram.viewID))
				{
					dialogPopUpTypeIdlyDatagramArr.splice(i, 1);
					sendNotification(ApplicationMediator.AM_PANEL_POPUP_FROM_LAYER, datagram, Fibre.SOUND_NOTIFICATION);
					return;
				}
			}
		}
		
		private function tryPopAllImmediatelyPanel():void
		{
			for(var i:int = 0; i < dialogPopUpTypeImmediatelyDatagramArr.length; ++i)
			{
				var datagram:DatagramView = dialogPopUpTypeImmediatelyDatagramArr[i];
				if(whiteList.canPopup(datagram.viewID))
				{
					dialogPopUpTypeImmediatelyDatagramArr.splice(i, 1);
					sendNotification(ApplicationMediator.AM_PANEL_POPUP_FROM_LAYER, datagram, Fibre.SOUND_NOTIFICATION);
					--i;
				}
			}
			
			PanelsHandle.updateCover();
		}
		
		private function pushDelayPopup(datagram:DatagramView):void
		{
			var initPriority:int = 1;
			
			datagram.priority = initPriority + positionIndex--;
			dialogPopUpTypeIdlyDatagramArr.push(datagram);
			dialogPopUpTypeIdlyDatagramArr.sort(sortByPriority);
		}
		
		private function sortByPriority(d1:DatagramView, d2:DatagramView):int
		{
			return (d2.priority - d1.priority);
		}
	}
}