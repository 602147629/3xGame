package framework.rpc.requestMessage
{
	/** 
	 * @author melody
	 */	
	public class Double
	{
		public var num:Number;
		public function Double(num:Number)
		{
			this.num = num;
		}
		
		public function toString():String
		{
			return num.toString();
		}
	}
}