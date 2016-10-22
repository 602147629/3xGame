package com.game.consts
{
	/** 
	 * @author melody
	 */
	public class ConstGameNetCmd
	{
		
		public static const CMD_SERVER_REGISTER:int = 1000;
		public static const CMD_SERVER_LOG_IN:int = 1001;
		public static const CMD_SERVER_GET_LIST:int = 1002;
		public static const CMD_SERVER_GET_SESSION_KEY:int = 1003;
		
		
		public static const CMD_DEBUG_COMMAND:int = 1;
		public static const CMD_SYSTEM_PLAYER_LOGIN_AGAIN:int = 2;
		public static const CMD_SYSTEM_MESSAGE:int = 3;
		public static const CMD_SYSTEM_SERVER_DOWN:int = 4;
	
		/**
		 * 999
		 * 每隔一定时间通知server, 玩家仍在线
		 */
		public static const CMD_ON_LINE:int = 999;
		/**
		 * 1000
		 * 玩家登录
		 */
		public static const PLAYER_LOG_IN:int = 1000;
		/**
		 * 1001
		 * 创建角色
		 */
		public static const CREAT_ROLE:int = 1001;
		/**
		 * 1002
		 * 绑定玩家
		 */
		public static const BINDING_PLAYER:int = 1002;
		/**
		 * 1003
		 * 获取玩家基本信息
		 */
		public static const GET_USER_BASE_INFO:int = 1003;
		/**
		 * 1004
		 * 金币更新
		 */
		public static const CMD_NOTICE_UPDATE_COIN:int = 1004
		/**
		 * 1006
		 * 元宝数量更新
		 */
		public static const CMD_NOTICE_UPDATE_GOLD:int = 1006;
		/**
		 * 1008
		 * 体力更新
		 */	
		public static const CMD_UPDATE_HP:int = 1008;
		/**
		 * 1010
		 * 获取主角形象
		 */
		public static const GET_MAINROLE_IMG:int = 1010;
		
		public static const UPDATE_ACTOR_STYLE:int = 1011;
		/**
		 * 1014
		 * 玩家经验更新
		 */
		public static const CMD_NOTICE_UPDATE_ROLE_EXP:int = 1014;
			
		public static const CMD_NOTICE_PLAYER_ONLINE:int = 1016;
		
		public static const CMD_NOTICE_PLAYER_OFFLINE:int = 1017;
		
		/**
		 * 1100
		 * 进入场景
		 */
		public static const ENTER_SCENE:int = 1100;
		public static const ENTER_FIGHT_SCENE:int = 1115;
		
		
		public static const CMD_UPDATE_MAIN_ACTOR_POSITION:int = 1101;
		
		public static const CMD_USER_QUIT_FIGHTSCENE:int = 1102;
		
		public static const CMD_GET_FIGHT_REWARD:int = 1103;
		
		/**
		 * 服务器通知玩家移动或状态改变 
		 * */
		public static const CMD_NOTICE_OTHER_PLAYER_STATUS_UPDATE:int = 1104;
		/**
		 * 服务器通知玩家进入场景（主城） 
		 * */
		public static const CMD_NOTICE_PLAYER_ENTER_TO_SCENE:int = 1105;
		/**
		 * 通知其他玩家退出场景（主城） 
		 * */
		public static const CMD_NOTICE_OTHER_PLAYER_LEAVE_SCENE:int = 1106;
		
		public static const CMD_GET_OTHER_PLAYER_INFOS:int = 1107;
		
		/**
		 * 1108
		 * 获取玩家在主场景中的位置 
		 * */
		public static const GET_CITY_INFO:int = 1108;
		
		/**
		 * 1109
		 * 获取玩家在主城中已经通过的副本数
		 */
		public static const GET_MSG_IN_TURNING_POINT:int = 1109;
		/**
		 * 1303
		 * 丢弃物品
		 */
		public static const DISCARD_ITEM:int = 1303;
		
		/**
		 * 1110
		 * 拾取通关奖励
		 * */
		public static const GET_STAGE_CLEAR_REWARD:int = 1110;
		
		/**
		 * 1111
		 * 翻牌
		 * */
		public static const RANDOM_STAGE_CLEAR_REWARD:int = 1111;
		
		
		public static const CMD_NOTICE_WORLD_BOSS:int = 1119;
		
		public static const CMD_WORLD_BOSS_ENTER_SCENE:int = 1120;
		
		public static const CMD_NOTICE_WORLD_BOSS_CLOSE:int = 1122;
		
		public static const CMD_WORLD_BOSS_AFTER_FIGHT_CD_TIME:int = 1126;
		
		public static const CMD_WORLD_BOSS_LEAVE_SCENE:int = 1127;
		
		public static const CMD_WORLD_BOSS_GET_FIGHT_RANK:int = 1129;
		
		public static const CMD_NOTICE_WORLD_BOSS_REWARD_NORMAL:int = 1131;

		public static const CMD_NOTICE_WORLD_BOSS_REWARD_FINAL:int = 1132;

		public static const CMD_NOTICE_WORLD_BOSS_REWARD_RANK:int = 1133;
		
		public static const CMD_WORLD_BOSS_CD_TIME_SPEED_UP:int = 1145;

		public static const CMD_WORLD_BOSS_GET_PLAYER_NUMBER:int = 1146;
		
		
		public static const CMD_WORLD_BOSS_START_FIGHT:int = 1207;
		
		public static const CMD_WORLD_BOSS_INCREASE_ENERGY:int = 1208;
		
		public static const CMD_NOTICE_WORLD_BOSS_CURRENT_HP:int = 1209;
		
		
		
		
		/**
		 * 1700
		 * 购买商店物品
		 * */
		public static const BUY_ITEM:int = 1700;
		
		/**
		 * 1701
		 * 卖出物品
		 * */
		public static const SELL_ITEM:int = 1701;
		
		/**
		 * 1702
		 * 赎回物品
		 * */
		public static const REDEEM_ITEM:int = 1702;
		
		/**
		 * 1703
		 * 直接购买装备
		 * */
		public static const QUICK_BUY:int = 1703;
		
		/**
		 * 1704
		 * 获取神秘商品列表
		 * */
		public static const GET_MYTH_ITEM_LIST:int = 1704;
		
		/**
		 * 1705
		 * 购买神秘商品列表
		 * */
		public static const BUY_MYTH_ITEM:int = 1705;
		
		/**
		 * 1706
		 *刷新神秘商品列表
		 * */
		public static const REFRESH_MYTH_ITEM:int = 1706;
		
		/**
		 * 1709
		 * 卖出任务物品 
		 */
		public static const SELL_TASK_ITEM:int = 1709;
		
		/**
		 * 1800
		 *获取商店宠物列表
		 * */
		public static const GET_PET_LIST_IN_STORE:int = 1800;
		
		/**
		 * 1801
		 *购买宠物
		 * */
		public static const BUY_PET:int = 1801;
		
		/**
		 * 1804
		 *刷新宠物商店点物品
		 * */
		public static const REFRESH_PET_LIST_IN_STORE:int = 1804;
		
		/**
		 * 1124
		 * 副本是否通关
		 * */
		public static const CMD_COPY_IS_OVER:int = 1124;

		
		/**
		 * 1200
		 * 发起副本战
		 */
		public static const BEGIN_FIGHT:int = 1200;
		
		
		
		/**
		 * 1201
		 * 获得阵法信息 
		 */
		public static const GET_FORMATION_MSG:int = 1201;
		
		
		/**
		 * 1202
		 * 出阵 
		 */
		public static const PARTNER_LEAVE_FORMATION:int = 1202;
		
		/**
		 * 1203
		 * 交换阵法位置 
		 */
		public static const FORMATION_POSITION_CHANGE:int = 1203;
		
		
		/**
		 *  1204
		 *  入阵
		 */
		public static const PARTNER_COME_FORMATION:int = 1204;
		
		/**
		 * 1205
		 * 已激活阵法 
		 */
		public static const ACTIVATED_FORMATION:int = 1205;
		
		/**
		 * 1206
		 * 升级阵法 
		 */
		public static const PROMOTE_FORMATION:int = 1206;
		
		/**
		 * 3600
		 * 技能列表 
		 */
		public static const CMD_GET_SKILL_LIST:int = 3600;
		
		/**
		 * 选择技能
		 */		
		public static const CMD_SKILL_SELECT:int = 3601;
		/**
		 * 学习技能
		 */		
		public static const CMD_SKILL_LEARN:int = 3602;
		/**
		 * 获得指定玩家主角的技能 
		 */		
		public static const CMD_GET_PLAYER_LEAD_SKILL:int = 3603;
	
		

		/**
		 * 1300
		 * 获取包裹数据
		 */
		public static const GET_PACK_DATA:int = 1300;
		
		
		public static const CMD_SEND_WORLD_MESSAGE:int = 1400;
		public static const CMD_SEND_PLAYER_MESSAGE:int = 1401;
		public static const CMD_SEND_SCENE_MESSAGE:int = 1402;
		public static const CMD_NOTICE_GET_WORLD_TALK:int = 1403;
		public static const CMD_NOTICE_GET_PLAYER_TALK:int = 1404;
		public static const CMD_NOTICE_GET_SCENE_TALK:int = 1405;
		public static const CMD_GET_PLAYER_MESSAGE_RECORD:int = 1406;
		
		/**
		 * 1500
		 * 获得本人所有伙伴简要信息 
		 */
		public static const PLAYER_PARTNER_INFO:int = 1500;
		
		/**
		 * 1501
		 * 邀請夥伴 
		 */
		public static const INVITE_PARTNER:int =  1501 ;
		
		/**
		 * 1502
		 * 夥伴歸隊 
		 */
		public static const PARTNER_COMEBACK:int = 1502;
		
		/**
		 * 1503
		 * 伙伴离队 
		 */
		public static const PARTENR_LEAVE:int = 1503;
		
		/**
		 * 1505
		 * 获取其他玩家所有伙伴简要信息 
		 */
		public static const OTHERPLAYER_PARTNER_INFO:int = 1505;
		
		/**
		 * 1301
		 * 交换包裹物品
		 */
		public static const CHANGE_PACK_POSITION:int = 1301;
		/**
		 * 1600
		 * 获取装备栏信息
		 */
		public static const GET_ROLE_EQUIPS:int = 1600;
		/**
		 * 1601
		 * 卸载装备
		 */
		public static const TAKEOFF_EQUIP:int = 1601;
		/**
		 * 1602
		 * 换装
		 */
		public static const CHANGE_ROLE_EQUIP:int = 1602;
		
		
		/**
		 * 1603
		 * 强化装备 
		 */
		public static const EQUIP_STRENGTH:int = 1603;
		
		/**
		 * 1604
		 * 获得强化累计CD时间 
		 */
		public static const EQUIP_STRENGTH_CD:int = 1604;
		
		/**
		 * 1605 移除一件装备
		 */
		public static const REMOVE_EQUIP_BYROLEID:int = 1605;
		/**
		 * 1606 获得一件装备
		 */
		public static const CMD_NOTICE_GET_EQUIP_BYROLEID:int = 1606;
		
		/**
		 * 1607 获得角色装备
		 */
		public static const CMD_GET_PLAYER_EQUIP:int = 1607;
		
		
		
		/**
		 *1609
		 * 其它玩家装备更新 
		 */		
		public static const CMD_NOTICE_OTHER_PLAYER_UPDATE_EQUIP:int = 1609;
		
		/**
		 * 1610
		 * 装备晋升（从装备栏触发） 
		 */
		public static const EQUIP_PROMOTE_FROM_PANEL:int = 1610;
		
		/**
		 * 1612 
		 * VIP装备晋升（从装备栏触发） 
		 */
		public static const EQUIP_VIP_PROMOTE_FORM_PANEL:int = 1612;
		
		/**
		 * 1615 
		 * 清除强化CD 
		 */
		public static const CLEAN_CD_TIME:int = 1615
		
		/**
		 * 1703
		 * 直接购买装备 
		 */
		public static const EASY_BUY_EQUIP:int = 1703;
		
		/**
		 * 1304 背包物品数量更新
		 */
		public static const CMD_NOTICE_PACK_DATA_UPDATE:int = 1304;
		/**
		 * 1305
		 * 后端推送 得到一件物品
		 */
		public static const CMD_NOTICE_PACK_GET_GOODS:int = 1305;
		/** 
		 * 1306
		 * 扩充背包
		*/
		public static const UNLOCK_PACK:int = 1306;
	
		/**
		 * 3000 获得已接任务列表
		 */
		public static const GET_HAS_TASK_LIST:int = 3000;
		/**
		 * 3001 获得可接任务列表
		 */
		public static const GET_CAN_TAKE_TASK_LIST:int = 3001;
		/**
		 * 3002 接任务
		 */
		public static const TAKE_TASK:int = 3002;
		/**
		 * 3003 交任务
		 */
		public static const PAY_TASK:int = 3003;
		
		/**
		 * 3100
		 * 使用坐骑 
		 */
		public static const USE_MOUNT:int = 3100;
		
		/**
		 * 3101
		 * 获得玩家使用的坐骑数据ID
		 */
		public static const GET_PLAYER_MOUNT:int = 3101;
		
		/**
		 * 3102
		 * 通知玩家坐骑数据变动 
		 */
		public static const CMD_NOTICE_PLAYER_MOUNT_CHANGE:int = 3102;
		
		/**
		 * 取消坐骑 
		 */
		public static const TAKE_OFF_MOUNT:int = 3103
		
		/**
		 * 2000 使用背包物品
		 */
		public static const USE_PACK_ITEM:int = 2000;
		/**
		 * 1116 玩家完成的最高级城市以及副本
		 */ 	
		public static const CMD_USER_MAX_CITY_LEVEL:int = 1116;
		
		/**
		 * 修炼的技能列表
		 * */
		public static const GET_ROLE_PROPERTY_LIST:int = 1900;
		
		/**
		 * 修炼
		 * */
		public static const ROLE_MYTH_SKILL_UPGRADE:int = 1901;
		/**
		 * 1802获取宠物背包
		 * */
		public static const GET_PET_PACK_CMD:int = 1802;
		/**
		 * 1803交换宠物背包中宠物位置
		 * */
		public static const SWAP_PET_PACK_POS:int = 1803;
		/**
		 * 1805 合并宠物
		 * */
		public static const MERGE_PET:int = 1805;
		
		public static const CMD_REQUEST_PET_FOLLOW:int = 1808;
		
		public static const CMD_GET_FOLLOW_PET:int = 1809;
		
		public static const CMD_GET_OTHER_PLAYER_FOLLOW_PET:int = 1810;
		
		public static const CMD_NOTICE_FOLLOW_PET_CHANGE:int = 1811;
		
		public static const CMD_REMOVE_PET_FOLLOW:int = 1812;
		/**
		 * 获取未确认的修身值
		 * */
		public static const GET_UNAPPROVED_PROPERTIES:int = 3200;
		
		/**
		 * 请求修身
		 * */
		public static const RANDOM_PROPERTIES:int = 3201;
		
		/**
		 * 确认修身
		 * */
		public static const APPROVE_RANDOM_PROPERTIES:int = 3202;
			
		/**
		 * 取消修身
		 * */
		public static const REJECT_RANDOM_PROPERTIES:int = 3203;
		/**
		 * 获得修身值
		 * */
		public static const GET_RANDOM_PROPERTIES:int = 3204;
		
		
		/**
		 * 3300 摇一摇 
		 */
		public static const MONEY_TREE:int = 3300;
		
		/**
		 *  3301 获得摇钱树剩余次数
		 */
		public static const MONEY_TREE_RESIDUE_DEGREE :int = 3301;
		
		
		
		
		/**
		 * 请求打坐 3404
		 * */
		public static const BEGIN_SITTING:int = 3404;
		/**
		 * 3405 取消打坐
		 * */
		public static const END_SITTING:int = 3405;
		/**
		 * 3406 结算打坐
		 * */
		public static const GET_SITTING_REWARD:int = 3406;
		
		/* zhangxin 二期请求 start */
		/**
		 * 2500
		 * 添加好友（按ID）
		 * */
		public static const ADD_FRIEND_BY_ID:int = 2500;
		
		/**
		 * 2501
		 * 添加好友（按名称）
		 * */
		public static const ADD_FRIEND_BY_NAME:int = 2501;
		
		/**
		 * 2502
		 * 移除好友
		 * */
		public static const REMOVE_FREIEND:int = 2502;
		
		/**
		 * 2503
		 * 获得好友列表
		 * */
		public static const GET_FRIEND_LIST:int = 2503;
		
		/**
		 * 2600
		 * 添加黑名单（按ID）
		 * */
		public static const ADD_TO_BLACK_LIST_BY_ID:int = 2600;
		
		/**
		 * 2601
		 * 添加黑名单（按名称）
		 * */
		public static const ADD_TO_BLACK_LIST_BY_NAME:int = 2601;
		
		/**
		 * 2602
		 * 移除黑名单
		 * */
		public static const REMOVE_FROM_BLACK_LIST:int = 2602;
		
		/**
		 * 2603
		 * 获得黑名单列表
		 * */
		public static const GET_BLACK_LIST:int = 2603;
		
		/**
		 * 2604
		 * 获得临时联系人列表
		 * */
		public static const GET_TEMP_PLAYER_LIST:int = 2604;
		
		/**
		 * 2605
		 * 设置消息已读
		 * */
		public static const SET_ALREADY_READ:int = 2605;
		
		/**
		 * 3700 
		 * 玩家在竞技场中的排名
		 * */
		public static const RANK_IN_ARENA:int = 3700;
		
		/**
		 * 3701
		 * 可以挑战的竞技场玩家列表
		 * */
		public static const CHALLENGING_LIST:int = 3701;
		
		/**
		 * 3702
		 * 挑战竞技场玩家
		 * */
		public static const CHALLENGE_A_PLAYER:int = 3702;
		
		/**
		 * 3703
		 * 剩余挑战次数与下次挑战时间
		 * */
		public static const TIMES_REMAIN_AND_NEXT_TIME:int = 3703;
		
		/**
		 * 3704
		 * 玩家竞技场挑战记录
		 * */
		public static const CHALLENGE_RECORD:int = 3704;
		
		/**
		 * 3705
		 * 被挑战通知
		 * */
		public static const CHALLENED_NOTICE:int = 3705;
		
		/**
		 * 3706
		 * 连胜通知
		 * */
		public static const COMBO_VICTORY_NOTICE:int = 3706;
		
		/**
		 * 3707
		 * 购买挑战次数
		 * */
		public static const BUY_CHALLENGE_TIMNES:int = 3707;
		
		/**
		 * 3708
		 * 获取排名奖励信息
		 * */
		public static const GET_RANK_REWARD_DATA:int = 3708;
		
		/**
		 * 3709
		 * 领取奖励
		 * */
		public static const GET_CHALLENGE_REWARD:int = 3709;
		/**
		 * 3710
		 * 其他玩家在竞技场中的排名
		 * */
		public static const GET_OTHER_RANK_IN_ARENA:int = 3710;
		
		/**
		 * 3711
		 * 获取已经购买的挑战次数
		 * */
		public static const CHALLENGE_TIMES_ALREADY_BOUGHT:int = 3711;
		
		
		
		/**
		 * 3800
		 * 寻宝 
		 */
		public static const TREASURE_HUNT:int = 3800;
		
		/**
		 * 3801
		 * 拾取法宝 
		 */
		public static const PICKUP_TALISMAN:int = 3801;
		
		/**
		 * 3802
		 * 移动（合成）法宝位置（仅在法宝背包中）
		 */
		public static const MOVE_TALISMAN_POSITION_PACKAGE_ONLY:int = 3802;
		
		/**
		 * 3803 
		 * 移动（合成）法宝位置（从法宝背包移到角色法宝栏） 
		 */
		public static const MOVE_TALISMAN_POSITION_PACKAGE_TO_ROLE:int = 3803;
		
		
		/**
		 * 3804 
		 * 移动（合成）法宝位置（从角色法宝栏移到法宝背包） 
		 */
		public static const MOVE_TALISMAN_POSITION_ROLE_TO_PACKAGE:int = 3804;
		
		
		/**
		 * 3805 
		 * 移动（合成）法宝位置（仅在角色法宝栏中） 
		 */
		public static const MOVE_TALISMAN_POSITION_ROLE_ONLY:int = 3805;
		
		/**
		 * 3806 
		 * 获取寻宝结果背包 
		 */
		public static const GET_TREASURE_RESULT_PACKAGE:int = 3806;
		
		
		/**
		 * 3807 
		 * 获取法宝背包 
		 */
		public static const GET_TALISMAN_PACKAGE:int = 3807;
		
		
		/**
		 * 3808 
		 * 获取角色法宝栏 
		 */
		public static const GET_ROLE_TALISMAN:int = 3808;
		
		/**
		 * 3809 
		 * 获取秘境状态 
		 */
		public static const GET_MISTERIOSO_STATE:int =3809;
		
		/**
		 * 3810
		 * 获取其他玩家指定的角色法宝栏 
		 */
		public static const GET_OTHERS_ROLE_TALISMAN:int = 3810;
		
		
		/**
		 * 3811 
		 * 兑换法宝 
		 */
		public static const EXCHANGE_TALISMAN:int = 3811;
		
		
		/**
		 * 3812 
		 * 扩充法宝背包 
		 */
		public static const ENLARGE_TALISMAN_PACKAGE:int = 3812;
		
		/**
		 * 3813 
		 * 兑换经验 
		 */
		public static const EXCHANGE_EXP:int = 3813;
		
		/**
		 *  3814 
		 * 灌注经验（在法宝背包中）
		 */
		public static const PERFUSION_EXPERIENCE_IN_PACKAGE:int =3814;
		
		/**
		 * 3815 
		 * 灌注经验（在角色法宝栏中） 
		 */
		public static const PERFUSION_EXPERIENCE_IN_ROLE:int = 3815;
		
		/**
		 * 3816 
		 * 获得碎片数量 
		 */
		public static const GET_TALISMAN_FRAGMENT_QUANTITY:int = 3816;
		
		/**
		 * 3817 
		 * 获得灌注经验数量 
		 */
		public static const GET_PERFUSION_EXPERIENCE_QUANTITY:int = 3817;
		
		
		/**
		 * 3818 
		 * 直接点亮秘境 
		 */
		public static const LIGHTS_MISTERIOSO:int = 3818;
		
		/**
		 * 3819
		 * 获得当天直接点亮秘境的剩余次数 
		 */
		public static const GET_REMAINING_NUMBER_OF_MISTERIOSO:int = 3819;
		
		
		
		/**
		 * 4100 请求主人
		 * */
		public static const REQUEST_MASTER:int = 4100;
		
		/**
		 * 4101 请求奴隶列表
		 * */
		public static const REQUEST_SLAVES:int = 4101;
		
		/**
		 * 4102 请求手下败将列表
		 * */
		public static const GET_DEFEATED_PLAYERS:int = 4102;
		
		/**
		 * 4103 请求夺奴之敌列表
		 * */
		public static const GET_SLAVE_SNATCHER_LIST:int = 4103;
		
		/**
		 * 4104 请求解救好友列表
		 * */
		public static const GET_FRIEND_RESCUER_LIST:int = 4104;
		
		/**
		 * 4105 请求求救好友列表
		 * */
		public static const GET_RESCUE_SEEKER_LIST:int = 4105;
		
		/**
		 * 4106 请求其他信息列表
		 * */
		public static const GET_OTHER_INFO_LIST:int = 4106;
		
		/**
		 * 4107 抓取奴隶
		 * */
		public static const GRAB_A_SLAVE:int = 4107;
		
		/**
		 * 4108 解救好友
		 * */
		public static const RESCUE_A_FRIEND:int = 4108;
		
		/**
		 * 4109 反抗主人
		 * */
		public static const REBEL:int = 4109;
		
		/**
		 * 4110 释放奴隶
		 * */
		public static const SET_SLAVE_FREE:int = 4110;
		
		/**
		 * 4111 调教奴隶
		 * */
		public static const BULLY_SLAVE:int = 4111;
		
		/**
		 * 4112 讨好主人
		 * */
		public static const RUB_MASTER:int = 4112;
		
		/**
		 * 4113 请求解救
		 * */
		public static const ASK_FOR_RESCUE:int = 4113;
		
		/**
		 * 4114 复仇敌人
		 * */
		public static const REVANGE:int = 4114;
		
		/**
		 * 3900
		 * 等级排行 
		 */
		public static const LEVEL_TOP:int = 3900 ;
		
		/**
		 * 3901
		 * 声望排行 
		 */
		public static const REPUTION_TOP:int = 3901;
		
		/**
		 * 3902
		 * 战斗力排行 
		 */
		public static const FIGHTING_CAPACITY_TOP:int = 3902;
		
		/**
		 * 3903
		 * 竞技场排行 
		 */
		public static const ARENA_TOP:int = 3903;

		
		/**
		 * 4200 
		 * 飞跃 
		 */
		public static const TRAIN_LEAP:int = 4200;
		
		/**
		 * 4201
		 * 开始训练 
		 */
		public static const TRAIN_START:int = 4201;
		
		/**
		 * 4202
		 * 终止训练 
		 */
		public static const TRAIN_STOP:int = 4202;
		
		/**
		 * 4203
		 * 清除训练CD 
		 */
		public static const TRAIN_CLEAN_CD:int = 4203;
		
		/**
		 * 4204
		 * 开启训练室 
		 */
		public static const TRAIN_OPEN:int = 4204;
		
		/**
		 * 4205
		 * 请求训练室信息 
		 */
		public static const TRAIN_INFOMATION:int = 4205;
		/**
		 * 4206
		 * 请求训练室已开启房间
		 */
		public static const TRAIN_OPENED_ROOM:int = 4206;

		/**
		 * 1140
		 * 离线扫荡开始
		 */
		public static const START_WIPE_OUT:int = 1140;
		
		/**
		 * 1141
		 * 离线扫荡结算（获取结果）
		 */
		public static const GET_WIPE_OUT_REWARD:int = 1141;
		
		/**
		 * 1142
		 * 离线扫荡加速
		 */
		public static const WIPE_ACCELERATE:int = 1142;
		
		/**
		 * 1144
		 * 离线扫荡结束
		 */
		public static const END_WIPE:int = 1144;
		
		/**
		 * 1117
		 * 根据城市ID获取城市精英副本列表
		 * */
		public static const ELITE_OPEN_LIST:int = 1117;
		
		/**
		 * 1121 
		 * 当天副本通关记录
		 * */
		public static const TODAY_CLEAR_RECORD:int = 1121;
		
		/**
		 * 1123 
		 * 重置精英副本
		 * */
		public static const RESET_ELITE_STATUS:int = 1123;
		
		/**
		 * 1130 
		 * 获取重置精英副本总次数
		 * */
		public static const TOTAL_ELITE_RESET_TIMES:int = 1130;
		
		/**
		 * 4000 
		 * 祭拜
		 * */
		public static const DONATE:int = 4000;
		
		/**
		 * 1018
		 * 根据玩家的UUID来获取玩家信息
		 * */
		public static const GET_USER_INFO_BY_UUID:int = 1018;
		
		/**
		 * 1308 
		 * 拆分背包物品 
		 */
		public static const SPLIT_PACK_DATA:int = 1308;
		
		/**
		 * 1310  
		 * 获取任务背包数据
		 */
		public static const GET_TASK_PACK_DATA:int = 1310;
		
		/**
		 * 1311
		 * 交换任务背包物品位置 
		 */
		public static const CHANGE_TASK_PACK_POSITION:int = 1311;
		
		
		/**
		 * 1312
		 * 合并任务背包 
		 */
		public static const MERGE_TASK_PACK_DATA:int = 1312;
		
		/**
		 * 1313
		 *  任务背包物品数量更新
		 */
		public static const CMD_NOTICE_TASK_PACK_DATA_UPDATE:int = 1313;
		
		
		/**
		 * 1314 
		 * 获得任务物品
		 */
		public static const CMD_NOTICE_TASK_PACK_GET_GOODS:int = 1314;
		
		/**
		 * 1315
		 * 拆分任务背包物品 
		 */
		public static const SPLIT_TASK_PACK_DATA:int = 1315;
		
		/**
		 * 3005
		 * 是否屏蔽低等级任务 
		 */
		public static const IF_HIDE_LOW_TASK:int = 3005;
		
		/**
		 * 3006
		 * 设置是否屏蔽低等级任务 
		 */
		public static const SET_IF_HIDE_LOW_TASK:int = 3006;
		
		/**
		 * 3007
		 *  获得需要从任务栏里屏蔽的任务列表 
		 */
		public static const HIDE_TASK_LIST:int = 3007;
		
		/**
		 * 3008
		 * 设置一个任务是否需要显示在任务栏里 
		 */
		public static const SET_IS_HIDE_TASK:int = 3008;
		
		/**
		 *  3009 
		 * 放弃任务
		 */
		public static const ABANDON_TASK:int = 3009;
		
		
		/* zhangxin 二期请求 end */
		public function ConstGameNetCmd()
		{
		}
	}
}