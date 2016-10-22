package com.ui.panel
{
	import com.game.consts.ConstMoneyType;
	import com.game.consts.ConstUnlockType;
	import com.game.module.CDataManager;
	import com.greensock.TweenLite;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemFriend;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CLevelConfigUtil;
	import com.ui.util.CScaleImageUtil;
	import com.ui.widget.CWidgetFloatText;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.resource.faxb.levelproperty.Levels;
	import framework.rpc.NetworkManager;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 关卡组解锁
	 * 创建时间：2014-6-24 上午9:52:42 
	 */
	public class CPanelUnlock extends CPanelAbstract
	{
		private var _groupid:int;
		private var _groupConfig:Levels;
		
		//自适应
		private const  PANEL_WIDTH:Number = 363;
		
		private const  FRIEND_WIDTH:Number = 60;
		
		private const INVITE_FRIEND_MAX:int = 5;
		
		private const ITEM_START_X:int = 10;
		
		private var ITEM_START_Y:Number = 15;
		
		//条件
		private var _inviteFriendNum:int = 3;
		
		private var _unlockAllStarNum:int = 999;
		
		private var _requireLevel:int = -1;
		
		//进度条
		private var _startX:Number = -163;
		private var _endX:Number = 0;
		private var _unlockNeedGold:int;
		private var _unlockNeedSilver:int;
		private var _needStars:int;
		private var _type:String;
		
		
		public function CPanelUnlock()
		{
			super(ConstantUI.DIALOG_GROUP_UNLOCK);
		}
		
		override protected function drawContent():void
		{
			__initData();
			
			__drawPanel();
			__drawScaleBg();	
			__drawItemFriend();
			__drawProgress();
			__drawBtn();
		}
		
		private function __initData():void
		{
			_groupid = datagramView.injectParameterList["groupid"];
			
			_groupConfig = CLevelConfigUtil.getLevelGroupConfig(_groupid);
			
			_inviteFriendNum = _groupConfig.conditionOrs.condition.friendHelp;
			
			_needStars = _groupConfig.conditionOrs.condition.requireAllstar;
			
			_inviteFriendNum = _inviteFriendNum > 5 ? 5 : _inviteFriendNum;
			
			_unlockAllStarNum = _groupConfig.conditionOrs.condition.requireAllstar;
			
			_unlockNeedGold = _groupConfig.unlockGold;
			
			_unlockNeedSilver = _groupConfig.unlockSilver;
			
			_requireLevel = _groupConfig.conditionRequires.condition.requiresLevel;
			
			//解锁货币类型
			if(_unlockNeedGold != 0)
			{
				_type = ConstMoneyType.MONEY_TYPE_GOLD;
				mc.icon.silver.visible = false;
				mc.icon.gold.visible = true;
				
				mc.goldtf.text = "x " + _unlockNeedGold;
			}
			else
			{
				_type = ConstMoneyType.MONEY_TYPE_SILVER;
				mc.icon.gold.visible = false;
				mc.icon.silver.visible = true;
				
				mc.goldtf.text = "x " + _unlockNeedSilver;
			}
		}
		
		private function __drawBtn():void
		{
			var closebtn:CButtonCommon = new CButtonCommon("close");
			mc.closebtnpos.addChild(closebtn);
			closebtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false , 0 , true);
			
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xFFFFFFF;
			var askBtn:CButtonCommon = new CButtonCommon("green" , "请好友帮忙" , tf ,0x00);
			mc.askforhelppos.addChild(askBtn);
			askBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAsk , false , 0 , true);
			
			var gotoBtn:CButtonCommon = new CButtonCommon("green" , "前往关卡", tf ,0x00);
			mc.gotopos.addChild(gotoBtn);
			gotoBtn.addEventListener(TouchEvent.TOUCH_TAP , __onGoto , false , 0 , true);
			
			//检测西蓝星的数量
			if(_needStars > CDataManager.getInstance().dataOfGameUser.totalStar)
			{
				gotoBtn.textField.text = "前往关卡";
			}
			else
			{
				gotoBtn.textField.text = "解锁";
			}
			
			
			var unlockBtn:CButtonCommon = new CButtonCommon("blueshort" , "解锁", tf ,0x00);
			mc.unlockpos.addChild(unlockBtn);
			unlockBtn.addEventListener(TouchEvent.TOUCH_TAP , __onUnlock , false , 0 , true);
			
		}
		
		protected function __onUnlock(event:TouchEvent):void
		{
			if(_type == ConstMoneyType.MONEY_TYPE_GOLD)
			{
				if(CDataManager.getInstance().dataOfMoney.gold < _unlockNeedGold )
				{
					CBaseUtil.showConfirm("金豆不足！是否立即获取银豆？" , CBaseUtil.showGoldExchange , function():void{});
				}
				else
				{
					//发请求
					NetworkManager.instance.sendServerUnlockLevelGroup(_groupid , ConstUnlockType.UNLOCK_TYPE_GOLD);
				}
			}
			else
			{
				if(CDataManager.getInstance().dataOfMoney.silver < _unlockNeedSilver )
				{
					CBaseUtil.showConfirm("银豆不足！是否立即获取银豆？" , CBaseUtil.showSilverExchange , function():void{});
				}
				else
				{
					//发请求
					NetworkManager.instance.sendServerUnlockLevelGroup(_groupid , ConstUnlockType.UNLOCK_TYPE_SILVER);
				}
			}
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.DIALOG_GROUP_UNLOCK));
		}
		
		protected function __onGoto(event:TouchEvent):void
		{
			//前往关卡
			if(_needStars > CDataManager.getInstance().dataOfGameUser.totalStar)
			{
				
				//找到第一个不满星的关卡
				var level:int = CDataManager.getInstance().dataOfStarInfo.getFirstUnfullLevel();
				CBaseUtil.viewPortGotoLevel(level);
			}
			//解锁星星
			else
			{
				NetworkManager.instance.sendServerUnlockLevelGroup(_groupid, ConstUnlockType.UNLOCK_TYPE_STAR);
			}
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.DIALOG_GROUP_UNLOCK));
		}
		
		protected function __onAsk(event:TouchEvent):void
		{
			CWidgetFloatText.instance.showTxt("敬请期待");
			return;
			
//			//先关闭原来的界面
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.DIALOG_GROUP_UNLOCK));
			
			//打开好友
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,new DatagramView(ConstantUI.PANEL_UNLOCK_ASK_FRIEND));
		}
		
		private function __onClose(e:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL ,new DatagramView(ConstantUI.DIALOG_GROUP_UNLOCK));
		}
		
		private function __drawItemFriend():void
		{
			//todo ，加入已经邀请过的头像
			for(var i:int = 1 ; i <= _inviteFriendNum ; i++)
			{
				var item:CItemFriend = new CItemFriend(null , "item.friend.help" , null , false);
				
				var span:Number = (PANEL_WIDTH - 2* ITEM_START_X - FRIEND_WIDTH) / (_inviteFriendNum -1) ;
				
				item.x = ITEM_START_X + (i - 1) * span;
				item.y = ITEM_START_Y;
				
				mc.bgpos1.addChild(item);
			}
		}
		
		private function __drawProgress():void
		{
			var totalStar:int = CDataManager.getInstance().dataOfGameUser.msgUserInfo.totalStar;
			var needStar:int = _unlockAllStarNum;
			
			totalStar = totalStar > needStar ? needStar : totalStar;
			
			var bar:MovieClip = mc.progress.bar;
			var endX:Number = (totalStar / needStar) * (_endX - _startX) + _startX;
			
			TweenLite.to(bar , 0.4 , {x:endX , y: bar.y});
			
			mc.progresstext.text = ""+ totalStar + "/" + needStar;
		}
		
		
		private function __drawPanel():void
		{
			mc.panelpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER));
		}
		
		private function __drawScaleBg():void
		{
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_FRIEND_UI_SCALE , 
				new Rectangle(50 , 30 , 4,4) , 
				new Point(367 , 157));
			
			mc.bgpos1.addChild(bg1);
			
			var bg2:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_FRIEND_UI_SCALE , 
				new Rectangle(50 , 30 , 4,4) , 
				new Point(367 , 93));
			
			mc.bgpos2.addChild(bg2);
			
			var bg3:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_FRIEND_UI_SCALE , 
				new Rectangle(50 , 30 , 4,4) , 
				new Point(367 , 66));
			
			mc.bgpos3.addChild(bg3);
		}
	}
}