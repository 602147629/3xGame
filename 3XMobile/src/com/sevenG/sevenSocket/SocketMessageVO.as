package com.sevenG.sevenSocket
{
	public class SocketMessageVO 
	{
		private var _messageContent:Object;

		public function get messageContent():Object
		{
			return _messageContent;
		}

		public function set messageContent(value:Object):void
		{
			_messageContent = value;
		}

		private var _msgType:int;

		public function get msgType():int
		{
			return _msgType;
		}

		public function set msgType(value:int):void
		{
			_msgType = value;
		}

		
		public function SocketMessageVO(type:int=0,msg:String="")
		{
			this._msgType = type;
			this._messageContent = msg;
		}
	}
}