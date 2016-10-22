package framework.rpc.requestMessage
{
	/** 
	 * @author melody
	 */	
	public class Short
	{
		public var num:int
		
		public function Short(num:int)
		{
			this.num = num;
		}
		
		public function toString():String
		{
			return num.toString();
		}
	}
}