package framework.tutorial
{
	import com.game.event.GameEvent;
	import com.game.module.CDataManager;
	import com.ui.util.CBaseUtil;
	
	import flash.geom.Point;
	
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.fibre.patterns.Proxy;
	import framework.resource.faxb.tutorial.Grid;
	import framework.resource.faxb.tutorial.LevelTutorial;
	import framework.resource.faxb.tutorial.ShowArrow;
	import framework.resource.faxb.tutorial.Step;
	import framework.resource.faxb.tutorial.Tutorial;
	
	public class TutorialManagerProxy extends Proxy
	{
		private var _stepId:int;
		private var _curLevelId:int;
		private var _isStartCheckTutorial:Boolean;
		public static var inst:TutorialManagerProxy;
		private var _tutorialData:Tutorial;
		private var _currentShowArrow:ShowArrow;
		
		public static const NAME:String = "TutorialProxy";
		public function TutorialManagerProxy()
		{
			super(NAME);
			inst = this;
			
			Fibre.getInstance().registerObserver(GameEvent.EVENT_NOTICE_EXECUTE_NEXT_TUTORIAL_STEP, onCompleteStep);
			Fibre.getInstance().registerObserver(GameEvent.EVENT_NOTICE_SKIP_ALL_STEPS, skipAllSteps);
			Fibre.getInstance().registerObserver(GameEvent.EVENT_NOTICE_CHECK_WORLD, checkWorldSteps);
			Fibre.getInstance().registerObserver(GameEvent.EVENT_NOTICE_CHECK_BARRIER_PANEL, checkBarrierPanelSteps);
		}
		
		private function checkBarrierPanelSteps(d:Notification):void
		{
			if(_tutorialData == null || d.data == null)
			{
				return;
			}
			_curLevelId = d.data as int;
			if(CDataManager.getInstance().dataOfGameUser.isLevelPassed(_curLevelId))
			{
				return;
			}
			_currentShowArrow = getCurrentShowArrow()
			if(_currentShowArrow)
			{
				CBaseUtil.sendEvent(GameEvent.EVENT_SHOW_TUTORIAL_UI_ARROW, _currentShowArrow);
			}
		}
		
		private function checkWorldSteps(d:Notification):void
		{
			if(_tutorialData == null || d.data == null)
			{
				return;
			}
			_curLevelId = d.data as int;
			_currentShowArrow = getCurrentShowArrow()
			if(_currentShowArrow)
			{
				CBaseUtil.sendEvent(GameEvent.EVENT_SHOW_TUTORIAL_WORLD_ARROW, _currentShowArrow);
			}
		}
		
		private function skipAllSteps(d:Notification):void
		{
			_isStartCheckTutorial = false;
			if(_currentLevelData)
			{
				_stepId = _currentLevelData.step.length;
			}
			_isNeedCheck = false;
			
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CLEAR_TUTORIAL_PANEL);
		}
		
		private function onCompleteStep(d:Notification):void
		{
			++_stepId;
			_isStartCheckTutorial = false;
			
			if(d.data != null  )
			{
				checkTutorialCondition();
			}
		}
		
		public function setTutorialData(tutorial:Tutorial):void
		{
			_tutorialData = tutorial;
		}
		
		private var _currentLevelData:LevelTutorial;
		
		public function setLevelStatus(levelId:int):void
		{
			if(!Debug.IS_OPEN_TUTORIAL)
			{
				return;
			}
			
			_stepId = 0;
			_curLevelId = levelId;
			
			_currentLevelData = getCurrentLevelData();
			if(_currentLevelData != null)
			{
				_isNeedCheck = true;
			}
			else
			{
				_isNeedCheck = false;
			}
			
			
			
		}
		
		private var _isNeedCheck:Boolean;
		
		private function getCurrentLevelData():LevelTutorial
		{
			for each(var tutorial:LevelTutorial in _tutorialData.levelTutorial)
			{
				if(tutorial.levelId == _curLevelId)
				{
					return tutorial;
				}
			}
			
			return null;
		}
		
		private function getCurrentShowArrow():ShowArrow
		{
			for each(var showArrow:ShowArrow in _tutorialData.showArrow)
			{
				if(showArrow.levelId == _curLevelId)
				{
					return showArrow;
				}
			}
			return null;
		}
		
		private function checkTutorialStartCondition():Boolean
		{
			
			return true;
		}
		
		public function checkTutorialCondition():void
		{
			if(_isNeedCheck)
			{
				if(checkTutorialStartCondition())
				{
					execute();
				}
				if(_stepId >=  _currentLevelData.step.length - 1)
				{
					_isNeedCheck = false;
				}
			}
		}
		
		public function getCurrentStep():Step
		{
			return _currentLevelData.step[_stepId];
		}
		
		public function isShowSwap(srcX:int, srcY:int, dstX:int, dstY:int):Boolean
		{
			var step:Step = getCurrentStep();
			if(step.execute.clickGrid != null)
			{
				if(isInGrids(srcX, srcY, step) && isInGrids(dstX, dstY, step))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			return true;
		}
		
		public function getStepHint():Array
		{
			var step:Step = getCurrentStep();
			if(step.execute.clickGrid != null)
			{
				return [new Point(step.execute.clickGrid.grid[0].x, step.execute.clickGrid.grid[0].y), step.execute.clickGrid.direction];  
			}
			return null;
		}
		
		private function isInGrids(x:int, y:int, step:Step):Boolean
		{
			for each(var grid:Grid in step.execute.clickGrid.grid)
			{
				if((grid.x == x && grid.y == y))
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function execute():void
		{
			var data:Step = getCurrentStep();
			//noticeUIshow
			Fibre.getInstance().sendNotification(GameEvent.EVENT_SHOW_TUTORIAL_UI, data);
			
			_isStartCheckTutorial = true;
		}

		public function get isStartCheckTutorial():Boolean
		{
			return _isStartCheckTutorial;
		}

	}
}