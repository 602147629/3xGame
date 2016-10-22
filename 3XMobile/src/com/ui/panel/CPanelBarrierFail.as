package com.ui.panel
{
	import com.game.consts.ConstIcon;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.ui.button.CButtonCommon;
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
	
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewChooseLevel;
	import framework.fibre.core.Fibre;
	import framework.sound.MediatorAudio;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	
	/**
	 * @author caihua
	 * @comment 关卡失败
	 * 创建时间：2014-6-10 下午5:35:07 
	 */
	public class CPanelBarrierFail extends CPanelAbstract
	{
		private var _friendList:CWidgetBarrierFriendList;
		private var _closeBtn:CButtonCommon;
		
		private var _tryagainBtn:CButtonCommon;
		
		private var _dataOfLevel:CDataOfLevel;
		private var _numFrames:Array;
		private var resulttf:TextField;
		
		public function CPanelBarrierFail()
		{
			super("dialog.barrier.fail");
		}
		
		override protected function drawContent():void
		{
			Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_LOSE, null, Fibre.SOUND_NOTIFICATION);
			
			_dataOfLevel = CDataManager.getInstance().dataOfLevel;
			
			mc.bgpos.addChild(CBaseUtil.createBgSimple(ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER));
			
			var bg1:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_TOOL_BG_SCALE , 
				new Rectangle(15 , 15 , 2,2) , 
				new Point(375 , 134));
			
			mc.toolbgpos.addChild(bg1);
			
			__specMc();
			
			__initEvents();
			
			__drawLevelMC();
			
			mc.score.scorenum.text = _dataOfLevel.d.score;
			
			__drawFailTextAndIcon();
		}
		
		private function __drawFailTextAndIcon():void
		{
			var iconId:int = CDataManager.getInstance().dataOfLevel.levelConfig.failIcon;
			var icon:MovieClip = ResHandler.getMcFirstLoad("common.icon");
			
			//收集够了
			if(_dataOfLevel.isCollectionSatisfied())
			{
				resulttf.text = "没有达到一星分数";
				iconId = 100;
			}
			else
			{
				resulttf.text = _dataOfLevel.levelConfig.failDesc;
			}
			
			icon.x =  resulttf.x + resulttf.width + 5;
			
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
				
				cardMc.x =  resulttf.x + resulttf.width;
				cardMc.y = mc.textbg.y + (mc.textbg.height - cardMc.width) /2;
				
				if(cardMc is MovieClip)
				{
					cardMc.y -= 3;
				}
				
				mc.addChild(cardMc);
			}
		}
		
		private function __drawLevelMC():void
		{
			_numFrames = CBaseUtil.getFramesByBmp("bmd.step.number", new Point(30, 27), 10);
			
			var levelMc:CWidgetAniNumber = new CWidgetAniNumber(_numFrames, CDataManager.getInstance().dataOfLevel.level+1);
			var width:int = 152;
			mc.levelpos.x = (width - levelMc.width) / 2 + 135.5;
			mc.levelpos.addChild(levelMc);
		}
		
		
		private function __specMc():void
		{
			//好友
			_friendList = new CWidgetBarrierFriendList(_dataOfLevel.level);
			this.mc.friendlistpos.addChild(_friendList);
			
			//按钮
			_closeBtn = new CButtonCommon("close");
			this.mc.btnclosepos.addChild(_closeBtn);
			
			_tryagainBtn = new CButtonCommon("start" , "再试一次");
			this.mc.btnconfirmpos.addChild(_tryagainBtn);
			
			resulttf = CBaseUtil.getTextField(mc.resulttf , 20 , 0x5e2f12);
			
			var sug1:TextField = CBaseUtil.getTextField(mc.sug1 , 16 , 0x5e2f12 , "left");
			sug1.text = "小建议 : ";
			var sug2:TextField = CBaseUtil.getTextField(mc.sug2 , 16 , 0x5e2f12, "left");
			sug2.text = "1.优先消除屏幕下方的物体";
			var sug3:TextField = CBaseUtil.getTextField(mc.sug3 , 16 , 0x5e2f12, "left");
			sug3.text = "2.在开始前购买消除道具";
			
			mc.score.scorename = CBaseUtil.getTextField(mc.score.scorename , 16 , 0x5e2f12);
			mc.score.scorenum = CBaseUtil.getTextField(mc.score.scorenum , 16 , 0x5e2f12);
		}
		
		private function __initEvents():void
		{
			_closeBtn.addEventListener(TouchEvent.TOUCH_TAP , __onClose , false, 0 ,true);
			_tryagainBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAgin , false, 0 ,true);
		}
		
		protected function __onAgin(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_FAIL));
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramViewChooseLevel(ConstantUI.SCENE_MAIN , true ,  _dataOfLevel.level));
			
			CBaseUtil.delayCall(function():void
			{
				CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL , new DatagramViewChooseLevel(ConstantUI.DIALOG_BARRIER_START , true , _dataOfLevel.level));
			},0.8,1);
			
		}
		
		protected function __onClose(event:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.DIALOG_BARRIER_FAIL));
			
			Fibre.getInstance().sendNotification(MediatorBase.G_CHANGE_WORLD, new DatagramView(ConstantUI.SCENE_MAIN));
		}
		
		override protected function dispose():void
		{
			_closeBtn.removeEventListener(TouchEvent.TOUCH_TAP , __onClose );
			_tryagainBtn.removeEventListener(TouchEvent.TOUCH_TAP , __onAgin );
		}
	}
}
