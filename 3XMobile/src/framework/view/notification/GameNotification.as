package framework.view.notification
{
	
	public class GameNotification
	{
		
		public static const AM_WORLD_ADD_TO_LAYER:String = "AM_WORLD_ADD_TO_LAYER";
		public static const AM_LAYER_CLEAR:String = "AM_LAYER_CLEAR";
		public static const AM_PANEL_POPUP_FROM_LAYER:String = "AM_PANEL_POPUP_FROM_LAYER";
		public static const AM_PANEL_REMOVE:String = "AM_PANEL_REMOVE";
		public static const AM_WORLD_REMOVE:String = "AM_WORLD_REMOVE";
		
		public static const WORLD_REMOVE:String = "WORLD_REMOVE";
		
		public static const GAME_MAP_READY:String = "GAME_MAP_READY";
		public static const CITY_FRIST_STEP_NONE_PLAYER:String = "CITY_FRIST_STEP_NONE_PLAYER";
		public static const USER_VISIABLE_CHANGED:String = "USER_VISIABLE_CHANGED";
		
		public static const G_CHANGE_WORLD:String = "G_CHANGE_WORLD";
		public static const G_REMOVE_WORLD:String = "G_REMOVE_WORLD";
		public static const G_POP_UP_PANEL:String = "G_POP_UP_PANEL";
		public static const G_CLOSE_PANEL:String = "G_CLOSE_PANEL";
		public static const G_FLUID_SCREEN:String = "G_FLUID_SCREEN";
		
		public static const GAME_STATE_CHANGE:String = "GAME_STATE_CHANGE";
		
		public static const PANEL_POPUP:String = "PANEL_POPUP";
		public static const PANEL_CLOSE:String = "PANEL_CLOSE";
		
		public static const SOMETHING_BEFORE_CLICK:String = "SOMETHING_BEFORE_CLICK";
		public static const SOMETHING_AFTER_CLICK:String = "SOMETHING_AFTER_CLICK";
		
		public static const EVENT_WORLD_MAP_MOVED:String = "EVENT_WORLD_MAP_MOVED";
		public static const EVENT_PROGRESS_MAP_MOVED:String = "EVENT_PROGRESS_MAP_MOVED";
		
		//组解锁
		public static const EVENT_GROUP_UNLOCKED:String = "EVENT_GROUP_UNLOCKED";
		
		public static const EVENT_GAME_START:String = "EVENT_GAME_START";
		public static const EVENT_GAME_OVER:String = "EVENT_GAME_OVER";
		
		public static const EVENT_START_CACULATE_FINISH:String = "EVENT_START_CACULATE_FINISH";
		
		public static const EVENT_SCORE_ANI:String = "EVENT_SCORE_ANI";
		
		public static const EVENT_STOP_TASK:String = "EVENT_STOP_TASK";
		
		//获取推荐列表回调
		public static const EVENT_GET_RECOMMAND_BACK:String = "EVENT_GET_RECOMMAND_BACK";
		
		//游戏中消除消除体
		public static const EVENT_GAME_REMOVE_ITEM:String = "EVENT_GAME_REMOVE_ITEM";
		//消除礼物
		public static const EVENT_GAME_REMOVE_GIFT:String = "EVENT_GAME_REMOVE_GIFT";
		public static const EVENT_GAME_REMOVE_GIFT_COMPLETE:String = "EVENT_GAME_REMOVE_GIFT_COMPLETE";
		
		//比赛数据更新
		public static const EVENT_MATCH_UPDATA:String = "EVENT_MATCH_UPDATA";
		//比赛排名信息
		public static const EVENT_MATCH_UPDATA_ORDER:String = "EVENT_MATCH_UPDATA_ORDER";
		//游戏数据更新
		public static const EVENT_GAME_DATA_UPDATE:String = "EVENT_GAME_DATA_UPDATE";
		//取好友列表
		public static const EVENT_GET_FRIENDLIST:String = "EVENT_GET_FRIENDLIST";
		//货币更新
		public static const EVENT_MONEY_DATA_UPDATE:String = "EVENT_MONEY_DATA_UPDATE";
		//体力恢复时间
		public static const EVENT_ENERGY_RECOVER_REMAIN_TIME:String = "EVENT_ENERGY_RECOVER_REMAIN_TIME";
		//体力更新
		public static const EVENT_GAME_ENERGY_UPDATE:String = "EVENT_GAME_ENERGY_UPDATE";
		//头像和名字
		public static const EVENT_FRIEND_IMG_NAME:String = "EVENT_FRIEND_IMG_NAME";
		//道具更新
		public static const EVENT_TOOL_DATA_UPDATE:String = "EVENT_TOOL_DATA_UPDATE";
		//购买失败
		public static const EVENT_TOOL_BUY_FAIL:String = "EVENT_TOOL_BUY_FAIL";
		//小信封更新
		public static const EVENT_UPDATE_MAIL:String = "EVENT_UPDATE_MAIL";
		//好友列表更新
		public static const EVENT_FRIEND_LIST_UPDATE:String = "EVENT_UPDATE_MAIL";
		//好友星值消息
		public static const EVENT_FRIEND_STAR_INFO:String = "EVENT_FRIEND_STAR_INFO";
		public static const EVENT_FRIEND_SCORE_INFO:String = "EVENT_FRIEND_SCORE_INFO";
		//个人关卡信息
		public static const EVENT_STAR_INFO:String = "EVENT_STAR_INFO";
		public static const EVENT_PLAY_TO:String = "EVENT_PLAY_TO";
		//警告面板
		public static const EVENT_SHOW_WARNING:String = "EVENT_SHOW_WARNING";
		
		public static const EVENT_USE_ITEM:String = "EVENT_USE_ITEM";
		//视口位置移动
		public static const EVENT_SCENE_VIEW_PORT_MOVE:String = "EVENT_SCENE_VIEW_PORT_MOVE";
		
		//星值奖励更新
		public static const EVENT_STAR_REWARD_UPDATE:String = "EVENT_STAR_REWARD_UPDATE";
			
		//好友账户来源
		public static const EVENT_USER_TYPE:String = "EVENT_USER_TYPE";
		//切换登录
		public static const EVENT_USER_CHANGE_LOGIN:String = "EVENT_USER_CHANGE_LOGIN";
		//第二组事件
		public static const EVENT_SECOND_LOAD_FINISH:String = "EVENT_SECOND_LOAD_FINISH";
		
		//显示赠送体力按钮
		public static const EVENT_SHOW_ENERGY:String = "EVENT_SHOW_ENERGY";
		public static const EVENT_TOTAL_ONLINE_USER:String = "EVENT_TOTAL_ONLINE_USER";
		//好友消息数量变化
		public static const EVENT_MESSAGE_NUM_CHANGE:String = "EVENT_MESSAGE_NUM_CHANGE";
		//系统提示
		public static const EVENT_SYSTEM_TIPS:String = "EVENT_SYSTEM_TIPS";
		//更改系统提示位置
		public static const EVENT_CHANGE_SYSTEM_TIPS:String = "EVENT_CHANGE_SYSTEM_TIPS";
		//选择一个比赛item
		public static const EVENT_CHANGE_MATCH_ITEM:String = "EVENT_CHANGE_MATCH_ITEM";
		//刷新比赛itemlist
		public static const EVENT_UPDATE_MATCH_LIST:String = "EVENT_UPDATE_MATCH_LIST";
		//更新奖状数量
		public static const EVENT_UPDATE_DIPLOMA_NUM:String = "EVENT_UPDATE_DIPLOMA_NUM";
		//显示奖状图标
		public static const EVENT_SHOW_DIPLOMA:String = "EVENT_SHOW_DIPLOMA";
		//奖杯提示
		public static const EVENT_DIPLOMA_TIPS:String = "EVENT_DIPLOMA_TIPS";
		//翻页改变
		public static const EVENT_CHANGE_PAGE:String = "EVENT_CHANGE_PAGE";
		//显示活动按钮
		public static const EVENT_ACTIVITY_ONLINE:String = "EVENT_ACTIVITY_ONLINE";
		//显示登陆按钮
		public static const EVENT_ACTIVITY_LOGIN:String = "EVENT_ACTIVITY_LOGIN";
		//开启新功能
		public static const EVENT_FUNCTION_OPEN_PANEL:String = "EVENT_FUNCTION_OPEN";
		//显示添加好友按钮
		public static const EVENT_SHOW_ADDFRIEND:String = "EVENT_SHOW_ADDFRIEND";
		
		public static const EVENT_FUNCTION_OPEN_ANI:String = "EVENT_FUNCTION_OPEN_ANI";
		
		public static const EVENT_FUNCTION_OPEN_ANI_COMPLETE:String = "EVENT_FUNCTION_OPEN_ANI_COMPLETE";
		
		public function GameNotification()
		{
			
		}
	}
}