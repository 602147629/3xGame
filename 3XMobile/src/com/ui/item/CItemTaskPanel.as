package com.ui.item
{
	import com.game.consts.ConstFlowTipSize;
	import com.game.consts.ConstTaskType;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CStringUtil;
	import com.ui.util.CTimer;
	import com.ui.widget.CWidgetCDNumber;
	
	import flash.display.MovieClip;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import framework.fibre.core.Notification;
	import framework.model.DataRecorder;
	import framework.sound.MediatorAudio;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 游戏中任务面板
	 * 创建时间：2014-6-26 下午5:57:08 
	 */
	public class CItemTaskPanel extends CItemAbstract
	{
		private var _dataOfLevel:CDataOfLevel;
		private var _decreaseMc:MovieClip;
		private var _d:DataRecorder;
		
		private var _cls:Class;
		
		private var _timer:CTimer;
		
		private var _itemList:Array;
		
		private var _flowTipItem:CItemFlowTip;
		
		private var _stepNumber_0:CWidgetCDNumber;
		private var _stepNumber_1:CWidgetCDNumber;
		private var _stepNumber_2:CWidgetCDNumber;
		private var _stepNumber_3:CWidgetCDNumber;
		private var _hasTip:Boolean;
		
		private var _soundWarningLimitTime:int = 11;
		private var _soundWarningLimitStep:int = 6;
		private var _lastPlayedStep:int = _soundWarningLimitStep;
		
		private var _lastPlayedTime:int = _soundWarningLimitTime;
		
		private var _warningPlayed:Boolean = false;
		
		public function CItemTaskPanel(d:DataRecorder)
		{
			_dataOfLevel = CDataManager.getInstance().dataOfLevel;
			
			_d = d;
			
			_cls = ResHandler.getClass("numberStep");
			
			_timer = new CTimer();
			
			_itemList = new Array();
			
			super(ConstantUI.ITEM_BARRIER_TASK);
		}
		
		override protected function drawContent():void
		{
			var tf:TextField = CBaseUtil.getTextField(mc.level_num, 20, 0xFAFA95);
			tf.text = "第 " + (_dataOfLevel.level + 1) + " 关";
			
			if(_dataOfLevel.taskType == ConstTaskType.TASK_TYPE_STEP)
			{
				mc.mc_step.visible = true;
				mc.mc_time.visible = false;
				
				_decreaseMc = mc.mc_step;
				for(var i :int = 0 ;i < 4 ; i++)
				{
					_decreaseMc["pos"+i].removeChildren();
					
					this["_stepNumber_"+i] = new CWidgetCDNumber(24, 29);
					_decreaseMc["pos"+i].addChild(this["_stepNumber_"+i]);
				}
				
				updateStepMc();
			}
			else if(_dataOfLevel.taskType == ConstTaskType.TASK_TYPE_TIME)
			{
				mc.mc_step.visible = false;
				mc.mc_time.visible = true;
				
				_decreaseMc = mc.mc_time;
				for(var j :int = 0 ;j < 4 ; j++)
				{
					_decreaseMc["pos"+j].removeChildren();
					
					this["_stepNumber_"+j] = new CWidgetCDNumber(24, 29);
					_decreaseMc["pos"+j].addChild(this["_stepNumber_"+j]);
				}
				
				updateTimeMc();
			}
			
			__drawCollectMc()
			
			CBaseUtil.regEvent(GameNotification.EVENT_GAME_OVER , __onGameOver);
		}
		
		private function __onGameOver(d:Notification):void
		{
			CBaseUtil.delayCall(function():void
			{stopUpdate()} , 1 , 1);
		}
		
		private function __drawCollectMc():void
		{
			mc.star.visible = false;
			mc.scoreneed.visible = false;
			
			if(_dataOfLevel.collectList.length == 0)
			{
				mc.star.visible = true;
				mc.scoreneed.visible = true;
				mc.scoreneed.text = "" + _dataOfLevel.scoreNeed;
			}
			else
			{
				for(var j:int =0 ; j < _dataOfLevel.collectList.length ; j++)
				{
					var item:CItemTaskCollectBar = new CItemTaskCollectBar(_dataOfLevel.collectList[j] , _d);
					
					item.x = mc.itempos.x;
					item.y = mc.itempos.y + 33 * j;
					
					mc.addChild(item);
					
					item.mouseChildren = false;
					
					_itemList.push(item);
				}
				
				mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
				mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			}
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(! (event.target is CItemTaskCollectBar))
			{
				return;
			}
			
			var item:CItemTaskCollectBar = event.target as CItemTaskCollectBar;
			
			if(!_hasTip)
			{
				_hasTip = true;
				CBaseUtil.showTip(_dataOfLevel.levelConfig.startDesc , mc.localToGlobal(new Point(item.x + 50 , item.y + item.height)),ConstFlowTipSize.FLOW_TIP_MAX ,true, "right");
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
		
		private function __updateDecreaseMc():void
		{
			if(_dataOfLevel.taskType == ConstTaskType.TASK_TYPE_STEP)
			{
				updateStepMc();
			}
			else if(_dataOfLevel.taskType == ConstTaskType.TASK_TYPE_TIME)
			{
				updateTimeMc();
			}
		}
		
		public function updateTimeMc(isBingoTime:Boolean = false):void
		{
			var numArray:Array = new Array();
			
			if(_dataOfLevel.timeRemain < _soundWarningLimitTime && _dataOfLevel.timeRemain < _lastPlayedTime)
			{
				_lastPlayedTime = _dataOfLevel.timeRemain ; 
				
				if(!_warningPlayed && !isBingoTime)
				{
					CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_WARNING);
				}
			}
			
			if(_dataOfLevel.timeRemain <= 0)
			{
				_warningPlayed = true;
				_timer.delCallback(__updateDecreaseMc);
			}
			
			var min:int = int(_dataOfLevel.timeRemain / 60);
			var seconds:int = _dataOfLevel.timeRemain - min * 60;
			
			if(min < 10)
			{
				numArray.push(0);
				numArray.push(min.toString());
			}
			else
			{
				var t:Array = CStringUtil.splitNumtoStr(min);
				numArray.push(t[0] , t[1]);
			}
			
			if(seconds < 10)
			{
				numArray.push(0);
				numArray.push(seconds.toString());
			}
			else
			{
				var p:Array = CStringUtil.splitNumtoStr(seconds);
				numArray.push(p[0] , p[1]);
			}
			
			_drawArray(numArray);
		}
		
		//5步以内一直播
		public function updateStepMc(isBingoTime:Boolean = false):void
		{
			var remainStepNumber:int = _dataOfLevel.stepLimit - _d.swapStep;
			
			remainStepNumber = remainStepNumber > 0 ? remainStepNumber : 0;
			
			if(remainStepNumber < _soundWarningLimitStep && remainStepNumber < _lastPlayedStep)
			{
				_lastPlayedStep = remainStepNumber;
				
				if(!_warningPlayed && !isBingoTime)
				{
					CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_WARNING);
				}
			}
			
			if(remainStepNumber == 0)
			{
				_warningPlayed = true;
//				_timer.delCallback(__updateDecreaseMc);
			}
			
			var numArray:Array = CStringUtil.splitNumtoStr(remainStepNumber);
			
			for(var i :int = numArray.length ;i < 4 ; i++)
			{
				numArray.unshift(0);
			}
			
			_drawArray(numArray);
		}
		
		private function _drawArray(numArray:Array):void
		{
			for(var i :int = 0 ;i < numArray.length ; i++)
			{
				this["_stepNumber_"+i].setNumber(numArray[i]);
			}	
		}
		
		public function startUpate():void
		{
			_timer.addCallback(__updateDecreaseMc , 1);
			_timer.start();
		}
		
		public function stopUpdate():void
		{
			_timer.delCallback(__updateDecreaseMc);
		}
		
		override protected function dispose():void
		{
			super.dispose();
			_warningPlayed = false;
			_lastPlayedStep = _soundWarningLimitStep;
			_timer.delCallback(__updateDecreaseMc);
			
			CBaseUtil.removeEvent(GameNotification.EVENT_GAME_OVER , __onGameOver);
		}
	}
}