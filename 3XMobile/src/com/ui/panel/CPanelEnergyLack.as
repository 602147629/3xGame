package com.ui.panel
{
	import com.game.consts.ConstGlobalConfig;
	import com.game.consts.ConstIcon;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemEnergyTimer;
	import com.ui.item.CItemIcon;
	import com.ui.item.CItemSignUpButton;
	import com.ui.item.CItemToolInBubble;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewChooseLevel;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 体力不足界面
	 * 创建时间：2014-7-3 下午5:56:37 
	 */
	public class CPanelEnergyLack extends CPanelAbstract
	{
		private var _userData:CDataOfGameUser;
		
		private var _startX:Number = -134.65;
		
		private var _endX:Number = 139.35;

		private var _addEnergyBtn:CItemSignUpButton;
		
		private var timer:CItemEnergyTimer;
		
		//距离满体力还剩下的数目
		private var _remainEnergy:int = 0;
		private var tipTF:TextField;

		private var tfEnergy:TextField;
		
		public function CPanelEnergyLack()
		{
			super(ConstantUI.PANEL_ENERGY_LACK , false);
		}
		
		override protected function drawContent():void
		{
			mc.bg1pos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_BIG_WITHBORDER));
			
			_userData = CDataManager.getInstance().dataOfGameUser;
			
			var tf:TextField = CBaseUtil.getTextField(mc.usetip , 14 , 0x5e2f12 ,"left");
			tf.text = "使用体力药瓶：";
			
			var item:CItemIcon = new CItemIcon(ConstIcon.ICON_TYPE_ENERTY , 0 );
			mc.itempos.addChild(item);
			
			tfEnergy = CBaseUtil.getTextField(mc.energytf, 16 , 0x5e2f12);
			
			tipTF = CBaseUtil.getTextField(mc.tiptf , 16 , 0x5e2f12);
			tipTF.text = "后恢复1点体力";
			
			__drawCoolDown();
			
			__drawToolBg();
			
			__drawBtn();
			
			__drawTools();
			
			CBaseUtil.regEvent(GameNotification.EVENT_ENERGY_RECOVER_REMAIN_TIME , update);
			
			CBaseUtil.centerUI(mc , new Point(494,379));
			
			update(null);
		}
		
		private function update(d:Notification):void
		{
			_remainEnergy = ConstGlobalConfig.MAX_ENERGY - CDataManager.getInstance().dataOfGameUser.curEnergy;
			var needSilver:int = 0;
			if(_remainEnergy <= 0)
			{
				_addEnergyBtn.enabled = false;
				_addEnergyBtn.mouseChildren = false;
				_addEnergyBtn.mouseEnabled = false;
				
				tipTF.visible = false;
				
				timer.visible = false;
				
				_addEnergyBtn.isShowIcon = false;
				
				_addEnergyBtn.setSignUpBtnText("      补满体力");
			}
			else
			{
				needSilver = _remainEnergy * ConstGlobalConfig.SILVER_PER_ENERGY;
				
				_addEnergyBtn.setSignUpBtnText(" " + needSilver + " 补满体力");
			}
			
			tfEnergy.text = CDataManager.getInstance().dataOfGameUser.curEnergy+"/" + ConstGlobalConfig.MAX_ENERGY;
			
			if(CDataManager.getInstance().dataOfGameUser.curEnergy >= 5)
			{
				if(CDataManager.getInstance().dataOfLevel.level != -1)
				{
					_addEnergyBtn.setSignUpBtnText("      开始游戏");
					_addEnergyBtn.isShowIcon = false;
					
					_addEnergyBtn.enabled = true;
					_addEnergyBtn.mouseEnabled = true;
					
					_addEnergyBtn.removeEventListener(TouchEvent.TOUCH_TAP , __onAddEnergy);
					_addEnergyBtn.addEventListener(TouchEvent.TOUCH_TAP , __onRestart , false, 0 ,true);
				}
			}
		}
		
		protected function __onRestart(event:TouchEvent):void
		{
			//关闭自己
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_ENERGY_LACK));
			
			NetworkManager.instance.sendServerStopGame();
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.WORLD_GAME_MAIN));
			
			var level:int = CDataManager.getInstance().dataOfLevel.level ;
			
			//需要重新初始化数据
			CDataManager.getInstance().dataOfLevel.decode(level);
			
			//先初始化
			Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramViewChooseLevel(ConstantUI.WORLD_GAME_MAIN , true , level));
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.USER_INFO_PANEL));
		}
		
		private function __drawCoolDown():void
		{
			timer = new CItemEnergyTimer(0x5e2f12);
			timer.showBg(false);
			mc.timerpos.addChild(timer);
		}
		
		override protected function dispose():void
		{
			Fibre.getInstance().removeObserver(GameNotification.EVENT_ENERGY_RECOVER_REMAIN_TIME , update);
		}
		
		private function __drawTools():void
		{
			for(var i:int = 0 ;i < 3 ; i++)
			{
				var tool:CItemToolInBubble = new CItemToolInBubble(10 + i ,true , true , true);
				
				tool.y = mc["itempos"+(i+1)].y;
				tool.x = mc["itempos"+(i+1)].x;
				
				mc.addChild(tool);
			}
		}
		
		private function __drawBtn():void
		{
			var closeBtn:CButtonCommon = new CButtonCommon("close");
			mc.closepos.addChild(closeBtn);
			closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
			
			var tf:* = CFontUtil.textFormatMiddle;
			tf.color = 0xffffff;
			
			_addEnergyBtn = new CItemSignUpButton(17);
			_addEnergyBtn.setIcon(ConstIcon.ICON_TYPE_SILVER + 1);
			_addEnergyBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAddEnergy , false, 0 ,true);
			mc.addpos.addChild(_addEnergyBtn);
			
			//求助好友
			var askFriendBtn:CButtonCommon = new CButtonCommon("green", "求助好友",tf, 0x00);
			mc.pos1.addChild(askFriendBtn);
			askFriendBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAsk , false, 0 ,true);
			
			//道具恢复
			var toolRecoveryBtn:CButtonCommon = new CButtonCommon("green", "购买道具" , tf, 0x00);
			mc.pos2.addChild(toolRecoveryBtn);
			toolRecoveryBtn.addEventListener(TouchEvent.TOUCH_TAP , __onUseTool , false, 0 ,true);
			
			//购买道具
			var buyToolBtn:CButtonCommon = new CButtonCommon("green", "购买道具" , tf, 0x00);
			mc.pos3.addChild(buyToolBtn);
			buyToolBtn.addEventListener(TouchEvent.TOUCH_TAP , __onBuyTool , false, 0 ,true);
		}
		
		protected function __onStartGame(event:TouchEvent):void
		{
			if(CDataManager.getInstance().dataOfGameUser.curEnergy < ConstGlobalConfig.ENERGY_PER_GAME)
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramView(ConstantUI.PANEL_ENERGY_LACK));
			}
			else
			{
				//退出当前游戏
				NetworkManager.instance.sendServerStopGame();
				
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
		
		protected function __onBuyTool(event:TouchEvent):void
		{
			CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_COMMON_BUY , true , {id:12}));
		}
		
		protected function __onUseTool(event:TouchEvent):void
		{
			CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_COMMON_BUY , true , {id:11}));
		}
		
		protected function __onAsk(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_ENERGY_LACK));
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramView(ConstantUI.PANEL_FRIEND_SENDENERGY));
		}
		
		protected function __onAddEnergy(event:TouchEvent):void
		{
			NetworkManager.instance.sendServerFullEnergy();	
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.PANEL_ENERGY_LACK));
		}
		
		private function __drawToolBg():void
		{
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_TOOL_BG_SCALE , 
				new Rectangle(15 , 15 , 2,2) , 
				new Point(436 , 150));
			
			mc.bgpos.addChild(bg1);
		}
	}
}