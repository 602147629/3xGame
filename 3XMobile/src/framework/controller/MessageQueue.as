package framework.controller
{
	/**
	 * @author caihua
	 * @comment 消息队列
	 * 创建时间：2014-9-23 下午2:38:50 
	 */
	import framework.fibre.patterns.Proxy;
	
	public class MessageQueue extends Proxy
	{
		public static const NAME:String = "MessageQueue";
		public static var  INSTANCE:MessageQueue = null;
		private var _messageQueue:Array = null;
		
		public static const TICK_INTERVAL:Number = 100;
		
		private var _useTime:Number = 0;
		
		public function MessageQueue()
		{
			super("MessageQueue");
			
			_messageQueue = new Array();
		}
		
		public static function getInstance():MessageQueue
		{
			if(INSTANCE == null)
			{
				INSTANCE = new MessageQueue();
			}
			return INSTANCE;
		}
		
		override public function tickObject(psdTickMs:Number):void
		{
			_useTime += psdTickMs;
			if(_useTime < TICK_INTERVAL)
			{
				return;
			}
			_useTime = 0;
			
			if(_messageQueue.length != 0)
			{
				var msg:Object = _messageQueue.shift();
				var func:Function = msg.func;
				var params:Array = msg.params;
				func.apply(null , params);
			}
		}
		
		/**
		 * 加消息
		 */
		public function pushMessage(obj:Object):void
		{
			_messageQueue.push(obj);
		}
	}
}