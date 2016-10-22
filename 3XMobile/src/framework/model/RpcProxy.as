package framework.model
{
	import com.game.consts.ConstGameNetCmd;
	import com.game.consts.ServerResultConst;
	import com.game.event.SocketEvent;
	
	import flash.utils.getTimer;
	
	import framework.fibre.core.Fibre;
	import framework.fibre.patterns.Proxy;
	import framework.game.InitState;
	import framework.rpc.GameSocket;
	import framework.rpc.requestMessage.SingleRequest;
	import framework.rpc.responseMessage.PackageIn;
	
	/**
	 * 游戏初始化链接
	 * @author melody
	 */
	public class RpcProxy extends Proxy
	{
		public static const NAME:String = "RpcProxy";
		public static const ENTER_SCENE:String = "enterScene";
		public static const CONNECT_SUCCESS:String = "connectSuccess";
		public static const CONNECT_FAILURE:String = "connectFailure";
		public static const USER_NAME_EXIST:String = "userNameExist";
		
		public function RpcProxy()
		{
			super(NAME);
		}
		
		public function init(port:int, ip:String):void
		{
			if (Debug.ISONLINE)
			{
				_port = port;
				_serverIp = ip;
				
				start();
				_currentRequestId = REQUEST_FREE_ID;
			}
			
		}
		
		
		private var _port:int;
		
		private var _serverIp:String;

		private var _mainSocket:GameSocket;
		
		private var _socketQueue:Vector.<RequestData>;
		private var _currentRequestId:int;
		
		private var _sendTimer:Number;
		private static const REQUEST_FREE_ID:int = -1;
		
		public function requsetData(pack:RequestData):void
		{
			if(_socketQueue == null)
			{
				_socketQueue = new Vector.<RequestData>();
			}
			
			_socketQueue.push(pack);
			
//			CommandGlobalOperation.startOnLineTick();
		}
		
		
		public function requsetSingleData(data:SingleRequest):void
		{
			/*var dataVos:Vector.<NetDataVo> = new Vector.<NetDataVo>();
			var dataVo:NetDataVo = new NetDataVo(data.cmdId, data.datas);
			dataVos.push(dataVo);
			
			var pack:PackageOut = new PackageOut(dataVos);
			
			if(_currentRequestId == REQUEST_FREE_ID)
			{				
				sendRequest(new RequestData(data.cmdId, pack));
			}
			else
			{				
				requsetData(new RequestData(data.cmdId, pack));
			}*/		
		}
		
		private var _currentRequest:RequestData;
		
		private function sendRequest(reuqestData:RequestData):void
		{
			_sendTimer = getTimer();
			
			_currentRequestId = reuqestData.cmdId;
			_currentRequest = reuqestData;
			
			_mainSocket.sendData(reuqestData.data);
			
//			CommandGlobalOperation.startOnLineTick();
		}
		
		private function start():void
		{
			
			
			if(_mainSocket)
			{
				_mainSocket.close();
				_mainSocket = null;
				GameSocket.removeCore("game");
			}
			_mainSocket = new GameSocket("game");
			_mainSocket.addEventListener(SocketEvent.NAME, socketConSuccess);
			_mainSocket.addEventListener(SocketEvent.CONNECT_SOCKET_FAILED,socketConFailure);
			_mainSocket.connect(_serverIp, _port);
		}
		
		private function socketConFailure(e:SocketEvent):void
		{
			sendNotification(CONNECT_FAILURE, null, Fibre.NORMAL_NOTIFICATION);
		}
		
		/**
		 *socket链接成功后请求数据验证
		 */
		
		private function executeFail(cmdId:int, dataIn:PackageIn, errorStr:String):void
		{
			if(isLoginServer())
			{
				executeLoginFail(cmdId, dataIn, errorStr);
			}
			else
			{
				executeGameFail(cmdId, dataIn, errorStr);	
			}
		}
		
		private function executeGameFail(cmdId:int, dataIn:PackageIn, errorStr:String):void
		{
			
		}
		
		private function executeLoginFail(cmdId:int, dataIn:PackageIn, errorStr:String):void
		{
			
		}
		
		private function executeLoginSuccess(cmdId:int, dataIn:PackageIn):void
		{
			
		}
		
		private function executeGameSuccess(cmdId:int, dataIn:PackageIn):void
		{
			
				
				

			
		}
		
		private function executeSuccess(cmdId:int, dataIn:PackageIn):void
		{
			if(isLoginServer())
			{
				executeLoginSuccess(cmdId, dataIn);
			}
			else
			{
				executeGameSuccess(cmdId, dataIn);
			}
			
		}
		
		private function isPushFromServerMessage(cmdId:int):Boolean
		{
			return cmdId == ConstGameNetCmd.CMD_SYSTEM_PLAYER_LOGIN_AGAIN ||
					cmdId == ConstGameNetCmd.CMD_SYSTEM_MESSAGE ||
					cmdId == ConstGameNetCmd.CMD_SYSTEM_SERVER_DOWN ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_PLAYER_ENTER_TO_SCENE ||
				    cmdId == ConstGameNetCmd.CMD_NOTICE_OTHER_PLAYER_LEAVE_SCENE ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_OTHER_PLAYER_STATUS_UPDATE ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_PACK_GET_GOODS ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_PACK_DATA_UPDATE ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_UPDATE_ROLE_EXP ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_UPDATE_COIN ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_UPDATE_GOLD ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_PLAYER_MOUNT_CHANGE ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_UPDATE_GOLD ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_OTHER_PLAYER_UPDATE_EQUIP||
					cmdId == ConstGameNetCmd.CMD_NOTICE_GET_EQUIP_BYROLEID ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_PLAYER_OFFLINE ||
					cmdId == ConstGameNetCmd.CMD_NOTICE_PLAYER_ONLINE ||
					cmdId == ConstGameNetCmd.COMBO_VICTORY_NOTICE ||					
					cmdId == ConstGameNetCmd.CMD_NOTICE_FOLLOW_PET_CHANGE||
					cmdId == ConstGameNetCmd.CMD_NOTICE_GET_PLAYER_TALK||
					cmdId == ConstGameNetCmd.CMD_NOTICE_GET_SCENE_TALK||
					cmdId == ConstGameNetCmd.CMD_NOTICE_GET_WORLD_TALK||
					cmdId == ConstGameNetCmd.CMD_NOTICE_WORLD_BOSS_CLOSE||
					cmdId == ConstGameNetCmd.CMD_NOTICE_WORLD_BOSS||
					cmdId == ConstGameNetCmd.CMD_NOTICE_WORLD_BOSS_CURRENT_HP||
					cmdId == ConstGameNetCmd.CMD_NOTICE_WORLD_BOSS_REWARD_NORMAL||
					cmdId == ConstGameNetCmd.CMD_NOTICE_WORLD_BOSS_REWARD_RANK||
					cmdId == ConstGameNetCmd.CMD_NOTICE_WORLD_BOSS_REWARD_FINAL||
					cmdId == ConstGameNetCmd.CMD_NOTICE_TASK_PACK_DATA_UPDATE||
					cmdId == ConstGameNetCmd.CMD_NOTICE_TASK_PACK_GET_GOODS
				;
		}
		
		public function isLoginServer():Boolean
		{
			return false;
		}
		
		private function socketConSuccess(e:SocketEvent):void
		{
			if (e.command == SocketEvent.SOCKET_CONNECTED)
			{
				if(isLoginServer())
				{
					InitState.recordFinish(InitState.KEY_LOGIN_IN_SERVER_SUCCESS);	
				}
				else
				{					
					sendNotification(CONNECT_SUCCESS, null, Fibre.NORMAL_NOTIFICATION);
				}

			}
			else if (e.command == SocketEvent.RECEIVE_SOCKET_DATA)
			{ //获取socket数据
				var dataIn:PackageIn = e.body as PackageIn;
				var cmdId:int = dataIn.cmdId;
				
				if(isPushFromServerMessage(cmdId))
				{
					executeSuccess(cmdId, dataIn);
				}
				else
				{					
					var result:int = dataIn.readByte();
					if (result == ServerResultConst.SUCCESS)
					{
						executeSuccess(cmdId, dataIn);
					}
					else 
					{
						var error:int = dataIn.readByte();
						var errorStr:String ;
						if(dataIn.length > 2)
						{
							
							errorStr = dataIn.readStr();
						}
						
						
						
						if(error == ServerResultConst.SYS_ERROR_SEND)
						{
							//todo try again
							sendRequest(_currentRequest);
							
							return;
						}
						else if(error == ServerResultConst.SYS_ERROR)
						{
							CONFIG::debug
							{
								ASSERT(false, "cmdId: "+ cmdId + " fail! errorCode: "+error  + " error reason:" + errorStr);
							}
						}
						else
						{
							executeFail(cmdId, dataIn, errorStr);
						}
//						if (error == ServerResultConst.ERROR)
//						{
//						}
						/*else
						{		
							CONFIG::debug
							{
								ASSERT(false, "cmdId: "+ cmdId + " fail! errorCode: "+result  + " error reason:" + errorStr);
							}
						}*/
					}
					if(_currentRequestId == REQUEST_FREE_ID || cmdId == _currentRequestId)
					{
						if(_socketQueue != null && _socketQueue.length > 0)
						{
							var reuqestData:RequestData = _socketQueue.shift();
							sendRequest(reuqestData);
						}
						else
						{
							_currentRequestId = REQUEST_FREE_ID;
						}
					}
				}				
			}
		}
		/**
		 * login
		 */
		
	}
	
}

import framework.rpc.requestMessage.PackageOut;

class RequestData
{
	public var cmdId:int;
	public var data:PackageOut;
	public function RequestData(id:int, dataPackageOut:PackageOut)
	{
		cmdId = id;
		data = dataPackageOut;
	}
	
	public function toString():String
	{
		return data.toString();
	}
	
}