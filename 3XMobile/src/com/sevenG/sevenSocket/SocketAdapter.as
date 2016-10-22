package com.sevenG.sevenSocket
{	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class SocketAdapter extends EventDispatcher implements ISocketAdapter
	{
		protected var _currentSocket:Socket;		
		protected var _hostIp:String;
		protected var _hostPort:int;
		
		protected var _socketName:String;		
				
		/**当前数据包的信息**/
		protected var _socketDataVO:SocketDataVO;		
		/**回调方法**/
		protected var _socketCallBack:ISocketCallBack;
		/**根据指令处理对象**/
		protected var _dataSerializer:Vector.<ISocketDataDeserializer>;
		/**来源**/
		protected var _orgion:int;
		
		/**
		 * 初始化socket对象 
		 * 
		 */		
		public function SocketAdapter(socketName:String,paramHostIp:String, paramHostPort:int,orgion:int,socketCallback:ISocketCallBack, dataSerializer:Vector.<ISocketDataDeserializer>):void
		{			
			_dataSerializer = dataSerializer;
			_orgion = orgion;
			_hostIp = paramHostIp;
			_hostPort = paramHostPort;	
			
			_currentSocket = new Socket();		
			_currentSocket.endian = Endian.LITTLE_ENDIAN;
			_currentSocket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketDataHandler );
			_currentSocket.addEventListener( Event.CLOSE, onCloseHandler );
			_currentSocket.addEventListener( Event.CONNECT, onConnectHandler );
			_currentSocket.addEventListener( IOErrorEvent.IO_ERROR, onIoErrorHandler );
			_currentSocket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
			
			this._socketCallBack = socketCallback;			
			this._socketName = socketName;
		}
		
		/**
		 * 连接 
		 * @param paramHostIp
		 * @param paramHostPort
		 * 
		 */		
		public function connect(paramHostIp:String=null, paramHostPort:int=0):void
		{		
			// 服务器未连接
			if(this._currentSocket.connected)	{return;}
			
			if(paramHostIp!=null)
			{
				this._hostIp = paramHostIp;
				this._hostPort = paramHostPort;
			}
			
			_currentSocket.connect( this._hostIp, this._hostPort );			
		}
		
		
		/**
		 * 断开连接 
		 * 
		 */
		public function disConnect():void
		{
			if(_currentSocket.connected)
			{
				_currentSocket.close();	
			}
		}
		
		/**
		 *  取回状态 
		 * @return 
		 * 
		 */
		//[Bindable]
		public function getConnectState():Boolean
		{
			return this._currentSocket.connected;
		}
		
		/**
		 *  取回状态 
		 * @return 
		 * 
		 */		
		public function getSocketName():String
		{
			return this._socketName;
		}
		
		/**
		 *  第一次注册连接 
		 * @return 
		 * 
		 */		
		public function sendClientConnectMsg():Boolean
		{
			// 服务器未连接
			if(!this._currentSocket.connected)	{return false;}
			
			_currentSocket.writeInt(1);			
			_currentSocket.writeInt(4);
			_currentSocket.writeInt(this._orgion);
			// 发包
			_currentSocket.flush();
			return true;
		}
		
		/**
		 *  心跳连接 
		 * @return 
		 * 
		 */		
		public function sendHeartbeatMsg():Boolean
		{
			// 服务器未连接
			if(!this._currentSocket.connected)	{return false;}
			
			_currentSocket.writeInt(3);			
			_currentSocket.writeInt(0);
			// 发包
			_currentSocket.flush();
			return true;
		}
		
		/**
		 *  
		 * @param socketMessageVO
		 * 
		 */		
		public function sendMsg( socketMessageVO : SocketMessageVO ):Boolean
		{
			// 服务器未连接
			if(!this._currentSocket.connected)	{return false;}
			
			// 组织数据包
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(socketMessageVO.messageContent as String);			
			// 写命令类型
			_currentSocket.writeInt(socketMessageVO.msgType);
			// 发给服务端的大小
			_currentSocket.writeInt(byteArray.length);
			// 写包内容
			_currentSocket.writeUTFBytes(socketMessageVO.messageContent as String);
			// 发包
			_currentSocket.flush();
			
			return true;
		}
		
		/**
		 * 获取数据
		 */
		protected function onSocketDataHandler(event:ProgressEvent):void
		{	
			var count:int=0;
			while(_currentSocket.connected==true &&
				_currentSocket.bytesAvailable >= 8)
			{
				if(getData())
				{
					break;
				}
				count++;
			}
		}
		
		protected function getData():Boolean
		{
			var ret:Boolean = false;
			// 先读消息类型
			if(!this._socketDataVO.IsMsgTypeReaded)
			{				
				if(_currentSocket.bytesAvailable >= this._socketDataVO.MSG_TYPE_LENGTH)
				{
					this._socketDataVO.MsgType = _currentSocket.readInt();
					this._socketDataVO.IsMsgTypeReaded = true;
				}
			}
			
			// 再读信息头
			if(this._socketDataVO.IsMsgTypeReaded&&!this._socketDataVO.IsMsgHeaderReaded)
			{
				if(_currentSocket.bytesAvailable >= this._socketDataVO.MSG_HEADER_LENGTH)
				{
					this._socketDataVO.MsgLength = _currentSocket.readInt();
					this._socketDataVO.IsMsgHeaderReaded = true;
				}
			}
			
			// 再读包体
			if(this._socketDataVO.IsMsgTypeReaded&&this._socketDataVO.IsMsgHeaderReaded)
			{
				if(_currentSocket.bytesAvailable>=(this._socketDataVO.MsgLength))
				{
					var commandType:int = this._socketDataVO.MsgType;				
					var messageContent:String = _currentSocket.readUTFBytes(this._socketDataVO.MsgLength);
					
					var socketMessageVO : SocketMessageVO = new SocketMessageVO();
					
					socketMessageVO.msgType = commandType;					
					
					
					for each(var des:ISocketDataDeserializer in _dataSerializer)
					{
						socketMessageVO.messageContent = des.Deserialize(commandType,messageContent);
						if(socketMessageVO.messageContent != null)
						{
							break;
						}
					}
					
					// 回调					
					this._socketCallBack.onData(this._socketName,socketMessageVO);
					
					// 准备读取新的包
					this._socketDataVO = new SocketDataVO();					
				}
				else
				{
					ret = true;
				}
			}
			
			return ret;
		}
		
		/**
		 * 连接关闭后
		 */
		protected function onCloseHandler(event:Event):void
		{			
			this._socketCallBack.onDisconnected(this._socketName);
		}
		
		/**
		 * 连接后
		 */
		protected function onConnectHandler(event:Event):void
		{				
			this.sendClientConnectMsg();
			this._socketCallBack.onConnected(this._socketName);
			this._socketDataVO = new SocketDataVO();			
		}
		
		/**
		 * 发生IO错误
		 */
		protected function onIoErrorHandler(event:IOErrorEvent):void
		{
			this._socketCallBack.onIOError(this._socketName);
		}
		
		/**
		 * 发生安全验证错误
		 */
		protected function onSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			this._socketCallBack.onSecurityError(this._socketName);
		}		

		/**socket标识**/
		public function get socketName():String
		{
			return _socketName;
		}

	}
}