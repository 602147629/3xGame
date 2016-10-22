package com.hch.iface
{
	/**
	 * 序列化接口
	 */
	public interface ISerialization
	{
		function serialization():String;
		function unSerialization(object:String):void;
	}
}