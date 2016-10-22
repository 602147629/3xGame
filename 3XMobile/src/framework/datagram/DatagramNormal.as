package framework.datagram
{
	public class DatagramNormal extends Datagram
	{
		public function DatagramNormal(params:Object)
		{
			super();
			injectParameterList[0] = params;
		}
		
		public function getParams():Object
		{
			return injectParameterList[0];
		}
	}
}