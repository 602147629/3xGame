package com.sevenG.sevenSocket
{
	import flash.events.IEventDispatcher;

	public interface ISocketAdapter extends IEventDispatcher
	{
		function connect(paramHostIp:String = null, paramHostPort:int=0):void;
		function disConnect():void;
		function getConnectState():Boolean;
		function getSocketName():String;
		function sendClientConnectMsg():Boolean;		
		function sendMsg( socketMessageVO : SocketMessageVO ):Boolean;		
		function sendHeartbeatMsg():Boolean;		
	}
}