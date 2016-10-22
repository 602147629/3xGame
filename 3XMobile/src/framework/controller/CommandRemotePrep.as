package framework.controller
{
	import framework.fibre.core.Fibre;
	import framework.model.FileProxy;
	import framework.rpc.DataUtil;
	
	public class CommandRemotePrep
	{
		public function CommandRemotePrep()
		{
		}
		
		public static function execute():void
		{		
			DataUtil.instance.loadFirstGroupStartTime = new Date().getTime();
			
			var fileProxy:FileProxy = Fibre.getInstance().retrieveProxy(FileProxy.NAME) as FileProxy;
			fileProxy.initFileProxy();
		}
	}
}