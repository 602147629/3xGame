package com.game.event
{
	
	import flash.events.Event;

	public class SocketEvent extends Event
	{
		public var body:Object;
		public var command:String;
		//
		public static const NAME:String = "socket_event_name";
		//
		public static const RECEIVE_SOCKET_DATA:String = "receive_socket_data";//获取到socket端的数据...
		public static const CONNECT_SOCKET_FAILED:String = "connect_socket_failed";//经过重连机制后，链接服务端的socket失败...
		public static const SOCKET_CONNECTED:String = "socket_connected";//socket长连接链接成功
		public static const SOCKET_CLOSED:String = "socket_closed";//socket关闭（包括主动和被动)
		//
		public function SocketEvent(_command:String = null,_body:Object = null)
		{
			body = _body;
			command = _command;
			//
			super(NAME);
		}
	}
}