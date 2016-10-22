package framework.ui
{
	import com.game.consts.ConstGlobalConfig;
	import com.game.consts.ConstTaskType;
	import com.game.event.GameEvent;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLocal;
	import com.game.module.task.CTaskChecker;
	import com.games.candycrush.ItemType;
	import com.games.candycrush.board.Board;
	import com.games.candycrush.board.IItemListener;
	import com.games.candycrush.board.Item;
	import com.games.candycrush.board.match.OrthoPatternMatcher;
	import com.games.candycrush.input.SwapInfo;
	import com.games.candycrush.input.Swapper;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Linear;
	import com.input.MouseInput;
	import com.math.Vec2;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItem321Go;
	import com.ui.item.CItemAbstract;
	import com.ui.item.CItemMatchTaskPanel;
	import com.ui.item.CItemRightItemList;
	import com.ui.item.CItemScoreCub;
	import com.ui.item.CItemStartAnimate;
	import com.ui.item.CItemTaskPanel;
	import com.ui.util.CBaseUtil;
	import com.ui.widget.CWidgetAniNumber;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import framework.datagram.Datagram;
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewChooseLevel;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.model.ConstantItem;
	import framework.model.DataManager;
	import framework.model.DataRecorder;
	import framework.model.SwapLogicProxy;
	import framework.model.objects.BasicObject;
	import framework.model.objects.GridObject;
	import framework.model.objects.LevelData;
	import framework.resource.faxb.levels.Basic;
	import framework.resource.faxb.levels.Grid;
	import framework.resource.faxb.levels.Level;
	import framework.resource.faxb.levels.Levels;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.sound.ConstantSound;
	import framework.sound.MediatorAudio;
	import framework.sound.SoundHandler;
	import framework.tutorial.TutorialManagerProxy;
	import framework.util.DisplayUtil;
	import framework.util.ResHandler;
	import framework.util.playControl.PlayMovieClipToEndAndDestroy;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	public class MediatorPanelMainUI extends MediatorBase implements IItemListener
	{
		public static const MAX_LINE_NUMBER:int = 9;
		public static const GRID_WIDHT:int = 65;
		public static const GRID_HEIGHT:int = 65;
		
		private static const LINE_PRE:String = "mcLine";
		private static const COL_PRE:String = "m";
		private static const POS_GRID:String = "posGrid";
		private static const MC_GRID:String = "mcGrid";		
		
		private static const POS_BTN:String = "btnpos";
		private static const POS_STEP:String = "posStep";
		private static const POS_SCORE:String = "posScoreNum";
		private static const GRID_POS_TOP:String = "posTop";
		private static const GRID_POS_MIDDLE:String = "pos";
		private static const GRID_POS_BOTTOM:String = "posBg";
		private static const GRID_POS_OBSTACLE:String = "posObstacle";
		
		private static const TEXT_NUM:String = "text_num";
		
		private var _currentSelectedGrid:BasicObject;
		
		private var _currentLevelGridData:LevelData;
		private var _selectedAnimationLayer:Sprite;
		private var _hintAnimationLayer:Sprite;
		private var _moveMiddleLayer:Sprite;
		private var _moveTopLayer:Sprite;
		private var _bottomBtnLayer:Sprite;
		private var _animationLayer:Sprite;
		
		private var _collectBoxLayer:Sprite;
		
		private var _closeBtn:CButtonCommon;
		private var _replayBtn:CButtonCommon;
		private var _bgMusicBtn:CButtonCommon;
		private var _soundBtn:CButtonCommon;
		private var _settingBtn:CButtonCommon;
		
		private var _rankBtn:CButtonCommon;
		
		private var _isShowSetting:Boolean = false;
		
		private var _scoreProgress:CItemScoreCub;
		private var _taskPanel:CItemAbstract;
		
		private var _startAnimItem:CItemStartAnimate;
		
		private var _aniStartY:Number = -300;
		public static var _animationSeleted:Vector.<int>;
		
		private var _rightItemList:CItemRightItemList;
		
		private var _numFrames:Array;
		
		private var _posList:Array;
		
		private var _currentLevelOriginData:Level;
		
		private var _animationManager:AnimationManager;
		
		private var _extension:MediatorExMainUI;
		
		public function MediatorPanelMainUI()
		{
			super(ConstantUI.WORLD_GAME_MAIN, ConstantUI.WORLD_GAME_MAIN, false);
			
			_extension = addExtention(new MediatorExMainUI(this)) as MediatorExMainUI;
		}
		
		private function refreshMcGrid():void
		{
			_collectBoxLayer.x = mc[MC_GRID]/*[POS_GRID]*/.x;
			_collectBoxLayer.y = mc[MC_GRID]/*[POS_GRID]*/.y;
			
			_moveMiddleLayer.x = mc[MC_GRID]/*[POS_GRID]*/.x;
			_moveMiddleLayer.y = mc[MC_GRID]/*[POS_GRID]*/.y;
			
			_moveTopLayer.x = mc[MC_GRID]/*[POS_GRID]*/.x;
			_moveTopLayer.y = mc[MC_GRID]/*[POS_GRID]*/.y;
			
			_animationLayer.x = mc[MC_GRID]/*[POS_GRID]*/.x;
			_animationLayer.y = mc[MC_GRID]/*[POS_GRID]*/.y;
		}
		
		override protected function start(d:DatagramView):void
		{
			SoundHandler.instance.playBackgroundMusic(ConstantSound.MUSIC_BACKGROUND);
	
			_animationManager = new AnimationManager();
			
			_selectedAnimationLayer = new Sprite();
			_selectedAnimationLayer.mouseChildren = false;
			_selectedAnimationLayer.mouseEnabled = false;
			mc.addChild(_selectedAnimationLayer);
			
			_collectBoxLayer = new Sprite();
			mc.addChild(_collectBoxLayer);
		
			_moveMiddleLayer = new Sprite();
			mc.addChild(_moveMiddleLayer);
						
			_moveTopLayer = new Sprite();
			mc.addChild(_moveTopLayer);
			
			_hintAnimationLayer = new Sprite();
			_hintAnimationLayer.mouseChildren = false;
			_hintAnimationLayer.mouseEnabled = false;
			mc.addChild(_hintAnimationLayer);
			
			_rankBtn = new CButtonCommon("z_n96_yingxiongbang");
			_rankBtn.x = 935;
			_rankBtn.y = 20;
			mc.addChild(_rankBtn);
			
			_animationLayer = new Sprite();
			mc.addChild(_animationLayer);
			
			_moveMiddleLayer.scrollRect = new Rectangle(0,0, MAX_LINE_NUMBER * GRID_WIDHT, MAX_LINE_NUMBER * GRID_HEIGHT);
	
			_bottomBtnLayer = new Sprite();
			_bottomBtnLayer.x = mc[POS_BTN].x;
			_bottomBtnLayer.y = mc[POS_BTN].y;
			mc.addChild(_bottomBtnLayer);
			
			_mouse = new MouseInput();
			_swapper = new Swapper();
			_swapLogic = SwapLogicProxy.inst;
			_swapLogic.init();
			
			if(NetworkManager.instance.isMatching)
			{
				NetworkManager.instance.status = NetworkManager.STATUS_MATCH;
				_rankBtn.visible = true;
			}else
			{
				NetworkManager.instance.status = NetworkManager.STATUS_LV;
				_rankBtn.visible = false;
			}
			
			_numFrames = CBaseUtil.getFramesByBmp("bmd.score", new Point(20, 19), 10);
			
			_posList = new Array();
			
			initUI();
			
			_startAnimItem = new CItemStartAnimate();
			mc.addChild(_startAnimItem);
			_startAnimItem.x = (ConstantUI.currentScreenWidth -_startAnimItem.width) / 2 ;
			_startAnimItem.y = _aniStartY;
			
			setMouseEnable(false);
			SwapLogicProxy.inst.setPause(true);
			TweenLite.to(_startAnimItem , 1 , {y:(ConstantUI.currentScreenHeight - _startAnimItem.height) / 2 , onComplete:__onAniComplete});
			
			initListener();
			
			if(Debug.ISONLINE)
			{
				WebJSManager.setPropValue(1);
				
				registerObserver(GameNotification.EVENT_GAME_START , __onStartGame);
				registerObserver(GameNotification.EVENT_GAME_OVER, __onGameOver);	
				registerObserver(GameNotification.EVENT_START_CACULATE_FINISH, onFinishLevelCaculate);	
				
				registerObserver(GameNotification.EVENT_STOP_TASK, stopTask);	
				registerObserver(GameNotification.EVENT_GAME_REMOVE_GIFT, __playAni);	
				
				registerObserver(GameNotification.EVENT_USE_ITEM, onUseItem);
				
				CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_SYSTEM_TIPS);
			}
			registerObserver(GameNotification.EVENT_SCORE_ANI, playScoreAnimation);	
			
			registerObserver(GameEvent.EVENT_REMOVE_ANIMATION_ITEM, removeAnimation);
		}
		
		private function __playAni(d:Notification):void
		{
			var giftItem:Item = d.data.item;
			
			var giftItemPos:Point = transGridPostionToStage(new Point(giftItem.x , giftItem.y));
			
			var dstX:Number = giftItemPos.x;
			var dstY:Number = giftItemPos.y;
			var cls:Class = ResHandler.getClass("common.tool.img");
			var item:MovieClip = new cls();
			var frame:int = CBaseUtil.getToolIconFrameByToolId(DataUtil.instance.giftId);
			item.gotoAndStop(frame);
			item.x = dstX;
			item.y = dstY;
			_animationLayer.addChild(item);
			
			var toolPos:Point = _rightItemList.getPosById(DataUtil.instance.giftId);
			var targetPos:Point = _animationLayer.globalToLocal(  _rightItemList.localToGlobal( toolPos ) );
			
			TweenLite.to(item , 1 , {x:targetPos.x -10 , y:targetPos.y - 10 , alpha:0.2 , ease:Cubic.easeInOut, onComplete: __onFlyComplete} );
			
			function __onFlyComplete():void
			{
				_animationLayer.removeChild(item);
				CBaseUtil.sendEvent(GameNotification.EVENT_GAME_REMOVE_GIFT_COMPLETE);
			}
		}
		
		private var _boatAnimation:MovieClip;
		public function playBoatAnimation(dstX:int, dstY:int, callBack:Function):void
		{
			if(_boatAnimation == null)
			{
				_boatAnimation = ResHandler.getMcFirstLoad("boatHat");
				_boatAnimation.x = GRID_WIDHT * 12;
				_boatAnimation.y = GRID_HEIGHT * (0 - _currentLevelOriginData.startLine);
				_animationLayer.addChild(_boatAnimation);
			}
			var dstXD:Number = dstX * GRID_WIDHT + GRID_WIDHT/2;
//			var dstYD:Number = dstY * GRID_HEIGHT;
			
			if(dstXD < _boatAnimation.x)
			{
				_boatAnimation.scaleX = 1;
			}
			else if(dstXD > _boatAnimation.x)
			{
				_boatAnimation.scaleX = -1;
			}
			else
			{
				
			}
			var lite:TweenLite = TweenLite.to(_boatAnimation, 2, {x:dstXD, ease:Linear.easeNone, onComplete:function():void
			{
				if(callBack != null)
				{
					callBack();
				}
				lite.kill();	
			}}
			);
		}
		
		private var _hintTick:int;
		public function showHintAnimation(gridX:int, gridY:int, direction:int):void
		{
			var stagePoint:Point = transGridPostionToStage(new Point(gridX, gridY));
			if(direction == ConstantItem.DIRECTION_H)
			{
				_hintAniamtion = ResHandler.getMcFirstLoad("aniHintH");
			}
			else if(direction == ConstantItem.DIRECTOIN_V)
			{
				_hintAniamtion = ResHandler.getMcFirstLoad("aniHintV");	
			}
		
			_hintAniamtion.x = stagePoint.x;
			_hintAniamtion.y = stagePoint.y;
			_hintAnimationLayer.addChild(_hintAniamtion);
			
			_hintAniamtion.gotoAndPlay(1);
			
			var callBack:Function = function():void
			{
				hideHint();
			};
			
			new PlayMovieClipToEndAndDestroy(_hintAniamtion.mc.mc, callBack);
		}
		
		private function hideHint():void
		{
			if(_hintAniamtion != null)
			{
				DisplayUtil.stopAllAnim(_hintAniamtion);
				DisplayUtil.removeFromDisplayTree(_hintAniamtion);
				_hintAniamtion = null;
			}
		}
		
		private function removeAnimation(d:Notification):void
		{
			var ani:AnimationMoveItem = AnimationMoveItem((d.data as Datagram).injectParameterList[0]);
			var index:int = _animationManager.animationMoveItems.indexOf(ani);
			if(index >= 0)
			{
				_animationManager.animationMoveItems.splice(index, 1);
			}
		}
		
		public function setMouseEnable(isEnable:Boolean):void
		{
			if(!mc)
			{
				return;
			}
			mc.mouseEnabled = isEnable;
			mc.mouseChildren = isEnable;
		}
		
		private function stopTask(n:Notification):void
		{
			if(this._taskPanel is CItemTaskPanel)
			{
				CItemTaskPanel(this._taskPanel).stopUpdate();
			}
		}
		
		private function onUseItem(d:Notification):void
		{
			//正在使用道具
			CDataManager.getInstance().dataOfLevel.isUsingTool = true;
			
			_swapLogic.board.useItem((d.data as Datagram).injectParameterList[0]);
		}
			
		private function onFinishLevelCaculate(d:Notification):void
		{
			_swapLogic.board.noticeFinishLevel();
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.PANEL_COMMON_CONFIRM));
		}
		
		override protected function end():void
		{
			super.end();
			SoundHandler.instance.playBackgroundMusic(ConstantSound.MUSIC_MENU);
			
			SwapLogicProxy.inst.setPause(true);
			if(Debug.ISONLINE)
			{				
				removeObserver(GameNotification.EVENT_GAME_START , __onStartGame);
				
				removeObserver(GameNotification.EVENT_START_CACULATE_FINISH, onFinishLevelCaculate);	
				removeObserver(GameNotification.EVENT_SCORE_ANI, playScoreAnimation);	
				removeObserver(GameNotification.EVENT_STOP_TASK, stopTask);	
				
				removeObserver(GameNotification.EVENT_USE_ITEM, onUseItem);
				
				removeObserver(GameEvent.EVENT_REMOVE_ANIMATION_ITEM, removeAnimation);
				removeObserver(GameNotification.EVENT_GAME_REMOVE_GIFT, __playAni);
				
				CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_SYSTEM_TIPS);
				
				NetworkManager.instance.status = NetworkManager.STATUS_LV;
				
				WebJSManager.setPropValue(0);
				
				_posList = new Array();
			}
			
			_boatAnimation = null;
		}
		
		private function initListener():void
		{
			this._closeBtn.addEventListener(TouchEvent.TOUCH_TAP, onCloseBtnClick, false, 0, true);
			this._replayBtn.addEventListener(TouchEvent.TOUCH_TAP, onReplayBtnClick, false, 0, true);
			this._bgMusicBtn.addEventListener(TouchEvent.TOUCH_TAP, onBgBtnClick, false, 0, true);
			_bgMusicBtn.selected = (CDataManager.getInstance().dataOfLocal.getKey(CDataOfLocal.LOCAL_KEY_MUSIC_WORLD) == 1)
			
			this._soundBtn.addEventListener(TouchEvent.TOUCH_TAP, onSoundBtnClick, false, 0, true);
			_soundBtn.selected = (CDataManager.getInstance().dataOfLocal.getKey(CDataOfLocal.LOCAL_KEY_MUSIC_EFFECT) == 1)
			
			this._settingBtn.addEventListener(TouchEvent.TOUCH_TAP, onSettingBtnClick, false, 0, true);
			this._rankBtn.addEventListener(TouchEvent.TOUCH_TAP, onRankBtnClick, false, 0, true);
		}
		
		protected function onRankBtnClick(event:TouchEvent):void
		{
			NetworkManager.instance.reqMatchInfo(1, 14);
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_MATCH_RANK));
		}
		
		protected function changeSetting():void
		{
			if(this._isShowSetting)
			{
				var fun:Function;
				fun = function () : void
				{
					_closeBtn.visible = false;
					_replayBtn.visible = false;
					_bgMusicBtn.visible = false;
					_soundBtn.visible = false;
				}
				TweenLite.to(this._closeBtn, 0.5, {x : this._settingBtn.x});
				TweenLite.to(this._replayBtn, 0.5, {x : this._settingBtn.x});
				TweenLite.to(this._bgMusicBtn, 0.5, {x : this._settingBtn.x});
				TweenLite.to(this._soundBtn, 0.5, {x : this._settingBtn.x, onComplete:fun});
			}else
			{
				this._closeBtn.visible = true;
				this._replayBtn.visible = true;
				this._bgMusicBtn.visible = true;
				this._soundBtn.visible = true;
				
				TweenLite.to(this._closeBtn, 0.5, {x : 0});
				TweenLite.to(this._replayBtn, 0.5, {x : 30});
				TweenLite.to(this._bgMusicBtn, 0.5, {x : 60});
				TweenLite.to(this._soundBtn, 0.5, {x : 90});
			}
		}
		
		protected function onSettingBtnClick(event:TouchEvent):void
		{
			this._isShowSetting = !this._isShowSetting;
			this.changeSetting();
			
			CDataManager.getInstance().dataOfLocal.setKey(CDataOfLocal.LOCAL_KEY_LEVEL_SETTING , _isShowSetting ? 1 : 0);
		}
		
		protected function onSoundBtnClick(event:TouchEvent):void
		{
			this._soundBtn.selected = !this._soundBtn.selected;
			
			CDataManager.getInstance().dataOfLocal.setKey(CDataOfLocal.LOCAL_KEY_MUSIC_EFFECT  , _soundBtn.selected ? 1 : 0);
			
			SoundHandler.instance.setSoundStatus(!_soundBtn.selected);
		}
		
		protected function onBgBtnClick(event:TouchEvent):void
		{
			this._bgMusicBtn.selected = !this._bgMusicBtn.selected;
			
			CDataManager.getInstance().dataOfLocal.setKey(CDataOfLocal.LOCAL_KEY_MUSIC_WORLD, _bgMusicBtn.selected ? 1 : 0);
			
			SoundHandler.instance.setMusicStatus(!_bgMusicBtn.selected);
		}
		
		protected function onReplayBtnClick(event:TouchEvent):void
		{
			if(NetworkManager.instance.status == NetworkManager.STATUS_MATCH)
			{
				//请求数据
				NetworkManager.instance.reqMatchInfo(1, 8);
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_MATCH_RESULT));
			}else
			{
				//二次确认
				CBaseUtil.showConfirm("重新挑战需"+ ConstGlobalConfig.ENERGY_PER_GAME + "点体力，确定要重新挑战吗?", __onReplayConfirm , function():void{});
			}
		}
		
		private function __onReplayConfirm():void
		{
			//检测体�?
			var needEnergy:int = ConstGlobalConfig.ENERGY_PER_GAME;
			//补充体力
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_START));
			
			if(CDataManager.getInstance().dataOfGameUser.curEnergy < needEnergy)
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramView(ConstantUI.PANEL_ENERGY_LACK));
			}
			else
			{
				//退出当前游�?
				NetworkManager.instance.sendServerStopGame();
				setMouseEnable(false);
				
				Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
				Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
				
				var level:int = CDataManager.getInstance().dataOfLevel.level ;
				
				//需要重新初始化数据
				CDataManager.getInstance().dataOfLevel.decode(level);
				
				//先初始化
				Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramViewChooseLevel(ConstantUI.WORLD_GAME_MAIN , true , level));
				
				Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.USER_INFO_PANEL));
				
			}
		}
		
		protected function onCloseBtnClick(event:TouchEvent):void
		{
			if(NetworkManager.instance.status == NetworkManager.STATUS_MATCH)
			{
				//请求数据
				NetworkManager.instance.reqMatchInfo(1, 8);
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_MATCH_RESULT));
			}else
			{
				//二次确认
				CBaseUtil.showConfirm("确定退出本关卡吗?", __onConfirm , function():void{});
			}
		}
		
		private function __onConfirm():void
		{
			NetworkManager.instance.sendServerStopGame();
			
			CDataManager.getInstance().dataOfLevel.reset();
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
			
			NetworkManager.instance.sendServerGetFriendList();
		}
		
		public function showExitGameWhenCanNotRefresh():void
		{
			CBaseUtil.showConfirm("不能找到新的消除体，游戏失败!", __onConfirm);
		}
		
		public function showExitGameWhenClockKnock():void
		{
			CBaseUtil.showConfirm("时钟到时，游戏失败!", __onConfirm);
		}
		
		public function showExitGameWhenHatDisappear(item:Item):void
		{			
			playDisappearAnimation(getBasicGrid(item.normalBasic, _animationSeleted), item.x, item.y);
			
			
			CBaseUtil.showConfirm("草帽被吸走，游戏失败!", __onConfirm);
		}
		
		private function __onAniComplete():void
		{
			CBaseUtil.delayCall(function():void
			{
				TweenLite.to(_startAnimItem , 1 , {y:_aniStartY , onComplete:__afterAni});
				
			} , 1 , 1);
		}
		
		private function __afterAni():void
		{
			if(mc != null && mc.contains(_startAnimItem))
			{
				mc.removeChild(_startAnimItem);
			}
			
			//如果是倒计时任务，显示倒计
			if(CDataManager.getInstance().dataOfLevel.taskType == ConstTaskType.TASK_TYPE_TIME)
			{
				__showTimeDecrease();
			}
			else
			{
				_startGame();
			}
		}
		
		private function __showTimeDecrease():void
		{
			var decreaseItem:CItem321Go = new CItem321Go();
			decreaseItem.x = (ConstantUI.currentScreenWidth - decreaseItem.width)/2;
			decreaseItem.y = (ConstantUI.currentScreenHeight - decreaseItem.height)/2;
			mc.addChild(decreaseItem);
			
			decreaseItem.play(_startGame);
		}
		
		private function _startGame():void
		{
			
			if(!Debug.ISONLINE)
			{
				__onStartGame(null);
			}
			else
			{
				if(NetworkManager.instance.status == NetworkManager.STATUS_MATCH)
				{
					NetworkManager.instance.sendMatchStartLevel(CDataManager.getInstance().dataOfLevel.level);
				}else
				{
					NetworkManager.instance.sendServerStartLevel(CDataManager.getInstance().dataOfLevel.level);
				}
				
				
			}
		}
		
		private function __onStartGame(d:Notification):void
		{
			if(_currentLevelOriginData.maxLine > MAX_LINE_NUMBER)
			{
				startPlayScrollScreen();
			}
			else
			{
				setMouseEnable(true);
				SwapLogicProxy.inst.setPause(false);
				
				//使用购买道具逻辑
				__useGameTool();
				
				//更新任务面板
				if(NetworkManager.instance.status == NetworkManager.STATUS_MATCH)
				{
					CItemMatchTaskPanel(_taskPanel).startUpate();
				}else
				{
					CItemTaskPanel(_taskPanel).startUpate();
				}
				CTaskChecker.doCheck(_swapLogic.board.dataRecord);
			}
		}
		
		private function __onGameOver(d:Notification):void
		{
			if(d.data != null && d.data == 1)
			{
				showExitGameWhenClockKnock();
			}
			else
			{
				setMouseEnable(true);
				SwapLogicProxy.inst.setPause(true);	
			}
			
		}
		
		private function __useGameTool():void
		{
			var inGameToolList:Array = CDataManager.getInstance().dataOfLevel.inGameToolIdList;
			if(inGameToolList.length == 0)
			{
				return;
			}
			
			for(var i:int =0 ;i <inGameToolList.length ;i ++)
			{
				var itemId:int = inGameToolList[i].id;
				var itemNum:int = inGameToolList[i].num;
				switch(itemId)
				{
					case ConstantItem.ITEM_ADD_STEP_3:
					case ConstantItem.ITEM_ADD_STEP_5:
					case ConstantItem.ITEM_CREATE_LINE_AND_DIAMOND:
						
						if(itemNum <= 0)
						{
							return;
						}
						var dataGram:Datagram = new Datagram();
						dataGram.injectParameterList[0] = itemId;
						//使用
						Fibre.getInstance().sendNotification(GameNotification.EVENT_USE_ITEM, dataGram);
						break;
				}
			}
			
			
		}
		
		private function initUI():void
		{
			var levels:Levels = DataManager.getInstance().levels;
			
			for(var i:int = 0 ; i < levels.level.length ; i++ )
			{
				if(levels.level[i].id == CDataManager.getInstance().dataOfLevel.level)
				{
					_currentLevelOriginData = levels.level[i];
					initGrids(levels.level[i]);
					break;
				}
			}
			
			__drawTaskPanel();
			
			__drawProgressScore();
			
			//右下的按钮组
			__drawBottomButton();
			
			//暂时放在这里
			CDataManager.getInstance().dataOfLevel.d = _swapLogic.board.dataRecord;
			
			_rightItemList = new CItemRightItemList();
			mc.itemlistpos.addChild(_rightItemList);
			if(NetworkManager.instance.status == NetworkManager.STATUS_MATCH)
			{
				_rightItemList.visible = false;
			}else
			{
				_rightItemList.visible = true;
			}
			
			var bgImage:String = CDataManager.getInstance().dataOfLevel.levelConfig.backgroundImage;
			
			DisplayUtil.removeAllChildren(mc.bgpos);
			if(bgImage == "bmd.loading.bg")
			{			
				mc.bgpos.addChild(new Bitmap(GameEngine.getInstance().getLoading().getMainBG()));
			}
			else
			{
				mc.bgpos.addChild(ResHandler.getMcFirstLoad(bgImage));
			}
			
		}
		
		
		
		private function __drawBottomButton():void
		{
			this._closeBtn = new CButtonCommon("level_close");
			this._bottomBtnLayer.addChild(this._closeBtn);
			
			this._replayBtn = new CButtonCommon("again");
			this._replayBtn.x = this._bottomBtnLayer.width;
			this._bottomBtnLayer.addChild(this._replayBtn);
			
			this._bgMusicBtn = new CButtonCommon("level_music");
			this._bgMusicBtn.x = this._bottomBtnLayer.width;
			this._bottomBtnLayer.addChild(this._bgMusicBtn);
			
			this._soundBtn = new CButtonCommon("level_sound");
			this._soundBtn.x = this._bottomBtnLayer.width;
			this._bottomBtnLayer.addChild(this._soundBtn);
			
			this._settingBtn = new CButtonCommon("level_set");
			this._settingBtn.x = this._bottomBtnLayer.width;
			this._bottomBtnLayer.addChild(this._settingBtn);
			
			_isShowSetting = CDataManager.getInstance().dataOfLocal.getKey(CDataOfLocal.LOCAL_KEY_LEVEL_SETTING) == 1;
			this.changeSetting();
			
			mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
			mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			var target:* = event.target;
			if((target is SimpleButton))
			{
				var btn:CButtonCommon = target.parent as CButtonCommon;
				if(!btn)
				{
					return;
				}
				if(!_hasTip)
				{
					_hasTip = true;
					if(btn.__name == "level_close")
					{
						if(NetworkManager.instance.isMatching)
						{
							CBaseUtil.showTip("退出比赛?" , btn.localToGlobal(new Point(btn.x-60 , btn.y)) , null, true );
						}
						else
						{
							CBaseUtil.showTip("退出本关?" , btn.localToGlobal(new Point(btn.x-60 , btn.y)) , null, true );
						}
					}
					else if(btn.__name == "again")
					{
						CBaseUtil.showTip("重新挑战" , btn.localToGlobal(new Point(btn.x - 90 , btn.y)) , null, true );
					}
					else if(btn.__name == "level_music")
					{
						if(btn.selected)
						{
							CBaseUtil.showTip("打开音乐" , btn.localToGlobal(new Point(btn.x -120 , btn.y)), null, true);
						}
						else
						{
							CBaseUtil.showTip("关闭音乐" , btn.localToGlobal(new Point(btn.x- 120 , btn.y)) , null, true );
						}
					}
					else if(btn.__name == "level_sound")
					{
						if(btn.selected)
						{
							CBaseUtil.showTip("打开音效" , btn.localToGlobal(new Point(btn.x- 150, btn.y)) , null, true );
						}
						else
						{
							CBaseUtil.showTip("关闭音效" , btn.localToGlobal(new Point(btn.x- 150, btn.y)) , null, true );
						}
					}
					else if(btn.__name == "level_set")
					{
						if(_isShowSetting)
						{
							CBaseUtil.showTip("展开" , btn.localToGlobal(new Point(btn.x-200, btn.y)) , null, true );
						}
						else
						{
							CBaseUtil.showTip("收起" , btn.localToGlobal(new Point(btn.x-200, btn.y)) , null, true );
						}
					}
				}
				else
				{
					_hasTip = false;
					CBaseUtil.closeTip()
				}
			}
		}
		
		private function __drawTaskPanel():void
		{
			if(NetworkManager.instance.status == NetworkManager.STATUS_MATCH)
			{
				_taskPanel = new CItemMatchTaskPanel(_swapLogic.board.dataRecord);
			}else
			{
				_taskPanel = new CItemTaskPanel(_swapLogic.board.dataRecord);
			}
			mc.taskpos.addChild(_taskPanel);
		}
		
		private function __drawProgressScore():void
		{
			_scoreProgress = new CItemScoreCub();
			mc.scorepos.addChild(_scoreProgress);
		}
		
		private function startPlayScrollScreen():void
		{
			_isStartScrollScreen = true;
			for each(var animationItem:AnimationMoveItem in _animationManager.animationMoveItems)
			{
				animationItem.startPlayNormalSpeed(true);
			}
		}
		private var _isStartScrollScreen:Boolean;
		private function initPlayScrollScreen():void
		{
			
			for(var i:int = 0; i < _currentLevelOriginData.maxLine; i++)
			{
				for(var j:int = 0; j < MAX_LINE_NUMBER; j++)
				{				
					var startPoint:Point = new Point(j, i -(_currentLevelOriginData.maxLine - MAX_LINE_NUMBER));
					var endPoint:Point = new Point(j, i);
					
					var mcGrid:MovieClip = new MovieClip();
					
					var gridData:Grid = _currentLevelOriginData.grid[j + i * MAX_LINE_NUMBER];
					for(var k:int = 0; k < gridData.basic.length; k++)
					{
						var basicData:Basic = gridData.basic[k];
						var basicObj:BasicObject = new BasicObject(basicData.id);
						var collectBox:MovieClip = getBasicGrid(basicObj, _animationSeleted);
						if(collectBox != null)
						{							
							mcGrid.addChild(collectBox);
						}
					}	
					var animationItem:AnimationMoveItem = new AnimationMoveItem(startPoint.x, startPoint.y, endPoint.x, endPoint.y, mcGrid, _moveMiddleLayer, null, null, null);
					_animationManager.animationMoveItems.push(animationItem);
					animationItem.startPlayNormalSpeed(false);
				}
			}
		}
		
		private var _isStartPlayMiddleScrollScreen:Boolean;
		public function playMiddleScrollScreen(moveLength:int, currentMaxLine:int):void
		{
			showAllGrids(false);
			
			_isStartPlayMiddleScrollScreen = true;
			for(var i:int = 0; i < MAX_LINE_NUMBER; i++)
			{
				for(var j:int = 0; j < MAX_LINE_NUMBER; j++)
				{				
					var startPoint:Point = new Point(j, i);
					var endPoint:Point = new Point(j, i - moveLength);
					
					var mcGrid:MovieClip = new MovieClip();
					
					var gridData:GridObject = _currentLevelGridData.grids[j + i * MAX_LINE_NUMBER];
					for(var k:int = 0; k < gridData.basicObjects.length; k++)
					{
						var basicData:BasicObject = gridData.basicObjects[k];
						var collectBox:MovieClip = getBasicGrid(basicData, _animationSeleted);
						if(collectBox != null)
						{							
							mcGrid.addChild(collectBox);
						}
					}	
					var animationItem:AnimationMoveItem = new AnimationMoveItem(startPoint.x, startPoint.y, endPoint.x, endPoint.y, mcGrid, _moveMiddleLayer, null, null, null);
					_animationManager.animationMoveItems.push(animationItem);
					animationItem.startPlayNormalSpeed(false);
					animationItem.startPlayNormalSpeed(true);
				}
			}
			
			playAddScrollScreen(moveLength, currentMaxLine);
		}
		
		private function playAddScrollScreen(moveLength:int, currentMaxLine:int):void
		{
			for(var i:int = 0; i < moveLength; i++)
			{
				for(var j:int = 0; j < MAX_LINE_NUMBER; j++)
				{				
					var startPoint:Point = new Point(j, i + MAX_LINE_NUMBER);
					var endPoint:Point = new Point(j, i + MAX_LINE_NUMBER - moveLength);
					
					var mcGrid:MovieClip = new MovieClip();
					
					var gridData:Grid = _currentLevelOriginData.grid[j + (currentMaxLine + i) * MAX_LINE_NUMBER];
					for(var k:int = 0; k < gridData.basic.length; k++)
					{
						var basicData:Basic = gridData.basic[k];
						var basicObj:BasicObject = new BasicObject(basicData.id);
						var collectBox:MovieClip = getBasicGrid(basicObj, _animationSeleted);
						mcGrid.addChild(collectBox);
					}	
					var animationItem:AnimationMoveItem = new AnimationMoveItem(startPoint.x, startPoint.y, endPoint.x, endPoint.y, mcGrid, _moveMiddleLayer, null, null, null);
					_animationManager.animationMoveItems.push(animationItem);
					animationItem.startPlayNormalSpeed(false);
					animationItem.startPlayNormalSpeed(true);
				}
			}
		}
		
		
		private function initGrids(level:framework.resource.faxb.levels.Level):void
		{
			mc[MC_GRID].y += level.startLine * GRID_HEIGHT;
			
			refreshMcGrid();
			
			_currentLevelGridData = new LevelData(level.id);
			
			var dropPoints:Vector.<TransPoint> = new Vector.<TransPoint>();
			
			
			for(var i:int = 0; i < MAX_LINE_NUMBER; i++)
			{
				lsnMan.addListener(mc[MC_GRID][LINE_PRE + i], TouchEvent.TOUCH_MOVE, onMouseMove);
				for(var j:int = 0; j < MAX_LINE_NUMBER; j++)
				{
					var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + i][COL_PRE + j];
					lsnMan.addListener(mcParent, TouchEvent.TOUCH_BEGIN, onMouseDown);
					lsnMan.addListener(mcParent, TouchEvent.TOUCH_END, onMouseUp);
					
					(mcParent[GRID_POS_OBSTACLE] as MovieClip).mouseEnabled = false;
					(mcParent[GRID_POS_OBSTACLE] as MovieClip).mouseChildren = false;
					
					initCurrentGrids(level, j, i, i, dropPoints);
	
				}
			}
			setDropData(dropPoints);
			
			_animationSeleted = CDataManager.getInstance().dataOfLevel.animationSeleted;
			
			if(CDataManager.getInstance().dataOfLevel.isRandomMap)
			{
				_swapLogic.board.preInitGrid(_currentLevelGridData, this);
				initRandomGrid(level);
			}
			
			_swapLogic.board.initGrids(_currentLevelGridData, this);
			
			if(level.maxLine > MAX_LINE_NUMBER)
			{
				showAllGrids(false);
				initPlayScrollScreen();
			}
		}
		
		private function initRandomGrid(level:Level):void
		{
			var match:OrthoPatternMatcher = _swapLogic.board.getMatch();
			for(var gridY:int = 0; gridY < MAX_LINE_NUMBER; gridY++)
			{
				for(var gridX:int = 0; gridX < MAX_LINE_NUMBER; gridX++)
				{
					var grid:GridObject = _currentLevelGridData.getGrid(gridX, gridY);
					var gridData:Grid = level.grid[gridX + gridY * MAX_LINE_NUMBER];
					for(var k:int = 0; k < gridData.basic.length; k++)
					{
						var basicData:Basic = gridData.basic[k];
						
						if(basicData.id == ConstantItem.GRID_ID_RANDOM_NORMAL
						|| basicData.id == ConstantItem.GRID_ID_RANDOM_VARIABLE
						|| basicData.id == ConstantItem.GRID_ID_RANDOM_CLOCK
						|| basicData.id == ConstantItem.GRID_ID_RANDOM_JELLY
						|| basicData.id == ConstantItem.GRID_ID_RANDOM_GIFT
						)
						{
							var basicRandom:BasicObject = _extension.getRandomBasic(basicData, _swapLogic.board, match, gridX, gridY);
							grid.pushObject(basicRandom);
						}
					}
					
				}
			}
				
		}
		
		private function initCurrentGrids(level:Level, gridX:int, gridY:int, dataGridY:int,dropPoints:Vector.<TransPoint>):void
		{
			var grid:GridObject = _currentLevelGridData.getGrid(gridX, gridY);
			var gridData:Grid = level.grid[gridX + dataGridY * MAX_LINE_NUMBER];
			for(var k:int = 0; k < gridData.basic.length; k++)
			{
				var basicData:Basic = gridData.basic[k];
				
				if(basicData.id == ConstantItem.GRID_ID_CREATE_POINT)
				{
					
				}
				else if(basicData.id == ConstantItem.GRID_ID_RANDOM_NORMAL
					|| basicData.id == ConstantItem.GRID_ID_RANDOM_VARIABLE
					|| basicData.id == ConstantItem.GRID_ID_RANDOM_CLOCK
					|| basicData.id == ConstantItem.GRID_ID_RANDOM_JELLY
					|| basicData.id == ConstantItem.GRID_ID_RANDOM_GIFT
				)
				{
					/*var basicRandom:BasicObject = _extension.getRandomBasic(basicData);
					grid.pushObject(basicRandom);*/
				}
				else
				{
					var basicObj:BasicObject = new BasicObject(basicData.id);
					if(basicData.id == ConstantItem.GRID_ID_COLLECT_BOX)
					{
						var collectBox:MovieClip = getBasicGrid(basicObj, null);
						collectBox.x = grid.x *  GRID_WIDHT;
						collectBox.y = (grid.y + 1) * GRID_HEIGHT;
						_collectBoxLayer.addChild(collectBox);
						
						grid.isCollectContainer = true;
					}
					else if(basicData.id == ConstantItem.GRID_ID_TRANSPORT_START)
					{
						basicObj.setDropPosition(basicData.dstX, basicData.dstY);
						grid.pushObject(basicObj);
						
						dropPoints.push(new TransPoint(gridX, dataGridY, basicData.dstX, basicData.dstY));
					}
						
					else
					{
						
						grid.pushObject(basicObj);
					}
				}														
			}
		}
		
		private function setDropData(dropPoints:Vector.<TransPoint>):void
		{
			for each(var transPoint:TransPoint in dropPoints)
			{
				var grid:GridObject = _currentLevelGridData.getGrid(transPoint.endPoint.x, transPoint.endPoint.y);
				var basicReceive:BasicObject = grid.getTransportEnd();
				basicReceive.setDropPosition(transPoint.startPoint.x, transPoint.startPoint.y);
			}
			
		}
		
		public function updateGridNormalItemData(gridX:int, gridY:int, item:Item, pointNormalBasic:BasicObject = null):void
		{
			var grid:GridObject = _currentLevelGridData.getGrid(gridX, gridY);
			
			var normalBasic:BasicObject = pointNormalBasic;
			if(normalBasic == null)
			{
				normalBasic = item.getMoveBasicObject();
				
			}
			grid.pushObject(normalBasic);
			item._gridObj = grid;
		}
		
		private function updateStep():void
		{
			
		}
		
		public function updateScore():void
		{
			_scoreProgress.score = _swapLogic.board.dataRecord.score;
		}
		
		private function transGridPostionToStage(gridPoint:Point):Point
		{
			var pos:MovieClip = mc[MC_GRID]/*[POS_GRID]*/;
			var stagePoint:Point = new Point(pos.x + gridPoint.x * GRID_WIDHT, pos.y + gridPoint.y * GRID_HEIGHT);
			
			return stagePoint;
		}
		
		private function transStagePostionToGrid(stagePoint:Point):Point
		{
			var pos:MovieClip = mc[MC_GRID]/*[POS_GRID]*/;
			var gridX:int = int((stagePoint.x - pos.x)/GRID_WIDHT);
			var gridY:int = int((stagePoint.y - pos.y)/GRID_HEIGHT);
			var gridPoint:Point = new Point(gridX, gridY);
			
			return gridPoint;
		}
		
		private var _isShortGame:Boolean;
		private var _mouse:MouseInput;
		private var _swapper:Swapper;
		private var _swapLogic:SwapLogicProxy;
		
		private var _hintAniamtion:MovieClip;
		private var _selectedAnimation:MovieClip;

		private var bgBmd:BitmapData;
		private function addSelectedAnimation(gridX:int, gridY:int):void
		{
			removeSelectedAnimation();
			
			var stagePoint:Point = transGridPostionToStage(new Point(gridX, gridY));
			_selectedAnimation = ResHandler.getMcFirstLoad("aniSelected");
			_selectedAnimation.x = stagePoint.x;
			_selectedAnimation.y = stagePoint.y;
			_selectedAnimationLayer.addChild(_selectedAnimation);
			
			_selectedAnimation.gotoAndPlay(1);	
			
			//todo play
			playNormalGridAnimation(true, gridX, gridY);
			
			Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_SELECT_ITEM, null, Fibre.SOUND_NOTIFICATION);
		}
		
		private function playNormalGridAnimation(isPlay:Boolean, gridX:int, gridY:int):void
		{
			var grid:GridObject = _currentLevelGridData.getGrid(gridX, gridY);
			var basic:BasicObject = grid.getNormalBasicObject();
			
			if(basic != null)
			{
				var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + gridY][COL_PRE + gridX][GRID_POS_MIDDLE];
				
				if(mcParent.numChildren > 0)
				{					
					playGridSelectedAnimation((mcParent.getChildAt(0) as MovieClip), isPlay, basic);
				}
			}				
		}
		
		private function removeSelectedAnimation():void
		{
			if(_selectedAnimation != null)
			{				
				var point:Point = transStagePostionToGrid(new Point(_selectedAnimation.x, _selectedAnimation.y));
				
				_selectedAnimation.gotoAndStop(1);
				DisplayUtil.removeFromDisplayTree(_selectedAnimation);
				_selectedAnimation = null;
				
				//todo stop
				playNormalGridAnimation(false, point.x, point.y);
			}
			
		}
		
		private function isMoveItem(gridX:int, gridY:int):Boolean
		{
			var item:Item = _swapLogic.board.getGridItem(gridX, gridY);
			
			if(item != null)
			{
				var basic:BasicObject = item.getTopBasicObjectNotContainObstacle();
				if(basic == null)
				{
					return false;
				}
				return basic.isMove;
			}
			else
			{
				return false;
			}
		}
		
		private function acceptMouseInput():void
		{	
			var clickPoint:Vec2 = null;
			var swapInfo:SwapInfo = null;
			
			if (this._isShortGame || _swapLogic.board.isPause || _swapLogic.isPaused() || !isAnimationOver()||_swapLogic.board.isStartBingo || _swapLogic.board.isPlayToolAnimation)
			{
				
				return;
			}
		
			if (this._mouse.isPressed())
			{
				clickPoint = this._mouse.getPressPosition();
				
				if (_swapLogic.board.isStable())
				{
					var tempClickPoint:Point = new Point(clickPoint.x , clickPoint.y);
					if(_swapLogic.board.useItemStatus == Board.USE_CLEAN_POINT)
					{
						_swapper.reset();
						
						__playUseItemAni("effect.hammer" , function():void
						{
							_swapLogic.board.useCleanPoint(tempClickPoint.x, tempClickPoint.y);
							removeSelectedAnimation();
							_mouse.reset();
						} , new Point(tempClickPoint.x , tempClickPoint.y));
						return;
					}
					else if(_swapLogic.board.useItemStatus == Board.USE_1_TO_2)
					{
						_swapper.reset();
						
						__playUseItemAni("effect.magicwood" , function():void
						{
							_swapLogic.board.useItemFrom_1_TO_2(tempClickPoint.x, tempClickPoint.y);
							removeSelectedAnimation();
							_mouse.reset();
						} , new Point(tempClickPoint.x , tempClickPoint.y));
						return;
					}
					
					
					if(isMoveItem(clickPoint.x, clickPoint.y))
					{
						var forceSwap:Boolean = _swapLogic.board.useItemStatus == Board.USE_SWAP_ITEM;
						
						this._swapper.mouseDownAt(clickPoint.x, clickPoint.y, forceSwap);
						addSelectedAnimation(clickPoint.x, clickPoint.y);
					}
					else
					{
						removeSelectedAnimation();
						this._swapper.reset();
					}
					
				}						
			}
			if (this._mouse.isReleased())
			{
				clickPoint = this._mouse.getReleasePosition();

				if (_swapLogic.board.isStable())
				{
					if(isMoveItem(clickPoint.x, clickPoint.y))
					{						
						this._swapper.mouseUpAt(clickPoint.x, clickPoint.y);
					}
				}
				
	
			}
			if (this._mouse.isDown())
			{
				clickPoint = this._mouse.getPosition();
				
				if (_swapLogic.board.isStable())
				{
					if(isMoveItem(clickPoint.x, clickPoint.y))
					{
						
						this._swapper.mouseMoveTo(clickPoint.x, clickPoint.y, _swapLogic.board.useItemStatus == Board.USE_SWAP_ITEM);
					}
					else
					{
						removeSelectedAnimation();
						this._swapper.reset();
						
					}
				}
				
			}
			if (this._swapper.shouldSwap() /*&& ! _swapLogic.isPaused()*/)
			{
				removeSelectedAnimation();
				hideHint();
				if(_swapLogic.board.dataRecord.getLeftStep() <= 0)
				{
					this._swapper.reset();
					this._mouse.reset();
					return;
				}
				
				swapInfo = this._swapper.getSwap();
				
				if(_swapLogic.board.useItemStatus == Board.USE_SWAP_ITEM)
				{
					var itemA:Item = _swapLogic.board.getGridItem(swapInfo.srcX, swapInfo.srcY);
					var itemB:Item = _swapLogic.board.getGridItem(swapInfo.dstX, swapInfo.dstY);
					
					if(itemA != null && itemA.isCanNotForceSwap() || itemB != null && itemB.isCanNotForceSwap() ||(itemA == itemB))
					{
						cleanMouseStatus();
						return ;
					}
					
					__playUseItemAni("effect.forceswap" , function():void
					{
						_swapLogic.board.useSwapItem(swapInfo.srcX, swapInfo.srcY, swapInfo.dstX, swapInfo.dstY);
					} , new Point(clickPoint.x , clickPoint.y));
				}
				else
				{
					if(TutorialManagerProxy.inst.isStartCheckTutorial)
					{
						var isCanSwap:Boolean = TutorialManagerProxy.inst.isShowSwap(swapInfo.srcX, swapInfo.srcY, swapInfo.dstX, swapInfo.dstY);
						
						if(isCanSwap)
						{
							_swapLogic.board.trySwap(swapInfo.srcX, swapInfo.srcY, swapInfo.dstX, swapInfo.dstY);
							Fibre.getInstance().sendNotification(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL, null);
							Fibre.getInstance().sendNotification(GameEvent.EVENT_NOTICE_EXECUTE_NEXT_TUTORIAL_STEP, null);
						}
						
					}
					else
					{
						
						_swapLogic.board.trySwap(swapInfo.srcX, swapInfo.srcY, swapInfo.dstX, swapInfo.dstY);
					}
				}
				
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_MOVE_ITEM, null, Fibre.SOUND_NOTIFICATION);
//				this._lastSwapTick = tickNumber;
				this._swapper.reset();
				
				
				
				CONFIG::debug
				{
					TRACE_LOG("srcX: "+ swapInfo.srcX+ " srcY: "+ swapInfo.srcY + " dstX: "+ swapInfo.dstX+" dstY: "+swapInfo.dstY);
				}
			}
			this._mouse.reset();
		}
		
		private function __playUseItemAni(clsKey:String , callback:Function , clickPoint:Point):void
		{
			setMouseEnable(false);
			_swapLogic.board.isPlayToolAnimation = true;
			
			var cls:Class = ResHandler.getClass(clsKey);
			var ani:MovieClip = new cls();
			
			var offsetX:Number = 0 ;
			var offsetY:Number = 0;
			if(clsKey == "effect.hammer")
			{
				offsetX = -20;
				offsetY = -16;
			}
			else if(clsKey == "effect.forceswap")
			{
				offsetX = -220;
				offsetY = 30;
			}
			else
			{
				offsetX = -80;
				offsetY = -10;
			}
			
			ani.x = clickPoint.x * GRID_WIDHT + GRID_WIDHT/2 + offsetX;
			ani.y = clickPoint.y * GRID_HEIGHT + GRID_HEIGHT/2  - ani.height + offsetY;
			_animationLayer.addChild(ani);
			
			CBaseUtil.playToEndAndStop(ani , 
				function():void
				{
					callback();
					setMouseEnable(true);
					_swapLogic.board.isPlayToolAnimation = false;
				}, false , true);
		}
		
		public function playRopeAnimation(x:int, y:int, direction:int):void
		{
			
		}
		
		public function cleanMouseStatus():void
		{
			removeSelectedAnimation();
			_swapper.reset();
			_mouse.reset();
		}
		
		private function onMouseMove(e:TouchEvent):void
		{
			var point:Point = transStagePostionToGrid(new Point(mc.mouseX, mc.mouseY));
			_mouse.setPosition(new Vec2(point.x, point.y));
		}
		
		private function onMouseDown(e:TouchEvent):void
		{

			for(var row:int = 0; row < MAX_LINE_NUMBER; row++)
			{
				for(var col:int = 0; col < MAX_LINE_NUMBER; col++)
				{
					var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + row][COL_PRE + col];
					if(e.currentTarget == mcParent)
					{
						_mouse.setPressed(new Vec2(col, row));
						return;
					}
				}
			}							
		}
		
		private function onMouseUp(e:TouchEvent):void
		{
			for(var row:int = 0; row < MAX_LINE_NUMBER; row++)
			{
				for(var col:int = 0; col < MAX_LINE_NUMBER; col++)
				{
					var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + row][COL_PRE + col];
					if(e.currentTarget == mcParent)
					{							
						_mouse.setReleased(new Vec2(col, row));
						return;
					}
				}
			}
		}
	
		
		private function onClickGrid(e:TouchEvent):void
		{
			for(var row:int = 0; row < MAX_LINE_NUMBER; row++)
			{
				for(var col:int = 0; col < MAX_LINE_NUMBER; col++)
				{
					var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + row][COL_PRE + col];
					if(e.currentTarget == mcParent)
					{							
						_mouse.setReleased(new Vec2(col, row));
						return;
					}
				}
			}
		}
		
		override public function updateView(psdTickMs:Number):void
		{
			acceptMouseInput();
			
			if(!_swapLogic.board.isStable())
			{
				setMouseEnable(false);
			}
			else
			{
				if(!_swapLogic.board.isStartBingo && !SwapLogicProxy.inst.isPaused() && !_swapLogic.board.isWaitFinishLevel)	
				{	
					setMouseEnable(true);
				}
				
			}
			
			if(_isStartScrollScreen)
			{
				if(_animationManager.animationMoveItems.length == 0)
				{
					DisplayUtil.removeAllChildren(_moveMiddleLayer);
					_isStartScrollScreen = false;
					showAllGrids(true);
					setMouseEnable(true);
					SwapLogicProxy.inst.setPause(false);
					
					//使用购买道具逻辑
					__useGameTool();
					
					//更新任务面板
					if(NetworkManager.instance.status == NetworkManager.STATUS_MATCH)
					{
						CItemMatchTaskPanel(_taskPanel).startUpate();
					}else
					{
						CItemTaskPanel(_taskPanel).startUpate();
					}
					CTaskChecker.doCheck(_swapLogic.board.dataRecord);
				}
			}
			else if(_isStartPlayMiddleScrollScreen)
			{
				if(_animationManager.animationMoveItems.length == 0)
				{
					DisplayUtil.removeAllChildren(_moveMiddleLayer);
					_isStartPlayMiddleScrollScreen = false;
					showAllGrids(true);
					setMouseEnable(true);
					SwapLogicProxy.inst.setPause(false);
				}	
			}
		}
		
		private static function playGridSelectedAnimation(mc:MovieClip, isPlay:Boolean, basic:BasicObject):void
		{
			if(basic.blockType == BasicObject.TYPE_NORMAL)
			{
				if(mc.currentFrame == 25)
				{
					if(isPlay)
					{
						mc.mc.gotoAndStop(2);
					}
					else
					{					
						mc.mc.gotoAndStop(1);
					}
				}
				else if(mc.currentFrame <= ConstantItem.MAX_CARD_NUM)
				{
					if(mc.mc != null)
					{
						if(mc.mc.mc != null)
						{
							if(isPlay)
							{
								(mc.mc as MovieClip).gotoAndPlay(1);
								(mc.mc.mc as MovieClip).gotoAndPlay(1);
							}
							else
							{
								(mc.mc as MovieClip).gotoAndStop(1);
								(mc.mc.mc as MovieClip).gotoAndStop(1);
							}
						}
					}
				}
			}
			else
			{
				if(mc.mc != null)
				{
					if(mc.mc.mc != null)
					{
						if(isPlay)
						{
							(mc.mc as MovieClip).gotoAndPlay(1);
							(mc.mc.mc as MovieClip).gotoAndPlay(1);
						}
						else
						{
							(mc.mc as MovieClip).gotoAndStop(1);
							(mc.mc.mc as MovieClip).gotoAndStop(1);
						}
					}
				}
			}
			
			
		}
		
		public static function getBasicGridStatic(basicObject:BasicObject, animationSeleted:Vector.<int>, isPlay:Boolean = false):MovieClip
		{
			var mc:MovieClip;
			if(basicObject.objectType == BasicObject.TYPE_NORMAL)
			{
				if(basicObject.picType < ConstantItem.MAX_CARD_NUM)
				{
					if(animationSeleted[basicObject.picType] == 0)
					{					
						mc = ResHandler.getMcFirstLoad("gameCard");
					}
					else
					{
						
						mc = ResHandler.getMcFirstLoad("gameCard1");
					}
				}
				else
				{
					mc = ResHandler.getMcFirstLoad("gameCard");
				}
				
				mc.gotoAndStop(basicObject.id + 1);
				
				if(!isPlay)
				{				
					playGridSelectedAnimation(mc, false, basicObject);
				}
			}
				
			else if(basicObject.objectType == BasicObject.TYPE_ADD_EMPTY)
			{
				if(basicObject.id == ConstantItem.GRID_ID_COLLECT_BOX)
				{
					mc = ResHandler.getMcFirstLoad("gameCollectBox");
					mc.gotoAndStop(1);
				}
				else if(basicObject.id == ConstantItem.GRID_ID_CREATE_POINT)
				{
					
				}
			}
			else if(basicObject.objectType == BasicObject.TYPE_BLOCK_OVERLAP)
			{
				mc = ResHandler.getMcFirstLoad("gridOverlap");
				mc.gotoAndStop(basicObject.picType + 1);
				
				if(basicObject.blockType == BasicObject.BLOCK_VINE)
				{
					if(isPlay)
					{
					}
					else
					{						
						(mc.mc as MovieClip).gotoAndStop(1);
					}
				}
				else if(basicObject.blockType == BasicObject.BLOCK_BUG)
				{
					if(isPlay)
					{
						mc = ResHandler.getMcFirstLoad("bugMove");
					}
				}
			}
			else if(basicObject.objectType == BasicObject.TYPE_BLOCK_OVERLAP_NO)
			{
				mc = ResHandler.getMcFirstLoad("gridOverlapNo");
				mc.gotoAndStop(basicObject.picType + 1);
				
				if(mc.mc != null )
				{
					(mc.mc.mc as MovieClip).gotoAndStop(1);
				}
			}
			else if(basicObject.objectType == BasicObject.TYPE_BLOCK_MOVE)
			{
				if(basicObject.isVariableObject())
				{
					if(animationSeleted[basicObject.picType - 1] == 0)
					{					
						mc = ResHandler.getMcFirstLoad("gameCard");
					}
					else
					{
						mc = ResHandler.getMcFirstLoad("gameCard1");
					}
					mc.addChild(ResHandler.getMcFirstLoad("variableWait"));					
					mc.gotoAndStop(basicObject.picType);
				}
				else if(basicObject.isGiftItem())
				{
					mc = ResHandler.getMcFirstLoad("gridMove");
					mc.gotoAndStop(basicObject.picType + 1);
					
					if(animationSeleted[basicObject.picType - 7] == 0)
					{					
						(mc.mc.icon as MovieClip).gotoAndStop(1);
					}
					else
					{
						(mc.mc.icon as MovieClip).gotoAndStop(2);
					}
					
				}
				else if(basicObject.isJellyItem() || basicObject.isClockItem())
				{
					mc = ResHandler.getMcFirstLoad("gridMove");
					mc.gotoAndStop(basicObject.picType + 1);
					
					if(!isPlay)
					{				
						playGridSelectedAnimation(mc, false, basicObject);
					}
				}
				else
				{
					mc = ResHandler.getMcFirstLoad("gridMove");
					mc.gotoAndStop(basicObject.picType + 1);
				}
				
			}
			else if(basicObject.objectType == BasicObject.TYPE_COLLECTION)
			{
				mc = ResHandler.getMcFirstLoad("gridCollected");
				mc.gotoAndStop(basicObject.picType + 1);
			}
			
			//			mc.scaleX = mc.scaleY = 0.95;
			//			mc.x = mc.y = 3;
			return mc;	
		}
		public function getBasicGrid(basicObject:BasicObject, animationSeleted:Vector.<int>, isPlay:Boolean = false):MovieClip
		{
			var mc:MovieClip;
			if(basicObject.objectType == BasicObject.TYPE_NORMAL)
			{
				if(basicObject.picType < ConstantItem.MAX_CARD_NUM)
				{
					if(animationSeleted[basicObject.picType] == 0)
					{					
						mc = ResHandler.getMcFirstLoad("gameCard");
					}
					else
					{
						
						mc = ResHandler.getMcFirstLoad("gameCard1");
					}
				}
				else
				{
					mc = ResHandler.getMcFirstLoad("gameCard");
				}
				
				mc.gotoAndStop(basicObject.id + 1);
				
				if(!isPlay)
				{				
					playGridSelectedAnimation(mc, false, basicObject);
				}
				
				
			}
			
			else if(basicObject.objectType == BasicObject.TYPE_ADD_EMPTY)
			{
				if(basicObject.id == ConstantItem.GRID_ID_COLLECT_BOX)
				{
					mc = ResHandler.getMcFirstLoad("gameCollectBox");
					mc.gotoAndStop(1);
				}
				else if(basicObject.id == ConstantItem.GRID_ID_CREATE_POINT)
				{
					
				}
			}
			else if(basicObject.objectType == BasicObject.TYPE_BLOCK_OVERLAP)
			{
				if(basicObject.id == ConstantItem.GRID_ID_TRANSPORT_START)
				{
					mc = ResHandler.getMcFirstLoad("passdoorDown");
					mc.gotoAndPlay(1);
				}
				else if(basicObject.id == ConstantItem.GRID_ID_TRANSPORT_END)
				{
					mc = ResHandler.getMcFirstLoad("passdoorUp");
					mc.gotoAndPlay(1);
				}
				else
				{
					mc = ResHandler.getMcFirstLoad("gridOverlap");
					mc.gotoAndStop(basicObject.picType + 1);
					
					if(basicObject.blockType == BasicObject.BLOCK_VINE)
					{
						if(isPlay)
						{
						}
						else
						{						
							(mc.mc as MovieClip).gotoAndStop(1);
						}
					}
					else if(basicObject.blockType == BasicObject.BLOCK_BUG)
					{
						if(isPlay)
						{
							mc = ResHandler.getMcFirstLoad("bugMove");
						}
					}
				}
			
			}
			else if(basicObject.objectType == BasicObject.TYPE_BLOCK_OVERLAP_NO)
			{
				mc = ResHandler.getMcFirstLoad("gridOverlapNo");
				mc.gotoAndStop(basicObject.picType + 1);
				
				if(mc.mc != null )
				{
					(mc.mc.mc as MovieClip).gotoAndStop(1);
				}
			}
			else if(basicObject.objectType == BasicObject.TYPE_BLOCK_MOVE)
			{
				if(basicObject.isVariableObject())
				{
					if(animationSeleted[basicObject.picType - 1] == 0)
					{					
						mc = ResHandler.getMcFirstLoad("gameCard");
					}
					else
					{
						mc = ResHandler.getMcFirstLoad("gameCard1");
					}
					mc.addChild(ResHandler.getMcFirstLoad("variableWait"));					
					mc.gotoAndStop(basicObject.picType);
				}
				else if(basicObject.isGiftItem())
				{
					mc = ResHandler.getMcFirstLoad("gridMove");
					mc.gotoAndStop(basicObject.picType + 1);
					
					if(animationSeleted[basicObject.picType - 7] == 0)
					{					
						(mc.mc.icon as MovieClip).gotoAndStop(1);
					}
					else
					{
						(mc.mc.icon as MovieClip).gotoAndStop(2);
					}
					
				}
				else if(basicObject.isJellyItem() || basicObject.isClockItem())
				{
					if(basicObject.isJellyItem() && animationSeleted[basicObject.picType - 13] != 0)
					{
						mc = ResHandler.getMcFirstLoad("gridMove1");
					}
					else
					{
						mc = ResHandler.getMcFirstLoad("gridMove");
					}
					
					mc.gotoAndStop(basicObject.picType + 1);
					
					if(!isPlay)
					{				
						playGridSelectedAnimation(mc, false, basicObject);
					}
				}
				else
				{
					mc = ResHandler.getMcFirstLoad("gridMove");
					mc.gotoAndStop(basicObject.picType + 1);
				}
				
			}
			else if(basicObject.objectType == BasicObject.TYPE_COLLECTION)
			{
				mc = ResHandler.getMcFirstLoad("gridCollected");
				mc.gotoAndStop(basicObject.picType + 1);
			}
			
			if(basicObject.blockType == BasicObject.BLOCK_JELLY_ITEM || basicObject.blockType == BasicObject.BLOCK_CLOCK_ITEM)
			{
				var num:int = getLeftNum(basicObject);
				if(num < 0)
				{
					num = 0;
				}
				(mc.mc[TEXT_NUM] as TextField).text = num.toString();
				var tf:TextField = CBaseUtil.getTextField(mc.mc[TEXT_NUM], int((mc.mc[TEXT_NUM] as TextField).defaultTextFormat.size), int((mc.mc[TEXT_NUM] as TextField).defaultTextFormat.color));
			}
//			mc.scaleX = mc.scaleY = 0.95;
//			mc.x = mc.y = 3;
			return mc;
		}
		
		public function checkAnimationStart():void
		{
			if(_isStartPlayDestoryAnimation)
			{
				if(_animationManager.animationPlayItems.length == 0)
				{
					_isStartPlayDestoryAnimation = false;
					startPlayMoveAnimation();
				}
			}
		}
		
		public function startPlayMoveAnimation():void
		{
			if(!_isStartPlayDestoryAnimation)
			{
				if(_animationManager.animationMoveItems.length > 0)
				{
					for each(var animation:AnimationMoveItem in _animationManager.animationMoveItems)
					{
						animation.startPlay(this);
					}
				}
			}
			
		}
		
		private function playMoveBasicObject(basicObject:BasicObject, item:Item, callBack:Function, moveLayer:DisplayObjectContainer):void
		{
			item.busy = true;
			var startPoint:Point = new Point(item.srcX, item.srcY);
			
			var dropPoint:Point = null;
			if(item.dropX != -1)
			{
				dropPoint = new Point(item.dropX, item.dropY);
			}
			
			var endPoint:Point = new Point(item.x, item.y);
						
			var mcGrid:MovieClip = getBasicGrid(basicObject, _animationSeleted);
			
			var callBackFunction:Function = function ():void
			{
				if(mc == null)
				{
					return;
				}
				
				drawGridObject(endPoint.x, endPoint.y);
				item.busy = false;
				if(callBack != null)
				{
					callBack(item);
				}
			}
			
			var animationItem:AnimationMoveItem = new AnimationMoveItem(startPoint.x, startPoint.y, endPoint.x, endPoint.y, mcGrid, moveLayer, callBackFunction, null,dropPoint);
			_animationManager.animationMoveItems.push(animationItem);
//			animationItem.startPlay();
		}
		
		public function drawGridObject(gridX:int, gridY:int):void
		{
			var mcParent:MovieClip;
			mcParent = mc[MC_GRID][LINE_PRE + gridY][COL_PRE + gridX];		
			
			//todo refreshGridUI
			refreshGridUI(gridX, gridY, mcParent);
		}
		
		private function showAllGrids(isShow:Boolean):void
		{
			for(var i:int = 0; i < MAX_LINE_NUMBER; i++)
			{
				for(var j:int = 0; j < MAX_LINE_NUMBER; j++)
				{
					showGrid(j, i, isShow);
				}
			}	
		}
		private function showGrid(gridX:int, gridY:int, isShow:Boolean):void
		{
			
			var mcParent:MovieClip;
			mcParent = mc[MC_GRID][LINE_PRE + gridY][COL_PRE + gridX];		
			mcParent[GRID_POS_BOTTOM].visible = isShow;
			mcParent[GRID_POS_MIDDLE].visible = isShow;
			mcParent[GRID_POS_TOP].visible = isShow;
			mcParent[GRID_POS_OBSTACLE].visible = isShow;
			//todo refreshGridUI
		}
		
		public function findParent(basic:BasicObject, mcParent:DisplayObjectContainer):MovieClip
		{
			var parent:MovieClip;
			
			if(basic.isObstacle())
			{
				parent = mcParent[GRID_POS_OBSTACLE];
			}
			else if(basic.layer < BasicObject.LAYER_NORMAL)
			{
				parent = mcParent[GRID_POS_BOTTOM];
//				CONFIG::debug
//				{
//					TRACE_BOTTOM_ITEM("add bottomGrid gridX: "+ gridX + " gridY: "+ gridY +" level: "+basic.level );
//				}
			}
			else if(basic.layer == BasicObject.LAYER_NORMAL)
			{
				parent = mcParent[GRID_POS_MIDDLE];
			}			
			else 
			{
				parent = mcParent[GRID_POS_TOP];	
			}
			
			return parent;
		}
		
		public function isAnimationOver():Boolean
		{
			return _animationManager.animationMoveItems.length == 0 && _animationManager.animationPlayItems.length == 0;
		}
		
		public function playFallingAnimation(item:Item, callBack:Function):void
		{
			if(item.srcX == item.x && item.srcY == item.y)
			{
				if(callBack != null)
				{
					callBack(item);
				}
				return;
			}

			item.busy = true;
			//push gridData
			
			if(item.isFindBug())
			{
				var dropPoint:Point = null;
				if(item.dropX != -1)
				{
					dropPoint = new Point(item.dropX, item.dropY);
				}
						
				moveBug(new Point(item.srcX, item.srcY), new Point(item.x, item.y), null, false, dropPoint);

			}
			var basicObject:BasicObject = getMoveBasicObject(item, item.x, item.y, true);
			playMoveBasicObject(basicObject, item, callBack, _moveMiddleLayer);
			
		}
		
		private function getBasicObjBySpecialType(item:Item):BasicObject
		{
			CONFIG::debug
			{					
				ASSERT(item.color >= 0, "item color is wrong!");
			}
			return new BasicObject(item.getIdBySpecialType());;
		}
		
		private function getMoveBasicObject(item:Item, gridX:int, gridY:int, isNewNoramlGrid:Boolean = false):BasicObject
		{
			var basicObj:BasicObject;
			
			if(isNewNoramlGrid || item._gridObj == null)
			{
				var grid:GridObject = _currentLevelGridData.getGrid(gridX, gridY);
//				grid.basicObjects = new Vector.<BasicObject>();	
				if(item.normalBasic != null && item.normalBasic.objectType != BasicObject.TYPE_NORMAL)
				{
					if(item.normalBasic.isMove)
					{						
						basicObj = item.normalBasic;
					}
					else if(item.normalBasic.blockType == BasicObject.BLOCK_VINE || item.isFindBug())
					{
						basicObj = item.getAcanMoveBasic();
					}
				}
				else
				{
					//normal basicObject or null
					basicObj = getBasicObjBySpecialType(item);
				}
				
				CONFIG::debug
				{
					ASSERT(basicObj != null, "can not push null basicObject to grid!");
				}
				//pushMoveBasicToNewPosition
				grid.pushObject(basicObj);
			
				item.setGridObject(grid, this);
			}
			basicObj = item.getMoveBasicObject();
			
			return basicObj;
		}
		
		private function refreshGridUI(gridX:int, gridY:int, mcParent:DisplayObjectContainer):void
		{
			CONFIG::debug
			{
				TRACE_BOTTOM_ITEM("refresh bottomGrid gridX: "+ gridX + " gridY: "+ gridY );
			}
			DisplayUtil.removeAllChildren(mcParent[GRID_POS_BOTTOM]);
			DisplayUtil.removeAllChildren(mcParent[GRID_POS_MIDDLE]);
			DisplayUtil.removeAllChildren(mcParent[GRID_POS_TOP]);
			DisplayUtil.removeAllChildren(mcParent[GRID_POS_OBSTACLE]);
			
			var grid:GridObject = _currentLevelGridData.getGrid(gridX, gridY);		
			
			for(var i:int = 0; i < grid.basicObjects.length; i++)
			{
				var basic:BasicObject = grid.basicObjects[i];
//				basic.uiIndex = i;
				var mc:MovieClip = getBasicGrid(basic, _animationSeleted);
				
				var parent:DisplayObjectContainer = findParent(basic, mcParent);
				
				
				if(mcParent.visible)
				{
					CONFIG::debug
					{
						ASSERT(mc != null, "mc can not is null layer: "+ basic.layer+ " basicId: "+ basic.id);
					}
					parent.addChild(mc);
				}
			}
		}
		
		private function getLeftNum(basic:BasicObject):int
		{
			return _swapLogic.board.stepItemsManager.getLeftNum(basic);
		}
		
		public function showBingoTime(item:Item, gridX:int, gridY:int, isFalling:Boolean, isNewNormalGrid:Boolean):void
		{
			var bingoTimeMC:MovieClip = ResHandler.getMcFirstLoad("effect.step");
			bingoTimeMC.x = 138;
			bingoTimeMC.y = 285;
			mc.addChild(bingoTimeMC);
			bingoTimeMC.gotoAndPlay(1);
			var dx:int = gridX * GRID_WIDHT + _moveMiddleLayer.x + 10;
			var dy:int = gridY * GRID_HEIGHT + _moveMiddleLayer.y + 10;
			
			var r:Number = Math.atan2(dy - 285, dx - 138);
			bingoTimeMC.rotation = (180 / Math.PI) * r;
			
			CDataManager.getInstance().dataOfLevel.d.swapStep += 1;
			CItemTaskPanel(this._taskPanel).updateStepMc(true);
			TweenLite.to(bingoTimeMC, 0.5, {x:dx, y:dy, onComplete:onBingoTimeMoveOver, onCompleteParams: [bingoTimeMC, item, gridX, gridY, isFalling, isNewNormalGrid]});
		}
		
		private function onBingoTimeMoveOver(bmc:MovieClip, item:Item, gridX:int, gridY:int, isFalling:Boolean, isNewNormalGrid:Boolean):void
		{
			if(bmc != null && mc.contains(bmc))
			{
				mc.removeChild(bmc);
			}
			addItemToUI(item, gridX, gridY, isFalling);
			
			Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_SELECT_ITEM, null, Fibre.SOUND_NOTIFICATION);
		}
		
		public function addItemToUI(item:Item, gridX:int, gridY:int, isFalling:Boolean) : void
		{
			var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + gridY][COL_PRE + gridX];
			
			if(item._gridObj != null)
			{			
				var basicTop:BasicObject = item.getTopBasicObjectNotContainObstacle();
				if(basicTop != null && basicTop.id == ConstantItem.GRID_ID_HIDE)
				{
					mcParent.visible = false;
					return;
				}
			}

			if(!isFalling)
			{						
				refreshGridUI(gridX, gridY, mcParent);	
			}
				
			CONFIG::debug
			{
				TRACE_LOG("addItemUI: x: "+ gridX +" y: "+gridY + " color: "+ item.color);
			}
		}
		
	
		/**
		 remove fallingItem from UI
		 */
		public function removeNormalItemUI(gridX:int, gridY:int, isFindBug:Boolean) : void
		{
			//todo deleteItem UI
			var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + gridY][COL_PRE + gridX][GRID_POS_MIDDLE];
			
			//todo removeBasicNoraml
			DisplayUtil.removeAllChildren(mcParent);
			
			if(isFindBug)
			{
				mcParent = findParent(new BasicObject(ConstantItem.GRID_ID_BUG), mc[MC_GRID][LINE_PRE + gridY][COL_PRE + gridX]);
				DisplayUtil.removeAllChildren(mcParent);
			}
		}
		
		
		
		public function moveBug(startPoint:Point, endPoint:Point, callBack:Function, isOwnMove:Boolean, dropPoint:Point):void
		{
			CONFIG::debug
			{
				TRACE_JLM("bugMove srcX: "+startPoint.x + " srcY: "+ startPoint.y + " dstX: "+ endPoint.x+ " dstY: "+ endPoint.y);	
			}				
			
			var bug:BasicObject = new BasicObject(ConstantItem.GRID_ID_BUG);
			var gridObject:GridObject = _currentLevelGridData.getGrid(startPoint.x, startPoint.y);
			gridObject.deleteSameLayerObject(bug);
			
			
//			var mcParent:MovieClip = mc[MC_GRID][LINE_PRE + startPoint.y][COL_PRE + startPoint.x];
//			refreshGridUI(startPoint.x, startPoint.y, mcParent);
			
			var refreshOld:Function = function ():void
			{				
				drawGridObject(startPoint.x, startPoint.y);
			}
			
			var bugCallParameter:Array = [];
			if(!isOwnMove)
			{
				bugCallParameter = [refreshOld];
			}
			else
			{
				refreshOld();
			}
			
			gridObject = _currentLevelGridData.getGrid(endPoint.x, endPoint.y);
			gridObject.pushObject(bug);
			
			var mcGrid:MovieClip = getBasicGrid(bug, _animationSeleted);
			
			var callBackFunction:Function = function ():void
			{
				if(mc == null)
				{
					return;
				}
				
				drawGridObject(endPoint.x, endPoint.y);
				
				if(callBack != null)
				{
					callBack();
				}
			}
			
			var animationItem:AnimationMoveItem = new AnimationMoveItem(startPoint.x, startPoint.y, endPoint.x, endPoint.y, mcGrid, _moveTopLayer, callBackFunction, bugCallParameter, dropPoint);
			_animationManager.animationMoveItems.push(animationItem);
			
			if(isOwnMove)
			{				
				animationItem.startPlay(this);
			}			
		}
		
		public function changeColor(item:Item, nextColor:int):Item
		{
			var itemChange:Item = null;
			
			var gridX:int = item.x;
			var gridY:int = item.y;
			
			//refreshGridData
			var gridObject:GridObject = _currentLevelGridData.getGrid(gridX, gridY);
			gridObject.pushObject(new BasicObject(ConstantItem.VARIABLE_OBJECT_START_INDEX + nextColor));
			
			itemChange = new Item(gridX, gridY);
			itemChange.setGridObject(gridObject, this);
	
			drawGridObject(gridX, gridY);
			
			return itemChange;
		}
		
		private var _isStartPlayDestoryAnimation:Boolean;
		private var _hasTip:Boolean;
		public function playGameAnimation(name:String, gridX:int, gridY:int, isMoveCenter:Boolean = false):MovieClip
		{
			var animation:MovieClip = ResHandler.getMcFirstLoad(name);
			animation.x = gridX * GRID_WIDHT;
			animation.y = gridY * GRID_HEIGHT;
			
			if(isMoveCenter)
			{
				animation.x += GRID_WIDHT/2;
				animation.y += GRID_HEIGHT/2;
			}
			_animationLayer.addChild(animation);
			
			animation.gotoAndPlay(1);
			var ani:MovieClip = animation.mc != null ? animation.mc : animation;
			var playItem:PlayMovieClipToEndAndDestroy = new PlayMovieClipToEndAndDestroy(ani, noticePlayOver, true, null, true);
		
			_animationManager.animationPlayItems.push(playItem);
			_swapLogic.board.isStopLogic = true;
			_isStartPlayDestoryAnimation = true;
			
			return animation;
		}
		
		public function playDisappearAnimation(animation:MovieClip, gridX:int, gridY:int, isMoveCenter:Boolean = false):MovieClip
		{
			animation.x = gridX * GRID_WIDHT;
			animation.y = gridY * GRID_HEIGHT;
			
			if(isMoveCenter)
			{
				animation.x += GRID_WIDHT/2;
				animation.y += GRID_HEIGHT/2;
			}
			_animationLayer.addChild(animation);
			_animationManager.animationPlayItems.push(animation);
			
			TweenMax.to(animation, 0.5, {alpha:0, onComplete:function():void
			{
				DisplayUtil.removeFromParent(animation);
				noticePlayOver(animation);
			}});
			_swapLogic.board.isStopLogic = true;
			_isStartPlayDestoryAnimation = true;
			
			return animation;
		}
		
		
		
		private function noticePlayOver(ani:MovieClip):void
		{
			_animationManager.animationPlayItems.shift();
			if(_animationManager.animationPlayItems.length == 0)
			{
				_swapLogic.board.isStopLogic = false;
			}
		}
		
		
		
		/**
		 *  检测该坐标是否正在飘分 
		 * @param pos
		 * 
		 */		
		private function checkPosScore(pos:Point):Boolean
		{
			for each(var p:Point in _posList)
			{
				if(p.x == pos.x && p.y == pos.y)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 *  删除播放完的飘分 
		 * @param target
		 * 
		 */		
		private function destoryPos(target:MovieClip):void
		{
			var p:Point = new Point(target.x, target.y);
			for(var i:int = 0; i < _posList.length; i++)
			{
				var pos:Point = _posList[i];
				if(p.x == pos.x && p.y == pos.y)
				{
					_posList.splice(i, 1);
					i--;
				}
			}
		}
		
		/**
		 *  连击特效 
		 * @param name
		 * 
		 */		
		public function playBombAnimation(name:String, callBack:Function = null):void
		{
			var animation:MovieClip = ResHandler.getMcFirstLoad(name);
			animation.x = mc[MC_GRID].x;
			animation.y = ((MAX_LINE_NUMBER - this._currentLevelOriginData.startLine) * GRID_HEIGHT >> 1) - 50;
			_animationLayer.addChild(animation);
			animation.gotoAndPlay(1);
			new PlayMovieClipToEndAndDestroy(animation, callBack);
		}
		
		public function playScoreAnimation(n:Notification):void
		{
			var score:int = n.data.score; 
			var itemX:int = n.data.itemX; 
			var itemY:int = n.data.itemY;
			
			var pos:Point = new Point(itemX * GRID_WIDHT, itemY * GRID_HEIGHT);
			
			if(checkPosScore(pos))
			{
				var n1:Notification = new Notification();
				n1.data = n.data;
				setTimeout(playScoreAnimation, 200, n1);
				return;
			}
			
			_posList.push(pos);
			
			var animation:MovieClip = ResHandler.getMcFirstLoad("common.scoreAni");
			var nm:CWidgetAniNumber = new CWidgetAniNumber(_numFrames, score);
			animation.content.addChild(nm);
			
			animation.x = itemX * GRID_WIDHT;
			animation.y = itemY * GRID_HEIGHT;
			_animationLayer.addChild(animation);
			animation.gotoAndPlay(1);
			new PlayMovieClipToEndAndDestroy(animation, destoryPos);
		}
		
		public function destroyItem(item:Item, comboTimes:int) : Item
		{
			var itemChange:Item = null;
			
			var gridX:int = item.x;
			var gridY:int = item.y;
					
			var animation:MovieClip;
			//refreshGridData
			var gridObject:GridObject = _currentLevelGridData.getGrid(gridX, gridY);
			for (var i:int = gridObject.basicObjects.length - 1; i >= 0; i--)
			{
				var basic:BasicObject = gridObject.basicObjects[i];
				
				if(!basic.isObstacle() && basic.id != ConstantItem.GRID_ID_DIAMOND)
				{					
					_swapLogic.board.dataRecord.removeBasic(basic, comboTimes, item);
				}
				
				if(basic.blockType == BasicObject.BLOCK_VINE || basic.blockType == BasicObject.BLOCK_BUG)
				{
					if(basic.blockType == BasicObject.BLOCK_VINE)
					{
						animation = getBasicGrid(basic, _animationSeleted,true);
						animation.x = gridX * GRID_WIDHT;
						animation.y = gridY * GRID_HEIGHT;
						(animation.mc as MovieClip).gotoAndPlay(1);
						_animationLayer.addChild(animation);

						var playItem:PlayMovieClipToEndAndDestroy = new PlayMovieClipToEndAndDestroy(animation.mc, noticePlayOver, true, null, true);					
						_animationManager.animationPlayItems.push(playItem);
						_swapLogic.board.isStopLogic = true;
						_isStartPlayDestoryAnimation = true;
						
						Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_CIRRUS, null, Fibre.SOUND_NOTIFICATION);
					}
					else if(basic.blockType == BasicObject.BLOCK_BUG)
					{
						playGameAnimation("bugDie", gridX, gridY);
						Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_BUG2, null, Fibre.SOUND_NOTIFICATION);
					}
					gridObject.basicObjects.splice(i, 1);
					
					if(item.isFly)
					{
						
					}
					else
					{						
						break;
					}
				}
				else if(basic.objectType == BasicObject.TYPE_NORMAL 
					|| basic.blockType == BasicObject.BLOCK_TYPE_VARIABLE_ITEM 
					|| basic.blockType == BasicObject.BLOCK_GIFT_ITEM
					|| basic.blockType == BasicObject.BLOCK_JELLY_ITEM
					|| basic.blockType == BasicObject.BLOCK_CLOCK_ITEM
				)
				{
					var itemMc:MovieClip;
					if(basic.blockType == BasicObject.BLOCK_TYPE_VARIABLE_ITEM)
					{
						if(_animationSeleted[basic.picType - 1] == 0)
						{					
							itemMc = ResHandler.getMcFirstLoad("gameCard");
						}
						else
						{
							itemMc = ResHandler.getMcFirstLoad("gameCard1");
						}
						itemMc.gotoAndStop(basic.picType);
						var animationItem:MovieClip = playGameAnimation("variableDie", gridX, gridY);
						animationItem.addChild(itemMc);
						
						Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_BUBBLE, null, Fibre.SOUND_NOTIFICATION);
					}
					else if(basic.blockType == BasicObject.BLOCK_GIFT_ITEM
						|| basic.blockType == BasicObject.BLOCK_JELLY_ITEM
						|| basic.blockType == BasicObject.BLOCK_CLOCK_ITEM
					)
					{
						
						if(basic.blockType == BasicObject.BLOCK_JELLY_ITEM)
						{
							playDisappearAnimation(getBasicGrid(basic, _animationSeleted), gridX, gridY);
							_swapLogic.board.stepItemsManager.removeJellyItem(basic);
						}
						else if(basic.blockType == BasicObject.BLOCK_CLOCK_ITEM)
						{
							playGameAnimation("putongDestory", gridX, gridY, true);
							_swapLogic.board.stepItemsManager.removeClockItem(basic);
						}
						else
						{
							playGameAnimation("putongDestory", gridX, gridY, true);
						}
					}
					else if(item.special == ItemType.LINE)
					{
						playGameAnimation("lineEffect", gridX, gridY, true);
						Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS1, null, Fibre.SOUND_NOTIFICATION);
					}
					else if(item.special == ItemType.COLUMN)
					{
						playGameAnimation("columnEffect", gridX, gridY, true);
						Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS1, null, Fibre.SOUND_NOTIFICATION);
					}
					else if(item.special == ItemType.DIAMOND)
					{
						playGameAnimation("level3Bomb", gridX, gridY, true);
						Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS2, null, Fibre.SOUND_NOTIFICATION);
					}
					else if(item.special == ItemType.COLOR)
					{
						playGameAnimation("mouguAbsorb", gridX, gridY, true);
						Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS6, null, Fibre.SOUND_NOTIFICATION);
					}
					else 
					{
						if(item.isDeleteBySpecialEffectStatus == DataRecorder.SCORE_SWAP_C_C)
						{
							playGameAnimation("putongDestorySimple", gridX, gridY, true);
						}
						else
						{
							var parameter:int = comboTimes;
							if(comboTimes > 8)
							{
								parameter = 8;
							}
							var soundEffect:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION" + parameter;
							
							
							Fibre.getInstance().sendNotification(soundEffect, null, Fibre.SOUND_NOTIFICATION);
							playGameAnimation("putongDestory", gridX, gridY, true);
						}
						
						
					}
						
					gridObject.basicObjects.splice(i, 1);
				}
				else if(basic.isMoveCollect())
				{
					gridObject.basicObjects.splice(i, 1);
					Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_COLLECT_ITEM, null, Fibre.SOUND_NOTIFICATION);
				}
				else if(basic.blockType == BasicObject.BLOCK_TYPE_ICE)
				{
					if(item.isFly)
					{
						continue;
					}
					CONFIG::debug
					{
						TRACE_BOTTOM_ITEM("gridX: "+ gridX + " gridY: "+ gridY + " level: "+basic.level);
					}
					
					playGameAnimation("iceDie", gridX, gridY);
					Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_DESTORY_ICE, null, Fibre.SOUND_NOTIFICATION);
					if(basic.level > 0)
					{
						gridObject.pushObject(new BasicObject(basic.id - 1));
					}
					else
					{
						gridObject.basicObjects.splice(i, 1);
					}
				}
				else if(basic.blockType == BasicObject.BLOCK_WALL || basic.blockType == BasicObject.BLOCK_SMALL_HILL)
				{
					if(basic.blockType == BasicObject.BLOCK_WALL)
					{
						CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_DESTORY_WALL);
					}
					else if(basic.blockType == BasicObject.BLOCK_SMALL_HILL)
					{
						CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_GRASS);
					}
					
					if(basic.level > 0)
					{
						gridObject.pushObject(new BasicObject(basic.id - 1));
						
						if(basic.blockType == BasicObject.BLOCK_WALL)
						{
							playGameAnimation("stoneDie", gridX, gridY);							
						}
					}
					else
					{
						gridObject.basicObjects.splice(i, 1);
						
						if(basic.blockType == BasicObject.BLOCK_SMALL_HILL)
						{
							var topGrid:BasicObject = item.getTopBasicObjectNotContainObstacle();
							if(topGrid != null && topGrid.id == ConstantItem.GRID_ID_DIAMOND)
							{
								var index:int = gridObject.basicObjects.indexOf(topGrid);
								gridObject.basicObjects.splice(index, 1);
								
								_swapLogic.board.dataRecord.addCollectItem(topGrid.id);
								_swapLogic.board.dataRecord.removeBasic(topGrid, comboTimes, item);
							}
							
						}
						else
						{
							playGameAnimation("destoryStoneLevel1", gridX, gridY);
						}
					}
					
					break;
				}
				else if(basic.blockType == BasicObject.BLOCK_SLIVER_COIN)
				{
					playGameAnimation("coinDie", gridX, gridY)
					gridObject.basicObjects.splice(i, 1);
					_swapLogic.board.dataRecord.addSliverCoin();
					Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_SILVER_AWARD, null);
				}
				else if(basic.isObstacle())
				{
					
				}
			}
			
			if(gridObject.basicObjects.length > 0)
			{
				itemChange = new Item(gridX, gridY);
				itemChange.setGridObject(gridObject, this);
			}
			drawGridObject(gridX, gridY);
						
			if(itemChange != null && itemChange.normalBasic == null)
			{
				itemChange = null;
			}
			return itemChange;
		
		}
		
		public function switchMade(swapInfo:SwapInfo, state:int) : void
		{
			if(state == Board.SWITCHSTATE_SUCCESS)
			{
				updateStep();
			}

		}		
		
		public function beginMove(item:Item, dstX:int, dstY:int, moveComplete:Function) : void
		{
			removeNormalItemUI(item.x, item.y, item.isFindBug());
			
			var mcParent:MovieClip /*= mc[MC_GRID][LINE_PRE + item.y][COL_PRE + item.x]["pos"]*/;
			
			item.x = dstX;
			item.y = dstY;
			item.busy = true;
			
			var basicObject:BasicObject = getMoveBasicObject(item, dstX, dstY/*, true*/);
			var mcGrid:MovieClip = getBasicGrid(basicObject, _animationSeleted);

			_moveMiddleLayer.addChild(mcGrid);
			mcGrid.x = item.srcX * GRID_WIDHT;
			mcGrid.y = item.srcY * GRID_HEIGHT;
			
			var dx:Number = dstX * GRID_WIDHT;
			var dy:Number = dstY * GRID_HEIGHT;
			
			var dropSpeed:Number = 0.2;
			
			TweenMax.to(mcGrid, dropSpeed, {x:dx, y:dy, onComplete:function():void
			{
				if(mc == null)
				{
					return;
				}
				mcParent = mc[MC_GRID][LINE_PRE + dstY][COL_PRE + dstX][GRID_POS_MIDDLE];
				DisplayUtil.removeAllChildren(mcParent);
				mcGrid.x = 0;
				mcGrid.y = 0;
				mcParent.addChild(mcGrid);
//				DisplayUtil.replaceChild(mcParent, mcGrid, null, basicObject.uiIndex);
				
				
				item.busy = false;
				
				if(moveComplete != null)
				{
					moveComplete();
				}
				
				CONFIG::debug
				{
					TRACE_LOG("addItemUI: from swapInfo x: "+ dstX +" y: "+ dstY + " color: "+ item.color);
				}
				
			}
			});
			
		}
		
		public function bounced(param1:Boolean) : void
		{
		/*	if (!param1)
			{
				return;
			}
			var _loc_2:* = Math.abs(this._item.ya);
			if (_loc_2 < 0.1)
			{
				return;
			}
			this.playCandyLandSound(this._item.x, (_loc_2 + 0.1) * 2);
			this._bounceTicks = 15;
			this._bounceForce = this._item.ya;
			return;*/
		}
		public function get currentLevelData():LevelData
		{
			return _currentLevelGridData;
		}

		public function get currentLevelOriginData():Level
		{
			return _currentLevelOriginData;
		}


	}
}
import flash.geom.Point;

class TransPoint
{
	public var startPoint:Point;
	public var endPoint:Point;
	public function TransPoint(startX:int, startY:int, endX:int, endY:int)
	{
		startPoint = new Point(startX, startY);
		endPoint = new Point(endX, endY);
	}
	
	
}