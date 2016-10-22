package framework.rpc
{
	import com.game.consts.ConstGameFlow;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.netease.protobuf.Message;
	import com.sevenG.sevenSocket.ISocketCallBack;
	import com.sevenG.sevenSocket.SocketManager;
	import com.sevenG.sevenSocket.SocketMessageVO;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFlowCode;
	import com.ui.widget.CWidgetFloatText;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewChooseLevel;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.game.InitState;
	import framework.model.DataManager;
	import framework.resource.faxb.award.MatchInfo;
	import framework.resource.faxb.onlineActivity.Activity;
	import framework.resource.faxb.onlineActivity.ActivityLevel;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.CMsgGS2MCAckEnterMatch;
	import qihoo.gamelobby.protos.CMsgGS2MCNotifyGameOver;
	import qihoo.gamelobby.protos.CMsgGS2MCNotifyMatchAward;
	import qihoo.gamelobby.protos.CMsgGS2MCNotifyMatchInfo;
	import qihoo.gamelobby.protos.CMsgGS2MCNotifyTableInfo;
	import qihoo.gamelobby.protos.CMsgGS2MCNotifyTipText;
	import qihoo.gamelobby.protos.CMsgGS2MCNotifyUserGameStatus;
	import qihoo.gamelobby.protos.EGameOverType;
	import qihoo.gamelobby.protos.GSMsgID;
	import qihoo.gamelobby.protos.MatchAttr;
	import qihoo.gamelobby.protos.User_Action_Type;
	import qihoo.triplecleangame.protos.CMsgAcceptRequestGiftResponse;
	import qihoo.triplecleangame.protos.CMsgAddFriendResponse;
	import qihoo.triplecleangame.protos.CMsgDeleteFriendResponse;
	import qihoo.triplecleangame.protos.CMsgFriendStarInfoResponse;
	import qihoo.triplecleangame.protos.CMsgGetActivityDayEnergyResponse;
	import qihoo.triplecleangame.protos.CMsgGetActivityInfoResponse;
	import qihoo.triplecleangame.protos.CMsgGetFriendListResponse;
	import qihoo.triplecleangame.protos.CMsgGetFriendScoreResponse;
	import qihoo.triplecleangame.protos.CMsgGetGiftResponse;
	import qihoo.triplecleangame.protos.CMsgGetLevelsInfoResponse;
	import qihoo.triplecleangame.protos.CMsgGetNameImageResponse;
	import qihoo.triplecleangame.protos.CMsgGetOnlineActivityInfoResponse;
	import qihoo.triplecleangame.protos.CMsgGetPlayerItemInfoResponse;
	import qihoo.triplecleangame.protos.CMsgGetStarRewardResponse;
	import qihoo.triplecleangame.protos.CMsgGetUserInfoResponse;
	import qihoo.triplecleangame.protos.CMsgMiddleValidateResponse;
	import qihoo.triplecleangame.protos.CMsgNotifyPlayerMoney;
	import qihoo.triplecleangame.protos.CMsgNotifyRecoverEnergyInterval;
	import qihoo.triplecleangame.protos.CMsgQuickAddEnergyResponse;
	import qihoo.triplecleangame.protos.CMsgQuickBuyResponse;
	import qihoo.triplecleangame.protos.CMsgRecommendFriendResponse;
	import qihoo.triplecleangame.protos.CMsgSendPlayerOrigin;
	import qihoo.triplecleangame.protos.CMsgStartGameResponse;
	import qihoo.triplecleangame.protos.CMsgStartMatchResponse;
	import qihoo.triplecleangame.protos.CMsgStepCleanResponse;
	import qihoo.triplecleangame.protos.CMsgTaskTimeoutResponse;
	import qihoo.triplecleangame.protos.CMsgUnlockLevelGroupResponse;
	import qihoo.triplecleangame.protos.CMsgUseItemResponse;
	import qihoo.triplecleangame.protos.PBItemInfo;
	import qihoo.triplecleangame.protos.TRIPLE_CLEAN_LOGIC_MSG_ID;
	
	import time.Task;
	
	public class GameServerSocketCallback implements ISocketCallBack
	{
		private var _matchInfo:MatchAttr;
		
		private var _heartbeatTask:Task;
		
		private var _timeCount:int;
		
		public function GameServerSocketCallback()
		{
			this._heartbeatTask = new Task();
			this._heartbeatTask.taskDelay = 1000;
			this._heartbeatTask.taskDoFun = onHeartbeat;
		}
		
		public function onData(socketName:String, socketMessageVO:SocketMessageVO):void
		{			
			var message:Message = socketMessageVO.messageContent as Message;
			
			TRACE_RPC(" socket type: "+socketMessageVO.msgType + " success received !" , socketName);
			
			var infoData:Object;
			var msg:SocketMessageVO;
			var result:int;
			var matchData:CDataOfMatch;
			
			switch(socketMessageVO.msgType)
			{
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_START_GAME_RESPONSE:
					
					result = CMsgStartGameResponse(message).result;
					if(result == 0)
					{
						DataManager.getInstance().initSeed = CMsgStartGameResponse(message).seed;
						DataUtil.instance.giftId = CMsgStartGameResponse(message).giftItemID;
						DataManager.getInstance().seedArray = CMsgStartGameResponse(message).seedArray;
						DataManager.getInstance().reset();
						
						//设置游戏中道具数据
						if(CMsgStartGameResponse(message).itemArray.length > 0)
						{
							for(var i:int = 0 ; i< CMsgStartGameResponse(message).itemArray.length ;i++)
							{
								var d:PBItemInfo = CMsgStartGameResponse(message).itemArray[i];
								CDataManager.getInstance().dataOfLevel.addToolInGame(d.itemID , d.itemNum);
							}
						}
						
						Fibre.getInstance().sendNotification(GameNotification.EVENT_GAME_START , {});
					}
					else
					{
						CBaseUtil.showConfirm("开始游戏失败 , errorcode:"+result, function():void{
							NetworkManager.instance.restartGame();
							CBaseUtil.showLoading();
						});
					}
					
					break;
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_LEVEL_BALANCE_NOTIFY:
					Fibre.getInstance().sendNotification(GameNotification.EVENT_START_CACULATE_FINISH ,null);
					break;
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_STEP_CLEAN_RESPONSE:
					result = CMsgStepCleanResponse(message).result;
					
					//报错直接弹
					if(result != 0)
					{
						//失败
						if(result == -130016)
						{
							CBaseUtil.delayCall(function():void
							{
								CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER, 0);
								
								Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,new DatagramViewNormal(ConstantUI.DIALOG_BARRIER_FAIL , true ,{score:CMsgStepCleanResponse(message).score}));
							},1,1);
						}
						else if(result == -130051)
						{
							CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER, 1);
						}
						else
						{
							CBaseUtil.showConfirm("前后端验证不一致 , errorcode:"+result, function():void{
								NetworkManager.instance.restartGame();
								CBaseUtil.showLoading();
							});
						}
						
						return;
					}
					if(NetworkManager.instance.isMatching)
					{
						return;
					}
					
					//游戏结束 0 - 成功     1 - 没完       负数 - 失败
					if(CMsgStepCleanResponse(message).isOverGame == 0)
					{
						//成功
						CBaseUtil.delayCall(function():void
						{
							CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER);
							Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,new DatagramViewNormal(ConstantUI.DIALOG_BARRIER_SUCC , true ,{score:CMsgStepCleanResponse(message).score , addEnergy:CMsgStepCleanResponse(message).addEnergy}));
							
							CDataManager.getInstance().dataOfLevel.reset();
							
							//计算需要开启的功能点
							CDataManager.getInstance().dataOfFunctionList.checkNeedOpen();
							
						},1,1);
					}
					else
					{
						
					}
					break;
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_MIDDLE_VALIDATE_RESPONSE:
					result = CMsgMiddleValidateResponse(message).result;
					
					//success
					if(result == 0)
					{
						if(CMsgMiddleValidateResponse(message).seedArray.length > 0 )
						{
							DataManager.getInstance().seedArray =  DataManager.getInstance().seedArray.concat(CMsgMiddleValidateResponse(message).seedArray);
						}
						CONFIG::debug
						{							
							TRACE_VALIDATE_RANDOM("velidate score success!");
						}
					}
					//fail
					else
					{
						CONFIG::debug
						{
//							ASSERT(false, "velidate score fail!");
							TRACE_VALIDATE_RANDOM("velidate score fail!");
						}
						
						CBaseUtil.showConfirm("前后端验证不一致 , errorcode:"+result, function():void{
							NetworkManager.instance.restartGame();
							CBaseUtil.showLoading();
						});
						
						
					}
					
					break;
				//用户数据  退出关卡的时候，会下发用户数据
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_USER_INFO_RESPONSE:
					result = CMsgGetUserInfoResponse(message).result;
					CONFIG::debug
					{
						if(result != 0)
						{							
							TRACE_LOG("fail msgType: "+socketMessageVO.msgType+ " errorCode: " + result);
						}
						ASSERT(result == 0, "response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					//初始化
					CDataManager.getInstance().dataOfGameUser.init(CMsgGetUserInfoResponse(message));
					TRACE_FLOW(ConstGameFlow.SERVER_GET_GAME_STARINFO);
					
					if(!CMsgGetUserInfoResponse(message).isLogin)
					{
						//请求关卡数据
						NetworkManager.instance.sendServerGetStarInfo();
					}
					
					break;
				//钱币信息
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_NOTIFY_PLAYER_MONEY:
					
					result = CMsgNotifyPlayerMoney(message).result;
					
					CONFIG::debug
					{
						if(result != 0)
						{							
							TRACE_LOG("fail msgType: "+socketMessageVO.msgType+ " errorCode: " + result);
						}
						ASSERT(result == 0, "response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					
					CDataManager.getInstance().dataOfMoney.init(CMsgNotifyPlayerMoney(message));
					
					break;
				//到计时时间
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_NOTIFY_RECOVER_ENERGY_INTERVAL:
					
					result = CMsgNotifyRecoverEnergyInterval(message).result;
					
					CONFIG::debug
					{
						if(result != 0)
						{							
							TRACE_LOG("fail msgType: "+socketMessageVO.msgType+ " errorCode: " + result);
						}
						ASSERT(result == 0, "response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					
					//设置间隔的时候发事件
					CDataManager.getInstance().dataOfGameUser.recoveryTime = CMsgNotifyRecoverEnergyInterval(message).interval;
					CDataManager.getInstance().dataOfGameUser.curEnergy = CMsgNotifyRecoverEnergyInterval(message).curEnergy;
					
					CBaseUtil.sendEvent(GameNotification.EVENT_ENERGY_RECOVER_REMAIN_TIME ,{});
					
					break;
				//计时任务
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_TASK_TIMEOUT_RESPONSE:
					
					result = CMsgTaskTimeoutResponse(message).result;
					
					var dv:DatagramViewNormal;
					
					if(result == 0)
					{
						dv = new DatagramViewNormal(ConstantUI.DIALOG_BARRIER_FAIL , true , 
							{score:CMsgTaskTimeoutResponse(message).score});
					}
					else
					{
						dv = new DatagramViewNormal(ConstantUI.DIALOG_BARRIER_SUCC , true , 
							{score:CMsgTaskTimeoutResponse(message).score});
					}
					
					Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,dv);
					
					break;
				//取好友列表
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_RRIEND_LIST_RESPONSE:
					
					result = CMsgGetFriendListResponse(message).result;
					
					if(result == 0)
					{
						CDataManager.getInstance().dataOfFriendList.serilization(CMsgGetFriendListResponse(message));
						
						//发事件
						CBaseUtil.sendEvent(GameNotification.EVENT_GET_FRIENDLIST ,{});
						
						//取好友的分数信息
//						var allFriend:Array = CDataManager.getInstance().dataOfFriendList.getFriendList();
//						var curLevel:int = CDataManager.getInstance().dataOfGameUser.curLevel;
						
//						NetworkManager.instance.sendServerGetScoreInfo(curLevel ,allFriend );
						
						
						CBaseUtil.startLoadFriendStarInfo();
					}
					else
					{
						CDataManager.getInstance().dataOfFriendList.init();
						CBaseUtil.hideLoading();
					}
					
					
					break;
				
				//加好友
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_ADD_FRIEND_RESPONSE:
					
					result = CMsgAddFriendResponse(message).result;
					
					if(result == 0)
					{
//						CDataManager.getInstance().dataOfFriendList.addFriend(CMsgAddFriendResponse(message).friendQID);
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					
					break;
				
				//删除好友
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_DELETE_FRIEND_RESPONSE:
					
					result = CMsgDeleteFriendResponse(message).result;
					
					if(result == 0)
					{
						
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					
					break;
				//取推荐列表
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_RECOMMEND_FRIEND_RESPONSE:
					
					result = CMsgRecommendFriendResponse(message).result;
					
					if(result == 0)
					{
						Fibre.getInstance().sendNotification(GameNotification.EVENT_GET_RECOMMAND_BACK , {data:CMsgRecommendFriendResponse(message).friendList});
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					
					break;
				//收到好友头像和名字信息
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_NAME_IMAGE_RESPONSE:
					result = CMsgGetNameImageResponse(message).result;
					if(result == 0)
					{
						Fibre.getInstance().sendNotification(GameNotification.EVENT_FRIEND_IMG_NAME , {message:CMsgGetNameImageResponse(message)});
						CDataManager.getInstance().dataOfFriendList.cacheImg(CMsgGetNameImageResponse(message).userQID , CMsgGetNameImageResponse(message));
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					break;
				//购买道具
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_QUICK_BUY_RESPONSE:
					result = CMsgQuickBuyResponse(message).result;
					if(result == 0)
					{
						CBaseUtil.sendEvent(GameNotification.EVENT_TOOL_DATA_UPDATE , {message:CMsgQuickBuyResponse(message)});
					}
					else
					{
						CBaseUtil.sendEvent(GameNotification.EVENT_TOOL_BUY_FAIL , {message:CMsgQuickBuyResponse(message)});
					}
					break;
				//获取用户道具信息
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_PLAYER_ITEM_INFO_RESPONSE:
					result = CMsgGetPlayerItemInfoResponse(message).result;
					if(result == 0)
					{
						CDataManager.getInstance().dataOfUserTool.init(CMsgGetPlayerItemInfoResponse(message));
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					break;
				//好友星值
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_FRIEND_STAR_INFO_RESPONSE:
					result = CMsgFriendStarInfoResponse(message).result;
					if(result == 0)
					{
						//缓存星值
						CDataManager.getInstance().dataOfFriendList.cacheStar(CMsgFriendStarInfoResponse(message).qid , CMsgFriendStarInfoResponse(message).totoalStar);
						
						Fibre.getInstance().sendNotification(GameNotification.EVENT_FRIEND_STAR_INFO ,{message:CMsgFriendStarInfoResponse(message)});
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					break;
				//领取星值奖励
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_STAR_REWARD_RESPONSE:
					result = CMsgGetStarRewardResponse(message).result;
					if(result == 0)
					{
						CDataManager.getInstance().dataOfGameUser.rewardLevel = CMsgGetStarRewardResponse(message).starRewardLevel;
						
						CBaseUtil.sendEvent(GameNotification.EVENT_STAR_REWARD_UPDATE  , {});
						
						CWidgetFloatText.instance.showTxt("领取成功！");
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					break;
				//好友分数
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_FRIEND_LEVEL_SCORE_RESPONSE:
					result = CMsgGetFriendScoreResponse(message).result;
					if(result == 0)
					{
						Fibre.getInstance().sendNotification(GameNotification.EVENT_FRIEND_SCORE_INFO ,{message:CMsgGetFriendScoreResponse(message)});
					}
					else
					{
						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
					}
					break;
				//一键补满体力
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_QUICK_ADD_ENERGY_RESPONSE:
					
					result = CMsgQuickAddEnergyResponse(message).result;
					
					if(result != 0)
					{
						CBaseUtil.showConfirm("购买失败，银豆不足！是否立即获取银豆？" , CBaseUtil.showSilverExchange , function():void{});
					}
					break;
				
				//好友的账户类型
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_SEND_PLAYER_ORIGIN:
					
					result = CMsgSendPlayerOrigin(message).result;
					
					if(result == 0)
					{
						CBaseUtil.sendEvent(GameNotification.EVENT_USER_TYPE , {message:CMsgSendPlayerOrigin(message)});
					}
					break;
				
				//使用道具
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_USE_ITEM_RESPONSE:
					
					result = CMsgUseItemResponse(message).result;
					
					if(result != 0)
					{
						CBaseUtil.showConfirm("使用失败 , code:"+result , function():void{});
					}
					else
					{
						//如果是关卡内道具，扣数量
						for(var j:int = 0 ;j <  CDataManager.getInstance().dataOfLevel.inGameToolIdList.length ; j++)
						{
							var data:Object =  CDataManager.getInstance().dataOfLevel.inGameToolIdList[j];
							if(CMsgUseItemResponse(message).itemID == data.id)
							{
								data.num -= CMsgUseItemResponse(message).itemNum;
							}
						}
						
						//清除使用标记
						CDataManager.getInstance().dataOfLevel.isUsingTool = false;
						
						//记录使用数量
						CDataManager.getInstance().dataOfLevel.addUseTime(CMsgUseItemResponse(message).itemID , CMsgUseItemResponse(message).itemNum);
					}
					break;
				//关卡信息
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_LEVELS_INFO_RESPONSE:
					
					result = CMsgGetLevelsInfoResponse(message).result;
					
					if(result == 0)
					{
						CDataManager.getInstance().dataOfStarInfo.init(CMsgGetLevelsInfoResponse(message));
						
						TRACE_FLOW(ConstGameFlow.SERVER_ENTER_SCENE);
						
						//加载成功 进入场景
						ConfigManager.isInit = true;
						//进入游戏
						DataUtil.instance.netConnectionEndTime = new Date().getTime();
						
						TRACE("网络连接共耗时 : " + (DataUtil.instance.netConnectionEndTime - DataUtil.instance.netConnectionStartTime) / 1000 +"s", "time");
						
						InitState.recordFinish(InitState.KEY_RPCPROXY);
						
						//断线重连上的，需要重新获取下倒计时信息
						if(DataUtil.instance.isExitGame)
						{
							NetworkManager.instance.sendServerEnergyRecoverRemainTime();
						}
					}
					break;
				
				//更新体力
//				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_NOTIFY_TIME_RECOVER_ENERGY:
//					
//					result = CMsgNotifyTimeRecoverEnergy(message).result;
//					
//					if(result == 0)
//					{
//						//当前体力
//						CDataManager.getInstance().dataOfGameUser.curEnergy = CMsgNotifyTimeRecoverEnergy(message).curEnergy;
//					}
//					else
//					{
//						trace("response fail! msgType: "+ socketMessageVO.msgType+ " error code: "+ result);
//					}
//					break;
				
				//报名后受到用户的状态
				case GSMsgID.GS2MC_Notify_UserGameStatus:
					result = CMsgGS2MCNotifyUserGameStatus(message).result;
					
					if(!result == 0 )
					{
						TRACE_FLOW(ConstGameFlow.SERVER_USER_STATUS_EXCEPTION);
						return;
					}
					
					var content:CMsgGS2MCNotifyUserGameStatus = message as CMsgGS2MCNotifyUserGameStatus;
					
					var roomInfo:* = new Object();
					roomInfo.matchID = content.matchID;
					
					TRACE_LOG("content.status : " + content.status);
					
					//非lobby ， 直接继续
					if(!Debug.inLobby && content.isPlayerExisting)
					{
						NetworkManager.instance.sendGameUserAction(roomInfo ,content.productID ,  User_Action_Type.UserAction_Continue);
					}
					else if(content.status == 2)
					{
						NetworkManager.instance.sendGameUserAction(roomInfo ,content.productID ,  User_Action_Type.UserAction_Continue);
					}
					
					break;
				//entermath
				case GSMsgID.GS2MC_Ack_Enter_Match:
					matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
					if(matchData)
					{
						matchData.stageID = CMsgGS2MCAckEnterMatch(message).stageID;
					}
					
					TRACE_FLOW(ConstGameFlow.SERVER_ENTER_MATCH_SUCC);
					
					break;
				//entermath
				case GSMsgID.GS2MC_Notify_TableInfo:
					matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
					if(matchData)
					{
						matchData.tableID = CMsgGS2MCNotifyTableInfo(message).tableID;
					}
					break;
				// 接收到开始比赛
				case GSMsgID.GS2MC_Notify_Start_Game:
					TRACE_FLOW(ConstGameFlow.SERVER_GET_GAME_USER_DATA);
					
					if(NetworkManager.instance.isMatching)
					{
						matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
						NetworkManager.instance.sendMatchStartMatch(matchData.matchID);
					}else
					{
						//请求玩家数据
						NetworkManager.instance.sendGameUserData(DataUtil.instance.myUserID);
					}
					break;
				//踢下线
				case GSMsgID.GS2MC_Notify_KickPlayer:
					if(NetworkManager.instance.status != NetworkManager.STATUS_MATCH)
					{
						CBaseUtil.showConfirm("用户登录状态异常，请重新登陆", function():void{
							NetworkManager.instance.restartGame();
							CBaseUtil.showLoading();
						});
					}
					break;
				//服务器宕机
				case GSMsgID.GS2MC_Notify_MSShutdown:
					CBaseUtil.showConfirm("服务器正在维护，请关闭游戏");
					CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER);
					NetworkManager.instance.exitGame();
					break;
				//比赛结束
				case GSMsgID.GS2MC_Notify_Game_Over:
					var productID:int = CMsgGS2MCNotifyGameOver(message).productID;
					if(productID != DataUtil.instance.selectMatchProductID)
					{
						return;
					}
					matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(productID);
					if(NetworkManager.instance.status == NetworkManager.STATUS_LV || !NetworkManager.instance.isMatching)
					{
						return;
					}
					NetworkManager.instance.reqMatchInfo(1, 8);
					if(NetworkManager.instance.isActiveStop)
					{
						CBaseUtil.hideLoading();
						
						NetworkManager.instance.sendMatchUserAction(matchData, productID, User_Action_Type.UserAction_Leave);
						Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
						Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
						NetworkManager.instance.isMatching = false;
						NetworkManager.instance.isActiveStop = false;
					}
					else if(NetworkManager.instance.isReplay)
					{
						NetworkManager.instance.sendLobbySignUpMatch(productID);
					}
					else
					{
						NetworkManager.instance.isPassiveStop = true;
						if(CMsgGS2MCNotifyGameOver(message).gameOverType == EGameOverType.EGameOverType_TableOver)
						{
							CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER);
							NetworkManager.instance.isMatchOver = true;
							Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramViewNormal(ConstantUI.PANEL_COMMON_CONFIRM));
							Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramViewNormal(ConstantUI.PANEL_MATCH_RANK));
							Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_MATCH_RESULT));
						}else
						{
							Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_MATCH_RESULT));
						}
					}
					
					break;
				//比赛结束发送排名奖励
				case GSMsgID.GS2MC_Notify_Match_Award:
					TRACE_LOG("比赛发奖")
					this._heartbeatTask.stop();
					//关闭连接 
					CBaseUtil.delayCall(function():void{NetworkManager.instance.disconnectMatchSocket(infoData.productID);} , 2 ,1);
					
					infoData = new Object();
					infoData.rank = CMsgGS2MCNotifyMatchAward(message).rank;
					infoData.itemList = CMsgGS2MCNotifyMatchAward(message).uDVAwdList;
					infoData.productID = CMsgGS2MCNotifyMatchAward(message).productID;
					matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(infoData.productID);
					var matchAward:MatchInfo = CBaseUtil.getMatchAwardByID(infoData.productID);
					if(matchAward == null)
					{
						return;
					}
					
					infoData.startTime = matchData.matchStartTime; 
					if(infoData.rank > matchAward.maxRank)
					{
						return;
					}
					
					DataUtil.instance.diplomaList.push(infoData);
					
//					CBaseUtil.sendEvent(GameNotification.EVENT_UPDATE_DIPLOMA_NUM);
					
					NetworkManager.instance.reqMatchInfo(1, 8);
					
					if(DataUtil.instance.isInWorld)
					{
//						CBaseUtil.sendEvent(GameNotification.EVENT_DIPLOMA_TIPS);
						CBaseUtil.popDiploma();
					}else
					{
						CFlowCode.Pop_Match_code = 1;
					}
					
					break;
				//比赛提示信息
				case GSMsgID.GS2MC_Notify_TipText:
					if(CMsgGS2MCNotifyTipText(message).classsType == 1001 
						|| CMsgGS2MCNotifyTipText(message).classsType == 1002
						|| CMsgGS2MCNotifyTipText(message).classsType == 1003
						|| CMsgGS2MCNotifyTipText(message).classsType == 1004)
					{
						CBaseUtil.sendEvent(GameNotification.EVENT_SYSTEM_TIPS, CMsgGS2MCNotifyTipText(message).strTip);
						CONFIG::debug
						{
							TRACE(CMsgGS2MCNotifyTipText(message).strTip, "systemtips");
						}
					}
					break;
				//领取礼物回复
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_GIFT_RESPONSE:
					result = CMsgGetGiftResponse(message).result;
					if(result != 0)
					{
						CWidgetFloatText.instance.showTxt("恭喜您达到每日礼物领取上限（10份），剩余请求请明天处理");
					}
					break;
				//同意赠送礼物
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_ACCEPT_PLAYER_REQUEST_GIFT_RESPONSE:
					result = CMsgAcceptRequestGiftResponse(message).result;
					if(result != 0)
					{
						CWidgetFloatText.instance.showTxt("赠送失败，赠送礼物已达上限。");
					}
					break;
				//更新比赛信息
				case GSMsgID.GS2MC_Notify_MatchInfo:
					TRACE_LOG("更新比赛信息");
					this._matchInfo = CMsgGS2MCNotifyMatchInfo(message).matchAttribute;
					break;
				//开始比赛
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_START_MATCH_RESPONSE:
					CBaseUtil.hideLoading();
					
					var level:int = CMsgStartMatchResponse(message).mapID;
					
					CDataManager.getInstance().dataOfLevel.decode(level);
					
					if(NetworkManager.instance.isReplay)
					{
						Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
						Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
						NetworkManager.instance.isReplay = false;
					}
					
					NetworkManager.instance.reqMatchInfo(1, 8);
					
					//先初始化
					Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramViewChooseLevel(ConstantUI.WORLD_GAME_MAIN , true , level));
					Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.USER_INFO_PANEL));
					break;
				//比赛开始
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_UNLOCK_LEVEL_GROUP_RESPONSE:
					TRACE_LOG("解锁组返回信息");
					
					result = CMsgUnlockLevelGroupResponse(message).result;
					CONFIG::debug
					{
						if(result != 0)
						{							
							TRACE_LOG("fail msgType: "+socketMessageVO.msgType+ " errorCode: " + result);
						}
					}
					
					if(result == 0)
					{
						CWidgetFloatText.instance.showTxt("解锁成功！");
						
						//解锁成功
						CDataManager.getInstance().dataOfGameUser.maxLevelGroup = CMsgUnlockLevelGroupResponse(message).levelID;
						
						//更新UI
						Fibre.getInstance().sendNotification(GameNotification.EVENT_GROUP_UNLOCKED, {groupid:CDataManager.getInstance().dataOfGameUser.maxLevelGroup});
					}
					else
					{
						CBaseUtil.showMessage("解锁失败 ,code: "+result);
					}
					
					
					break;
				// 运营活动信息回复
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ACTIVITY_INFO_RESPONSE:
					DataUtil.instance.setSystemTime(CMsgGetActivityInfoResponse(message).curTime);
					if(CMsgGetActivityInfoResponse(message).result == 0)
					{
						//赠送体力
						if(CMsgGetActivityInfoResponse(message).activityType == 1
							&& CMsgGetActivityInfoResponse(message).curTime >= CMsgGetActivityInfoResponse(message).startTime
							&& CMsgGetActivityInfoResponse(message).curTime < CMsgGetActivityInfoResponse(message).endTime)
						{
							CBaseUtil.sendEvent(GameNotification.EVENT_SHOW_ENERGY, CMsgGetActivityInfoResponse(message).dayEnergyGetCount);
						}
					}
					break;
				// 运营活动每日赠送体力领取回复
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ACTIVITY_DAY_ENERGY_RESPONSE:
					if(CMsgGetActivityDayEnergyResponse(message).result == 0)
					{
						CBaseUtil.showMessage("体力领取成功");
						NetworkManager.instance.sendServerActivityInfo(1);
					}
					break;
				// 运营活动
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ONLINE_ACTIVITY_INFO_RESPONSE:
					if(DataUtil.instance.systemTime < CMsgGetOnlineActivityInfoResponse(message).startTime
						|| DataUtil.instance.systemTime > CMsgGetOnlineActivityInfoResponse(message).endTime)
					{
						return;
					}
					
					var curlv:int = CMsgGetOnlineActivityInfoResponse(message).level;
					var levels:Vector.<ActivityLevel>;
					for each(var activity:Activity in DataManager.getInstance().activitys.activity)
					{
						if(activity.type == CMsgGetOnlineActivityInfoResponse(message).type)
						{
							levels = activity.level;
							break;
						}
					}
					if(levels == null)
					{
						return;
					}
					switch(CMsgGetOnlineActivityInfoResponse(message).type)
					{
						//在线奖励
						case 0:
							CDataManager.getInstance().dataOfGameUser.onlineTime = CMsgGetOnlineActivityInfoResponse(message).onlineTime * 1000;
							var curNeedTime:int;
							var flog:Boolean = false;
							for each(var activityLv:ActivityLevel in levels)
							{
								if(activityLv.id == (curlv + 1))
								{
									curNeedTime = activityLv.num * 1000;
									flog = true;
									break;
								}
							}
							var cd:int = curNeedTime - CDataManager.getInstance().dataOfGameUser.onlineTime;
							infoData = new Object();
							infoData.cd = cd;
							infoData.curlv = curlv;
							infoData.flog = flog;
							CBaseUtil.sendEvent(GameNotification.EVENT_ACTIVITY_ONLINE, infoData);
							break;
						//连续登陆
						case 1:
							CDataManager.getInstance().dataOfGameUser.dayCount = CMsgGetOnlineActivityInfoResponse(message).dayCount;
							infoData = new Object();
							infoData.curlv = curlv;
							infoData.dayNum = CMsgGetOnlineActivityInfoResponse(message).dayCount;
							CBaseUtil.sendEvent(GameNotification.EVENT_ACTIVITY_LOGIN, infoData);
							break;
					}
					break;
				// 在线奖励回复
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ONLINE_ACTIVITY_REWARD_RESPONSE:
					if(CMsgGetStarRewardResponse(message).result == 0)
					{
						var cur:int = CMsgGetStarRewardResponse(message).starRewardLevel;
						var curNeedTime1:int;
						var flog1:Boolean = false;
						var levels1:Vector.<ActivityLevel>;
						for each(var activity1:Activity in DataManager.getInstance().activitys.activity)
						{
							if(activity1.type == 0)
							{
								levels1 = activity1.level;
								break;
							}
						}
						if(levels1 == null)
						{
							return;
						}
						for each(var activityLv1:ActivityLevel in levels1)
						{
							if(activityLv1.id == (cur + 1))
							{
								curNeedTime1 = activityLv1.num * 1000;
								flog1 = true;
								break;
							}
						}
						var cd1:int = curNeedTime1 - CDataManager.getInstance().dataOfGameUser.onlineTime;
						infoData = new Object();
						infoData.cd = cd1;
						infoData.curlv = cur;
						infoData.flog = flog1;
						CBaseUtil.sendEvent(GameNotification.EVENT_ACTIVITY_ONLINE, infoData);
					}
					/*else
					{
						CBaseUtil.showConfirm("领取失败，错误代码：" + CMsgGetStarRewardResponse(message).result, new Function());
					}*/
					break;
				case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_DAY_ACTIVITY_REWARD_RESPONSE:
					if(CMsgGetStarRewardResponse(message).result == 0)
					{
						infoData = new Object();
						infoData.curlv = CMsgGetStarRewardResponse(message).starRewardLevel;
						infoData.dayNum = CDataManager.getInstance().dataOfGameUser.dayCount;
						CBaseUtil.sendEvent(GameNotification.EVENT_ACTIVITY_LOGIN, infoData);
					}
					/*else
					{
						CBaseUtil.showConfirm("领取失败，错误代码：" + CMsgGetStarRewardResponse(message).result, new Function());
					}*/
					break;
				default:
					CONFIG::debug
					{
						TRACE("无效消息ID：" + socketMessageVO.msgType, "nullType");
					}
					break;
			}
		}
		
		public function onConnected(socketName:String):void
		{
			this._heartbeatTask.taskFunParam = [socketName];
			this._heartbeatTask.start();
			this._timeCount = 0;
			
			TRACE_FLOW(ConstGameFlow.SERVER_ENTER_MATCH);
			NetworkManager.instance.sendGameEnterMatch();
		}
		
		private function onHeartbeat(socketName:String):void
		{
		
			if(this._timeCount % 30 == 0)
			{
				//心跳
				SocketManager.instance.sendHeartbeatMsg(socketName);
				
				CONFIG::debug
				{
					TRACE_HEART("心跳包："+(this._timeCount/30));
				}
			}
			this._timeCount ++;
		}
		
		private function resetHeart():void
		{
			_timeCount = 0;
		}
		
		public function onDisconnected(socketName:String):void
		{
			/*var tipsObj:Object = new Object();
			tipsObj.txt = LanguageUtils.instance.translateString("TIPS_DISCONNECTED");
			tipsObj.sure = this.onReconnect;
			tipsObj.sureParams = [socketName];
			tipsObj.cancel = this.onCloseGame;
			BaseUtil.getDisconnectTipsWin(tipsObj);*/
			
			this._heartbeatTask.stop();
		}
		
		public function onIOError(socketName:String):void
		{
			TRACE_LOG("onIOError");
			
			/*var tipsObj:Object = new Object();
			tipsObj.txt = LanguageUtils.instance.translateString("TIPS_DISCONNECTED");
			tipsObj.sure = this.onReconnect;
			tipsObj.sureParams = [socketName];
			tipsObj.cancel = this.onCloseGame;
			BaseUtil.getDisconnectTipsWin(tipsObj);*/
		}
		
		public function onSecurityError(socketName:String):void
		{
			TRACE_LOG("onSecurityError");
			
			/*var tipsObj:Object = new Object();
			tipsObj.txt = LanguageUtils.instance.translateString("TIPS_DISCONNECTED");
			tipsObj.sure = this.onReconnect;
			tipsObj.sureParams = [socketName];
			tipsObj.cancel = this.onCloseGame;
			BaseUtil.getDisconnectTipsWin(tipsObj);*/
		}
		
		private function onReconnect(socketName:String):void
		{
			SocketManager.instance.connectServer(socketName);
		}
		
		private function onCloseGame():void
		{
			/*if(GameManager.instance.battleView)
			{
				GameManager.instance.battleView.showResultWin();
			}*/
		}
	}
}