package com.ui.item
{
	import com.game.consts.ConstGlobalConfig;
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.widget.CWidgetFloatText;
	
	import flash.display.MovieClip;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.rpc.ConfigManager;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	import qihoo.gamelobby.protos.UserOrigin;
	
	public class CItemFunctionEntry extends CItemAbstract
	{
		private var _currentBtnStr:String;
		private var _num:int;
		private var _hasTip:Boolean;
		private var _isShowTips:Boolean;
		private var _flowTipText:String;
		private var _direction:String = "right";
		
		public function CItemFunctionEntry(isShowTips:Boolean = true)
		{
			_isShowTips = isShowTips;
			super("entry_item");
		}
		
		override protected function drawContent():void
		{
			mc.tips.mouseChildren = false;
			mc.tips.mouseEnabled = false;
			mc.tips.visible = false;
			mc.numTxt.mouseEnabled = false;
			mc.numTxt.visible = false;
			
			if(_isShowTips)
			{
				mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
				mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			}
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_hasTip)
			{
				_hasTip = true;
				
				var pos:Point 
				if(_direction == "right")
				{
					pos = mc.btn.localToGlobal(new Point(mc.btn.x + mc.btn.width , (mc.btn.height - 25) / 2));
				}
				else if(_direction == "down")
				{
					pos = mc.btn.localToGlobal(new Point(-mc.btn.width /2  , mc.y + mc.btn.height));
				}
				
				CBaseUtil.showTip(_flowTipText , pos , new Point(150,25) , true , _direction);
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
		
		public function setEntryBtn(btnID:String):void
		{
			this._currentBtnStr = btnID;
			var btn:CButtonCommon = new CButtonCommon(btnID);
			mc.btn.addChild(btn);
			btn.addEventListener(TouchEvent.TOUCH_TAP, onCurrentBtnClickHandler, false, 0, true);
			
			__setFlowTipText();
		}
		
		public function setBackEffect(effect:String, pos:Point):void
		{
			var c:Class = ResHandler.getClass(effect);
			var mc1:MovieClip = new c() as MovieClip;
			mc.backEffect.addChild(mc1);
			mc1.mouseChildren = false;
			mc1.mouseEnabled = false;
			mc1.x = pos.x;
			mc1.y = pos.y;
		}
		
		public function setEffect(effect:String, pos:Point):void
		{
			var c:Class = ResHandler.getClass(effect);
			var mc1:MovieClip = new c() as MovieClip;
			mc.effect.addChild(mc1);
			mc1.mouseChildren = false;
			mc1.mouseEnabled = false;
			mc1.x = pos.x;
			mc1.y = pos.y;
		}
		
		private function __setFlowTipText():void
		{
			switch(this._currentBtnStr)
			{
				case "z_n4_area":
					_flowTipText = "话费、银豆任你夺取";
					_direction = "down";
					break;
				case "main_friendmessage":
					_flowTipText = "你收到了新的消息";
					break;
				case "z_n1_main_forum":
					_flowTipText = "来跟小伙伴们互动吧";
					break;
				case "main_giftcenter":
					_flowTipText = "请及时领奖过期不候哟~";
					_direction = "down";
					break;
				case "main_morefriend":
					_flowTipText = "邀请好友互赠体力";
					break;
				case "z_main_mail":
					_flowTipText = "注意领奖通知哦";
					_direction = "right";
					break;
				//一键补满
				case "z_n2_main_onekeyfillup":
					_flowTipText = "开服头五天,每天三次补满";
					_direction = "down";
					break;
				case "z_main_honor":
					_flowTipText = "打开看看吧";
					break;
				
				case "z_n92_activity":
					_flowTipText = "官网有大礼，赶紧来参与";
					_direction = "down";
					break;
				
				case "z_n95_serieslogin":
					_direction = "down";
					_flowTipText = "连续登录，惊喜天天有";
					break;
			}
		}
		
		public function setTipsNumTxt(num:int):void
		{
			_num = num
			if(_num <= 0)
			{
				mc.tips.visible = false;
				mc.numTxt.visible = false;
			}else
			{
				mc.tips.visible = true;
				mc.numTxt.visible = true;
				mc.numTxt.text = _num;
			}
		}
		
		protected function onCurrentBtnClickHandler(event:TouchEvent):void
		{
			switch(this._currentBtnStr)
			{
				case "z_n4_area":
					
					if(!CBaseUtil.checkSecondComplete(__showSignUpPanel))
					{
						return;
					}
					
					__showSignUpPanel();
					break;
				case "main_friendmessage":
					if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
					{
						WebJSManager.loginEnrol();
					}else
					{
						__showFriendMessage();
					}
					break;
				case "z_n1_main_forum":
					if(!Debug.inLobby)
					{
						return;
					}
					
					WebJSManager.navigateByTab(ConfigManager.LUTAN_URL);
					break;
				case "main_giftcenter":
					if(!Debug.inLobby)
					{
						return;
					}
					
					if(Debug.OPEN_WEB)
					{
						if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
						{
							WebJSManager.loginEnrol();
						}else
						{
							WebJSManager.navigateByTab(ConfigManager.REWARD_URL);
						}
					}else
					{
						CWidgetFloatText.instance.showTxt("功能暂未开放...");
					}
					
					break;
				case "z_n92_activity":
					if(!Debug.inLobby)
					{
						return;
					}
					
					WebJSManager.navigateByTab("http://3x.qipai.360.cn/activity.html");
					break;
				case "main_morefriend":
					if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
					{
						WebJSManager.loginEnrol();
					}else
					{
						Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_FRIEND_INVITE));
					}
					break;
				case "z_main_mail":
					if(!Debug.inLobby)
					{
						return;
					}
					
					if(Debug.OPEN_WEB)
					{
						if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
						{
							WebJSManager.loginEnrol();
						}else
						{
							setTipsNumTxt(0);
							WebJSManager.gameFuncGetInbox();
						}
					}else
					{
						CWidgetFloatText.instance.showTxt("功能暂未开放...");
					}
					
					break;
				//一键补满
				case "z_n2_main_onekeyfillup":
					if(mc.numTxt.visible == false)
					{
						CBaseUtil.showMessage("今日领取次数已用完，明天再来吧");		
						return;
					}
					if(CDataManager.getInstance().dataOfGameUser.curEnergy >= ConstGlobalConfig.MAX_ENERGY)
					{
						CBaseUtil.showMessage("当前体力点已达最大值，不需要一键补满");	
						return;
					}
					NetworkManager.instance.sendServerActivityDayEnergy();
					break;
				case "z_main_honor":
					__showDiploma();
					break;
				case "z_n95_serieslogin":
					__popSeriesLogin();
					break;
			}
		}
		
		private function __popSeriesLogin():void
		{
			NetworkManager.instance.sendServerActivity(1);
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_SERIES_LOGIN));
		}
		
		private function __showDiploma():void
		{
			var infoData:Object = DataUtil.instance.diplomaList.shift();
			if(infoData == null)
			{
				return;
			}
			DataUtil.instance.currentDiplomaNum --;
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramViewNormal(ConstantUI.PANEL_MATCH_DIPLOMA, true, infoData));
			this.setTipsNumTxt(DataUtil.instance.currentDiplomaNum);
			if(DataUtil.instance.currentDiplomaNum == 0)
			{
				this.visible = false;
			}
		}
		
		private function __showSignUpPanel():void
		{
			CBaseUtil.popSignUpWin();
		}
		
		private function __showFriendMessage():void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_FRIEND_MESSAGE));
		}

		public function get num():int
		{
			return _num;
		}

		public function set num(value:int):void
		{
			_num = value;
		}


	}
}