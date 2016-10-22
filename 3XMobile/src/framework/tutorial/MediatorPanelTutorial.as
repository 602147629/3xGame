package framework.tutorial
{
	import com.game.event.GameEvent;
	import com.greensock.TweenLite;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Notification;
	import framework.resource.faxb.tutorial.Panel;
	import framework.resource.faxb.tutorial.ShowArea;
	import framework.resource.faxb.tutorial.ShowArrow;
	import framework.resource.faxb.tutorial.Step;
	import framework.rpc.DataUtil;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	public class MediatorPanelTutorial extends MediatorBase
	{
		/**
		 * 不透明层 
		 */		
		private var _opaqueLayer:Sprite;
		
		private var _itemLayer:Sprite;
		
		private var _currentStep:Step;
		
		private var _skipBtn:CButtonCommon;
		
		private var _isShowArrowArea:Boolean;
		
		private static const ARROW_X:int = 190;
		private static const ARROW_Y:int = 490;
		
		private static const BTN_X:int = 293;
		private static const BTN_Y:int = 511;
		
		public function MediatorPanelTutorial()
		{
			super(ConstantUI.PANEL_TUTORIAL, ConstantUI.PANEL_TUTORIAL, false, false);
		}
		
		override protected function start(d:DatagramView):void
		{
			this._opaqueLayer = new Sprite();
			mc.back.addChild(this._opaqueLayer);
			
			this._itemLayer = new Sprite();
			mc.back.addChild(this._itemLayer);
			
			CBaseUtil.regEvent(GameEvent.EVENT_SHOW_TUTORIAL_UI, showTutorialPanel);
			CBaseUtil.regEvent(GameEvent.EVENT_SHOW_TUTORIAL_UI_ARROW, showTutorialArrow);
			CBaseUtil.regEvent(GameEvent.EVENT_TUTORIAL_CONFIRM, tutorialConfirm);
			CBaseUtil.regEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL, tutorialClear);
			CBaseUtil.regEvent(GameNotification.EVENT_UPDATE_DIPLOMA_NUM , onUpdateDiploma);
			CBaseUtil.regEvent(GameNotification.EVENT_DIPLOMA_TIPS , onDiplomaTips);
		}
		
		override protected function end():void
		{
			CBaseUtil.removeEvent(GameEvent.EVENT_SHOW_TUTORIAL_UI, showTutorialPanel);
			CBaseUtil.removeEvent(GameEvent.EVENT_SHOW_TUTORIAL_UI_ARROW, showTutorialArrow);
			CBaseUtil.removeEvent(GameEvent.EVENT_TUTORIAL_CONFIRM, tutorialConfirm);
			CBaseUtil.removeEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL, tutorialClear);
			CBaseUtil.removeEvent(GameNotification.EVENT_UPDATE_DIPLOMA_NUM , onUpdateDiploma);
			CBaseUtil.regEvent(GameNotification.EVENT_DIPLOMA_TIPS , onDiplomaTips);
		}
		
		private function showTutorialArrow(n:Notification):void
		{
			if(n.data == null)
			{
				return;
			}
			
			if(_isShowArrowArea)
			{
				_isShowArrowArea = false;
				this.addArrow(ARROW_X, ARROW_Y);
				this.addButtonEffect(BTN_X, BTN_Y);
				return;
			}
			
			var showArrow:ShowArrow = n.data as ShowArrow;
			if(showArrow.showArea.length != 0)
			{
				_isShowArrowArea = true;
				this.addMask(showArrow.showArea);
				var showArea:ShowArea = showArrow.showArea[0];
				this.addArrow(showArea.x - 100, showArea.y - 20);
				
				this.addSkipBtn();
			}else
			{
				_isShowArrowArea = false;
				this.addArrow(ARROW_X, ARROW_Y);
				this.addButtonEffect(BTN_X, BTN_Y);
			}
		}
		
		private function showTutorialPanel(n:Notification):void
		{
			if(n.data == null)
			{
				return;
			}
			
			tutorialClear();
			
			this._currentStep = n.data as Step;
			if(this._currentStep.execute.isDark == "true")
			{
				var areaList:Vector.<ShowArea> = this._currentStep.execute.showArea;
				this.addMask(areaList);
				
				this.addSkipBtn();
			}else
			{
				CBaseUtil.delayCall(tutorialClear, 5);
			}
			
			var itemList:Vector.<Panel> = this._currentStep.execute.panel;
			this.addItem(itemList);
		}
		
		private function tutorialConfirm(n:Notification):void
		{
			var panel:Panel = n.data as Panel;
			
			this[panel.callbackFunction].call();
		}
		
		private function tutorialClear(n:Notification = null):void
		{
			this._opaqueLayer.graphics.clear();
			
			while(_itemLayer.numChildren)
			{
				_itemLayer.removeChildAt(0);
			}
			
			if(_skipBtn && mc.back.contains(this._skipBtn))
			{
				_skipBtn.removeEventListener(TouchEvent.TOUCH_TAP, onSkipClick);
				mc.back.removeChild(_skipBtn);
			}
		}
		
		/**
		 * 清空显示 
		 * 
		 */		
		private function clearLayer():void
		{
			tutorialClear();
			
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_EXECUTE_NEXT_TUTORIAL_STEP, true);
		}
		
		/** 
		 * 添加蒙版 
		 * 
		 */
		private function addMask(areaList:Vector.<ShowArea>):void
		{
			this._opaqueLayer.graphics.clear();
			this._opaqueLayer.graphics.beginFill(0,0.4);
			this._opaqueLayer.graphics.drawRect(0,0,GameEngine.getInstance().stage.stageWidth,GameEngine.getInstance().stage.stageHeight);
			for each(var areaObj:ShowArea in areaList)
			{
				this._opaqueLayer.graphics.drawRect(areaObj.x,areaObj.y - 5,areaObj.width,areaObj.height);
			}
			this._opaqueLayer.graphics.endFill();
		}
		
		/**
		 *  添加显示对象 
		 * @param itemList
		 * 
		 */		
		private function addItem(itemList:Vector.<Panel>):void
		{
			for each(var panelObj:Panel in itemList)
			{
				var item:CItemTutorial = new CItemTutorial(panelObj.panelId);
				
				item.showContent(panelObj);
				
				this._itemLayer.addChild(item);
			}
		}
		
		/**
		 * 添加跳过按钮 
		 * 
		 */		
		private function addSkipBtn():void
		{
			_skipBtn = new CButtonCommon("z_n7_jump");
			_skipBtn.x = 925;
			_skipBtn.y = 12;
			mc.back.addChild(_skipBtn);
			
			_skipBtn.addEventListener(TouchEvent.TOUCH_TAP, onSkipClick);
		}
		
		private function onSkipClick(e:TouchEvent):void
		{
			_isShowArrowArea = false;
			
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_SKIP_ALL_STEPS);
		}
		
		/**
		 *  添加箭头 
		 * @param x
		 * @param y
		 * 
		 */		
		private function addArrow(x:int, y:int):void
		{
			var cl:Class = ResHandler.getClass("tutorial.arrow");
			var arrow:MovieClip = new cl();
			arrow.scaleX = arrow.scaleY = 0.8;
			arrow.x = x;
			arrow.y = y;
			this._itemLayer.addChild(arrow);
		}
		
		/**
		 *  按钮特效 
		 * @param x
		 * @param y
		 * 
		 */		
		private function addButtonEffect(x:int, y:int):void
		{
			var cl:Class = ResHandler.getClass("effect.button");
			var btn:MovieClip = new cl();
			btn.mouseChildren = false;
			btn.mouseEnabled = false;
			btn.enabled = false;
			btn.x = x;
			btn.y = y;
			this._itemLayer.addChild(btn);
		}
		
		private function onUpdateDiploma(d:Notification):void
		{
			DataUtil.instance.currentDiplomaNum ++;
		}
		
		private function onDiplomaTips(d:Notification):void
		{
			var btn:CButtonCommon = new CButtonCommon("z_main_honor");
			btn.x = ConstantUI.WIDTH - btn.width >> 1;
			btn.y = ConstantUI.HEIGHT - btn.height >> 1;
			this._itemLayer.addChild(btn);
			
			CBaseUtil.delayCall( function():void
			{
				TweenLite.to(btn, 0.5, {x:15, y:360, onComplete:onMoveOver, onCompleteParams:[btn]});
			}, 1, 1);
		}
		
		private function onMoveOver(btn:CButtonCommon):void
		{
			if(btn && this._itemLayer.contains(btn))
			{
				this._itemLayer.removeChild(btn);
			}
			
			CBaseUtil.sendEvent(GameNotification.EVENT_SHOW_DIPLOMA);
		}
	}
}