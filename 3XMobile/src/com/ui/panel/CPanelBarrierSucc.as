package com.ui.panel
{
	import com.game.consts.ConstIcon;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemIcon;
	import com.ui.item.CItemStarAni;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CLevelConfigUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetAniNumber;
	import com.ui.widget.CWidgetBarrierFriendList;
	
	import flash.display.Bitmap;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewChooseLevel;
	import framework.fibre.core.Fibre;
	import framework.resource.faxb.levelproperty.Levels;
	import framework.resource.faxb.levelproperty.Star;
	import framework.sound.MediatorAudio;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	/**
	 * @author caihua
	 * @comment 关卡成功
	 * 创建时间：2014-6-10 下午8:35:07 
	 */
	public class CPanelBarrierSucc extends CPanelAbstract
	{
		private var _friendList:CWidgetBarrierFriendList;
		private var _closeBtn:CButtonCommon;
		
		private var _confirmBtn:CButtonCommon;
		
		private var _levelData:CDataOfLevel;
		
		private var _getScore:Number = 0;
		
		private var _currentStar:int = 0;
		
		private var _hasTip:Boolean;
		
		private var _isCanNext:Boolean;
		
		private var _addEnergy:int;
		private var _numFrames:Array;
		
		private var _starList:Array;
		
		public function CPanelBarrierSucc()
		{
			super("dialog.barrier.succ" , false);
		}
		
		override protected function drawContent():void
		{
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER));
			
			Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_WIN, null, Fibre.SOUND_NOTIFICATION);
			
			_levelData = CDataManager.getInstance().dataOfLevel;
			
			__specMc();
			
			__drawBg();
			
			_getScore = _levelData.d.score;
			
			mc.score.scorenum.text = _getScore;
			
			_addEnergy = datagramView.injectParameterList["addEnergy"];
			
			__initEvents();
			
			__drawLevelMC();
			
			CBaseUtil.centerUI(mc , new Point(mc.width , mc.height));
			
			__drawStars();
			
			__drawReward();
		}
		
		private function __drawStars():void
		{
			_starList = new Array();
			
			for(var i:int = 1 ; i<= 3 ; i++)
			{
				var star:CItemStarAni = new CItemStarAni();
				mc["starpos"+i].addChild(star);
				
				_starList.push(star);
			}
		}
		
		private function __drawBg():void
		{
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_TOOL_BG_SCALE , 
				new Rectangle(15 , 15 , 2,2) , 
				new Point(375 , 134));
			
			mc.toolbgpos.addChild(bg1);
		}
		
		private function __drawReward():void
		{
			var rewardList:Star ;
			if(_getScore < _levelData.oneStar)
			{
				_currentStar = 0;
			}
			else if(_getScore >= _levelData.oneStar && _getScore < _levelData.twoStar)
			{
				_currentStar = 1;
				rewardList = _levelData.rewardList[0];
			}
			else if(_getScore >= _levelData.twoStar && _getScore < _levelData.threeStar)
			{
				_currentStar = 2;
				rewardList = _levelData.rewardList[1];
			}
			else
			{
				_currentStar = 3;
				rewardList = _levelData.rewardList[2];
			}
			
			if(rewardList)
			{
				var needDrawHp:Boolean = false;
				
				if(_addEnergy > 0)
				{
					needDrawHp = true;
				}
				
				if(needDrawHp)
				{
					var item:CItemIcon = new CItemIcon(ConstIcon.ICON_TYPE_ENERTY , _addEnergy);
					mc.item1pos.addChild(item);
				}

				if(rewardList.coin != 0)
				{
					//挪位置
					var item1:CItemIcon = new CItemIcon(ConstIcon.ICON_TYPE_SILVER , rewardList.coin);
					if(!needDrawHp)
					{
						mc.item1pos.addChild(item1);
					}
					else
					{
						mc.item2pos.addChild(item1);
					}
				}
			}
			
			__updateStar();
		}
		
		private function __updateStar():void
		{
			__hideAllStar();
			
			var tempList:Array = new Array();
			
			for(var i:int = 0 ; i < _currentStar; i++)
			{
				var item:CItemStarAni = _starList[i];
				tempList.push(item);
			}
			
			__playAni(tempList);
			
		}
		
		private function __playAni(tempList:Array):void
		{
			if(tempList.length > 0)
			{
				CBaseUtil.delayCall(function():void{
					tempList.shift().shine();
					__playAni(tempList);
				} , 0.3 , 1);
			}
		}
		
		private function __hideAllStar():void
		{
			for(var i:int = 0 ; i < 3; i++)
			{
				_starList[i].gray();
				
				_starList[i].mouseChildren = false;
				_starList[i].addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
				_starList[i].addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			}
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			var item:CItemStarAni = event.target as CItemStarAni;
			
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
		
		private function __drawLevelMC():void
		{
			_numFrames = CBaseUtil.getFramesByBmp("bmd.step.number", new Point(30, 27), 10);
			
			var levelMc:CWidgetAniNumber = new CWidgetAniNumber(_numFrames, _levelData.level+1);
			var width:int = 152;
			mc.levelpos.x = (width - levelMc.width) / 2 + 135.5;
			mc.levelpos.addChild(levelMc);
		}
		
		private function __specMc():void
		{
			//好友
			_friendList = new CWidgetBarrierFriendList(_levelData.level);
			this.mc.friendlistpos.addChild(_friendList);
			
			//按钮
			_closeBtn = new CButtonCommon("close");
			this.mc.btnclosepos.addChild(_closeBtn);
			
			var levels:Levels = CLevelConfigUtil.getLevelGroupConfig(CDataManager.getInstance().dataOfGameUser.maxLevelGroup);
			
			if(levels.endlevel == CDataManager.getInstance().dataOfGameUser.maxLevel)
			{
				_confirmBtn = new CButtonCommon("start" , "确 定");
				_isCanNext = false;
			}else
			{
				_confirmBtn = new CButtonCommon("start" , "下一关");
				_isCanNext = true;
			}
			this.mc.btnconfirmpos.addChild(_confirmBtn);
			
			mc.score.scorename = CBaseUtil.getTextField(mc.score.scorename , 16 , 0x5e2f12, "left");
			mc.score.scorenum = CBaseUtil.getTextField(mc.score.scorenum , 16 , 0x5e2f12, "left");
			
			mc.rewardtf = CBaseUtil.getTextField(mc.rewardtf , 16 , 0x5e2f12, "left");
		}
		
		private function __initEvents():void
		{
			_closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
			_confirmBtn.addEventListener(TouchEvent.TOUCH_TAP , __onConfirm , false, 0 ,true);
		}
		
		protected function __onConfirm(event:TouchEvent):void
		{
			if(_isCanNext)
			{
				if(!CDataManager.getInstance().dataOfFunctionList.hasOpenFunction())
				{
					CBaseUtil.delayCall(function():void
					{
						CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL , new DatagramViewChooseLevel(ConstantUI.DIALOG_BARRIER_START , true , CDataManager.getInstance().dataOfGameUser.curLevel));
					},0.8,1);
				}
				Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_SUCC));
				Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramViewChooseLevel(ConstantUI.SCENE_MAIN , true ,  CDataManager.getInstance().dataOfGameUser.curLevel));
			}else
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_SUCC));
				Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
			}
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_SUCC));
			Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
		}
	}
}
