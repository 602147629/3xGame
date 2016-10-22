package com.ui.item
{
	import com.game.consts.ConstUILevelStatus;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.game.module.CDataOfStarInfo;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CLevelConfigUtil;
	
	
	import flash.events.TouchEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	
	import framework.datagram.DatagramViewChooseLevel;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.rpc.DataUtil;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.PBStarArray;
	
	/**
	 * @author caihua
	 * @comment 主场景，关卡选择item
	 * 创建时间：2014-6-8 上午9:30:01 
	 */
	public class CItemLevelSprite extends CItemAbstract
	{
		private var _level:int = 0;
		private var _status:int = ConstUILevelStatus.STATUS_UNOPEN;
		private var _starNum:int = 0;
		private var _levelData:PBStarArray;

		private var userData:CDataOfGameUser;
		private var starInfo:CDataOfStarInfo;

		private var logo:CItemFriend;
		private var _hasEvent:Boolean;
		
		public function CItemLevelSprite(id:String , level:int)
		{
			_level = level;
			super(id);
		}
		
		protected function __onClickHandler(event:TouchEvent):void
		{
			if(!CBaseUtil.checkSecondComplete(openBarrierStart))
			{
				return;
			}
			
			openBarrierStart();
		}
		
		private function openBarrierStart():void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramViewChooseLevel(ConstantUI.DIALOG_BARRIER_START , true , _level));
		}
		
		override protected function drawContent():void
		{
			userData = CDataManager.getInstance().dataOfGameUser;
			starInfo = CDataManager.getInstance().dataOfStarInfo;
			
			__initData();
			
			__drawFlower();
			
			__drawStar();
			
			mc.leveltf.defaultTextFormat.bold = true;
			
			mc.leveltf.filters = [new GlowFilter( 0x5e2f12, 1,5, 5, 100, 1, false )]
			mc.leveltf.text = "" + (_level+1);
			
			CBaseUtil.regEvent(GameNotification.EVENT_STAR_INFO , __onStarInfo);
			CBaseUtil.regEvent(GameNotification.EVENT_PLAY_TO , __playTo);
			
			if(_level == CDataManager.getInstance().dataOfGameUser.maxLevel || 
				_level == CDataManager.getInstance().dataOfGameUser.curLevel)
			{
				if(!_hasEvent)
				{
					_hasEvent = true;
					CBaseUtil.regEvent(GameNotification.EVENT_GROUP_UNLOCKED , __refreshLogo);
				}
			}
		}
		
		private function __refreshLogo(d:Notification):void
		{
			__initData();
		}
		
		private function __showLogo(size:Point):void
		{
			logo = new CItemFriend(DataUtil.instance.myUserID , "item.friend.logo" , new Point(36,36));
			
			logo.x += size.x;
			logo.y += size.y;
			
			mc.logopos.addChild(logo);
			
			mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
			mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			logo.toggleTip();
		}
		
		private function __playTo(n:Notification):void
		{
			if(_status == ConstUILevelStatus.STATUS_OPEN_FIRST)
			{
				var callBack:Function;
				callBack = function ():void
				{
					mc["mc_"+_status].visible = false;
					_status = ConstUILevelStatus.STATUS_OPEN;
					mc["mc_"+_status].visible = true;
					userData.isFistNext = false;
					
					
				}
				mc["mc_"+_status].gotoAndPlay(1);
				
				CBaseUtil.playToEndAndStop(mc["mc_"+_status] , callBack , false);
			}
		}
		
		private function __onStarInfo(d:Notification):void
		{
			if(_level <= CDataManager.getInstance().dataOfGameUser.maxLevel + 5)
			{
				__initData();
			}
		}
		
		private function __initData():void
		{
			if(_level > CDataManager.getInstance().dataOfGameUser.maxLevel + 2)
			{
				status = ConstUILevelStatus.STATUS_UNOPEN; 
			}
			else
			{
				_levelData = starInfo.getLevelInfo(_level);
				
				if(!_levelData)
				{
					_starNum = 0;
				}
				else
				{
					_starNum = _levelData.maxStar > 3 ? 3 : _levelData.maxStar;
				}
				
				var size:Point;
				
				//所在关卡已经解锁
				if(_level == CDataManager.getInstance().dataOfGameUser.curLevel)
				{
					if(CLevelConfigUtil.isCurlevelGroupUnlocked())
					{
						if(id == "levelflower")
						{
							size = new Point(10, 35);
						}
						else if(id == "levelstraw")
						{
							size = new Point(10 , -20);
						}
						else
						{
							size = new Point(0 , -5);
						}
						
						
						__showLogo(size);
					}
				}
				else
				{
					if(_level == CDataManager.getInstance().dataOfGameUser.maxLevel)
					{
						if(!CLevelConfigUtil.isCurlevelGroupUnlocked())
						{
							if(id == "levelflower")
							{
								size = new Point();
							}
							else if(id == "levelstraw")
							{
								size = new Point(0 , -20);
							}
							else
							{
								size = new Point(0 , -5);
							}
							
							__showLogo(size);
						}
						else
						{
							if(logo && logo.parent && logo.parent.contains(logo))
							{
								logo.parent.removeChild(logo);
							}
						}
					}
				}
				
				__calcStatus();
			}
		}
		
		private function __drawFlower():void
		{
			for(var i:int = 1 ; i <= 6; i++)
			{
				mc["mc_"+i].visible = false;
			}
			mc["mc_"+_status].visible = true;
		}
		
		private function __drawStar():void
		{
			for(var i:int = 1 ; i <= 3; i++)
			{
				if(status == ConstUILevelStatus.STATUS_UNOPEN)
				{
					__hideAllStar();
				}
				else
				{
					mc["mc_star"+i]["liang"].visible = false;
					mc["mc_star"+i]["an"].visible = true;
					
					for(var j:int = 1 ; j <= _starNum; j++)
					{
						mc["mc_star"+j]["liang"].visible = true;
					}
				}
			}
		}
		
		private function __calcStatus():void
		{
			var fightTimes:int = userData.curTimes;
			//通过了。
			if(_level < userData.curLevel)
			{
				//异常
				if(!_levelData)
				{
					status = ConstUILevelStatus.STATUS_COMPLETE_STAR_1;
				}
				else
				{
					//算星
					if(_levelData.maxStar >= 3)
					{
						status = ConstUILevelStatus.STATUS_COMPLETE_STAR_34;
					}
					else if(_levelData.maxStar == 2)
					{
						status = ConstUILevelStatus.STATUS_COMPLETE_STAR_2;
					}
					else if(_levelData.maxStar == 1)
					{
						status = ConstUILevelStatus.STATUS_COMPLETE_STAR_1;
					}
				}
			}
			//没通过
			else
			{
				//当前关 
				if(_level == userData.curLevel)
				{
					TRACE("当前关卡匹配: "+ _level , "STAR_INFO");
					TRACE("_levelData is null : "+ (_levelData == null).toString() , "STAR_INFO");
					if(_levelData)
					{
						TRACE("maxScore : "+  _levelData.maxScore , "STAR_INFO");
					}
					
					//没打，并且是当前关，就是小花盆。
					if(_levelData == null || _levelData.maxScore == 0)
					{
						if(userData.isFistNext)
						{
							status = ConstUILevelStatus.STATUS_OPEN_FIRST;
						}
						else
						{
							status = ConstUILevelStatus.STATUS_OPEN;
						}
					}
					else
					{
						TRACE("**************数据出现异常************** : " , "STAR_INFO");
						TRACE("本关 : " + _level , "STAR_INFO");
						TRACE("当前关 curLevel : " + userData.curLevel , "STAR_INFO");
						TRACE("最大关 maxLevel : " + userData.maxLevel , "STAR_INFO");
						TRACE("数据异常 --> 本关和当前关相等，但是当前关的分数值 ！= 0 ， 当前关分值 = "+  _levelData.maxScore , "STAR_INFO");
						TRACE("**************数据出现异常************** : " , "STAR_INFO");
						
						//实际上，这是个bug状态
						status = ConstUILevelStatus.STATUS_OPEN
					}
				}
				//其他关
				else
				{
					status = ConstUILevelStatus.STATUS_UNOPEN;
				}
			}
			
			TRACE("maxLevel : " + userData.maxLevel + " curLevel : " + userData.curLevel + "_levelData==null : "+ (_levelData == null).toString() , "STAR_INFO");
			
			TRACE("关卡: "+_level+" status : " + status , "STAR_INFO");
		}
		
		private function __hideAllStar():void
		{
			for(var i:int = 1 ; i <= 3; i++)
			{
				mc["mc_star"+i].visible = false;
			}
		}
		
		override protected function dispose():void
		{
			if(_hasEvent)
			{
				_hasEvent = false;
				CBaseUtil.removeEvent(GameNotification.EVENT_GROUP_UNLOCKED , __refreshLogo);
			}
			
			CBaseUtil.removeEvent(GameNotification.EVENT_STAR_INFO , __onStarInfo);
			CBaseUtil.removeEvent(GameNotification.EVENT_PLAY_TO , __playTo);
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			if (value > ConstUILevelStatus.STATUS_OPEN_FIRST || value < ConstUILevelStatus.STATUS_UNOPEN)
			{
				value = ConstUILevelStatus.STATUS_UNOPEN;
				mc.buttonMode = false;
			}else
			{
				mc.buttonMode = true;
				mc.mouseChildren = false;
			}
			
			_status = value;
			
			__drawFlower();
			
			__drawStar();
		}
		
		//由云层决定它的状态
		public function setEnabled(_bEnabled:Boolean = true):void
		{
			if(_status == ConstUILevelStatus.STATUS_UNOPEN)
			{
				_bEnabled = false;
			}
			else
			{
				_bEnabled = true;
			}
			
			if(_bEnabled)
			{
				addEventListener(TouchEvent.TOUCH_TAP , __onClickHandler , false, 0 , true);
			}
			else
			{
				removeEventListener(TouchEvent.TOUCH_TAP , __onClickHandler);
				this.mouseChildren = false;
			}
		}
	}
}