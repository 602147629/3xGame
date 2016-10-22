package framework.rpc
{
	import com.game.consts.ConstGameFlow;
	import com.game.event.GameEvent;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.netease.protobuf.Int64;
	import com.netease.protobuf.UInt64;
	import com.sevenG.sevenSocket.ISocketDataDeserializer;
	import com.sevenG.sevenSocket.SocketAdapter;
	import com.sevenG.sevenSocket.SocketManager;
	import com.sevenG.sevenSocket.SocketMessageVO;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFlowCode;
	import com.ui.util.CSwapUtil;
	
	import framework.datagram.DatagramView;
	import framework.game.InitState;
	import framework.model.DataRecorder;
	import framework.model.RandomItem;
	import framework.model.ScoreItem;
	import framework.model.objects.BasicObject;
	import framework.model.objects.GridObject;
	import framework.sound.MediatorAudio;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.GSMsgID;
	import qihoo.gamelobby.protos.LC2LSMsgID;
	import qihoo.gamelobby.protos.Product_Status;
	import qihoo.gamelobby.protos.UserOrigin;
	import qihoo.gamelobby.protos.User_Action_Type;
	import qihoo.gamelobby.utils.GameLobbySocketDataCreator;
	import qihoo.gamelobby.utils.GameLobbySocketDataProtoBufDeserializer;
	import qihoo.gamelobby.utils.MatchSystemSocketDataCreator;
	import qihoo.triplecleangame.protos.CMsgAcceptAddPlayerRequest;
	import qihoo.triplecleangame.protos.CMsgAcceptRequestGiftRequest;
	import qihoo.triplecleangame.protos.CMsgAddFriendRequest;
	import qihoo.triplecleangame.protos.CMsgDebugRequest;
	import qihoo.triplecleangame.protos.CMsgFriendStarInfoRequest;
	import qihoo.triplecleangame.protos.CMsgGetActivityDayEnergyRequest;
	import qihoo.triplecleangame.protos.CMsgGetActivityInfoRequest;
	import qihoo.triplecleangame.protos.CMsgGetFriendListRequest;
	import qihoo.triplecleangame.protos.CMsgGetFriendScoreRequest;
	import qihoo.triplecleangame.protos.CMsgGetGiftRequest;
	import qihoo.triplecleangame.protos.CMsgGetLevelsInfoRequest;
	import qihoo.triplecleangame.protos.CMsgGetNameImageRequest;
	import qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoRequest;
	import qihoo.triplecleangame.protos.CMsgGetPlayerItemInfoRequest;
	import qihoo.triplecleangame.protos.CMsgGetStarRewardRequest;
	import qihoo.triplecleangame.protos.CMsgGetUserCoinRequest;
	import qihoo.triplecleangame.protos.CMsgGetUserInfoRequest;
	import qihoo.triplecleangame.protos.CMsgMiddleValidateRequest;
	import qihoo.triplecleangame.protos.CMsgPlayerRequestGiftRequest;
	import qihoo.triplecleangame.protos.CMsgQuickAddEnergyRequest;
	import qihoo.triplecleangame.protos.CMsgQuickBuyRequest;
	import qihoo.triplecleangame.protos.CMsgRecommendFriendRequest;
	import qihoo.triplecleangame.protos.CMsgRecoverEnergyIntervalRequest;
	import qihoo.triplecleangame.protos.CMsgStartGameRequest;
	import qihoo.triplecleangame.protos.CMsgStartMatchRequest;
	import qihoo.triplecleangame.protos.CMsgStepCleanRequest;
	import qihoo.triplecleangame.protos.CMsgStopGameRequest;
	import qihoo.triplecleangame.protos.CMsgStopMatchRequest;
	import qihoo.triplecleangame.protos.CMsgUnlockLevelGroupRequest;
	import qihoo.triplecleangame.protos.CMsgUseItemRequest;
	import qihoo.triplecleangame.protos.PBBaseObj;
	import qihoo.triplecleangame.protos.PBCleanResult;
	import qihoo.triplecleangame.protos.PBFriendList;
	import qihoo.triplecleangame.protos.PBGetGiftArray;
	import qihoo.triplecleangame.protos.PBItemInfo;
	import qihoo.triplecleangame.protos.PBMatrix;
	import qihoo.triplecleangame.protos.PBRandomList;
	import qihoo.triplecleangame.protos.PBScoreItem;
	import qihoo.triplecleangame.protos.TRIPLE_CLEAN_LOGIC_MSG_ID;
	
	import time.TimerManager;

	public class NetworkManager extends Object
	{
		/**
		 * 大厅返回的游戏服务器信息 
		 */		
		private var _currentMessage:*;
		
		public var isMatching:Boolean;
		
		public var isReplay:Boolean;
		
		public var isActiveStop:Boolean;
		
		public var isPassiveStop:Boolean;
		
		public var isMatchOver:Boolean;
		
		public var status:int; //比赛的状态时1 关卡状态是0
		
		public static const STATUS_LV:int = 0;
		public static const STATUS_MATCH:int = 1;
		
		private static var _instance:NetworkManager;
		
		public function NetworkManager()
		{
			super();
		}
		
		public static function get instance() : NetworkManager
		{
			if (_instance == null)
			{
				_instance = new NetworkManager();
			}
			return _instance;
		}
		
		
		/****************************************************请求大厅数据***************************************************************/
		/**
		 * 连接大厅 
		 * 
		 */		
		public function connectLobby():void
		{
//			GameEngine.getInstance().getLoading().setProgresstf("正在初始化大厅服务...");
			
			var deserializerList:Vector.<ISocketDataDeserializer> = new Vector.<ISocketDataDeserializer>();
			deserializerList.push(new GameLobbySocketDataProtoBufDeserializer());
			
			var lobbySocket:GameLobbySocketCallback = new GameLobbySocketCallback();
			DataUtil.instance.setCacheDBByKV(ConfigManager.SOCKET_LOBBY, lobbySocket);			
			
			/** 连接socket **/
			SocketManager.instance.createSocketAdapter(
				ConfigManager.SOCKET_LOBBY, 
				ConfigManager.SOCKET_LOBBY_IP, 
				ConfigManager.SOCKET_LOBBY_PORT, 
				SocketManager.SOCKET_ADAPTER_PROTOBUF,
				ConfigManager.SOCKET_LOBBY_ORGION,
				deserializerList, 
				lobbySocket);
			
			TRACE_FLOW(ConstGameFlow.CONNECT_LOBBY);
			TRACE_FLOW("Lobby ip : " + ConfigManager.SOCKET_LOBBY_IP + " port : " + ConfigManager.SOCKET_LOBBY_PORT);
			
			SocketManager.instance.connectServer(ConfigManager.SOCKET_LOBBY);
		}
		/**
		 *  用户登录 
		 * @param originType
		 * @param macUrl
		 * @param q
		 * @param t
		 * @param visitorID
		 * 
		 */		
		public function sendLobbyUserLogin(originType:int, macUrl:*, q:String, t:String, visitorID:*):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_User_Login;
			msg.messageContent = GameLobbySocketDataCreator.sendUserLogin(originType, WebJSManager.macUrl, q, t, visitorID, ConfigManager.GAME_ID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		/**
		 *  请求用户数据 
		 * @param userID
		 * 
		 */		
		public function sendLobbyUserData(userID:*):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_User_Data;
			msg.messageContent = GameLobbySocketDataCreator.sendUserData(new Int64(), ConfigManager.GAME_ID, 0, 0, userID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY, msg);
		}
		
		
		/**
		 * 请求频道列表 
		 * 
		 */		
		public function sendLobbyAreaInfo():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_AreaInfo;
			msg.messageContent = GameLobbySocketDataCreator.sendAreaInfo();
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY, msg);
		}
		/**
		 *  请求防沉迷 
		 * @param userID
		 * 
		 */		
		public function sendLobbyUserFangChenMi(userID:*):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_UserFangChenMi;
			msg.messageContent = GameLobbySocketDataCreator.sendUserFangChenMi(userID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY, msg);
		}
		
		public function sendDebugMessage(debugCode:int, param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_DEBUG_REQUEST;
			var message:CMsgDebugRequest = new CMsgDebugRequest();
			message.opcode = debugCode;
			message.param1 = param1;
			message.param2 = param2;
			message.param3 = param3;
			message.param4 = param4;
			
			msg.messageContent = message;
			
			sendGameRequest(msg);
		}
		/**
		 *  报名比赛 
		 * @param productInfo
		 * @param isFcm 是否需要防沉迷验证
		 * 
		 */		
		public function sendLobbySignUpMatch(productID:int):void
		{
			if(productID == 0)
			{
				return;
			}
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(productID);
			if(matchData && matchData.status != Product_Status.Product_Status_SustainedSignup)
			{
				//非比赛
				if(!NetworkManager.instance.isMatching)
				{
					CFlowCode.params = "当前游戏场未开放,请稍后尝试";
					CFlowCode.Signup_Result_code = 1;
					CFlowCode.showWarning();
				}else
				{
					CBaseUtil.showConfirm("当前比赛正在维护...", new Function());
					CBaseUtil.hideLoading();
				}
				
				NetworkManager.instance.isMatching = false;
				WebJSManager.setPropValue(0);
				return;
			}
			
			if(matchData != null && matchData.visitorCanEnter == 0 &&　WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
			{
				//非比赛
				if(!NetworkManager.instance.isMatching)
				{
					CFlowCode.params = "当前游戏场未开放游客进入";
					CFlowCode.Signup_Result_code = 1;
					CFlowCode.showWarning();
				}else
				{
					CBaseUtil.showConfirm("亲爱的玩家，本房间需要正式玩家才能进入....", WebJSManager.loginEnrol);
					CBaseUtil.hideLoading();
				}
				
				NetworkManager.instance.isMatching = false;
				WebJSManager.setPropValue(0);
				return;
			}
			
			//请求报名比赛
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_Signup;				
			msg.messageContent = GameLobbySocketDataCreator.sendSignUpMsg
				(ConfigManager.GAME_ID, new UInt64(0,0), productID, DataUtil.instance.myUserID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);	
			
			CONFIG::debug
			{
				
				TRACE_LOG("请求加入游戏场：productId: "+ productID + " userId: " + DataUtil.instance.myUserID.low +" --下一步 LS2LC_Ack_Signup");
			}
		}
		/**
		 *  取消报名 
		 * @param productID
		 * 
		 */		
		public function sendLobbySignOffMatch(productID:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_Signoff;				
			msg.messageContent = GameLobbySocketDataCreator.sendSignOffMsg
				(ConfigManager.GAME_ID, new UInt64(0,0), productID, DataUtil.instance.myUserID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);	
		}
		/**
		 * 请求产品列表 
		 * 
		 */		
		public function sendLobbyProductList():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_ProductList;
			msg.messageContent = GameLobbySocketDataCreator.sendProductList(ConfigManager.GAME_ID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		/**
		 * 更新产品列表 
		 */		
		public function sendLobbyUpdateProductList(productID:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_Update_ProductList;
			msg.messageContent = GameLobbySocketDataCreator.sendUpdateProductList(ConfigManager.GAME_ID, productID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		/**
		 *  获取用户比赛信息 
		 * @param productID
		 * 
		 */		
		public function sendLobbyPlayerMatchInfo(productID:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_PlayerMatchInfo;
			msg.messageContent = GameLobbySocketDataCreator.sendPlayerMatchInfo
				(DataUtil.instance.myUserID, ConfigManager.GAME_ID, productID, new UInt64(0, 0));
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		/**
		 *  获取比赛信息 
		 * @param productID
		 * 
		 */		
		public function sendLobbyMatchInfo(productID:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_MatchInfo;
			msg.messageContent = GameLobbySocketDataCreator.sendMatchInfo(ConfigManager.GAME_ID, productID, new UInt64(0, 0));
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		/**
		 *  打开红包 
		 * @param transID
		 * 
		 */		
		public function sendOpenRed(transID:Int64):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_UserLingHongBao;
			msg.messageContent = GameLobbySocketDataCreator.sendUserLingHongBao(transID, DataUtil.instance.myUserID);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		
		/**
		 *  获取在线人数
		 */		
		public function sendLobbyOnlineUser():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_Total_OnlineUserCount;
			msg.messageContent = GameLobbySocketDataCreator.sendTotalOnlineUserCount();
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		
		/**
		 *  获取比赛排名信息 
		 * @param productID
		 * @param matchID
		 * 
		 */		
		public function sendLobbyMatchOrder(productID:int, matchID:UInt64, minRank:int, maxRank:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = LC2LSMsgID.LC2LS_Req_MatchOrder;
			msg.messageContent = GameLobbySocketDataCreator.sendReqMatchOrder(DataUtil.instance.myUserID, ConfigManager.GAME_ID, productID, matchID, minRank, maxRank);
			SocketManager.instance.sendMsg(ConfigManager.SOCKET_LOBBY,msg);
		}
		
		/**
		 * 请求比赛信息 
		 * 
		 */		
		public function reqMatchInfo(minRank:int, maxRank:int):void
		{
			var productID:int = DataUtil.instance.selectMatchProductID;
			if(productID == 0)
			{
				var firstMatch:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getFirstMatch();
				if(firstMatch == null)
				{
					return;
				}
				productID = firstMatch.productID;
			}
			//请求数据
			NetworkManager.instance.sendLobbyPlayerMatchInfo(productID);
			NetworkManager.instance.sendLobbyMatchInfo(productID);
			NetworkManager.instance.sendLobbyMatchOrder(productID, new UInt64(0,0), minRank, maxRank);
		}
		/**************************************************请求游戏数据**********************************************************************/
		/**
		 *  连接游戏服务器 
		 * @param message
		 * 
		 */		
		public function connectGameServer(message:*):void
		{
			this._currentMessage = message;
			if(this._currentMessage == null)
			{
				return;
			}
			
//			GameEngine.getInstance().getLoading().setProgresstf("正在初始化游戏服务...");
			
			var deserializerList:Vector.<ISocketDataDeserializer> = new Vector.<ISocketDataDeserializer>();
			deserializerList.push(new GameSocketDataProtoBufDeserializer());
			deserializerList.push(new GameLobbySocketDataProtoBufDeserializer());
			
			var gameSocketName:String = __getSocketName();
			var gameSocket:framework.rpc.GameServerSocketCallback = new GameServerSocketCallback();
			var socketAdapter:SocketAdapter = SocketManager.instance.getSocketAdapter(gameSocketName);
			if(socketAdapter != null && socketAdapter.getConnectState())
			{
				//正在连接中的直接请求加入游戏
				this.sendGameEnterMatch();
			}else
			{
				//连接
				SocketManager.instance.createSocketAdapter(
					gameSocketName,
					message.gsIP,
					message.port,
					SocketManager.SOCKET_ADAPTER_PROTOBUF,
					ConfigManager.SOCKET_GAME_ORGION,
					deserializerList,
					gameSocket);
				
				SocketManager.instance.connectServer(gameSocketName);
				
				TRACE_LOG("请求游戏服务器--下一步--EnterMatch");
			}
		}
		
		/**
		 * 开始某关卡消除游戏
		 */
		public function sendServerStartLevel(level:int = 0):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_START_GAME_REQUEST;
			var message:CMsgStartGameRequest = new CMsgStartGameRequest();
			message.level = level;
			
			var tools:Array = CDataManager.getInstance().dataOfLevel.inGameToolIdList;
			for(var i:int = 0 ; i< tools.length ; i ++)
			{
				var d:PBItemInfo = new PBItemInfo();
				d.itemID = tools[i].id;
				d.itemNum = tools[i].num;
				
				message.itemArray.push(d);
			}
			
			msg.messageContent = message;
			
			sendGameRequest(msg);
			
			//清理开始游戏前的购买道具信息
			CDataManager.getInstance().dataOfLevel.inGameToolIdList = new Array();
		}
		
		/**
		 * 结算
		 */
		public function sendFinishLevel(map:Vector.<GridObject>, dataRecord:DataRecorder):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_LEVEL_BALANCE_OVER;
			var message:CMsgStepCleanRequest = new CMsgStepCleanRequest();
			message.x = 0;
			message.y = 0;
			message.score = dataRecord.currentScore;
			message.totalScore = dataRecord.score;
			message.curLevel = CDataManager.getInstance().dataOfLevel.level;
			
			for(var id:String in dataRecord.removeItemList)
			{
				var pbClean:PBCleanResult = new PBCleanResult();
				pbClean.id = int(id);
				pbClean.number = dataRecord.removeItemList[id];
				message.cleanResult.push(pbClean);
			}
			
			message.direction = CSwapUtil.getDirection(0, 0, 0, 0);
			
			for each(var grid:GridObject in map)
			{
				var pb:PBMatrix = new PBMatrix();
				pb.x = grid.x;
				pb.y = grid.y;
				
				for each(var basic:BasicObject in grid.basicObjects)
				{
					var pbBasic:PBBaseObj = new PBBaseObj();	
					pbBasic.id = basic.id;
					pb.baseObj.push(pbBasic);
				}
				message.matrix.push(pb);
			}			
			msg.messageContent = message;
			
			sendRequest(msg);
		}
		
		public function sendSwapInfo(srcX:int, srcY:int, dstX:int, dstY:int, map:Vector.<GridObject>, dataRecord:DataRecorder, isSubStep:Boolean):void
		{
			
			CONFIG::debug
			{
				TRACE_ANIMATION_MOVE("send step: "+ isSubStep);
			}
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_STEP_CLEAN_REQUEST;
			var message:CMsgStepCleanRequest = new CMsgStepCleanRequest();
			message.x = srcX;
			message.y = srcY;
			message.score = dataRecord.currentScore;
			message.totalScore = dataRecord.score;
			message.curLevel = CDataManager.getInstance().dataOfLevel.level;
			message.silverNum = dataRecord.sliverCoin;
			message.isSubStep = isSubStep;
			
			
			
			for(var id:String in dataRecord.removeItemList)
			{
				var pbClean:PBCleanResult = new PBCleanResult();
				pbClean.id = int(id);
				pbClean.number = dataRecord.removeItemList[id];
				message.cleanResult.push(pbClean);
			}
			
			for(var id1:String in dataRecord.removeOnceList)
			{
				var pbClean1:PBCleanResult = new PBCleanResult();
				pbClean1.id = int(id1);
				pbClean1.number = dataRecord.removeOnceList[id1];
				message.onceCleanResult.push(pbClean1);
			}
			
			dataRecord.resetOnceList();
			
			message.direction = CSwapUtil.getDirection(srcX, srcY, dstX, dstY);
			
			for each(var grid:GridObject in map)
			{
				var pb:PBMatrix = new PBMatrix();
				pb.x = grid.x;
				pb.y = grid.y;
				
				for each(var basic:BasicObject in grid.basicObjects)
				{
					var pbBasic:PBBaseObj = new PBBaseObj();	
					pbBasic.id = basic.id;
					pb.baseObj.push(pbBasic);
				}
				message.matrix.push(pb);
			}			
			msg.messageContent = message;
			
			sendRequest(msg);
		}
		
		/**
		 *  请求的活动类型, 0:所有活动, 1:每日体赠送
		 * @param type
		 * 
		 */		
		public function sendServerActivityInfo(type:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_ACTIVITY_INFO_REQUEST;
			var message:CMsgGetActivityInfoRequest = new CMsgGetActivityInfoRequest();
			message.activityType = type;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  领取体力 
		 * 
		 */		
		public function sendServerActivityDayEnergy():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_ACTIVITY_DAY_ENERGY_REQUEST;
			var message:CMsgGetActivityDayEnergyRequest = new CMsgGetActivityDayEnergyRequest();
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  开始比赛 
		 * @param matchID
		 * 
		 */		
		public function sendMatchStartMatch(matchID:UInt64):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_START_MATCH_REQUEST;
			var message:CMsgStartMatchRequest = new CMsgStartMatchRequest();
			message.matchID = CBaseUtil.toNumber2(matchID);
			msg.messageContent = message;
			sendMatchRequest(msg);
		}
		
		/**
		 *  比赛结束 
		 */		
		public function sendMatchStopMatch():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_STOP_MATCH_REQUEST;
			var message:CMsgStopMatchRequest = new CMsgStopMatchRequest();
			msg.messageContent = message;
			sendMatchRequest(msg);
		}
		
		/**
		 * 比赛开始某消除游戏
		 */
		public function sendMatchStartLevel(level:int = 0):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_START_GAME_REQUEST;
			var message:CMsgStartGameRequest = new CMsgStartGameRequest();
			message.level = level;
			
			msg.messageContent = message;
			sendMatchRequest(msg);
		}
		
		/**
		 * 请求游戏用户数据
		 */		
		public function sendGameUserData(uid:UInt64):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_USER_INFO_REQUEST;
			var message:CMsgGetUserInfoRequest = new CMsgGetUserInfoRequest();
			message.userID = uid;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  请求解锁关卡组 
		 * @param gid
		 * @param: type 1:星值 2:好友 3:金豆 4:银豆
		 */		
		public function sendServerUnlockLevelGroup(gourpid:int , type:int = 1):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_UNLOCK_LEVEL_GROUP_REQUEST;
			var message:CMsgUnlockLevelGroupRequest = new CMsgUnlockLevelGroupRequest();
			message.userID = DataUtil.instance.myUserID;
			message.levelID = gourpid;
			message.type = type;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		
		/**
		 *  取好友组 
		 * @param num 默认取的数量
		 */		
		public function sendServerGetFriendList(num:int = 18):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_FRIEND_LIST_REQUEST;
			var message:CMsgGetFriendListRequest = new CMsgGetFriendListRequest();
			message.num = num;
			message.userQID = DataUtil.instance.myUserID;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  取推荐组
		 * @param num 默认取的数量
		 */		
		public function sendServerGetRecommandList(num:int = 18):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_RECOMMEND_FRIEND_REQUEST;
			var message:CMsgRecommendFriendRequest = new CMsgRecommendFriendRequest();
			message.num = num;
			message.userQID = DataUtil.instance.myUserID;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  请求好友送我东西
		 * @param fid 好友id
		 */		
		public function sendServerRequestGift(fidList:Array ,id:int, requestNum:int = 1):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_PLAYER_REQUEST_GIFT_REQUEST;
			var message:CMsgPlayerRequestGiftRequest = new CMsgPlayerRequestGiftRequest();
			var userid:UInt64 = CDataManager.getInstance().dataOfGameUser.userId;
			
			for(var i:int =0 ; i< fidList.length ; i++)
			{
				var d:PBGetGiftArray = new PBGetGiftArray();
				d.friendQID = fidList[i];
				d.userQID = userid;
				d.id = id;
				d.requestNum = requestNum;
				message.getGiftArray.push(d);
			}
			
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  同意赠送好友东西
		 * @param fid 好友id
		 */		
		public function sendServerAcceptRequestGift(fid:UInt64 , itemid:int, requestNum:int = 1 , accept:int = 0):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_ACCEPT_PLAYER_REQUEST_GIFT_REQUEST;
			var message:CMsgAcceptRequestGiftRequest = new CMsgAcceptRequestGiftRequest();
			message.friendQID = fid;
			message.userQID = CDataManager.getInstance().dataOfGameUser.userId;
			message.requestNum = requestNum;
			message.id = itemid;
			message.accept = accept;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  领取好友赠送的礼物
		 * @param fid 好友id
		 */		
		public function sendServerFetchGift(fid:UInt64 , id:int , requestNum:int = 1):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_GIFT_REQUEST;
			var message:CMsgGetGiftRequest = new CMsgGetGiftRequest();
			message.userQID = CDataManager.getInstance().dataOfGameUser.userId;
			message.friendQID = fid;
			message.userQID = CDataManager.getInstance().dataOfGameUser.userId;
			message.requestNum = requestNum;
			message.id = id;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		
		
		/**
		 *  同意添加好友
		 * @param fid 好友id
		 * @params agree : 0 - 同意  1-拒绝
		 */		
		public function sendServerAcceptAddFriend(fid:UInt64 , agree:int = 0):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_ACCEPT_ADD_PLAYER_REQUEST;
			var message:CMsgAcceptAddPlayerRequest = new CMsgAcceptAddPlayerRequest();
			message.friendQID = fid;
			message.accept = agree;
			message.userQID = CDataManager.getInstance().dataOfGameUser.userId;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  加好友
		 * @param fid 好友id
		 */		
		public function sendServerAddFriend(fid:UInt64):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_ADD_FRIEND_REQUEST;
			var message:CMsgAddFriendRequest = new CMsgAddFriendRequest();
			message.friendQID = fid;
			message.userQID = CDataManager.getInstance().dataOfGameUser.userId;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  删好友
		 *  @param fid 好友id
		 */		
		public function sendServerDelFriend(fid:UInt64):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_ADD_FRIEND_REQUEST;
			var message:CMsgAddFriendRequest = new CMsgAddFriendRequest();
			message.friendQID = fid;
			message.userQID = CDataManager.getInstance().dataOfGameUser.userId;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  单次游戏结束
		 */		
		public function sendServerStopGame():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_STOP_GAME_RESQUEST;
			var message:CMsgStopGameRequest = new CMsgStopGameRequest();
			message.levelID = CDataManager.getInstance().dataOfLevel.level;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		
		/**
		 *  请求用户货币
		 */		
		public function sendServerGetCoin():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_USER_COIN_REQUEST;
			var message:CMsgGetUserCoinRequest = new CMsgGetUserCoinRequest();
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  请求好友头像和名字
		 */		
		public function sendServerGetFriendImageAndName(qid:UInt64):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_NAME_IMAGE_REQUEST;
			var message:CMsgGetNameImageRequest = new CMsgGetNameImageRequest();
			message.friendList = qid;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  领取星值奖励
		 */		
		public function sendServerGetStarReward(level:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_STAR_REWARD_REQUEST;
			var message:CMsgGetStarRewardRequest = new CMsgGetStarRewardRequest();
			message.level = level;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  请求好友的星值
		 */		
		public function sendServerGetFriendStarInfo(qid:UInt64):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_FRIEND_STAR_INFO_REQUEST;
			var message:CMsgFriendStarInfoRequest = new CMsgFriendStarInfoRequest();
			message.qid = qid;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  取体力剩余时间
		 */		
		public function sendServerEnergyRecoverRemainTime():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_RECOVER_ENERGY_INTERVAL_REQUEST;
			var message:CMsgRecoverEnergyIntervalRequest = new CMsgRecoverEnergyIntervalRequest();
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  获取道具信息
		 */		
		public function sendServerUserTool():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_PLAYER_ITEM_INFO_REQUEST;
			var message:CMsgGetPlayerItemInfoRequest = new CMsgGetPlayerItemInfoRequest();
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 * 购买道具
		 */		
		public function sendServerBuyTool(tid:int , num:int = 1 , buyType:int = 2):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_QUICK_BUY_REQUEST;
			var message:CMsgQuickBuyRequest = new CMsgQuickBuyRequest();
			message.buyNum = num;
			message.itemID = tid;
			message.buyType = buyType;
			msg.messageContent = message;
			sendGameRequest(msg);
		}

		/**
		 * 一键补满体力
		 */		
		public function sendServerFullEnergy():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_QUICK_ADD_ENERGY_REQUEST;
			var message:CMsgQuickAddEnergyRequest = new CMsgQuickAddEnergyRequest();
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  获取运营活动 
		 * @param type
		 * 
		 */		
		public function sendServerActivity(type:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_ONLINE_ACTIVITY_INFO_REQUEST;
			var message:CMsgGetOnlineActivityInfoRequest = new CMsgGetOnlineActivityInfoRequest();
			message.type = type;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 *  领取在线奖励 
		 * @param level
		 * 
		 */		
		public function sendServerOnlineAward(level:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_ONLINE_ACTIVITY_REWARD_REQUEST;
			var message:CMsgGetStarRewardRequest = new CMsgGetStarRewardRequest();
			message.level = level;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		/**
		 *  领取连续登陆 
		 * @param level
		 * 
		 */		
		public function sendServerLoginAward(level:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_DAY_ACCTIVITY_REWARD_REQUEST;
			var message:CMsgGetStarRewardRequest = new CMsgGetStarRewardRequest();
			message.level = level;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 * 使用道具
		 */		
		public function sendServerUseTool(tid:int , useNum:int = 1):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_USE_ITEM_REQUEST;
			var message:CMsgUseItemRequest = new CMsgUseItemRequest();
			message.itemID = tid;
			message.itemNum = useNum;
			msg.messageContent = message;
			sendGameRequest(msg);
			
			CONFIG::debug
			{
				TRACE_LOG("send use Item id: " + tid);
			}
			
			if(CBaseUtil.isEnergyTool(tid))
			{
				CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_MANUAL_BOTTLE);
			}
		}
		
		/**
		 * 关卡数据
		 */		
		public function sendServerGetStarInfo():void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_LEVELS_INFO_REQUEST;
			var message:CMsgGetLevelsInfoRequest = new CMsgGetLevelsInfoRequest();
			message.level = CDataManager.getInstance().dataOfGameUser.maxLevel;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		/**
		 * 分数数据
		 */		
		public function sendServerGetScoreInfo(level:int , fidList:Array):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_GET_FRIEND_LEVEL_SCORE_REQUEST;
			var message:CMsgGetFriendScoreRequest = new CMsgGetFriendScoreRequest();
			
			for(var i:int =0 ; i< fidList.length  ;i ++)
			{
				var pb:PBFriendList = new PBFriendList();
				pb.qid = fidList[i];
				message.friendQID.unshift(pb);
			}
			
			message.level = level;
			msg.messageContent = message;
			sendGameRequest(msg);
		}
		
		public function sendMapValidate(randomIndexs:Vector.<RandomItem>, scoreItems:Vector.<ScoreItem>, map:Vector.<GridObject>, totalScore:int, bombTimes:int):void
		{
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = TRIPLE_CLEAN_LOGIC_MSG_ID.C2S_MIDDLE_VALIDATE_REQUEST;
			var message:CMsgMiddleValidateRequest = new CMsgMiddleValidateRequest();
			
			message.curLevel = CDataManager.getInstance().dataOfLevel.level;
			for each(var randomItem:RandomItem in randomIndexs)
			{
				var ranItem:PBRandomList = new PBRandomList();
				ranItem.x = randomItem.x;
				ranItem.y = randomItem.y;
				ranItem.index = randomItem.index;
				ranItem.result = randomItem.result;
				
				message.randomIndex.push(ranItem);
				
				CONFIG::debug
				{
					TRACE_VALIDATE_RANDOM("x: "+ randomItem.x + " y: "+ ranItem.y + " index: "+ ranItem.index + " result: "+ randomItem.result + " rangeValue: "+ ranItem.result%100);	
				}
				
			}
			
			var strScore:int;
			for each(var scoreItem:ScoreItem in scoreItems)
			{
				var sItem:PBScoreItem = new PBScoreItem();
				sItem.x = scoreItem.x;
				sItem.y = scoreItem.y;
				sItem.scoreID = scoreItem.scoreId;
				sItem.singleScore = scoreItem.isSingle;
				sItem.effectID = scoreItem.inFluenceId;
				sItem.times = scoreItem.bombTime;
				message.scoreItem.push(sItem);
				
				TRACE_VALIDATE_SCORE("x: "+sItem.x + " y: "+ sItem.y + " scoreId: "+sItem.scoreID + " isSingleScore: "+ sItem.singleScore + " effectId: "+sItem.effectID + " time: "+sItem.times);
			}
			message.times = bombTimes;
			TRACE_VALIDATE_SCORE("times: "+ bombTimes);
			message.score = totalScore;	
			TRACE_VALIDATE_SCORE("score: " + totalScore);
			
			for each(var grid:GridObject in map)
			{
				var str:String="";
				var pb:PBMatrix = new PBMatrix();
				pb.x = grid.x;
				pb.y = grid.y;
				pb.baseObj
				str+=" x: "+pb.x + " y: "+pb.y;
				for each(var basic:BasicObject in grid.basicObjects)
				{
					var pbBasic:PBBaseObj = new PBBaseObj();	
					pbBasic.id = basic.id;
					pbBasic.layer = basic.layer;
					pb.baseObj.push(pbBasic);
					str+=" id: "+ pbBasic.id+" layer: "+pbBasic.layer;
				}
				message.matrix.push(pb);
				
				TRACE_VALIDATE_MAP(str);
			}
			
			CONFIG::debug
			{
				validateMap(map, randomIndexs);
			}
			
			msg.messageContent = message;
			sendRequest(msg);
		}
		
		private function validateMap(map:Vector.<GridObject>, randomIndexs:Vector.<RandomItem>):void
		{
			
		}
		
		
		/**
		 * 重新开始游戏
		 */
		public function restartGame():void
		{
			DataUtil.instance.isExitGame = true;
			DataUtil.instance.currentDiplomaNum = 0;
			isMatching = false;
			//退出游戏
			CBaseUtil.sendEvent(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_SIGNUP));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_START));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_MATCH_DIPLOMA));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_FRIEND_INVITE));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_FRIEND_SENDENERGY));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_MATCH_RESULT));
			//弹出loading界面
			CBaseUtil.sendEvent(GameNotification.EVENT_SHOW_WARNING);
			CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER);
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL);
			//清除时间任务
			TimerManager.instance.removeAllTask();
			
			exitGame();
			
			//视口设置为当前关卡
			DataUtil.instance.currentPos = -1;
			
			CBaseUtil.delayCall(function():void{connectLobby();} , 1 , 1);
		}
		
		/**
		 * 根据当前的游戏状态，确定发哪个请求
		 */
		private function sendRequest(msg:SocketMessageVO):void
		{
			var socketName:String = __getSocketName();
			SocketManager.instance.sendMsg(socketName, msg);
		}
		
		
		private function sendGameRequest(msg:SocketMessageVO):void
		{
			if(!Debug.ISONLINE)
			{
				return;
			}
			var socketName:String = __getGameSocketName();
			SocketManager.instance.sendMsg(socketName, msg);
		}
		
		private function sendLobbyRequest(msg:SocketMessageVO):void
		{
			var socketName:String = __getLobbySocketName();
			SocketManager.instance.sendMsg(socketName, msg);
		}
		
		private function sendMatchRequest(msg:SocketMessageVO):void
		{
			var socketName:String = __getMatchSocketName();
			SocketManager.instance.sendMsg(socketName, msg);
		}
		
		/**
		 * 请求加入比赛 
		 */		
		public function sendGameEnterMatch():void
		{
			if(this._currentMessage == null)
			{
				return;
			}
			var imgUrl:String = null;
			var gameSocketName:String = __getSocketName();
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = GSMsgID.MC2GS_Req_Enter_Match;
			msg.messageContent = MatchSystemSocketDataCreator.sendEnterMatch(
				this._currentMessage.encryptParam,
				this._currentMessage.encryptParamLen,
				0,
				imgUrl,
				this._currentMessage.matchID,
				this._currentMessage.userID,
				this._currentMessage.productID,
				new UInt64(0,0));
			SocketManager.instance.sendMsg(gameSocketName,msg);	
			
			var roomInfo:Object = new Object();
			roomInfo.id = this._currentMessage.productID;
			roomInfo.userID = this._currentMessage.userID;
			roomInfo.matchID = this._currentMessage.matchID;
			
			DataUtil.instance.roomInfo = roomInfo;
			
			TRACE_LOG("请求EnterMatch ----- 下一步收到 GS2MC_Notify_Start_Game" +"___" + DataUtil.instance.selectProductID)
		}
		
		
		/**
		 * 请求比赛排名 
		 * 
		 */		
		public function sendGameUserOrder():void
		{
			var gameSocketName:String = __getMatchSocketName();
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = GSMsgID.MC2GS_Req_UserOrder;
			msg.messageContent = GameLobbySocketDataCreator.sendUserOrder(DataUtil.instance.myUserID, 0);
			SocketManager.instance.sendMsg(gameSocketName,msg);	
		}
	
		/**
		 *  提交用户行为的请求 
		 * @param roomInfo
		 * 
		 */		
		public function sendGameUserAction(roomInfo:*, productID:int, actionType:int):void
		{
			if(!roomInfo )
			{
				return;
			}
			
			var gameSocketName:String = __getSocketName();
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = GSMsgID.MC2GS_Req_UserAction;
			msg.messageContent = GameLobbySocketDataCreator.sendUserAction(productID, DataUtil.instance.myUserID, roomInfo.stageID, roomInfo.tableID, roomInfo.matchID, actionType, 0);
			SocketManager.instance.sendMsg(gameSocketName,msg);	
		}
		
		/**
		 *  比赛用户行为 
		 * @param roomInfo
		 * @param productID
		 * @param actionType
		 * 
		 */		
		public function sendMatchUserAction(roomInfo:*, productID:int, actionType:int):void
		{
			if(!roomInfo )
			{
				return;
			}
			
			var gameSocketName:String = ConfigManager.SOCKET_MATCH + "_" + productID;
			var msg:SocketMessageVO = new SocketMessageVO();
			msg.msgType = GSMsgID.MC2GS_Req_UserAction;
			msg.messageContent = GameLobbySocketDataCreator.sendUserAction(productID, DataUtil.instance.myUserID, roomInfo.stageID, roomInfo.tableID, roomInfo.matchID, actionType, 0);
			SocketManager.instance.sendMsg(gameSocketName,msg);	
		}
		
		
		public function exitGame():void
		{
			DataUtil.instance.isExitGame = true;
			
			exitMatchServer();
			exitGameServer();
			exitLobbyServer();
			
			CDataManager.getInstance().clearAll();
			
			InitState.onReconnectReset();
		}
		
		public function exitGameServer():void
		{
			NetworkManager.instance.sendGameUserAction(DataUtil.instance.roomInfo, DataUtil.instance.selectProductID, User_Action_Type.UserAction_Leave);
			NetworkManager.instance.disconnectGameSocket();
		}
		
		public function exitMatchServer():void
		{
			var gameSocketName:String = __getMatchSocketName();
			var socketAdapter:SocketAdapter = SocketManager.instance.getSocketAdapter(gameSocketName);
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
			if(socketAdapter != null && socketAdapter.getConnectState() && matchData)
			{
				NetworkManager.instance.sendMatchStopMatch();
				NetworkManager.instance.sendGameUserAction(matchData, DataUtil.instance.selectMatchProductID, User_Action_Type.UserAction_Leave);
				NetworkManager.instance.disconnectMatchSocket(DataUtil.instance.selectMatchProductID);
			}
		}
		
		public function exitLobbyServer():void
		{
			disconnectLobbySocket();
		}
		
		/**
		 * 关闭当前的游戏socket 
		 */		
		public function disconnectGameSocket():void
		{
			SocketManager.instance.disconnectServer(__getGameSocketName());
		}
		
		/**
		 * 关闭当前的lobby socket 
		 */		
		public function disconnectLobbySocket():void
		{
			SocketManager.instance.disconnectServer(__getLobbySocketName());
		}
		
		/**
		 * 关闭当前的Match socket 
		 */		
		public function disconnectMatchSocket(productID:int):void
		{
			var gameSocketName:String = ConfigManager.SOCKET_MATCH + "_" + productID;
			SocketManager.instance.disconnectServer(gameSocketName);
			
			if(status == STATUS_LV)
			{
				isMatching = false;
			}
		}
		
		private function __getLobbySocketName():String
		{
			return ConfigManager.SOCKET_LOBBY;
		}
		
		private function __getMatchSocketName():String
		{
			return ConfigManager.SOCKET_MATCH + "_" + DataUtil.instance.selectMatchProductID;
		}
		
		private function __getGameSocketName():String
		{
			return ConfigManager.SOCKET_GAME + "_" + DataUtil.instance.selectProductID;
		}
		
		/**
		 * 比赛和普通游戏公用
		 */
		private function __getSocketName():String
		{
			if(__isMatch())
			{
				return __getMatchSocketName();
			}
			else
			{
				return __getGameSocketName();
			}
		}
		
		private function __isMatch():Boolean
		{
			return isMatching;
		}
	}
}