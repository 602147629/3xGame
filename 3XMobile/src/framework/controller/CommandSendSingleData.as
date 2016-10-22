package framework.controller
{
	import framework.fibre.core.Fibre;
	import framework.model.RpcProxy;
	import framework.rpc.requestMessage.SingleRequest;

	/** 
	 * @author melody
	 */	
	public class CommandSendSingleData
	{
		public function CommandSendSingleData()
		{
		}
		public static function execute(data:SingleRequest):void
		{
			var proxy:RpcProxy = Fibre.getInstance().retrieveProxy(RpcProxy.NAME) as RpcProxy;
			proxy.requsetSingleData(data);
		}
	}
}