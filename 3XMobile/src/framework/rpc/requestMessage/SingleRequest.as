package framework.rpc.requestMessage
{
	/** 
	 * @author melody
	 */	
	public class SingleRequest
	{
		public var cmdId:int;
		
		public var datas:Array;
		
		public function SingleRequest(_cmdId:int,_datas:Array)
		{
			this.cmdId = _cmdId;
			this.datas = _datas;
		}
	}
}