package framework.view.mediator
{
	import framework.controller.CommandSendSingleData;
	import framework.fibre.core.Notification;
	import framework.fibre.patterns.Mediator;
	import framework.rpc.requestMessage.SingleRequest;

	/**
	 * @author melody
	 */
	public class MediatorRpc extends Mediator
	{
		public static const NAME:String = "rpcMediator";
		
		/**
		 * 发送多个请求 需要自己拼装packageout
		 */ 
//		public static const REQUEST_DATAS:String = "requestDatas";
		/**
		 * 发送单个请求 数据类型SingleRequest
		 */
		public static const REQUEST_SINGLE_DATA:String = "requestSingleData";

		public function MediatorRpc()
		{
			super(NAME);

		}

		override public function onRegister():void
		{
			if(Debug.ISONLINE)
			{
//				registerObserver(REQUEST_DATAS, onSendDatas);
				registerObserver(REQUEST_SINGLE_DATA, onSendSingleData);
			}
		}

		/*private function onSendDatas(notification:Notification):void
		{
			var data:PackageOut = notification.data as PackageOut;
			CommandSendDatas.execute(data);
		}*/
		private function onSendSingleData(notification:Notification):void
		{
			var data:SingleRequest = notification.data as SingleRequest;
			CommandSendSingleData.execute(data);
		}
	}
}
