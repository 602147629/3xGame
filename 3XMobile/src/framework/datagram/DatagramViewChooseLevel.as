package framework.datagram
{
	
	/**
	 * 选关数据
	 */
	public class DatagramViewChooseLevel extends DatagramView
	{
		public function DatagramViewChooseLevel(viewID:String, popUpImmediately:Boolean = true , level:int = 1 )
		{
			super(viewID , popUpImmediately );
			injectParameterList[0] = level;
		}
		
		/**
		 * 获取当前进入的关卡
		 */
		public function getLevel():int
		{
			return injectParameterList[0];
		}
	}
}