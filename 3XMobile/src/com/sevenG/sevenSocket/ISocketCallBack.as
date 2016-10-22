package com.sevenG.sevenSocket
{
	public interface ISocketCallBack
	{
		function onData(socketName:String, socketMessageVO:SocketMessageVO):void;
		function onConnected(socketName:String):void;
		function onDisconnected(socketName:String):void;
		function onIOError(socketName:String):void;
		function onSecurityError(socketName:String):void;
	}
}