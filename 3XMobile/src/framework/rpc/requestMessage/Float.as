package framework.rpc.requestMessage
{
	public class Float
	{
		public function Float(num:Number)
		{
			this.num = num;
		}
		
		public var num:Number;
		
		public function toString():String
		{
			return num.toString();
		}
	}
}