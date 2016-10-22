package framework.datagram
{	
	public class DatagramSomeThingClick extends Datagram
	{
		public function DatagramSomeThingClick(buttonLocator:String, object:Object = null)
		{
			super();
			injectParameterList[0] = buttonLocator;
			injectParameterList[1] = object;
		}
		
		public static function getLocatorString(datagram:Object):String
		{
			return (datagram as Datagram).injectParameterList[0];
		}
		
		public static function getObject(datagram:Object):Object
		{
			return (datagram as Datagram).injectParameterList[1];
		}
	}
}