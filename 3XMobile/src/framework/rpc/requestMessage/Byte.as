package framework.rpc.requestMessage
{
	/** 
	 * @author melody
	 */	
	public class Byte
	{
		public var num:int
		public function Byte(num:int)
		{
			this.num = num;
		}
		
		public function toString():String
		{
			return num.toString();
		}
	}
}