package com.sevenG.sevenSocket
{
	public class SocketDataVO 
	{
		/**安全策略错误后的事件**/
		private var _isMsgHeaderReaded:Boolean;
		/**安全策略错误后的事件**/
		private var _isMsgTypeReaded:Boolean;
		/**安全策略错误后的事件**/
		private var _msgType:int;
		/**安全策略错误后的事件**/
		private var _msgLength:int;
		/**安全策略错误后的事件**/
		public const MSG_TYPE_LENGTH:int = 4;
		/**安全策略错误后的事件**/
		public const MSG_HEADER_LENGTH:int = 4;		
		
		public function get IsMsgHeaderReaded():Boolean
		{
			return _isMsgHeaderReaded;
		}
		
		public function set IsMsgHeaderReaded(value:Boolean):void
		{
			_isMsgHeaderReaded = value;
		}
		
		public function get IsMsgTypeReaded():Boolean
		{
			return _isMsgTypeReaded;
		}
		
		public function set IsMsgTypeReaded(value:Boolean):void
		{
			_isMsgTypeReaded = value;
		}
		
		public function get MsgType():int
		{
			return _msgType;
		}
		
		public function set MsgType(value:int):void
		{
			_msgType = value;
		}
		
		public function get MsgLength():int
		{
			return _msgLength;
		}
		
		public function set MsgLength(value:int):void
		{
			_msgLength = value;
		}		
	}
}