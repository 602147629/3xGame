package framework.rpc
{
	
	import com.game.event.SocketEvent;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.XMLSocket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import framework.rpc.responseMessage.PackageIn;

	public class GameSocket extends EventDispatcher
	{
		protected static var instanceMap:Dictionary = new Dictionary();
		protected const MULTITON_MSG:String = "当前的socket对象已经存在";
		protected var multitonKey:String;//每个socket的标示...
		//Socket中的类...
		private var _socket:Socket;
		private var _socket_host:String;
		private var _policy_host:String;
		private var _socket_port:int;
		private var _policy_port:int;
		//socket数据中的头文件字节数...
		private var _tcp_short:int = 0;
		//重连相关的参数..
		private var _rc_num:int = 0;
		private var _rc_tot:int = 10;//允许重连次数...
		
		public function GameSocket(key:String)
		{
			if(GameSocket.instanceMap[key] != null)
			{
				throw Error(MULTITON_MSG);
			}
			
			GameSocket.instanceMap[key] = this;
		}
		public static function getInstance(key:String):GameSocket
		{
			if(GameSocket.instanceMap[key] == null)
			{
				GameSocket.instanceMap[key] = new GameSocket(key);
			}
			return GameSocket.instanceMap[key];
		}
		public static function removeCore(key:String):void
		{
			if(instanceMap[key])
			{
				instanceMap[key].close();
				delete instanceMap[key];			
			}
		}
		
		/**
		 * socket的连接，关闭接口
		 * */
		public function connect(socketHost:String = null,socketPort:int = 0,policyHost:String = null, policyPort:int = 0 ,sendPolicy:Boolean = false):void
		{
			if(_socket) close();
			//
			if(socketHost)
			{
				_socket_host = socketHost;
			}
			if(policyHost) 
			{
				_policy_host = policyHost;
			}
			else
			{
				_policy_host = socketHost;
			}
			
			
			if(socketPort > 0)
			{
				_socket_port = socketPort;
			}
			if(policyPort > 0) 
			{
				_policy_port = policyPort;
			}
			//
			if(_socket_host == null||_socket_port == 0)
			{
				return;
			}
			//xmlsocket://foo.com:414
			var _url:String = "xmlsocket://" + _policy_host + ":" + _policy_port;
			
			CONFIG::debug
			{
				TRACE_RPC("security policy xmlsocket:::  " + _url , "rpc");
				
				TRACE_RPC("socket: "+ _socket_host+ " port: "+socketPort, "rpc");
			}
			
			if(sendPolicy)
			{
				Security.loadPolicyFile(_url);
			}
			//Security.loadPolicyFile(_url);
	
			
			
			
			
			
			_socket = new Socket();
			
			addSocketEvent();
			
			_socket.connect(_socket_host,_socket_port);
			
			CONFIG::debug
			{
				TRACE_RPC("socket connect", "rpc");
			}
		}
		public function close():void
		{
			_tcp_short = 0;
			_rc_num = 0;
			//
			removeSocketEvent();
			if(_socket)
			{
				try
				{
					_socket.close();
				}
				catch(e:Error)
				{
					CONFIG::debug
					{						
						TRACE_RPC("socket close error"+e.toString(), "rpc");
					}
				}
				
			}
			_socket = null;
		}
		
		/**
		 * 为重联机制准备的重连..
		 * 调用此方法，有几个条件：
		 * 一定是链接失败时调用，
		 * 一定是socket对象存在，
		 * 一定是socket需要的参数对象都存在的情况下
		 * */
		public function reconnect():void
		{
			if(_socket == null)
			{
				return;
			}
			_socket.connect(_socket_host,_socket_port);
		}
		
		/**
		 * socket的数据接收和发送部分
		 * */
		//根据需要在某些时候可能需要先发送头文件...
		public function sendHead(header:String):void
		{
			if(_socket&&_socket.connected)
			{
				CONFIG::debug
				{					
//					TRACE_RPC("post host port: " + _socket_host + ":" + _socket_port);
					
					TRACE_RPC("post head:" + header, "rpc");
				}
				_socket.writeUTFBytes(header);
				_socket.flush();
			}
		}
		
		//发送的核心部件..
		public function sendData(pkOut:ByteArray):void 
		{
			/*CONFIG::debug
			{			
				TRACE_RPC("post host port: " + _socket_host + ":" + _socket_port);
			}*/
//			TRACE_RPC("post content:" + content);
			if(_socket&&_socket.connected)
			{
				_socket.writeUnsignedInt(pkOut.length);
				_socket.writeBytes(pkOut,0,pkOut.length);
				_socket.flush();
			}
			else 
			{
				reconnect();
			}
		}
		
		/**
		 * socket的数据处理部分（字符串和需求数据之间的转化部分）
		 * */
		
		
		/**
		 * socket的事件侦听处理部分
		 * */
		private function addSocketEvent():void
		{
			
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onSocketData);
			_socket.addEventListener(Event.CONNECT,onSocketConnect);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onSocketIOError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSocketSecurityError);
			_socket.addEventListener(Event.CLOSE,onSocketClose);
		}
		private function removeSocketEvent():void
		{
			if(_socket == null) 
			{
				return;
			}
			
			_socket.removeEventListener(ProgressEvent.SOCKET_DATA,onSocketData);
			_socket.removeEventListener(Event.CONNECT,onSocketConnect);
			_socket.removeEventListener(IOErrorEvent.IO_ERROR,onSocketIOError);
			_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onSocketSecurityError);
			_socket.removeEventListener(Event.CLOSE,onSocketClose);
		}
		
		private var _readFlag:int = 0;
		private var _length:uint;
		private static const READ_START:int = 0;
		private static const READ_LENGTH:int = 1;
		
		private var _readBuffer:ByteArray;
		
		private function readData(byteArray:ByteArray):void
		{
			var cmdListlength:int = byteArray.readByte();
			for(var i:int=0; i < cmdListlength; i ++)
			{
				var readBuffer:PackageIn = new PackageIn();
				var cmdId:int = byteArray.readUnsignedInt();
				readBuffer.cmdId = cmdId;
				
				//todo what is type?
				var type:int = byteArray.readByte();
				var bodyLen:uint = byteArray.readUnsignedInt();
				
				CONFIG::debug
				{
					TRACE_RPC("receive data  cmdId:"+ cmdId +"  data length:" + bodyLen, "rpc");
				}
				
				byteArray.readBytes(readBuffer,0,bodyLen);
				
				
				
				dispatchSocketEvent(SocketEvent.RECEIVE_SOCKET_DATA, readBuffer);
			}
		}
		
		private function onSocketData(e:ProgressEvent):void
		{			
			while(_socket != null &&  _socket.bytesAvailable > 0 )
			{
				if (_readFlag == READ_START && _socket.bytesAvailable >= 4) 
				{
					_length = _socket.readUnsignedInt();
					_readFlag = READ_LENGTH;
					
					if(_readBuffer == null)
					{						
						_readBuffer = new ByteArray();
					}
					
					_readBuffer.clear();
					_readBuffer.length = 0;
					
				}
				
				if (_readFlag == READ_LENGTH) 
				{
					if(_socket.bytesAvailable >= _length)
					{
						_socket.readBytes(_readBuffer, _readBuffer.length , _length);
						readData(_readBuffer);
						
						
						
						_length = 0;
						_readFlag = READ_START;
					}
					else
					{
						_length -= _socket.bytesAvailable;
						
						_socket.readBytes(_readBuffer, _readBuffer.length);
					}
				}
			}
		}
		private function onSocketConnect(e:Event):void
		{
			//链接建立成功..
			CONFIG::debug
			{				
				TRACE_RPC("socket connect successfully", "rpc");
			}
			//初始化重连的次数...
			_rc_num = 0;
			//
			dispatchSocketEvent(SocketEvent.SOCKET_CONNECTED,e);
		}
		private function onSocketIOError(e:IOErrorEvent):void
		{
			CONFIG::debug
			{				
				TRACE_RPC("socket connect failed because of ioerror:" + e, "rpc");
			}
			
			_rc_num++;
			if(_rc_num > _rc_tot)
			{
				_rc_num = 0;
				dispatchSocketEvent(SocketEvent.CONNECT_SOCKET_FAILED,e);
				
				if(_socket)
				{
					close();
				}
			}
			else
			{
				reconnect();
			}
		}
		private function onSocketSecurityError(e:SecurityErrorEvent):void
		{
			CONFIG::debug
			{				
				TRACE_RPC("socket connect failed because of securityerror:" + e, "rpc");
			}
			//sendNoticeOut(SocketEvent.CONNECT_SOCKET_FAILED,e);
		}
		private function onSocketClose(e:Event):void
		{
			CONFIG::debug
			{
				TRACE_RPC("socket connect failed because of closed:" + e, "rpc");
			}
			//
			//reconnect();
			dispatchSocketEvent(SocketEvent.SOCKET_CLOSED,e);
		}
	
		private function dispatchSocketEvent(command:String = null,data:Object = null):void
		{
			var se:SocketEvent = new SocketEvent(command,data);
			dispatchEvent(se);
		}
		
		/**
		 * socket的心跳机制，根据产品需求可选定制
		 * 这里可以在外部控制的manager中添加..
		 * 在内核中不做添加...
		 * */
		
		
		/**
		 * getter..setter..
		 * */
		public function set socket_host(host:String):void { _socket_host = host; }
		public function set policy_host(host:String):void { _policy_host = host; }
		public function set socket_port(port:int):void { _socket_port = port; }
		public function set policy_port(port:int):void { _policy_port = port; }
		public function set rc_tot(tot:int):void { _rc_tot = tot; }
		
		public function get connected():Boolean
		{
			if(_socket == null) return false;
			else return _socket.connected;
		}
		public function get key():String { return multitonKey; }
		//
	}
}