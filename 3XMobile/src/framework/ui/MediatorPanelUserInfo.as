package framework.ui
{
	import com.game.consts.ConstMoneyType;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfFriendList;
	import com.game.module.CDataOfFunctionList;
	import com.game.module.CDataOfLocal;
	import com.greensock.TweenLite;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemAbstract;
	import com.ui.item.CItemEnergy;
	import com.ui.item.CItemEnergyTimer;
	import com.ui.item.CItemFriend;
	import com.ui.item.CItemFunctionEntry;
	import com.ui.item.CItemMoney;
	import com.ui.item.CItemOnlineAward;
	import com.ui.item.CItemStar;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CKeyboardUtil;
	import com.ui.widget.CWidgetBottomFriendList;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framework.datagram.DatagramNormal;
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.model.DataManager;
	import framework.model.FullScreenHandler;
	import framework.resource.faxb.functionopen.FunctionConfig;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.sound.SoundHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	/**
	 * @author caihua
	 * @comment 主场景面板
	 * 创建时间：2014-6-9 上午9:44:01 
	 */
	public class MediatorPanelUserInfo extends MediatorBase
	{
		//树叶
		private var _progressSymbol:MovieClip ;
		//树干
		private var _progressTree:MovieClip;
		//全屏按钮
		private var _btnFullScreen:CButtonCommon;
		//声音按钮
		private var _btnMusicWorld:CButtonCommon;
		//音效按钮
		private var _btnMusicGame:CButtonCommon;
		
		/*********************functionopen***********************/
		//邀请好友
		private var _itemInviteBtn:CItemFunctionEntry;
		//抢话费
		private var _itemRobBtn:CItemFunctionEntry;
		//一键补满体力
		private var _itemSupplementBtn:CItemFunctionEntry;
		//在线奖励
		private var _itemOnlineBtn:CItemOnlineAward;
		//精彩活动
		private var _itemActiveBtn:CItemFunctionEntry;
		//领奖中心
		private var _itemRewardBtn:CItemFunctionEntry;
		//好友消息
		private var _itemFriendMegBtn:CItemFunctionEntry;
		//奖状图标
		private var _itemDiplomaBtn:CItemFunctionEntry;
		//连续登陆
		private var _itemSeriesLoginBtn:CItemFunctionEntry;
		//小信封
		private var _itemMailBtn:CItemFunctionEntry;
		//论坛
		private var _itemForumBtn:CItemFunctionEntry;
		/*********************functionopen***********************/
		
		//拖拽状态标记
		private var _isDragging:Boolean = false;
		//点击初始y
		private var _orignaly:Number = 0;
		//自己的头像
		private var _selfItem:CItemFriend;
		//下面的好友面板
		private var _friendListPanel:CWidgetBottomFriendList;
		
		//星值
		private var _itemStar:CItemStar;
		//金豆
		private var _goldItem:CItemMoney;
		//银豆
		private var _silverItem:CItemMoney;
		//体力
		private var _energyItem:CItemEnergy;
		//倒计时控件
		private var _timeRemainItem:CItemEnergyTimer;
		
		private var _onlineTF:TextField;
		
		
		public static const MAX_X:Number = -39.15;
		public static const MIN_X:Number = -39.15;
		
		public static const MAX_Y:Number = 318.95;
		public static const MIN_Y:Number = 24;
		
		public static const DAY_ENG_COUNT:int = 3;
		
		private var _hasTip:Boolean;
		
		private var _map:Dictionary;
		
		public function MediatorPanelUserInfo()
		{
			super(ConstantUI.USER_INFO_PANEL,ConstantUI.USER_INFO_PANEL , false , false);
		}
		
		override protected function start(d:DatagramView):void
		{
			_map = new Dictionary();
			
			__specMc();
			
			__initEvent();
			
			__drawEntry();
			
			if(DataUtil.instance.currentPos == -1)
			{
				__locateCurrent();
			}
			else
			{
				//确定要定位的位置
				if(CDataManager.getInstance().dataOfGameUser.curLevel - DataUtil.instance.currentPos <= 1)
				{
					__locateCurrent();
				}
				else
				{
					CBaseUtil.viewPortGotoLevel(DataUtil.instance.currentPos , false);
				}
			}
			
			_progressSymbol.hint.alpha = 0;
			
			
			//请求补体力活动
			NetworkManager.instance.sendServerActivityInfo(1);
			//请求在线礼包
			NetworkManager.instance.sendServerActivity(0);
			//请求连续登陆
			NetworkManager.instance.sendServerActivity(1);
			
			CDataManager.getInstance().dataOfFunctionList.openFunction();
		}
		
		private function __onTotalUser(d:Notification):void
		{
			var total:int = Number(DataUtil.instance.totalUser) * 2.5+666
			
			_onlineTF.text = ""+total;
		}
		
		private function __onShowEnergy(d:Notification):void
		{
			_itemSupplementBtn.visible = true;
			
			this._itemSupplementBtn.setTipsNumTxt(DAY_ENG_COUNT - int(d.data));
		}
		
		private function __onUpdateUserData(d:Notification):void
		{
			_goldItem.update();
			_silverItem.update();
			_energyItem.update();
			_itemStar.update();
		}
		
		private function __drawEntry():void
		{
			this._itemInviteBtn = new CItemFunctionEntry();
			this._itemInviteBtn.setEntryBtn("main_morefriend");
			_itemInviteBtn.x = 5;
			_itemInviteBtn.y = 75;
			mc.addChild(this._itemInviteBtn);
			
			
			this._itemMailBtn = new CItemFunctionEntry();
			this._itemMailBtn.setEntryBtn("z_main_mail");
			_itemMailBtn.x = 5;
			this._itemMailBtn.y = 145;
			mc.addChild(this._itemMailBtn);
			
			
			this._itemForumBtn = new CItemFunctionEntry();
			this._itemForumBtn.setEntryBtn("z_n1_main_forum");
			this._itemForumBtn.y = 215;
			_itemForumBtn.x = 5;
			mc.addChild(this._itemForumBtn);
			
			
			this._itemFriendMegBtn = new CItemFunctionEntry();
			this._itemFriendMegBtn.setEntryBtn("main_friendmessage");
			this._itemFriendMegBtn.y = 285;
			this._itemFriendMegBtn.x = 5;
			mc.addChild(this._itemFriendMegBtn);
			
			this._itemDiplomaBtn = new CItemFunctionEntry();
			this._itemDiplomaBtn.setEntryBtn("z_main_honor");
			this._itemDiplomaBtn.x = 5;
			this._itemDiplomaBtn.y = 355;
			
			if(DataUtil.instance.currentDiplomaNum > 0)
			{
				this._itemDiplomaBtn.setTipsNumTxt(DataUtil.instance.currentDiplomaNum);
			}else
			{
				this._itemDiplomaBtn.visible = false;
			}
			mc.addChild(this._itemDiplomaBtn);
			
			this._itemRewardBtn = new CItemFunctionEntry();
			this._itemRewardBtn.setEntryBtn("main_giftcenter");
			_itemRewardBtn.x = 190;
			_itemRewardBtn.y = 0;
			mc.addChild(this._itemRewardBtn);
			
			
			this._itemActiveBtn = new CItemFunctionEntry();
			this._itemActiveBtn.setEntryBtn("z_n92_activity");
			this._itemActiveBtn.x = 255;
			_itemActiveBtn.y = -1;
			mc.addChild(this._itemActiveBtn);
			
			
			this._itemRobBtn = new CItemFunctionEntry();
			this._itemRobBtn.setEntryBtn("z_n4_area");
			this._itemRobBtn.setBackEffect("shiningEffect", new Point(-15, -18));
			this._itemRobBtn.setEffect("starEffect", new Point(0, 0));
			this._itemRobBtn.x = 325;
			_itemRobBtn.y = -2;
			mc.addChild(this._itemRobBtn);
			
			
			this._itemSupplementBtn = new CItemFunctionEntry();
			this._itemSupplementBtn.setEntryBtn("z_n2_main_onekeyfillup");
			this._itemSupplementBtn.x = 400;
			_itemSupplementBtn.y = -2;
			this._itemSupplementBtn.visible = false;
			mc.addChild(this._itemSupplementBtn);
			
			
			this._itemSeriesLoginBtn = new CItemFunctionEntry();
			this._itemSeriesLoginBtn.setEntryBtn("z_n95_serieslogin");
			this._itemSeriesLoginBtn.x = 390;
			this._itemSeriesLoginBtn.y = -2;
			this._itemSeriesLoginBtn.visible = false;
			mc.addChild(this._itemSeriesLoginBtn);
			
			
			this._itemOnlineBtn = new CItemOnlineAward();
			this._itemOnlineBtn.x = 465;
			_itemOnlineBtn.y = -2;
			this._itemOnlineBtn.visible = false;
			mc.addChild(this._itemOnlineBtn);
			
			_regFunction("func_invite" , this._itemInviteBtn);
			_regFunction("func_mail" , this._itemMailBtn);
			_regFunction("func_forum" , this._itemForumBtn);
			_regFunction("func_friendmessage" , this._itemFriendMegBtn);
			_regFunction("func_honor" , this._itemDiplomaBtn);
			_regFunction("func_gift" , this._itemRewardBtn);
			_regFunction("func_activity" , this._itemActiveBtn);
			_regFunction("func_match" , this._itemRobBtn);
			_regFunction("func_onkeyfillup" , this._itemSupplementBtn);
			_regFunction("func_serieslogin" , this._itemSeriesLoginBtn);
			_regFunction("func_online" , this._itemOnlineBtn);
			
			__initFunctionEntry();
			
			this.onUpdateFriendMsg(null);
		}
		
		private function __initFunctionEntry():void
		{
			var dataOfFunctionList:CDataOfFunctionList = CDataManager.getInstance().dataOfFunctionList;
			for(var key:String in _map)
			{
				if(__inFunctionMap(key))
				{
					DisplayObjectContainer(_map[key]).visible = false;
					if(dataOfFunctionList.openList[key])
					{
						_map[key].visible = true;
					}
					else
					{
						_map[key].visible = false;
					}
				}
			}
			
		}
		
		/**
		 * 有没有配置这个key
		 */
		private function __inFunctionMap(key:String):Boolean
		{
			var len:int = DataManager.getInstance().functionList.functionConfig.length;
			for(var i:int =0 ; i < len ; i++)
			{
				var config:FunctionConfig = DataManager.getInstance().functionList.functionConfig[i];
				if(config.key == key)
				{
					return true;
				}
			}
			return false;
		}
		
		private function _regFunction(key:String , func:CItemAbstract):void
		{
			_map[key] = func;
		}
		
		private function _fetchKey(key:String):DisplayObjectContainer
		{
			return _map[key];
		}
		
		private function __onMailUnread(data:Object):void
		{
			var n:Notification = new Notification();
			n.data = data.unread_count;
			this.__onUpdateMail(n);
		}
		
		private function __locateCurrent():void
		{
			__gotoCurrentLevel();
			
			DataUtil.instance.currentPos = CDataManager.getInstance().dataOfGameUser.curLevel;
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			CBaseUtil.viewPortGotoLevel(CDataManager.getInstance().dataOfGameUser.curLevel);
		}
		
		private function __gotoCurrentLevel():void
		{
			//先到上一关
			CBaseUtil.viewPortGotoLevel(DataUtil.instance.currentPos , false);
			var currentLevel:int = CDataManager.getInstance().dataOfGameUser.curLevel;
			//跑到当前关
			CBaseUtil.viewPortGotoLevel(currentLevel);
			
			CBaseUtil.sendEvent(GameNotification.EVENT_PLAY_TO);
		}
		
		private function __onViewPortMove(d:Notification):void
		{
			var level:int = d.data.level;
			var useTween:Boolean = d.data.useTween;
			
			__gotoLevel(level , useTween);
		}
		
		private function __gotoLevel(level:int , useTween:Boolean):void
		{
			var currentPercent:Number = CBaseUtil.calcLevelPercent(level - 1);
			
			updateProgressBar(1 - currentPercent);
			
			__notifyProgress(1 - currentPercent , useTween);
			
			CBaseUtil.sendEvent(GameNotification.EVENT_PLAY_TO);
		}
		
		private function __specMc():void
		{
			_progressSymbol = mc.bar.mc_progresssymbol;
			_progressTree = mc.bar.mc_progresstree;
			
			_btnFullScreen = new CButtonCommon("fullscreen");
			_btnMusicWorld = new CButtonCommon("musicgame");
			
			_btnMusicWorld.selected = (CDataManager.getInstance().dataOfLocal.getKey(CDataOfLocal.LOCAL_KEY_MUSIC_WORLD) == 1)
			
			_btnMusicGame = new CButtonCommon("music");
			
			_btnMusicGame.selected = (CDataManager.getInstance().dataOfLocal.getKey(CDataOfLocal.LOCAL_KEY_MUSIC_EFFECT) == 1)
			
			mc.musicgamepos.addChild(_btnMusicGame);
			mc.musicworldpos.addChild(_btnMusicWorld);
			mc.fullscreenpos.addChild(_btnFullScreen);
			
			_friendListPanel = new CWidgetBottomFriendList();
			
			mc.friendpanelpos.addChild(_friendListPanel);
			
			_goldItem = new CItemMoney(ConstMoneyType.MONEY_TYPE_GOLD);
			_silverItem = new CItemMoney(ConstMoneyType.MONEY_TYPE_SILVER);
			_energyItem = new CItemEnergy();
			_itemStar = new CItemStar();
			
			
			mc.posgold.addChild(_goldItem);
			mc.possilver.addChild(_silverItem);
			mc.poscoin.addChild(_energyItem);
			mc.poscoin.x += 15;
			
			_itemStar.x = 10;
			_itemStar.y = 5;
			mc.addChild(_itemStar);
			
			_timeRemainItem = new CItemEnergyTimer();
			mc.timepos.addChild(_timeRemainItem);
			mc.timepos.x += 40;
			
			_onlineTF = CBaseUtil.getTextField(mc.onlineitem.onlinetf ,  14 ,0xfcf895 ,"left");
			mc.onlineitem.mouseChildren = false;
			
			//画自己
			_selfItem = new CItemFriend(CDataManager.getInstance().dataOfGameUser.userId , "item.friend.bar", new Point(25,25));
			
			_selfItem.x = mc.bar.logopos.x - 12;
			_selfItem.y = mc.bar.logopos.y;
			
			_selfItem.mouseChildren = false;
			
			mc.bar.addChild(_selfItem);
				
			var currentPercent:Number = CBaseUtil.calcLevelPercent(CDataManager.getInstance().dataOfGameUser.curLevel - 1);
			_selfItem.y = MAX_Y - currentPercent * (MAX_Y - MIN_Y);
			
			_selfItem.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0 , true);
			
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
					if(btn.__name == "fullscreen")
					{
						if(btn.selected)
						{
							CBaseUtil.showTip("退出全屏" , btn.localToGlobal(new Point(btn.x , btn.y)) , null, true , "left" );
						}
						else
						{
							CBaseUtil.showTip("全屏" , btn.localToGlobal(new Point(btn.x, btn.y)) , null, true , "left" );
						}
					}
					else if(btn.__name == "musicgame")
					{
						if(btn.selected)
						{
							CBaseUtil.showTip("打开音乐" , btn.localToGlobal(new Point(btn.x , btn.y)) , null, true , "left" );
						}
						else
						{
							CBaseUtil.showTip("关闭音乐" , btn.localToGlobal(new Point(btn.x , btn.y)) , null, true , "left" );
						}
					}
					else if(btn.__name == "music")
					{
						if(btn.selected)
						{
							CBaseUtil.showTip("打开音效" , btn.localToGlobal(new Point(btn.x , btn.y)), null, true , "left"  );
						}
						else
						{
							CBaseUtil.showTip("关闭音效" , btn.localToGlobal(new Point(btn.x , btn.y)) , null, true , "left" );
						}
					}
					else if(btn.__name == "music")
					{
						if(btn.selected)
						{
							CBaseUtil.showTip("打开音效" , btn.localToGlobal(new Point(btn.x, btn.y)) , null, true , "left" );
						}
						else
						{
							CBaseUtil.showTip("关闭音效" , btn.localToGlobal(new Point(btn.x, btn.y)) , null, true , "left" );
						}
					}
				}
				else
				{
					_hasTip = false;
					CBaseUtil.closeTip()
				}
			}
			else if(event.target.name == "onlineitem")
			{
				if(!_hasTip)
				{
					_hasTip = true;
					CBaseUtil.showTip("与你并肩作战的人数" , event.target.parent.localToGlobal(new Point(event.target.x - 16 , event.target.y)));
				}
				else
				{
					_hasTip = false;
					CBaseUtil.closeTip()
				}
			}
		}
		
		private function __initEvent():void
		{
			_progressSymbol.addEventListener(TouchEvent.TOUCH_BEGIN , __onMouseDown , false, 0 ,true);
			
			_progressTree.addEventListener(TouchEvent.TOUCH_TAP , __onChooseProgress , false , 0 , true);
			//全屏
			_btnFullScreen.addEventListener(TouchEvent.TOUCH_TAP , __onToggleFullScreen , false , 0 , true);
			_btnMusicWorld.addEventListener(TouchEvent.TOUCH_TAP , __onToggleMusicWorld , false , 0 , true);
			_btnMusicGame.addEventListener(TouchEvent.TOUCH_TAP , __onToggleMusicGame , false , 0 , true);
			//处理世界地图移动
			registerObserver(GameNotification.EVENT_WORLD_MAP_MOVED , __onMapMoved);
			registerObserver(GameNotification.EVENT_UPDATE_MAIL , __onUpdateMail);
			registerObserver(GameNotification.EVENT_GET_FRIENDLIST , onUpdateFriendMsg);
			registerObserver(GameNotification.EVENT_MESSAGE_NUM_CHANGE , onMessageNumChange);
			
			CBaseUtil.regEvent(GameNotification.EVENT_GAME_DATA_UPDATE , __onUpdateUserData);
			CBaseUtil.regEvent(GameNotification.EVENT_SCENE_VIEW_PORT_MOVE , __onViewPortMove);
			CBaseUtil.regEvent(GameNotification.EVENT_SHOW_ENERGY , __onShowEnergy);
			CBaseUtil.regEvent(GameNotification.EVENT_TOTAL_ONLINE_USER , __onTotalUser);
			CBaseUtil.regEvent(GameNotification.EVENT_SHOW_DIPLOMA , __onUpdateDiploma);
			CBaseUtil.regEvent(GameNotification.EVENT_ACTIVITY_ONLINE , __onShowOnline);
			CBaseUtil.regEvent(GameNotification.EVENT_FUNCTION_OPEN_PANEL , __showFunctionOpenPanel);
			CBaseUtil.regEvent(GameNotification.EVENT_FUNCTION_OPEN_ANI , __showFunctionItemAni);
			
			CBaseUtil.regEvent(GameNotification.EVENT_ACTIVITY_LOGIN , __onShowSeriesLogin);
			
			_itemStar.addEventListener(TouchEvent.TOUCH_TAP , __onClickStar , false , 0 , true);
			//监听键盘
			CKeyboardUtil.setkeyCodeDownUp([Keyboard.ESCAPE], __onKeyUp);
		}
		
		private function __showFunctionOpenPanel(d:Notification):void
		{
			var config:FunctionConfig = d.data as FunctionConfig;
			
			CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal("common.function.open" , true ,{config:config}));
		}
		
		private function __showFunctionItemAni(d:Notification):void
		{
			var config:FunctionConfig = d.data.injectParameterList["config"] as FunctionConfig;
			var mv:CItemAbstract = _map[config.key];
			if(!mv)
			{
				return;
			}
			mv.x = ConstantUI.currentScreenWidth /2;
			mv.y = ConstantUI.currentScreenHeight /2;
			mv.mouseEnabled = false;	
			mv.visible = true;
			mc.addChild(mv);
			CBaseUtil.delayCall(function():void
			{
				TweenLite.to(mv , 1 , {x:config.x , y:config.y , onComplete:function():void{
					CBaseUtil.sendEvent( GameNotification.EVENT_FUNCTION_OPEN_ANI_COMPLETE, config.key );						
					mv.mouseEnabled = true;
				}});
			},1);
		}
		
		private function __onShowSeriesLogin(d:Notification):void
		{
			_itemSeriesLoginBtn.visible = true;
		}
		
		private function __onUpdateDiploma(d:Notification):void
		{
			this._itemDiplomaBtn.visible = true;
			this._itemDiplomaBtn.setTipsNumTxt(DataUtil.instance.currentDiplomaNum);
		}
		
		private function __onShowOnline(d:Notification):void
		{
			if(CDataManager.getInstance().dataOfFunctionList.isFunctionOpen("func_online"))
			{
				this._itemOnlineBtn.visible = d.data.flog as Boolean;
				this._itemOnlineBtn.setStatue(d.data.cd as int);
			}
		}
		
		protected function __onClickStar(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_STAR_REWARD));
		}
		
		protected function __onKeyUp(event:KeyboardEvent, keyword:int):void
		{
			if(event.type == CKeyboardUtil.KEY_DOWN)
			{
				switch(keyword)
				{
					case Keyboard.ESCAPE:
						if(FullScreenHandler.isFullScreenMode)
						{
							_btnFullScreen.selected = !_btnFullScreen.selected;
							FullScreenHandler.instance.fullScreenOut();
							GameEngine.getInstance().stage.scaleMode = StageScaleMode.NO_SCALE;
							FullScreenHandler.instance.resizeHandle();
						}
						break;
				}
			}
		}
		
		protected function __onUpdateMail(n:Notification):void
		{
			TRACE_LOG("小信封数量："+ n.data);
			this._itemMailBtn.setTipsNumTxt(n.data as int);
		}
		
		protected function __onToggleMusicGame(event:TouchEvent):void
		{
			_btnMusicGame.selected = !_btnMusicGame.selected;
			
			CDataManager.getInstance().dataOfLocal.setKey(CDataOfLocal.LOCAL_KEY_MUSIC_EFFECT , _btnMusicGame.selected ? 1 : 0);
			
			SoundHandler.instance.setSoundStatus(!_btnMusicGame.selected);
		}
		
		protected function __onToggleMusicWorld(event:TouchEvent):void
		{
			_btnMusicWorld.selected = !_btnMusicWorld.selected;
			
			CDataManager.getInstance().dataOfLocal.setKey(CDataOfLocal.LOCAL_KEY_MUSIC_WORLD , _btnMusicWorld.selected ? 1 : 0);
			
			SoundHandler.instance.setMusicStatus(!_btnMusicWorld.selected);
		}
		
		protected function __onToggleFullScreen(event:TouchEvent):void
		{
			_btnFullScreen.selected = !_btnFullScreen.selected;
			
			if(FullScreenHandler.isFullScreenMode)
			{
				FullScreenHandler.instance.fullScreenOut();
				this.mc.stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			else
			{
				FullScreenHandler.instance.fullScreenIn();
				this.mc.stage.scaleMode = StageScaleMode.EXACT_FIT;
			}
			
			FullScreenHandler.instance.resizeHandle();
		}
		
		/**
		 * 点击树干选择地图位置
		 */
		protected function __onChooseProgress(event:TouchEvent):void
		{
			event.localY = event.localY < MIN_Y ? MIN_Y : event.localY;
			event.localY = event.localY > MAX_Y ? MAX_Y : event.localY;
			
			var percent:Number = Math.abs(event.localY - MIN_Y) / (MAX_Y - MIN_Y);
			
			__notifyProgress(percent);
			updateProgressBar(percent);
		}
		
		protected function __onMouseOut(event:TouchEvent):void
		{
			if(_isDragging)
			{
				__fixPos();
				_progressSymbol.stopDrag();
				_isDragging = false;
			}
		}
		
		protected function __onMouseMove(event:TouchEvent):void
		{
			if(_isDragging)
			{
				var mousey:Number = GameEngine.getInstance().stage.mouseY;
				this._progressSymbol.y = _orignaly + mousey;
				
				__fixPos();
				
				var nowY:Number = _progressSymbol.y;
				
				var percent:Number = Math.abs(nowY - MIN_Y) / (MAX_Y - MIN_Y);
				
				__notifyProgress(percent);
			}
		}
		
		/**
		 * 通知世界地图改变
		 */
		private function __notifyProgress(progress:Number , useTween:Boolean = true):void
		{
			Fibre.getInstance().sendNotification(GameNotification.EVENT_PROGRESS_MAP_MOVED , new DatagramNormal({percent: progress , useTween:useTween}));
		}
		
		private function __fixPos():void
		{	
			_progressSymbol.y = _progressSymbol.y < MIN_Y ? MIN_Y : _progressSymbol.y;
			_progressSymbol.y = _progressSymbol.y > MAX_Y ? MAX_Y : _progressSymbol.y;
		}
		
		protected function __onMouseUp(event:TouchEvent):void
		{
			__fixPos();
			_isDragging = false;
			
			GameEngine.getInstance().stage.removeEventListener(TouchEvent.TOUCH_END , __onMouseUp);
			GameEngine.getInstance().stage.removeEventListener(TouchEvent.TOUCH_MOVE , __onMouseMove);
		}
		
		protected function __onMouseDown(event:TouchEvent):void
		{
			_isDragging = true;
			_orignaly = this._progressSymbol.y - GameEngine.getInstance().stage.mouseY;
			GameEngine.getInstance().stage.addEventListener( TouchEvent.TOUCH_MOVE, __onMouseMove, false, 0 ,true);
			GameEngine.getInstance().stage.addEventListener( TouchEvent.TOUCH_END, __onMouseUp, false, 0 ,true);
		}
		
		public function onUpdateFriendMsg(n:Notification):void
		{
			var friendList:CDataOfFriendList = CDataManager.getInstance().dataOfFriendList;
			var num:int = friendList.msgFriendSendMeGiftList.length +  friendList.msgFriendSendMeGift.length + friendList.msgFriendAskToMakeFriendsList.length + friendList.msgFriendAskMeToSendList.length;
			this._itemFriendMegBtn.setTipsNumTxt(num);
		}
		
		public function dispose():void
		{
			_progressSymbol.removeEventListener(TouchEvent.TOUCH_BEGIN , __onMouseDown);
			GameEngine.getInstance().stage.removeEventListener(TouchEvent.TOUCH_END , __onMouseUp);
			GameEngine.getInstance().stage.removeEventListener(TouchEvent.TOUCH_MOVE , __onMouseMove);
		}
		
		override protected function end():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_WORLD_MAP_MOVED , __onMapMoved);
			CBaseUtil.removeEvent(GameNotification.EVENT_UPDATE_MAIL , __onUpdateMail);
			CBaseUtil.removeEvent(GameNotification.EVENT_GET_FRIENDLIST , onUpdateFriendMsg);
			CBaseUtil.removeEvent(GameNotification.EVENT_MESSAGE_NUM_CHANGE , onMessageNumChange);
			
			CBaseUtil.removeEvent(GameNotification.EVENT_GAME_DATA_UPDATE , __onUpdateUserData);
			CBaseUtil.removeEvent(GameNotification.EVENT_SCENE_VIEW_PORT_MOVE , __onViewPortMove);
			CBaseUtil.removeEvent(GameNotification.EVENT_SHOW_ENERGY , __onShowEnergy);
			CBaseUtil.removeEvent(GameNotification.EVENT_TOTAL_ONLINE_USER , __onTotalUser);
			CBaseUtil.removeEvent(GameNotification.EVENT_SHOW_DIPLOMA , __onUpdateDiploma);
			CBaseUtil.removeEvent(GameNotification.EVENT_ACTIVITY_ONLINE , __onShowOnline);
			CBaseUtil.removeEvent(GameNotification.EVENT_FUNCTION_OPEN_PANEL , __showFunctionOpenPanel);
			CBaseUtil.removeEvent(GameNotification.EVENT_ACTIVITY_LOGIN , __onShowSeriesLogin);
			CBaseUtil.removeEvent(GameNotification.EVENT_FUNCTION_OPEN_ANI , __showFunctionItemAni);
		}
		
		private function onMessageNumChange(d:Notification):void
		{
			this._itemFriendMegBtn.setTipsNumTxt(this._itemFriendMegBtn.num-=1);
			
		}
		
		/**
		 * 响应来自世界地图的改变事件
		 */
		private function __onMapMoved(notification:Notification):void
		{
			var params:Object = (notification.data as DatagramNormal).getParams();
			updateProgressBar(params.percent);	
		}
		
		private function updateProgressBar(percent:Number):void
		{
			_progressSymbol.y = (MAX_Y - MIN_Y) * percent + MIN_Y;
		}
	}
}