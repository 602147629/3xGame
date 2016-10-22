package com.sevenG.sevenSocket
{
	import com.game.consts.ConstGlobalConfig;
	import com.game.event.GameEvent;
	import com.ui.util.CBaseUtil;
	
	import flash.utils.Dictionary;
	
	import framework.rpc.ConfigManager;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.view.notification.GameNotification;

	public class SocketManager extends Object
	{
		/** 单例 **/		
		protected static var _instance:SocketManager;		
		/** 适配器集合 **/		
		private var _socketAdapters:Dictionary;
		
		/** 测试用 **/
		public static const SOCKET_ADAPTER_TEST:String = "TEST";
		/** 文本类型 **/
		public static const SOCKET_ADAPTER_TEXT:String = "TEXT";
		/** protobuf格式 **/
		public static const SOCKET_ADAPTER_PROTOBUF:String = "PROTOBUF";
		
		public function SocketManager()
		{
			this._socketAdapters = new Dictionary();
		}
		
		/**
		 *  创建socket适配器 
		 * @param name
		 * @param ip
		 * @param port
		 * @param callback
		 * @param isDebug 是否创建一个测试socket适配器
		 * 
		 */		
		public function createSocketAdapter(name:String,ip:String,port:int,socketAdapterType:String,orgion:int,deserilizer:Vector.<ISocketDataDeserializer>=null,callback:ISocketCallBack=null):SocketAdapter
		{
			var ret:SocketAdapter = getSocketAdapter(name);
			
			if(ret == null)
			{
				ret = createNewSocketAdapter(socketAdapterType,ip,port,name,orgion,callback,deserilizer);
				addSocketAdapterToList(ret);
				//ret.connect(ip, port);
			}
			
			return ret;
		}
		
		/**
		 * 生成指定类型的socketadapter 
		 * @param socketType
		 * @param name
		 * @param callback
		 * @param serilizer
		 * @return 
		 * 
		 */		
		private function createNewSocketAdapter(socketType:String,ip:String,port:int,name:String,orgion:int,callback:ISocketCallBack,serilizer:Vector.<ISocketDataDeserializer>):SocketAdapter
		{
			var ret:SocketAdapter;
			
			switch(socketType)
			{
				case SocketManager.SOCKET_ADAPTER_TEST:
					ret = new SocketTestAdapter(name,ip,port,orgion,callback,serilizer);
					break;
				case SocketManager.SOCKET_ADAPTER_TEXT:
					ret = new SocketAdapter(name,ip,port,orgion,callback,serilizer);
					break;
				case SocketManager.SOCKET_ADAPTER_PROTOBUF:
					ret = new SocketAdapterProtoBuf(name,ip,port,orgion,callback,serilizer);
					break;
			}
			
			return ret;
		}
		
		/**
		 *  发送请求 
		 * @param name
		 * @param type
		 * @param data
		 * 
		 */		
		public function sendMsg(socketName:String,data:SocketMessageVO):void
		{
			TRACE_RPC(" send message type: "+ data.msgType , socketName);
			
			if(!Debug.ISONLINE)
			{
				return;
			}
			// 取适配器
			var socketAdapter:SocketAdapter = getSocketAdapter(socketName);	
			if(socketAdapter == null){	return;	}
			
			//是否连接
			if(socketAdapter.getConnectState())
			{
				socketAdapter.sendMsg(data);
			}
			else
			{
				TRACE_SOCKET("socketName : " + socketName + "断开连接");
				//如果是游戏服务，不弹出断线
				if(CBaseUtil.getSocketType(socketName) == ConstGlobalConfig.SOCKET_MATCH)
				{
					return;
				}
				//如果处于退出游戏状态，不发送重新连接
				if(DataUtil.instance.isExitGame)
				{
					return;
				}
				
				CBaseUtil.showLoading();
				
				CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL);
				CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER);
				CBaseUtil.showConfirm("连接超时 ， 点击确定退出当前游戏并重连 。 " , __onConfirm , null , socketName);
			}
		}
		
		private function __onConfirm(socketName:String):void
		{
			//延迟
			CBaseUtil.delayCall(function():void{
				var socket:SocketAdapter = getSocketAdapter(socketName);
				if(socket && socket.getConnectState())
				{
//					CBaseUtil.hideLoading();
//					//退出游戏
//					CBaseUtil.sendEvent(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
//					CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
				}
				else
				{
					NetworkManager.instance.restartGame();
					__onConfirm(socketName);
				}
			} , 5);
		}
		
		/**
		 *  心跳请求 
		 * @param socketName
		 */		
		public function sendHeartbeatMsg(socketName:String):void
		{
			// 取适配器
			var socketAdapter:SocketAdapter = getSocketAdapter(socketName);			
			if(socketAdapter == null){	return;	}
			
			//退出游戏不再发心跳
			if(DataUtil.instance.isExitGame)
			{
				return;
			}
			
			// 发包
			socketAdapter.sendHeartbeatMsg();
		}
		
		/**
		 * 连接服务器 
		 * @param socketName
		 * 
		 */		
		public function connectServer(socketName:String):void
		{
			// 取适配器
			var socketAdapter:SocketAdapter = getSocketAdapter(socketName);			
			if(socketAdapter == null){	return;	}
			
			// 发包
			socketAdapter.connect();
		}
		
		/**
		 * 断开服务器 
		 * @param socketName
		 * 
		 */		
		public function disconnectServer(socketName:String):void
		{
			// 取适配器
			var socketAdapter:SocketAdapter = getSocketAdapter(socketName);			
			if(socketAdapter == null){	return;	}
			
			TRACE_SOCKET("socketName : " + socketName + "主动断开连接");
			// 发包
			socketAdapter.disConnect();
			
			delete _socketAdapters[socketName];
		}
				
		/**
		 *  查找 
		 * @param name
		 * @return 
		 * 
		 */		
		public function getSocketAdapter(name:String):SocketAdapter
		{	
			return _socketAdapters[name];
		}
		
		/**
		 * 添加到socketadapter列表 
		 * @param socketAdapter
		 * 
		 */		
		public function addSocketAdapterToList(socketAdapter:SocketAdapter):void
		{
			this._socketAdapters[socketAdapter.getSocketName()] = socketAdapter;
		}
		
		public static function get instance():SocketManager
		{
			if (!_instance)
			{
				_instance = new SocketManager();
			}
			return _instance;
		}
	}
}