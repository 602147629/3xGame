package framework.controller
{
	import framework.fibre.core.Fibre;
	import framework.model.RpcProxy;
	import framework.rpc.requestMessage.PackageOut;

	/** 
	 * @author melody
	 */	
	public class CommandSendDatas
	{
		public function CommandSendDatas()
		{
		}
		public static function execute(data:PackageOut):void
		{
			var proxy:RpcProxy = Fibre.getInstance().retrieveProxy(RpcProxy.NAME) as RpcProxy;
			proxy.requsetData(data);
		}
	}
}