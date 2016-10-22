package framework.controller
{
	import framework.fibre.core.Fibre;
	import framework.rpc.requestMessage.SingleRequest;
	import framework.view.mediator.MediatorRpc;

	public class CommandRpc
	{
		public static function sendMessage(cmdId:int, data:Array):void
		{
			Fibre.getInstance().sendNotification(MediatorRpc.REQUEST_SINGLE_DATA, new SingleRequest(cmdId, data));	
		}
	}
}