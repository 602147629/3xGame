package framework.datagram
{
	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-6-24 下午2:26:19 
	 */
	public class DatagramViewNormal extends DatagramView
	{
		public function DatagramViewNormal(viewID:String, popUpImmediately:Boolean=true , params:Object = null)
		{
			super(viewID, popUpImmediately);
			
			for(var k:* in params)
			{
				injectParameterList[k] = params[k];
			}
		}
	}
}