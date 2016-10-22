package com.sevenG.sevenSocket
{	
	import com.netease.protobuf.Message;
	
	import flash.utils.ByteArray;
	
	public class SocketAdapterProtoBuf extends SocketAdapter implements ISocketAdapter
	{	
		/**
		 * 初始化socket对象 
		 * 
		 */		
		public function SocketAdapterProtoBuf(socketName:String,paramHostIp:String, paramHostPort:int,orgion:int,socketCallback:ISocketCallBack, dataSerializer:Vector.<ISocketDataDeserializer>)
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
			// 服务器未连接
			if(_currentSocket.connected==false)	
			{
				return false;
			}
			
			if(!Debug.GAME_SOCKET_OFF || !Debug.LOBBY_SOCKET_OFF)
			{
				TRACE("socket type all[send] : " + socketMessageVO.msgType , "socketall");
			}
			
			// 组织数据包
			var byteArray:ByteArray = new ByteArray();
			(socketMessageVO.messageContent as Message).writeTo(byteArray);
			// 写命令类型
			_currentSocket.writeInt(socketMessageVO.msgType);
			// 发给服务端的大小
			_currentSocket.writeInt(byteArray.length);
			// 写包内容
			_currentSocket.writeBytes(byteArray);
			// 发包
			_currentSocket.flush();
			return true;
		}
		
		override protected function getData():Boolean
		{	
			var ret:Boolean = false;
			// 先读消息类型
			if(!this._socketDataVO.IsMsgTypeReaded)
			{				
				if(_currentSocket.bytesAvailable >= this._socketDataVO.MSG_TYPE_LENGTH)
				{
					this._socketDataVO.MsgType = _currentSocket.readInt();
					this._socketDataVO.IsMsgTypeReaded = true;
					
					TRACE("socket type all[receive] : " + _socketDataVO.MsgType , "socketall");
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
					var dataByteArray:ByteArray = new ByteArray();
					
					if(this._socketDataVO.MsgLength > 0)
					{
						_currentSocket.readBytes(dataByteArray,0,this._socketDataVO.MsgLength);	
					}
					
					var socketMessageVO : SocketMessageVO = new SocketMessageVO();
					socketMessageVO.msgType = commandType;
					
					for each(var des:ISocketDataDeserializer in _dataSerializer)
					{
						socketMessageVO.messageContent = des.Deserialize(commandType,dataByteArray);						
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
	}
}