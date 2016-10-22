package framework.rpc.responseMessage
{
	/** 
	 * 接收包需要渐渐完善
	 * @author melody
	 */	
	import flash.utils.ByteArray;
	
	public class PackageIn extends ByteArray
	{
		public var cmdId:int;
		public var MAX_NUMBER:String = "0xffffffffffffffff";
		
		public function PackageIn()
		{
			super();
		}
		//读取字符串
		public function readStr():String
		{
			var length:int = readInt();
			return this.readUTFBytes(length);
		}
		//读取long
		public function readLong():Number{
			
			var long:String = "0x";
			for (var i:int = 0; i < 8; i++)
			{
				var numStr:String = this.readUnsignedByte().toString(16);
				var hexStr:String = numStr.length == 1 ? "0"+numStr : numStr;
				long += hexStr;
			}
			
			if(MAX_NUMBER == long)
			{
				return -1;
			}
			else
			{				
				return Number(long);
			}
			
		}
	}
}