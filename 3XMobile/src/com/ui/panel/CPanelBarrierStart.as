package com.ui.panel
{
	import com.game.consts.ConstGlobalConfig;
	import com.game.consts.ConstIcon;
	import com.game.event.GameEvent;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.game.module.CDataOfStarInfo;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemFlowTip;
	import com.ui.item.CItemTool;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetAniNumber;
	import com.ui.widget.CWidgetBarrierFriendList;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewChooseLevel;
	import framework.fibre.core.Fibre;
	import framework.resource.faxb.levelproperty.ShowItem;
	import framework.rpc.DataUtil;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	import qihoo.triplecleangame.protos.PBStarArray;

	/**
	 * @author caihua
	 * @comment 关卡开始
	 * 创建时间：2014-6-10 下午5:35:07 
	 */
	public class CPanelBarrierStart extends CPanelAbstract
	{
		private var _friendList:CWidgetBarrierFriendList;
		private var _closeBtn:CButtonCommon;
		
		private var _startBtn:CButtonCommon;
		
		private var _level:int;
		private var userData:CDataOfGameUser;
		private var _levelData:PBStarArray;
		private var _starNum:int;
		private var _flowTipItem:CItemFlowTip;
		
		private var _itemList:Array;
		private var starInfo:CDataOfStarInfo;
		private var _hasTip:Boolean;
		private var _numFrames:Array;

		private var title:TextField;
		
		public function CPanelBarrierStart()
		{
			super("dialog.barrier.start");
		}
		
		override protected function drawContent():void
		{
			__initData();
			
			__specMc();
			
			__drawBg();
			
			__drawLevelMC();
			
			__drawScore();
			
			__drawStar();
			
			__initEvents();
			
			__drawStartItems();
			
			__drawTaskIcon();
		}
		
		//任务按钮
		private function __drawTaskIcon():void
		{
			var iconId:int = CDataManager.getInstance().dataOfLevel.levelConfig.starIcon;
			var icon:MovieClip = ResHandler.getMcFirstLoad("common.icon");
			
			icon.x =  title.x + title.width + 5;
			
			if(iconId == 50)
			{
				icon.gotoAndStop(ConstIcon.ICON_TYPE_MIXTURE);
				icon.y = mc.textbg.y + (mc.textbg.height - icon.width) / 2 ;
				mc.addChild(icon);
			}
			else if(iconId == 100)
			{
				icon.gotoAndStop(ConstIcon.ICON_TYPE_STAR);
				icon.y = mc.textbg.y + (mc.textbg.height - icon.width) /2 - 3 ;
				mc.addChild(icon);
			}
			else
			{
				var cardMc:Sprite = CBaseUtil.getCardMc(iconId);
				cardMc.scaleX = cardMc.scaleY = 0.8;
				
				cardMc.x =  title.x + title.width + 5;
				cardMc.y = mc.textbg.y + (mc.textbg.height - cardMc.width) / 2 - 4 ;
				
				if(cardMc is MovieClip)
				{
					cardMc.y -= 3;
				}
				
				mc.addChild(cardMc);
			}
		}
		
		private function __drawStartItems():void
		{
			var items:Vector.<ShowItem> = CDataManager.getInstance().dataOfLevel.startItems;
			for(var i:int = 0 ;i < 3 ; i++)
			{
				var tool:CItemTool = new CItemTool(items[i].id , true , false , true , false , false , false);
				mc["itempos"+(i+1)].addChild(tool);
				
				_itemList.push(tool);
			}
		}
		
		private function __initData():void
		{
			_itemList = new Array();
			
			_level = datagramView.injectParameterList[0];
			
			//decode数据
			CDataManager.getInstance().dataOfLevel.decode(_level);
			
			//记录当前位置
			DataUtil.instance.currentPos = _level;
			
			userData = CDataManager.getInstance().dataOfGameUser;
			
			starInfo = CDataManager.getInstance().dataOfStarInfo;
			
			_levelData = starInfo.getLevelInfo(_level);
			
			if(!_levelData)
			{
				_starNum = 0;
			}
			else
			{
				_starNum = _levelData.maxStar;
			}
			
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CHECK_BARRIER_PANEL, _level);
		}
		
		private function __drawScore():void
		{
			title.autoSize = TextFieldAutoSize.CENTER;
			
			if(CDataManager.getInstance().dataOfLevel.levelConfig && CDataManager.getInstance().dataOfLevel.levelConfig.desc)
			{
				title.text = CDataManager.getInstance().dataOfLevel.levelConfig.desc;
			}
			else
			{
				title.text = "规定步数内消除目标";
			}
			
			//第一次打
			if(userData.curLevel < _level)
			{
				mc.score.visible = false;	
			}
			else
			{
				mc.score.visible = true;	
				if(_levelData)
				{
					mc.score.scorenum.text = _levelData.maxScore;
				}
				else
				{
					mc.score.scorenum.text = 0;
				}
			}
		}
		
		private function __drawBg():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER));
			
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_TOOL_BG_SCALE , 
				new Rectangle(15 , 15 , 2,2) , 
				new Point(375 , 134));
			
			mc.toolbgpos.addChild(bg1);
		}
		
		private function __drawLevelMC():void
		{
			_numFrames = CBaseUtil.getFramesByBmp("bmd.step.number", new Point(30, 27), 10);
			
			var levelMc:CWidgetAniNumber = new CWidgetAniNumber(_numFrames, _level+1);
			var width:int = 152;
			mc.levelpos.x = (width - levelMc.width) / 2 + 135.5;
			mc.levelpos.addChild(levelMc);
		}
		
		private function __hideAllStar():void
		{
			for(var i:int = 1 ; i <= 3; i++)
			{
				mc["star"+i]["star_liang"].visible = false;
				
				(mc["star"+i] as MovieClip).mouseChildren  = false;
				
				(mc["star"+i] as MovieClip).addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
				(mc["star"+i] as MovieClip).addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			}
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			var item:MovieClip = event.target as MovieClip;
			
			if(item.name.indexOf("star") == -1)
			{
				return;
			}
			
			var starNum:int = int(item.name.substr(-1 , 1));
			
			var scoreNum:int = CDataManager.getInstance().dataOfLevel.getScoreByStar(starNum);
			
			if(!_hasTip)
			{
				_hasTip = true;
				
				var pos:Point = item.localToGlobal(new Point(0 , -2));
				
				CBaseUtil.showTip("需要分值： " + scoreNum ,pos,new Point(160,20) ,true , "up");
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
		
		private function __drawStar():void
		{
			__hideAllStar();
			
			for(var i:int = 1 ; i <= _starNum; i++)
			{
				mc["star"+i]["star_liang"].visible = true;
			}
		}
		
		private function __specMc():void
		{
			//好友
			_friendList = new CWidgetBarrierFriendList(_level);
			this.mc.friendlistpos.addChild(_friendList);
			
			//按钮
			_closeBtn = new CButtonCommon("close");
			this.mc.btnclosepos.addChild(_closeBtn);
			
			_startBtn = new CButtonCommon("start" , "开  始");
			this.mc.btnconfirmpos.addChild(_startBtn);
			
			_startBtn.addEventListener(TouchEvent.TOUCH_OVER , __showEnergyTip , false , 0 , true);
			_startBtn.addEventListener(TouchEvent.TOUCH_OUT , __showEnergyTip , false , 0 , true);
			
			
			title = CBaseUtil.getTextField(mc.title , 20 , 0x5e2f12);
			
			mc.score.scorename = CBaseUtil.getTextField(mc.score.scorename , 16 , 0x5e2f12 , "left");
			mc.score.scorenum = CBaseUtil.getTextField(mc.score.scorenum , 16 , 0x5e2f12, "left");
			
			mc.choosetf = CBaseUtil.getTextField(mc.choosetf , 16 , 0x5e2f12, "left");
		}
		
		protected function __showEnergyTip(event:TouchEvent):void
		{
			var target:CButtonCommon = event.target.parent as CButtonCommon;
			if(!target)
			{
				return;
			}
			if(!_hasTip)
			{
				_hasTip = true;
				
				var pos:Point = target.localToGlobal(new Point(target.x + 55 , target.y - 5));
				
				CBaseUtil.showTip("  -5" ,pos, new Point(70 , 20) ,false , "up" , true , ConstIcon.ICON_TYPE_ENERTY ,
				new Point(7,3) , new Point(26,26));
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
		
		private function __initEvents():void
		{
			_closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
			_startBtn.addEventListener(TouchEvent.TOUCH_TAP , __onGame , false, 0 ,true);
			
			mc.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0 , true);
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			if(! (event.target.parent is CItemTool))
			{
				return;
			}
			
			//清除新手
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL);
			
			var item:CItemTool = event.target.parent as CItemTool;
			
			//货币不够的时候，接入购买货币
			if(item.buyType == CItemTool.BUY_TYPE_SILVER)
			{
				if(CDataManager.getInstance().dataOfMoney.silver < item.price )
				{
					CBaseUtil.showConfirm("银豆不足，去兑换吧？" , function():void{CBaseUtil.showSilverExchange();} , function():void{});
					return;
				}
			}
			else
			{
				if(CDataManager.getInstance().dataOfMoney.gold < item.price )
				{
					CBaseUtil.showConfirm("金豆不足，去充值吧？" , function():void{CBaseUtil.showGoldExchange();} , function():void{});
					return;
				}
			}
			
			for(var i:int = 0; i < _itemList.length ;i ++ )
			{
				if(_itemList[i].itemid == item.itemid)
				{
					item.selected = !item.selected;
					
					if(item.selected)
					{
						CDataManager.getInstance().dataOfLevel.addToolInGame(item.itemid);
					}
					else
					{
						CDataManager.getInstance().dataOfLevel.removeToolInGame(item.itemid);
					}
				}
			}
			
			//触发新手
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CHECK_BARRIER_PANEL, _level);
		}
		
		protected function __onGame(event:TouchEvent):void
		{
			if(CBaseUtil.getFCMTipsWin())
			{
				return;
			}
			
			_hasTip = false;
			CBaseUtil.closeTip()

			//清除新手
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL);
			
			CDataManager.getInstance().dataOfLevel.doEnergyCheck = true;
			//检测体力 
			var needEnergy:int = ConstGlobalConfig.ENERGY_PER_GAME;
			//补充体力
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_START));
			
			if(userData.curEnergy < needEnergy)
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramView(ConstantUI.PANEL_ENERGY_LACK));
			}
			else
			{
				var level:int = int(datagramView.getInjectedValue(0 , 0)) ;
				//先初始化
				Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramViewChooseLevel(ConstantUI.WORLD_GAME_MAIN , true , level));
				
				Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.USER_INFO_PANEL));
			}
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_START));
			
			//清除新手
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL);
		}
	}
}