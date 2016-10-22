package com.ui.item
{
	import com.game.consts.ConstUIGroupStatus;
	import com.game.consts.ConstUnlockType;
	import com.game.module.CDataManager;
	import com.ui.util.CLevelConfigUtil;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.resource.faxb.levelproperty.Levels;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	

	/**
	 * @author caihua
	 * @comment 云
	 * 创建时间：2014-6-23 下午4:02:47 
	 */
	public class CItemCloud extends CItemAbstract
	{
		private var _status:int = ConstUIGroupStatus.GROUP_STATUS_INIT;
		private var _groupid:int = 0;
		private var _levelItems:Array;

		private var groupConfig:Levels;
		
		public function CItemCloud(groupid:int , groupLevelItems:Array)
		{
			_groupid = groupid;
			_levelItems = groupLevelItems == null ? [] : groupLevelItems;
			super("effect.cloud");
		}
		
		override protected function drawContent():void
		{
			mc.gotoAndStop(1);
			this.mc.height = 200;
			
			groupConfig = CLevelConfigUtil.getLevelGroupConfig(_groupid);
			
			update();
		}
		
		public function playUnlock():void
		{
			mc.mouseChildren = false;
			mc.mouseEnabled = false;
			if(mc.currentFrame > 1)
			{
				return;
			}
			mc.mc_lock.gotoAndPlay(1);
			mc.mc_lock.content.gotoAndPlay(1);
			mc.gotoAndPlay(1);
			
			var call:Function = function ():void
			{
				mc.visible = false;
				mc.mouseChildren = true;
				mc.mouseEnabled = true;
			}
			
			__playToEndAndStop(mc , call);
		}
		
		/**
		 * 解锁
		 */
		public function update():void
		{
			//第一个默认开启
			if(_groupid == 0)
			{
				status = ConstUIGroupStatus.GROUP_STATUS_UNLOCK;
				return;
			}
			
			//已经解锁了
			if(_groupid <= CDataManager.getInstance().dataOfGameUser.maxLevelGroup)
			{
				status = ConstUIGroupStatus.GROUP_STATUS_UNLOCK;
			}
			else
			{
				if(groupConfig == null)
				{
					status = ConstUIGroupStatus.GROUP_STATUS_LOCK;
				}
				else
				{
					//没解锁，并且是下一关，带锁
					if(groupConfig.startlevel == CDataManager.getInstance().dataOfGameUser.curLevel)
					{
						status = ConstUIGroupStatus.GROUP_STATUS_CURRENTLOCK;
					}
					else
					{
						status = ConstUIGroupStatus.GROUP_STATUS_LOCK;
					}
				}
			}
		}
		
		/**
		 * 播放一遍动画
		 */
		private function __playToEndAndStop(mc:MovieClip , callback:Function = null , visible:Boolean = false):void
		{
			var func:Function = function (e:Event):void
			{
				var target:MovieClip = (e.target as MovieClip);
				if(target.currentFrame == target.totalFrames)
				{
					target.stop();
					target.visible = visible;
					target.removeEventListener(Event.ENTER_FRAME , func);
					
					if(callback != null)
					{
						callback();
					}
				}
			};
			
			mc.addEventListener(Event.ENTER_FRAME , func);
		}
		
		private function __showLockStatus():void
		{
			mc.mc_lock.visible = false;
			this.mc.mouseChildren = false;
			this.mc.mouseEnabled = false;
			
			this.mc.visible = true;
			for(var i:int = 0 ; i <_levelItems.length ; i++)
			{
				(_levelItems[i] as CItemLevelSprite).setEnabled(false);
			}
		}
		
		private function __showNextLockStatus():void
		{
			mc.mc_lock.visible = true;
			mc.mc_lock.gotoAndStop(1);
			mc.mc_lock.content.gotoAndStop(1);
			mc.buttonMode = true;
			this.mc.mouseChildren = false;
			this.mc.mouseEnabled = true;
			
			//点击解锁
			this.mc.addEventListener(TouchEvent.TOUCH_TAP , __onClick);
			
			this.mc.visible = true;
			for(var i:int = 0 ; i <_levelItems.length ; i++)
			{
				(_levelItems[i] as CItemLevelSprite).setEnabled(false);
			}
		}
		
		private function __showUnlockStatus():void
		{
			for(var i:int = 0 ; i <_levelItems.length ; i++)
			{
				(_levelItems[i] as CItemLevelSprite).setEnabled(true);
			}
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			var needStars:int = groupConfig.conditionOrs.condition.requireAllstar;
			
			//星值不够
			if(needStars > CDataManager.getInstance().dataOfGameUser.totalStar)
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.DIALOG_GROUP_UNLOCK ,true, {groupid:_groupid}));
			}
			else
			{
				NetworkManager.instance.sendServerUnlockLevelGroup(_groupid , ConstUnlockType.UNLOCK_TYPE_STAR);
				
				playUnlock();
			}
		}

		public function get groupid():int
		{
			return _groupid;
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			if(value == _status)
			{
				return;
			}
			_status = value;
			
			switch(status)
			{
				case ConstUIGroupStatus.GROUP_STATUS_UNLOCK: __showUnlockStatus();
					break;
				case ConstUIGroupStatus.GROUP_STATUS_CURRENTLOCK: __showNextLockStatus();
					break;
				case ConstUIGroupStatus.GROUP_STATUS_LOCK: __showLockStatus();
					break;
				default:
					__showUnlockStatus();
			}	
			
		}
	}
}