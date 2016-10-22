package framework.rpc
{
	import com.netease.protobuf.Message;
	import com.sevenG.sevenSocket.ISocketDataDeserializer;
	
	import flash.utils.ByteArray;
	
	import qihoo.gamelobby.protos.CMsgGS2MCNotifyUserGameStatus;
	import qihoo.gamelobby.protos.GSMsgID;
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
	import qihoo.triplecleangame.protos.CMsgNotifyTimeRecoverEnergy;
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
	import qihoo.triplecleangame.protos.TRIPLE_CLEAN_LOGIC_MSG_ID;
	
	public class GameSocketDataProtoBufDeserializer implements ISocketDataDeserializer
	{
		public function GameSocketDataProtoBufDeserializer()
		{
		}
		
		public function Deserialize(msgType:int, dataArray:Object):Object
		{
			try
			{
				var ret:Message;
				var da:ByteArray = dataArray as ByteArray;
				da.position = 0;
				switch(msgType)
				{
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_MIDDLE_VALIDATE_RESPONSE:
						ret = new CMsgMiddleValidateResponse();
						ret.mergeFrom(da);
						break;
					//开始游戏
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_START_GAME_RESPONSE:
						ret = new CMsgStartGameResponse();
						ret.mergeFrom(da);
						break;
					//消除
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_STEP_CLEAN_RESPONSE:
						ret = new CMsgStepCleanResponse();
						ret.mergeFrom(da);
						break;
					//用户信息
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_USER_INFO_RESPONSE:
						ret = new CMsgGetUserInfoResponse();
						ret.mergeFrom(da);
						break;
					//组解锁
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_UNLOCK_LEVEL_GROUP_RESPONSE:
						ret = new CMsgUnlockLevelGroupResponse();
						ret.mergeFrom(da);
						break;
					//倒计时
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_TASK_TIMEOUT_RESPONSE:
						ret = new CMsgTaskTimeoutResponse();
						ret.mergeFrom(da);
						break;
					//请求好友列表
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_RRIEND_LIST_RESPONSE:
						ret = new CMsgGetFriendListResponse();
						ret.mergeFrom(da);
						break;
					//添加好友
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_ADD_FRIEND_RESPONSE:
						ret = new CMsgAddFriendResponse();
						ret.mergeFrom(da);
						break;
					//删除好友
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_DELETE_FRIEND_RESPONSE:
						ret = new CMsgDeleteFriendResponse();
						ret.mergeFrom(da);
						break;
					//随机推荐
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_RECOMMEND_FRIEND_RESPONSE:
						ret = new CMsgRecommendFriendResponse();
						ret.mergeFrom(da);
						break;
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_NOTIFY_TIME_RECOVER_ENERGY:
						ret = new CMsgNotifyTimeRecoverEnergy();
						ret.mergeFrom(da);
						break;
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_START_MATCH_RESPONSE:
						ret = new CMsgStartMatchResponse();
						ret.mergeFrom(da);
						break;
					case GSMsgID.GS2MC_Notify_UserGameStatus:
						ret = new CMsgGS2MCNotifyUserGameStatus();
						ret.mergeFrom(da);
						break;
					//url和头像
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_NAME_IMAGE_RESPONSE:
						ret = new CMsgGetNameImageResponse();
						ret.mergeFrom(da);
						break;
					//货币
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_NOTIFY_PLAYER_MONEY:
						ret = new CMsgNotifyPlayerMoney();
						ret.mergeFrom(da);
						break;
					//倒计时时间间隔
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_NOTIFY_RECOVER_ENERGY_INTERVAL:
						ret = new CMsgNotifyRecoverEnergyInterval();
						ret.mergeFrom(da);
						break;
					//购买道具
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_QUICK_BUY_RESPONSE:
						ret = new CMsgQuickBuyResponse();
						ret.mergeFrom(da);
						break;
					//获取用户信息
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_PLAYER_ITEM_INFO_RESPONSE:
						ret = new CMsgGetPlayerItemInfoResponse();
						ret.mergeFrom(da);
						break;
					//好友星值信息
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_FRIEND_STAR_INFO_RESPONSE:
						ret = new CMsgFriendStarInfoResponse();
						ret.mergeFrom(da);
						break;
					//好友星值信息
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_FRIEND_LEVEL_SCORE_RESPONSE:
						ret = new CMsgGetFriendScoreResponse();
						ret.mergeFrom(da);
						break;
					//一键补满体力
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_QUICK_ADD_ENERGY_RESPONSE:
						ret = new CMsgQuickAddEnergyResponse();
						ret.mergeFrom(da);
						break;
					//使用道具
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_USE_ITEM_RESPONSE:
						ret = new CMsgUseItemResponse();
						ret.mergeFrom(da);
						break;
					//关卡数据
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_LEVELS_INFO_RESPONSE:
						ret = new CMsgGetLevelsInfoResponse();
						ret.mergeFrom(da);
						break;
					//关卡数据
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_GIFT_RESPONSE:
						ret = new CMsgGetGiftResponse();
						ret.mergeFrom(da);
						break;
					//关卡数据
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_SEND_PLAYER_ORIGIN:
						ret = new CMsgSendPlayerOrigin();
						ret.mergeFrom(da);
						break;
					// 运营活动信息回复
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ACTIVITY_INFO_RESPONSE:
						ret = new CMsgGetActivityInfoResponse();
						ret.mergeFrom(da);
						break;
					// 运营活动每日赠送体力领取回复
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ACTIVITY_DAY_ENERGY_RESPONSE:
						ret = new CMsgGetActivityDayEnergyResponse();
						ret.mergeFrom(da);
						break;
					// 星值奖励
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_STAR_REWARD_RESPONSE:
						ret = new CMsgGetStarRewardResponse();
						ret.mergeFrom(da);
						break;
					//在线运营活动
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ONLINE_ACTIVITY_INFO_RESPONSE:
						ret = new CMsgGetOnlineActivityInfoResponse();
						ret.mergeFrom(da);
						break;
					//领取在线奖励
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_ONLINE_ACTIVITY_REWARD_RESPONSE:
						ret = new CMsgGetStarRewardResponse();
						ret.mergeFrom(da);
						break;
					//领取连续登陆
					case TRIPLE_CLEAN_LOGIC_MSG_ID.S2C_GET_DAY_ACTIVITY_REWARD_RESPONSE:
						ret = new CMsgGetStarRewardResponse();
						ret.mergeFrom(da);
						break;
				}
			}
			catch(e:Object)
			{
				
			}
			return ret;
		}
	}
}