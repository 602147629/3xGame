package com.sevenG.sevenSocket
{
	
	public class SocketTestAdapter extends SocketAdapter
	{	
		private var _dataSetter:Function;
		public function setDataSetter(f:Function):void
		{
			_dataSetter = f;
		}
		
		/**
		 * 初始化socket对象 
		 * 
		 */		
		public function SocketTestAdapter(socketName:String,paramHostIp:String, paramHostPort:int,orgion:int,socketCallback:ISocketCallBack, dataSerializer:Vector.<ISocketDataDeserializer>)
		{	
			super(socketName,paramHostIp, paramHostPort,orgion,socketCallback,dataSerializer);
		}
		
				
		/**
		 *  
		 * @param socketMessageVO
		 * 
		 */		
		override public function sendMsg( socketMessageVO : SocketMessageVO ):Boolean
		{		
			var receiveData:Array = _dataSetter.call(this,socketMessageVO);
			
			for each(var o:Object in receiveData)
			{				
				this.receivedMsg(o as SocketMessageVO);	
			}
						
			return true;
		}
		
		public function receivedMsg(socketMessageVO : SocketMessageVO ):void
		{
			this._socketCallBack.onData(this.getSocketName(),socketMessageVO);						
		}
	}
}