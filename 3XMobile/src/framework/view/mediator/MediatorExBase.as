package framework.view.mediator
{
	import flash.display.MovieClip;
	
	import framework.datagram.Datagram;
	import framework.util.listenerManager.ListenerManager;
	import framework.view.mediator.MediatorBase;

	public class MediatorExBase
	{
		private var mediatorBase:MediatorBase;
		
		public function MediatorExBase(mediatorBase:MediatorBase)
		{
			this.mediatorBase = mediatorBase;
		}
		
		protected function getParent():MediatorBase
		{
			return this.mediatorBase;
		}
		
		protected function get mc():MovieClip
		{
			return mediatorBase.mc;
		}
		
		public function get lsnMan():ListenerManager
		{
			return mediatorBase.lsnMan;
		}
		
		public function start(data:Datagram):void
		{
			
		}
		
		public function updateView(psdTickMs:Number):void
		{
			
		}
		
		public function end():void
		{
			
		}
		
		public function tick(psdTickMs:Number):void
		{
			if(mc)
			{
				updateView(psdTickMs);
			}
		}
	}
}