package framework.rpc
{
	import com.game.consts.ConstGameFlow;
	import com.game.event.GameEvent;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.netease.protobuf.Message;
	import com.netease.protobuf.UInt64;
	import com.sevenG.sevenSocket.ISocketCallBack;
	import com.sevenG.sevenSocket.SocketManager;
	import com.sevenG.sevenSocket.SocketMessageVO;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFlowCode;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.CMsgLC2LSAckTotalOnlineUserCount;
	import qihoo.gamelobby.protos.CMsgLS2LCAckAreaInfo;
	import qihoo.gamelobby.protos.CMsgLS2LCAckLogin;
	import qihoo.gamelobby.protos.CMsgLS2LCAckMatchInfo;
	import qihoo.gamelobby.protos.CMsgLS2LCAckMatchOrder;
	import qihoo.gamelobby.protos.CMsgLS2LCAckPlayerMatchInfo;
	import qihoo.gamelobby.protos.CMsgLS2LCAckProductList;
	import qihoo.gamelobby.protos.CMsgLS2LCAckSignup;
	import qihoo.gamelobby.protos.CMsgLS2LCAckUpdateProductList;
	import qihoo.gamelobby.protos.CMsgLS2LCAckUserData;
	import qihoo.gamelobby.protos.CMsgLS2LCAckUserFangChenMi;
	import qihoo.gamelobby.protos.CMsgLS2LCNotifySignupInfo;
	import qihoo.gamelobby.protos.CMsgLS2LCNotifyUserLingHongBao;
	import qihoo.gamelobby.protos.CMsgLS2LCReqAddProduct;
	import qihoo.gamelobby.protos.CMsgLS2LCReqDelProduct;
	import qihoo.gamelobby.protos.CMsgLS2LCSystemNotice;
	import qihoo.gamelobby.protos.LC2LSMsgID;
	import qihoo.gamelobby.protos.LoginAckResult;
	import qihoo.gamelobby.protos.MatchInfo;
	import qihoo.gamelobby.protos.PlayerMatchInfo;
	import qihoo.gamelobby.protos.ProductInfo;
	import qihoo.gamelobby.protos.ProductSpecInfo;
	import qihoo.gamelobby.protos.Product_Type;
	import qihoo.gamelobby.protos.Signup_Result;
	import qihoo.gamelobby.protos.UDV;
	import qihoo.gamelobby.protos.UpdateProductInfo;
	import qihoo.gamelobby.protos.UserOrigin;
	import qihoo.gamelobby.protos.UserSignupInfo;
	import qihoo.gamelobby.protos.tagArea;
	import qihoo.gamelobby.protos.tagAreaProductInfo;
	
	import time.Task;
	
	public class GameLobbySocketCallback implements ISocketCallBack
	{
		public static var fcmTime:int;
		
		public static var userFcmStatus:int;
		
		public static var currentRed:CMsgLS2LCNotifyUserLingHongBao;
		
		private var _heartbeatTask:Task;	
		private var _timeCount:int;
		
		private var _isFristLogin:Boolean = true;
		
		public function GameLobbySocketCallback()
		{
			this._heartbeatTask = new Task();
			this._heartbeatTask.taskDelay = 1000;
			this._heartbeatTask.taskDoFun = onHeartbeat;
		}
		
		public function onData(socketName:String, socketMessageVO:SocketMessageVO):void
		{			
			var infoData:Object;
			var message:Message = socketMessageVO.messageContent as Message;
			var msg:SocketMessageVO;
			
			var matchData:CDataOfMatch;
			
			CONFIG::debug
			{
				TRACE_RPC(" socket type: "+socketMessageVO.msgType + " success received !" , socketName);
			}
				switch(socketMessageVO.msgType)
				{
					//登录信息返回
					case LC2LSMsgID.LS2LC_Ack_User_Login:
						infoData = new Object();
						infoData.resultCode = CMsgLS2LCAckLogin(message).resultCode;
						infoData.id = CMsgLS2LCAckLogin(message).userID;
						infoData.name = CMsgLS2LCAckLogin(message).nickName;
						infoData.imgUrl = String(CMsgLS2LCAckLogin(message).imgUrl).split("\\").join("");
						
						var userid:Number = CBaseUtil.toNumber2(infoData.id);
						
						//缓存用户id
						if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor && WebJSManager.visitorID != userid)
						{
							if(Debug.inLobby)
							{
								var timeNum:int = new Date().getTime() / 1000;
								WebJSManager.setProfile("visitor", "id", String(userid));
								WebJSManager.setProfile("visitor", "login_time", String(timeNum));
								CONFIG::debug
								{
									TRACE("游客首次登陆时间"+timeNum,"visitor");
								}
							}
							else
							{
								CDataManager.getInstance().dataOfLocal.setKey("visitorID" ,CBaseUtil.toNumber2(infoData.id));
							}
						}
						
						if(infoData.resultCode == LoginAckResult.LoginAck_OK 
							|| infoData.resultCode == LoginAckResult.LoginAck_OK_FirstLogin
							|| infoData.resultCode == LoginAckResult.LoginAck_OK_YinDaoLogin
							|| infoData.resultCode == LoginAckResult.LoginAck_OK_SameClientMAC)
						{
							DataUtil.instance.myUserID = infoData.id;
							
							DataUtil.instance.userType = WebJSManager.originType;
							
							CDataManager.getInstance().dataOfGameUser.nickName = infoData.name;
							CDataManager.getInstance().dataOfGameUser.headUrl = infoData.imgUrl;
							
							if(Debug.inLobby)
							{
								//更新大厅游戏条信息(昵称信息)
								WebJSManager.setToolbarButtonText("static_name", infoData.name);
							}
						
							TRACE_FLOW(ConstGameFlow.LOBBY_GET_AREA_INFO + " userid = " + CBaseUtil.toNumber2(DataUtil.instance.myUserID));
							//登录成功  请求用户信息
							NetworkManager.instance.sendLobbyUserData(DataUtil.instance.myUserID);
							
							//登录成功  请求频道列表
							NetworkManager.instance.sendLobbyAreaInfo();
						}
						else
						{
							TRACE_LOG("登录失败:code_"+infoData.resultCode);
							var msgTxt:String = "";
							CFlowCode.LoginAckResult_code = infoData.resultCode;
							if(infoData.resultCode == LoginAckResult.LoginAck_Fail_AlreadyOnline)
							{
								msgTxt = "您的账号已登录,不能重复登录";
							}else if(infoData.resultCode == 251 || infoData.resultCode == LoginAckResult.LoginAck_Fail_NotOpen)
							{
								msgTxt = "服务器正在维护，请稍后登陆";
							}else
							{
								msgTxt = "您的账号登录失败,请重新登录,code:"+infoData.resultCode;
							}
							CFlowCode.params = msgTxt;
							
							CFlowCode.showWarning();
						}
						break;
					//获取防沉迷
					case LC2LSMsgID.LS2LC_Ack_UserFangChenMi:
						infoData = new Object();
						infoData.status = CMsgLS2LCAckUserFangChenMi(message).status;
						
						fcmTime = CBaseUtil.toNumber2(CMsgLS2LCAckUserFangChenMi(message).onlineSeconds) * 1000;
						
						userFcmStatus = infoData.status;
						
						if(!Debug.IS_OPEN_FCM)
						{
							return;
						}
						
						if(infoData.status != 2) //0 - 用户未填写身份信息   1 - 用户未满18岁, 
						{
							CFlowCode.Pop_FCM_code = 1;
							
							var onlinehour:Number = fcmTime / 3600000;
							
							if(onlinehour >= 1 && onlinehour < 2)
							{
								CFlowCode.params = "亲爱的玩家，您的累计在线时间已满1小时";
							}else if(onlinehour >= 2 && onlinehour < 3)
							{
								CFlowCode.params = "亲爱的玩家，您的累计在线时间已满2小时";
							}else if(onlinehour >= 3)
							{
								CFlowCode.params = "亲爱的玩家，您已进入‘疲劳’游戏时间，为了您的健康，请尽快下线休息，合理安排学习生活。";
							}else
							{
								if(infoData.status == 0)
								{
									CFlowCode.params = "亲爱的玩家，您尚未进行实名验证。去除提醒请尽快进行实名验证。";
								}
							}
							
							CONFIG::debug
							{
								TRACE("防沉迷信息："+infoData.status+"____"+fcmTime, "FCM");
							}
							
							CFlowCode.showWarning();
						}
						
						
						break;
					//领取红包的通知
					case LC2LSMsgID.LS2LC_Notify_UserLingHongBao:
						var userRed:CMsgLS2LCNotifyUserLingHongBao = CMsgLS2LCNotifyUserLingHongBao(message);
						TRACE_LOG("红包的状态："+userRed.status);
						if(userRed.status == 0)
						{
							currentRed = userRed;
							
							CFlowCode.Pop_Red_code = 1;
						}
						
						break;
					//获取用户之前报名的比赛
					case LC2LSMsgID.LS2LC_Notify_SignupInfo:
						var list:Array = CMsgLS2LCNotifySignupInfo(message).userSignupList;
						var len:int = list.length;
						var index:int;
						var userSignupInfo:UserSignupInfo;
						for(index = 0; index < len; index++)
						{
							infoData = new Object();
							userSignupInfo = list[index];
							infoData.id = userSignupInfo.productID;
							infoData.gameID = userSignupInfo.gameID;
							infoData.money = userSignupInfo.money.low;
							infoData.status = userSignupInfo.status;
						}
						break;
					//得到频道列表
					case LC2LSMsgID.LS2LC_Ack_AreaInfo:
						var areaInfo:tagArea;
						var areaObj:Object;
						for each(areaInfo in CMsgLS2LCAckAreaInfo(message).areaInformation.area)
						{
							areaObj = new Object();
							areaObj.id = areaInfo.areaID;
							areaObj.parentAreaID = areaInfo.parentAreaID;
						}
							
						var areaProInfo:tagAreaProductInfo;
						var areaProObj:Object;
						for each(areaProInfo in CMsgLS2LCAckAreaInfo(message).areaInformation.areaProductInfo)
						{
							areaProObj = new Object();
							areaProObj.id = areaProInfo.productID;
							areaProObj.areaID = areaProInfo.areaID;
							areaProObj.gameID = areaProInfo.gameID;
						}
						
						TRACE_FLOW(ConstGameFlow.LOBBY_GET_PRODUCT);
						//请求产品列表
						NetworkManager.instance.sendLobbyProductList();
						break;
					//得到产品列表
					case LC2LSMsgID.LS2LC_Ack_Product_List:
						var productInfo:ProductInfo;
						for each(productInfo in CMsgLS2LCAckProductList(message).prodInfo)
						{
							if(productInfo.productType == Product_Type.Product_Type_Island)
							{
								DataUtil.instance.selectProductID = productInfo.productID;
							}else if(productInfo.productType == Product_Type.Product_Type_FishingJoy)
							{
								matchData = new CDataOfMatch();
								matchData.productID = productInfo.productID;
								matchData.status = productInfo.status;
								matchData.startTime = CBaseUtil.toNumber2(productInfo.matchStartTime) * 1000;
								matchData.endTime = CBaseUtil.toNumber2(productInfo.productCloseTime) * 1000;
								matchData.signUpCost = productInfo.signupCost;
								matchData.matchName = productInfo.productName;
								matchData.visitorCanEnter = productInfo.visitorCanEnter;
								
								if(productInfo.productID >= 140000 && productInfo.productID <= 140100)
								{
									matchData.matchType = 2;//银豆赛
								}else
								{
									matchData.matchType = 1;//话费赛
								}
								
								if(productInfo.specInfoData != null)
								{
									var productSpecInfo:ProductSpecInfo = new ProductSpecInfo();
									productSpecInfo.mergeFrom(productInfo.specInfoData);
									
									matchData.matchEndTime = productSpecInfo.secStopSignToEnd * 1000;
								}
								
								CDataManager.getInstance().dataOfProduct.pushMatch(matchData);
							}
							
							CONFIG::debug
							{
								TRACE_LOG("request match productId: "+productInfo.productID+" name: "+productInfo.productName+" type: "+productInfo.productType+"status:"+productInfo.status);
							}
						}
						
						TRACE_FLOW(ConstGameFlow.LOBBY_SIGN_UP_MATCH);
						NetworkManager.instance.sendLobbySignUpMatch(DataUtil.instance.selectProductID);
						
						break;
					//更新产品信息
					case LC2LSMsgID.LS2LC_Ack_Update_Product_List:
						var updateProductInfo:UpdateProductInfo;
						for each(updateProductInfo in CMsgLS2LCAckUpdateProductList(message).updateProdInfo)
						{
							matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(updateProductInfo.productID);
							if(matchData == null)
							{
								continue;
							}
							matchData.status = updateProductInfo.status;
						}
						CBaseUtil.sendEvent(GameNotification.EVENT_UPDATE_MATCH_LIST);
						
						break;
					//添加一个产品
					case LC2LSMsgID.LS2LC_Req_AddProduct:
						if(message)
						{
							var prodInfo:ProductInfo = CMsgLS2LCReqAddProduct(message).prodInfo;
							if(prodInfo.productType == Product_Type.Product_Type_FishingJoy)
							{
								matchData = new CDataOfMatch();
								matchData.productID = prodInfo.productID;
								matchData.status = prodInfo.status;
								matchData.startTime = CBaseUtil.toNumber2(prodInfo.matchStartTime) * 1000;
								matchData.endTime = CBaseUtil.toNumber2(prodInfo.productCloseTime) * 1000;
								matchData.signUpCost = prodInfo.signupCost;
								matchData.matchName = prodInfo.productName;
								matchData.visitorCanEnter = prodInfo.visitorCanEnter;
								
								if(prodInfo.productID >= 140000 && prodInfo.productID <= 140100)
								{
									matchData.matchType = 2;//银豆赛
								}else
								{
									matchData.matchType = 1;//话费赛
								}
								
								if(prodInfo.specInfoData != null)
								{
									var prodSpecInfo:ProductSpecInfo = new ProductSpecInfo();
									prodSpecInfo.mergeFrom(prodInfo.specInfoData);
									
									matchData.matchEndTime = prodSpecInfo.secStopSignToEnd * 1000;
								}
								
								CDataManager.getInstance().dataOfProduct.pushMatch(matchData);
								
								CBaseUtil.sendEvent(GameNotification.EVENT_UPDATE_MATCH_LIST);
							}
						}
						break;
					//删除一个产品
					case LC2LSMsgID.LS2LC_Req_DelProduct:
						if(message)
						{
							CDataManager.getInstance().dataOfProduct.delMatch(CMsgLS2LCReqDelProduct(message).productID);
							
							if(DataUtil.instance.selectMatchProductID == CMsgLS2LCReqDelProduct(message).productID)
							{
								var first:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getFirstMatch();
								if(first)
								{
									DataUtil.instance.selectMatchProductID = first.productID;
									
									CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_MATCH_ITEM, DataUtil.instance.selectMatchProductID);
								}
							}
							
							CBaseUtil.sendEvent(GameNotification.EVENT_UPDATE_MATCH_LIST);
						}
						break;
					//获取用户信息
					case LC2LSMsgID.LS2LC_Ack_User_Data:
						var udv:UDV;
						for each(udv in CMsgLS2LCAckUserData(message).userData)
						{
							if(udv.type.iD == 25)
							{                 
								var num:int = CBaseUtil.toNumber(udv.value);
								if(num > 0)
								{
									CFlowCode.Pop_New_code = 1;
								}
							}else if(udv.type.iD == 26)
							{
								var num1:int = CBaseUtil.toNumber(udv.value);
								//弹红包结果
								Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_RED_GIFT_RESULT , true , {num:num1}));
							}
						}
						
						//通知观察者
						break;
					//获取用户比赛信息
					
					case LC2LSMsgID.LS2LC_Ack_PlayerMatchInfo:
						if(message != null)
						{
							matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(CMsgLS2LCAckPlayerMatchInfo(message).productID);
							if(matchData == null)
							{
								return;
							}
							matchData.matchID = CMsgLS2LCAckPlayerMatchInfo(message).matchID;
							
							var playerMatchInfo:PlayerMatchInfo = new PlayerMatchInfo();
							playerMatchInfo.mergeFrom(CMsgLS2LCAckPlayerMatchInfo(message).infoData);
							
							matchData.maxScore = playerMatchInfo.maxScore;
							matchData.matchRank = playerMatchInfo.order;
							matchData.currentRobNum = playerMatchInfo.playedCount;
							matchData.isPlaying = playerMatchInfo.isPlaying;
							
							Fibre.getInstance().sendNotification(GameNotification.EVENT_MATCH_UPDATA, {id:matchData.productID, flog:false});
						}
						break;
					//获取产品比赛信息
					case LC2LSMsgID.LS2LC_Ack_MatchInfo:
						if(message != null)
						{
							matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(CMsgLS2LCAckMatchInfo(message).productID);
							if(matchData == null)
							{
								return;
							}
							//新赛制
							var matchInfo:MatchInfo = new MatchInfo();
							matchInfo.mergeFrom(CMsgLS2LCAckMatchInfo(message).specInfo);
							
							matchData.signUpNum = matchInfo.playingCount;
							matchData.totalRobNum = matchInfo.allowReplayCount;
							matchData.maxRobNum = matchInfo.maxReplayCount;
							matchData.replayCost = matchInfo.replayCost;
							matchData.matchCD = matchInfo.secRemain * 1000;
							matchData.waitCD = matchInfo.secWait * 1000;
							matchData.matchStartTime = CBaseUtil.toNumber2(matchInfo.startTime) * 1000;
							
							Fibre.getInstance().sendNotification(GameNotification.EVENT_MATCH_UPDATA, {id:matchData.productID, flog:true});
						}
						
						break;
					//比赛排名
					case LC2LSMsgID.LS2LC_ACK_MatchOrder:
						matchData = CDataManager.getInstance().dataOfProduct.getMatchByID(CMsgLS2LCAckMatchOrder(message).productID);
						if(matchData == null)
						{
							return;
						}
						matchData.remainCount = CMsgLS2LCAckMatchOrder(message).remainCount;
						matchData.rankList = CMsgLS2LCAckMatchOrder(message).order;
						
						Fibre.getInstance().sendNotification(GameNotification.EVENT_MATCH_UPDATA_ORDER, {});
						break;
					//收到报名
					case LC2LSMsgID.LS2LC_Ack_Signup:
						
						var tipsObj:Object = new Object();
						var result:int = CMsgLS2LCAckSignup(message).result;
						
						CFlowCode.Signup_Result_code = result;
						
						var signUpMsg:String = "";
						if(result == Signup_Result.Signup_Success)
						{
							TRACE_FLOW(ConstGameFlow.LOBBY_SIGN_UP_MATCH_SUCC);
							
							DataUtil.instance.tryReconnect = DataUtil.RECONNECT_NUM;
							
							return;
						}else if(result == Signup_Result.Signup_Fail_Money_Not_Enough || result == Signup_Result.Signup_Fail_ExecuteFee)
						{
							signUpMsg = "报名失败，比赛所需费用不足";
						}else if(result == Signup_Result.Signup_PlayerCount_Full)
						{
							signUpMsg = "当前比赛报名人数已满，请等待下场比赛";
						}else if(result == Signup_Result.Signup_NoSignStatus)
						{
							signUpMsg = "当前比赛正在维护中...";
						}else if(result == Signup_Result.Signup_Fail_AlreadyExist)
						{
							if(DataUtil.instance.tryReconnect < 0)
							{
								signUpMsg = "您的账号登陆超时，请重新登陆";
							}else
							{
								CFlowCode.Signup_Result_code = 0;
								
								NetworkManager.instance.exitGame();
								
								CBaseUtil.delayCall(function():void{
									NetworkManager.instance.connectLobby();
								} , 3 , 1);
								
								DataUtil.instance.tryReconnect -- ;
								return;
							}
						}else
						{
							
							signUpMsg = "报名失败，请稍后重试，errorcode:" + result;
						}
						CFlowCode.params = signUpMsg;
						
						//非比赛
						if(!NetworkManager.instance.isMatching)
						{
							CFlowCode.showWarning();
						}
						else
						{
							CBaseUtil.showConfirm(signUpMsg, function ():void
							{
								CBaseUtil.sendEvent(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
								CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
								NetworkManager.instance.sendServerGetCoin();
							});
							CBaseUtil.hideLoading();
						}
						
						NetworkManager.instance.isMatching = false;
						WebJSManager.setPropValue(0);
						
						break;
					case LC2LSMsgID.LS2LC_Ack_Signoff:
						break;
					//收到游戏服务器地址信息并请求连接游戏服务器
					case LC2LSMsgID.LS2LC_Notify_Start_Match:
						TRACE_FLOW(ConstGameFlow.LOBBY_CONNECT_SERVER_GAME);
						NetworkManager.instance.connectGameServer(message);
						break;
					//停机维护
					case LC2LSMsgID.LS2LC_Ack_Total_OnlineUserCount:
						DataUtil.instance.totalUser = CMsgLC2LSAckTotalOnlineUserCount(message).onlineUserCount;
						CBaseUtil.sendEvent(GameNotification.EVENT_TOTAL_ONLINE_USER ,{});
						break;
					//停机维护
					case LC2LSMsgID.LS2LC_Notify_SystemMaintain:
						CBaseUtil.showConfirm("服务器正在停机维护，请立即下线");
						NetworkManager.instance.exitGame();
						break;
					//比赛提示信息
					case LC2LSMsgID.LS2LC_Notify_SystemNotice:
						CBaseUtil.sendEvent(GameNotification.EVENT_SYSTEM_TIPS, CMsgLS2LCSystemNotice(message).notice);
						CONFIG::debug
						{
							TRACE(CMsgLS2LCSystemNotice(message).notice, "systemtips");
						}
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
			TRACE_FLOW(ConstGameFlow.LOBBY_GET_QT);
			
			DataUtil.instance.tryReconnect = DataUtil.RECONNECT_NUM;
			
			if(Debug.inLobby)
			{
				WebJSManager.getQT(startLogin);
			}
			else
			{
				startLogin("");
			}
			
			this._heartbeatTask.taskFunParam = [socketName];
			this._heartbeatTask.start();
		}
		
		public function startLogin(data:String):void
		{
			var q:String = "";
			var t:String = "";
			var strs:Array = data.split(";");
			
			DataUtil.instance.qt = data;
			
			for each(var str:String in strs)
			{
				if(str.indexOf("Q=") != -1)
				{
					q = str.replace("Q=", "");
					q = q.replace(/\s/g,"");
				}else if(str.indexOf("T=") != -1)
				{
					t = str.replace("T=", "");
					t = t.replace(/\s/g,"");
				}
			}
			
			//取缓存的游客id登录
			var visitorID:UInt64;
			if(Debug.inLobby)
			{
				visitorID = CBaseUtil.fromNumber2(WebJSManager.visitorID);
			}
			else
			{
				visitorID = CBaseUtil.fromNumber2(CDataManager.getInstance().dataOfLocal.getKey("visitorID"))
			}
			
			CONFIG::debug
			{
				TRACE("TYPE = " + WebJSManager.originType , "login");
				TRACE("visitorID = " + visitorID , "login");
				TRACE("isLoginChangeState = " + WebJSManager.isLoginChangeState , "login");
			}
			
			//引导注册
			if(WebJSManager.originType != UserOrigin.UserOrigin_Visitor && visitorID != null && WebJSManager.isLoginChangeState)
			{
				//状态重置
				WebJSManager.isLoginChangeState = false;
				
				if(Debug.inLobby)
				{
					WebJSManager.setProfile("visitor", "id", "0");
				}else
				{
					CDataManager.getInstance().dataOfLocal.delKey("visitorID");
				}
			}
			else if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor && visitorID != null)
			{
				
			}
			else
			{
				visitorID = new UInt64();
			}
			
//			visitorID = new UInt64();
			
			if(WebJSManager.macUrl == null)
			{
				WebJSManager.macUrl = new UInt64();
			}
			
			TRACE_FLOW(ConstGameFlow.LOBBY_LOGIN);
			TRACE_FLOW("originType = " + WebJSManager.originType
				+ " mac = " + WebJSManager.macUrl 
				+ " visitorID = " + visitorID
				+ " qt = " + data);
			
			if(Debug.DEBUG_LOGIN_OTHER_COUNT)
			{
				CDataManager.getInstance().dataOfDebugOther.startLogin();
			}
			else
			{
				//登录
				NetworkManager.instance.sendLobbyUserLogin(WebJSManager.originType, WebJSManager.macUrl, q, t, visitorID);
			}
		}
		
		public function onHeartbeat(socketName:String):void
		{
			this._timeCount ++;
			
			if(this._timeCount % 30 == 0)
			{
				//心跳
				SocketManager.instance.sendHeartbeatMsg(socketName);
				
				//30秒获取一次人数
				NetworkManager.instance.sendLobbyOnlineUser();
			}
			
			if(this._timeCount %　180 == 0)
			{
				if(Debug.inLobby && Debug.OPEN_WEB)
				{
					WebJSManager.gameLoadUnread(onMailUnread);
				}
			}
			
			
			fcmTime += 1000;
			
			
			if((fcmTime / 3600000) == 1 && userFcmStatus != 2 && WebJSManager.originType != UserOrigin.UserOrigin_Visitor && Debug.IS_OPEN_FCM)
			{
				CBaseUtil.showConfirm("亲爱的玩家，您的累计在线时间已满1小时", onFangChenMi);
			}else if((fcmTime / 3600000) == 2 && userFcmStatus != 2 && WebJSManager.originType != UserOrigin.UserOrigin_Visitor && Debug.IS_OPEN_FCM)
			{
				CBaseUtil.showConfirm("亲爱的玩家，您的累计在线时间已满2小时", onFangChenMi);
			}else if((fcmTime / 3600000) == 3 && userFcmStatus != 2 && WebJSManager.originType != UserOrigin.UserOrigin_Visitor && Debug.IS_OPEN_FCM)
			{
				CBaseUtil.showConfirm("亲爱的玩家，您已进入‘疲劳’游戏时间，为了您的健康，请尽快下线休息，合理安排学习生活。", onFangChenMi);
			}
			
		}
		
		public function onDisconnected(socketName:String):void
		{
			this._heartbeatTask.stop();
			
			DataUtil.instance.selectMatchProductID = 0;
				
			CBaseUtil.sendEvent(GameNotification.EVENT_GAME_OVER);
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL);
			CBaseUtil.showConfirm("您已断开连接 ， 点击确定退出当前游戏并重连 。 ", reconnet);
		}
		
		public function onIOError(socketName:String):void
		{
			if(DataUtil.instance.tryReconnect < 0)
			{
				CFlowCode.params = "请检查您的网络或者留意官方维护公告。<a href='event:"+ ConfigManager.LUTAN_URL +"'><u> 论坛地址 </u></a>";
				CFlowCode.Signup_Result_code = -1;
				CFlowCode.showWarning();
			}else
			{
				NetworkManager.instance.exitGame();
				
				CBaseUtil.delayCall(function():void{
					NetworkManager.instance.connectLobby();
				} , 3 , 1);
				
				DataUtil.instance.tryReconnect -- ;
				return;
			}
			
			CONFIG::debug
			{
				TRACE_LOG("onIOError");
			}
		}
		
		public function onSecurityError(socketName:String):void
		{
			if(DataUtil.instance.tryReconnect < 0)
			{
				CFlowCode.params = "请检查您的网络或者留意官方维护公告。<a href='event:"+ ConfigManager.LUTAN_URL +"'><u> 论坛地址 </u></a>";
				CFlowCode.Signup_Result_code = -1;
				CFlowCode.showWarning();
			}else
			{
				NetworkManager.instance.exitGame();
				
				CBaseUtil.delayCall(function():void{
					NetworkManager.instance.connectLobby();
				} , 3 , 1);
				
				DataUtil.instance.tryReconnect -- ;
				return;
			}
			
			CONFIG::debug
			{
				TRACE_LOG("onSecurityError");
			}
		}
		
		public function reconnet():void
		{
			CBaseUtil.showLoading();
			NetworkManager.instance.restartGame();
		}
		
		/**
		 * 弹出防沉迷验证 
		 * 
		 */		
		public static function onFangChenMi():void
		{
			if(Debug.inLobby && userFcmStatus == 0)
			{
				WebJSManager.gameFuncGetFcm();
			}
		}
		
		public function onMailUnread(data:Object):void
		{
			CBaseUtil.sendEvent(GameNotification.EVENT_UPDATE_MAIL, data.unread_count);
		}
	}
}