package framework.view.mediator
{
	import framework.datagram.DatagramView;
	import framework.model.DialogManagerProxy;
	import framework.view.ConstantUI;

	public class MediatorPopupWhiteList
	{
		private var list:Vector.<String>;
		
		private static var _instance:MediatorPopupWhiteList;
		
		private var _isActive:Boolean;
		
		public function MediatorPopupWhiteList()
		{
			list = new Vector.<String>();
		}
		
		public static function get instance():MediatorPopupWhiteList
		{
			if(_instance == null)
			{
				_instance = new MediatorPopupWhiteList();
			}
			return _instance;
		}
		
		public function canPopup(viewID:String):Boolean
		{
			return !_isActive || list.indexOf(viewID) != -1 || viewID == ConstantUI.PANEL_ERROR;
		}
		
		public function set isActive(value:Boolean):void
		{
			if(_isActive != value)
			{
				_isActive = value;
				if(!_isActive)
				{
					list = new Vector.<String>();
					//DialogManagerProxy.inst.tryPopPanelWhenWhiteListInactive();
				}
			}
		}
		
		public function isInList(viewID:String):Boolean
		{
			return list.indexOf(viewID) >= 0;
		}
		
		public function pushViewID(viewID:String, activateAutomatically:Boolean = false):void
		{
			if(!isInList(viewID))
			{
				list.push(viewID);
				if(activateAutomatically)
				{
					isActive = true;
				}
			}
		}
		
		public function removeViewID(viewID:String, inactivateAutomatically:Boolean = false):void
		{
			var index:int = list.indexOf(viewID);
			if(index != -1)
			{
				list.splice(index, 1);
				if(inactivateAutomatically)
				{
					isActive = false;
				}
			}
		}
		
		public function removeAllViewID(inactivateAutomatically:Boolean = false):void
		{
			list = new Vector.<String>();
			if(inactivateAutomatically)
			{
				isActive = false;
			}
		}
	}
}