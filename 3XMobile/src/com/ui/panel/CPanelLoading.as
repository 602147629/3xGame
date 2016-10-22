package com.ui.panel
{
	import com.ui.util.CBaseUtil;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Notification;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	public class CPanelLoading extends CPanelAbstract
	{
		private var _callback:Function;
		private var _params:Object;
		
		public function CPanelLoading()
		{
			super(ConstantUI.PAENL_LOADING);
		}
		
		override protected function drawContent():void
		{
			_callback = this.datagramView.injectParameterList.callback;
			_params = this.datagramView.injectParameterList.params;
			
			CBaseUtil.regEvent(GameNotification.EVENT_SECOND_LOAD_FINISH , __onLoadingComplete);
			
//			CBaseUtil.delayCall(function():void{ CBaseUtil.sendEvent(GameNotification.EVENT_SECOND_LOAD_FINISH) } , 5 );
			
			this.mc.play();
		}
		
		private function __onLoadingComplete(d:Notification):void
		{
			CBaseUtil.delayCall(function():void{ 
			
				if(_callback != null)
				{
					if(_params)
					{
						_callback(_params);
					}
					else
					{
						_callback();
					}
				}
				CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PAENL_LOADING));
			
			} , 1 );
			
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_SECOND_LOAD_FINISH , __onLoadingComplete);
		}
	}
}