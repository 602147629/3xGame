package framework.datagram
{
	import flash.display.Sprite;
	
	//for framework
	public class DatagramView extends Datagram
	{
		public var viewID:String;
		public var layerID:String;
		public var layer:Sprite;
		public var popUpImmediately:Boolean;
		public var isDialog:Boolean = false; //only use when send close world/panel ntf
		public var canIgnore:Boolean = false;
		public var priority:int;
		
		public function DatagramView(viewID:String, popUpImmediately:Boolean = true)
		{
			if(viewID)
				this.viewID = viewID;
			
			this.popUpImmediately = popUpImmediately;
		}
		
		public function isSameMediator(data:DatagramView):Boolean
		{
			return viewID == data.viewID;
		}
		
		public function getInjectedValue(key:Object, defaultValue:Object):Object
		{
			var value:Object = injectParameterList[key];
			if(value == null)
			{
				value = defaultValue;
			}
			
			return value;
		}
	}
}