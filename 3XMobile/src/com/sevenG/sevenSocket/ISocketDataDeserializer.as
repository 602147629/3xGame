package com.sevenG.sevenSocket
{
	/**
	 * 反序列化包内容接口 
	 * @author wangshuo-g
	 * 
	 */	
	public interface ISocketDataDeserializer
	{
		function Deserialize(msgType:int, dataArray:Object):Object;			
	}
}