package com.ui.item
{
	import com.game.consts.ConstFlowTipSize;
	import com.game.consts.ConstIcon;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfGameUser;
	import com.greensock.TweenLite;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.MovieClip;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import framework.resource.faxb.starreward.Levels;
	import framework.rpc.NetworkManager;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment 星值奖励
	 * 创建时间：2014-8-27  10:09:34 
	 */
	public class CItemStarReward extends CItemAbstract
	{
		private var _startX:Number = -163;
		private var _endX:Number = 0;
		
		private var _userData:CDataOfGameUser;
		
		private var _flowTipText:String = "";
		
		private var _flowTipItem:CItemFlowTip;
		private var _tf:TextField;
		private var _needStars:Number;
		private var _status:int;
		
		private var _rewardid:int;
		private var _config:Levels;
		
		public static const REWRAD_TYPE_SILVER:int = 0; 
		public static const REWRAD_TYPE_GOLD:int = 1; 
		public static const REWRAD_TYPE_TOOL:int = 2; 
		
		private var _rewardType:int = 0 ;
		
		private var _rewardNum:int = 0;
		private var _toolId:int;
		
		private var _icon:MovieClip;

		private var rewardBtn:CButtonCommon;
		
		private var _height:int = 50;
		
		public function CItemStarReward(config:Levels)
		{
			_config = config;
			_rewardid = _config.level;
			super("function.item.starreward");
		}
		
		override protected function drawContent():void
		{
			__decodeRewardInfo();
			
			__drawBg();
			
			mc.rewardnum = CBaseUtil.getTextField(mc.rewardnum , 14 , 0xffffff , null , false , 0x01);
			mc.rewardnum.text = "x "+_rewardNum;
			
			__drawIcon();
			
			__drawProgress();
			
			__drawBtn();
			
			__fixPos();
		}
		
		private function __fixPos():void
		{
			mc.rewardnum.y =  (_height - mc.rewardnum.height) / 2 + 3;
			_icon.y = (_height - _icon.height) / 2;
			rewardBtn.y = (_height - rewardBtn.height) / 2;
		}
		
		private function __drawBg():void
		{
			mc.bgpos.addChild(CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_COMMON_FRIEND , 
				new Rectangle(20 , 20 , 1,1) , 
				new Point(430 , _height)));
		}
		
		private function __drawIcon():void
		{
			mc.iconpos.addChild(_icon);
		}
		
		private function __drawProgress():void
		{
			var totalStar:int = CDataManager.getInstance().dataOfGameUser.msgUserInfo.totalStar;
			
			var needStar:int = _config.star;
			
			totalStar = totalStar > needStar ? needStar : totalStar;
			
			var bar:MovieClip = mc.progress.bar;
			mc.progress.stop();
			var endX:Number = (totalStar / needStar) * (_endX - _startX) + _startX;
			
			TweenLite.to(bar , 0.4 , {x:endX , y: bar.y});
			
			mc.progresstext.text = ""+ totalStar + "/" + needStar;
		}
		
		private function __drawBtn():void
		{
			var tf:TextFormat = CFontUtil.getTextFormat(16 , 0xffffff);
			
			rewardBtn = new CButtonCommon("greenshort" , "领取" , tf);
			
			mc.rewardbtnpos.addChild(rewardBtn);
			rewardBtn.addEventListener(TouchEvent.TOUCH_TAP , __onReward , false , 0 , true);
			
			if(_status == 0)
			{
				rewardBtn.textField.text = "领取";
			}
			else
			{
				rewardBtn.textField.text = "已领取"
			}
			
			if(_config.star > CDataManager.getInstance().dataOfGameUser.totalStar)
			{
				rewardBtn.enabled = false;
			}
			else
			{
				rewardBtn.enabled = true;
				rewardBtn.buttonMode = true;
			}
		}
		
		private function __decodeRewardInfo():void
		{
			var toolId:int = 0 ;
			var ob:Object = {};
			
			if(_config.silver != 0)
			{
				_rewardType = REWRAD_TYPE_SILVER;
				_rewardNum = _config.silver;
				_toolId = ConstIcon.ICON_TYPE_SILVER;
				_icon = ResHandler.getMcFirstLoad("common.icon");
				_icon.gotoAndStop(_toolId + 1);
			}
			else if(_config.gold != 0)
			{
				_rewardType = REWRAD_TYPE_GOLD;
				_rewardNum = _config.gold;
				_toolId = ConstIcon.ICON_TYPE_GOLD;
				_icon = ResHandler.getMcFirstLoad("common.icon");
				_icon.gotoAndStop(_toolId + 1);
			}
			else if(_config.items.num != 0)
			{
				_rewardType = REWRAD_TYPE_TOOL;
				_rewardNum = _config.items.num;
				_toolId = _config.items.itemId;
				
				_icon = ResHandler.getMcFirstLoad("common.tool.img");
				
				_icon.gotoAndStop(CBaseUtil.getToolIconFrameByToolId(_toolId));
			}
			
			ob.rewardType = _rewardType;
			ob.rewardNum = _rewardNum;
		}
		
		protected function __onReward(event:TouchEvent):void
		{
			//20140828 修改为无论点哪个按钮，都领取第一个
			NetworkManager.instance.sendServerGetStarReward(CDataManager.getInstance().dataOfGameUser.rewardLevel + 1);
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_flowTipItem)
			{
//				_flowTipText = "打关收星好礼相送";
				_flowTipItem = new CItemFlowTip(_flowTipText , ConstFlowTipSize.FLOW_TIP_MIDDLE);
				_flowTipItem.x = mc.x + 20;
				_flowTipItem.y = mc.y + mc.height;
				mc.addChild(_flowTipItem);
			}
			else
			{
				mc.removeChild(_flowTipItem);
				_flowTipItem = null;
			}
		}
	}
}