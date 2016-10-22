package framework.game
{
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLocal;
	import com.ui.iface.MouseManager;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFlowCode;
	import com.ui.util.CFontUtil;
	
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.model.DataManager;
	import framework.model.LoadStrategyProxy;
	import framework.resource.faxb.award.MatchAwards;
	import framework.resource.faxb.elements.Elements;
	import framework.resource.faxb.functionopen.FunctionList;
	import framework.resource.faxb.items.Items;
	import framework.resource.faxb.levelproperty.LevelProperties;
	import framework.resource.faxb.levels.Levels;
	import framework.resource.faxb.notice.NoticeList;
	import framework.resource.faxb.onlineActivity.Activitys;
	import framework.resource.faxb.sceneui.SceneConfig;
	import framework.resource.faxb.score.Scores;
	import framework.resource.faxb.starreward.StarReward;
	import framework.resource.faxb.tutorial.Tutorial;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.sound.ConstantSound;
	import framework.sound.SoundHandler;
	import framework.tutorial.TutorialManagerProxy;
	import framework.util.FAXB_TEST;
	import framework.util.cacher.BackgroundTaskManager;
	import framework.util.rsv.Rsv;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	public class InitState
	{
		public static const KEY_RPCPROXY:String = "KEY_RPCPROXY";
		public static const KEY_STATIC_RES:String = "KEY_STATIC_RES";
		public static const KEY_LOAD_QUEST:String = "KEY_LOAD_QUEST";
		public static const KEY_GET_FRIENDS_FROM_SERVER:String = "KEY_GET_FRIENDS_FROM_SERVER";
		public static const KEY_INIT_GAMEDATA:String = "KEY_INIT_SCENE";
		public static const KEY_GET_USERINFO:String = "KEY_GET_USERINFO";
		public static const KEY_GET_USERPETPACK:String = "KEY_GET_USERPETPACK";
		public static const KEY_GET_SKILL_LIST:String = "KEY_GET_SKILL_LIST";
		public static const KEY_GET_MAIN_FUNCTION:String = "KEY_GET_MAIN_FUNCTION";
		public static const KEY_LOGIN_IN_SERVER_SUCCESS:String = "KEY_LOGIN_IN_SERVER_SUCCESS";
		
		
		private static var states:Object = {};
		private static var soundMap:Vector.<String>;
		
		private static const ID:int = 0;
		private static const CONDITION:int = 1;
		private static const CALLBACK:int = 2;
		private static const ID_CALLED:int = 3;


		private static const CALL_BACKS:Array = 
			[
				[0, [KEY_STATIC_RES], initGameData, false],
				[1, [KEY_STATIC_RES ,KEY_RPCPROXY,KEY_INIT_GAMEDATA], enterGame, false],
				[2 ,[KEY_RPCPROXY] ,enterGame , true ]
			];
		
		public function InitState()
		{
			
		}
		
		private static function initActorProperty():void
		{
			
		}
		
		public static function isFinish(key:String):Boolean
		{
			if(states[key] == undefined)
				return false;
			return states[key]
		}
		
		public static function recordFinish(key:String):void
		{
			CONFIG::debug
			{
				TRACE_LOADING(key + " finished " + getTimer());
			}
			states[key] = true;
			handle();
		}
		
		CONFIG::debug
		{
			public static function getState():Object
			{
				return states;
			}
		}
		
		public static function initUser():void
		{

		}
		
		private static function initRpc():void
		{

		}
		
		private static function initModelResource():void
		{
			CONFIG::debug
			{
				TRACE_LOADING("initModelResource " + getTimer());
			}
			
		}
		
		public static function getSoundMap():Vector.<String>
		{
			return soundMap;
		}
		
		private static function initGameData():void		
		{
			BackgroundTaskManager.startBackgroundCaching();
			var xml:XML;		
			
			__initCursor();
			
			LoadStrategyProxy.inst.startLoadSecondStuffGroupInBackground();
			
			DataUtil.instance.configDecodeStartTime = new Date().getTime();
			
			xml = Rsv.getFile_s("file_elements").xml;
			DataManager.getInstance().elements = FAXB_TEST.unmarshal(xml, getQualifiedClassName(Elements));

			xml = Rsv.getFile_s("file_levelproperty").xml;
			DataManager.getInstance().levelproperty = FAXB_TEST.unmarshal(xml, getQualifiedClassName(LevelProperties));
			
			xml = Rsv.getFile_s("file_score").xml;
			DataManager.getInstance().scoreData = FAXB_TEST.unmarshal(xml, getQualifiedClassName(Scores));
			
			xml = Rsv.getFile_s("file_config_sceneui").xml;
			DataManager.getInstance().sceneConfig = FAXB_TEST.unmarshal(xml, getQualifiedClassName(SceneConfig));
			
			xml = Rsv.getFile_s("file_award").xml;
			DataManager.getInstance().matchAwards = FAXB_TEST.unmarshal(xml, getQualifiedClassName(MatchAwards));
			
			xml = Rsv.getFile_s("file_levels").xml;
			DataManager.getInstance().levels = FAXB_TEST.unmarshal(xml, getQualifiedClassName(Levels));
			
			xml = Rsv.getFile_s("file_items").xml;
			DataManager.getInstance().items = FAXB_TEST.unmarshal(xml, getQualifiedClassName(Items));
			
			xml = Rsv.getFile_s("file_tutorial").xml;
			DataManager.getInstance().tutorialData = FAXB_TEST.unmarshal(xml, getQualifiedClassName(Tutorial));
			
			xml = Rsv.getFile_s("file_starreward").xml;
			DataManager.getInstance().starRewards = FAXB_TEST.unmarshal(xml, getQualifiedClassName(StarReward));
			
			xml = Rsv.getFile_s("file_onlineActivity").xml;
			DataManager.getInstance().activitys = FAXB_TEST.unmarshal(xml, getQualifiedClassName(Activitys));
			
			xml = Rsv.getFile_s("file_functionopen").xml;
			DataManager.getInstance().functionList = FAXB_TEST.unmarshal(xml, getQualifiedClassName(FunctionList));
			
			xml = Rsv.getFile_s("file_notice").xml;
			DataManager.getInstance().noticeList = FAXB_TEST.unmarshal(xml, getQualifiedClassName(NoticeList));
			
			TutorialManagerProxy.inst.setTutorialData(DataManager.getInstance().tutorialData);
			
			//注册字体
			CFontUtil.registerFont();
			
			DataUtil.instance.isResReadey = true;
			
			DataUtil.instance.configDecodeEndTime = new Date().getTime();
			
			TRACE("解析配置共耗时 : " + (DataUtil.instance.configDecodeEndTime - DataUtil.instance.configDecodeStartTime) / 1000+"s" , "time");
			
			recordFinish(KEY_INIT_GAMEDATA);
			
			CFlowCode.showWarning();
			
			CFlowCode.showPop();
		}
		
		private static function __initCursor():void
		{
			MouseManager.instance.initAfterLoad();
		}
		
		private static function setSoundStatus():void
		{
			SoundHandler.instance.setMusicStatus(CDataManager.getInstance().dataOfLocal.getKey(CDataOfLocal.LOCAL_KEY_MUSIC_WORLD) != 1);
			SoundHandler.instance.setSoundStatus(CDataManager.getInstance().dataOfLocal.getKey(CDataOfLocal.LOCAL_KEY_MUSIC_EFFECT) != 1);
			
			SoundHandler.instance.playBackgroundMusic(ConstantSound.MUSIC_MENU);
		}
		
		private static function enterGame():void
		{
			setSoundStatus();
			
			//初始化功能点入口数据
			CDataManager.getInstance().dataOfFunctionList.init();
			
			//退出游戏
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.USER_INFO_PANEL));
			CBaseUtil.sendEvent(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
			CBaseUtil.sendEvent(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_TUTORIAL));
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_NOTICE));
			
			//请求好友数据
			if(Debug.ISONLINE)
			{				
				NetworkManager.instance.sendServerGetFriendList();
			}
			
			
			DataUtil.instance.isExitGame = false;
			
			CBaseUtil.hideLoading();
		}
		
		public static function desposeMapBackGroundHandle():void
		{
		}
		public static function handle():void
		{
			for(var i:int = 0 ; i < CALL_BACKS.length ; i++)
			{
				var entry:Array = CALL_BACKS[i];
				if(entry[ID_CALLED] == false)
				{
					var allfit:Boolean = true;
					for(var j:int = 0 ; j < entry[CONDITION].length ; j++)
					{
						if(!isFinish(entry[CONDITION][j]))
						{
							allfit = false;
							break;
						}
					}
					
					if(allfit)
					{
						entry[ID_CALLED] = true;
						entry[CALLBACK]();
					}
				}
			}
		}
		
		/**
		 * 重连执行
		 */
		public static function onReconnectReset():void
		{
			CALL_BACKS[2][3] = false;
		}
	}
}