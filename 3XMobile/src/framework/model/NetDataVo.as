

package framework.model
{
	/** 
	 * @author melody
	 */	
	public class NetDataVo
	{
		//指令ID
		public var cmdid:int;
		
		//参数
		public var param:Array;
		
		public function NetDataVo(id:int,pa:Array)
		{
			this.cmdid = id ;
			this.param = pa ;
		}
	}
}