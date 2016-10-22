package com.game.module.task
{
	import com.game.consts.ConstGameStatus;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.ui.iface.ITaskChecker;
	import com.ui.util.CTimer;
	
	import framework.model.DataRecorder;
	import framework.resource.faxb.levelproperty.ElementDemand;
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment 限制交换次数任务
	 * 创建时间：2014-6-26 下午4:27:39 
	 */
	public class CTaskStepChecker extends CTaskChecker implements ITaskChecker
	{
		private var _dataOfLevel:CDataOfLevel;
		private var _d:DataRecorder;
		private var _timer:CTimer;
		
		private var _tick:int = 0;
		
		public function CTaskStepChecker(d:DataRecorder)
		{
			_dataOfLevel = CDataManager.getInstance().dataOfLevel;
			_d = d;
//			_timer = new CTimer();
		}
		
		public function start():void
		{
			/*timer.addCallback(__onTime , 1);
			_timer.start();*/
		}
		
		public function __onTime():void
		{
			//如果在线，不需要检测状态
			if(Debug.ISONLINE)
			{
				return;
			}
			
			var status:int = getStatus();
			switch(status)
			{
				case ConstGameStatus.GAME_STATUS_FAIL :
//					_timer.delCallback(__onTime);
					showResult({level:_dataOfLevel.level , score:_d.score , step:_d.swapStep} , ConstantUI.DIALOG_BARRIER_FAIL);
					break;
				case ConstGameStatus.GAME_STATUS_SUCC :
//					_timer.delCallback(__onTime);
					showResult({level:_dataOfLevel.level , score:_d.score , step:_d.swapStep} , ConstantUI.DIALOG_BARRIER_SUCC);
					break;
				case ConstGameStatus.GAME_STATUS_UNCOMPLETE :
					break;
				default :
			}	
		}
		
		public function getStatus():int
		{
			var scoreSatisfied:Boolean = false;
			var collectSatisfied:Boolean = false;
			//检测分数
			if(_d.score > _dataOfLevel.scoreNeed)
			{
				scoreSatisfied = true;
			}
			
			//检测收集
			//不需要收集
			if(_dataOfLevel.collectList.length == 0)
			{
				collectSatisfied = true;
			}
				//需要收集
			else
			{
				for(var i:int =0 ; i < _dataOfLevel.collectList.length ; i++)
				{
					var element:ElementDemand = _dataOfLevel.collectList[i];
					var collectedNum:int = _d.getCollectItemNum(element);
					
					if( collectedNum < element.num)
					{
						collectSatisfied = false;
						break;
					}
					else
					{
						collectSatisfied = true;
					}
				}
			}
			
			//			trace(" collectSatisfied  == " + collectSatisfied);
			
			//失败
			if(_d.swapStep >= _dataOfLevel.stepLimit && (!collectSatisfied || !scoreSatisfied) )
			{
				return ConstGameStatus.GAME_STATUS_FAIL;
			}
				//成功
			else if(_d.swapStep <= _dataOfLevel.stepLimit && collectSatisfied && scoreSatisfied)
			{
				return ConstGameStatus.GAME_STATUS_SUCC;
			}
				//没完
			else
			{
				return ConstGameStatus.GAME_STATUS_UNCOMPLETE;
			}
		}
		
		/**
		 * 获得当前关卡的状态
		 */
		public static function getPassLevelStatus(_d:DataRecorder, _dataOfLevel:CDataOfLevel):int
		{
			var scoreSatisfied:Boolean = false;
			var collectSatisfied:Boolean = false;
			//检测分数
			if(_d.score > _dataOfLevel.scoreNeed)
			{
				scoreSatisfied = true;
			}
			
			//检测收集
			//不需要收集
			if(_dataOfLevel.collectList.length == 0)
			{
				collectSatisfied = true;
			}
			//需要收集
			else
			{
				for(var i:int =0 ; i < _dataOfLevel.collectList.length ; i++)
				{
					var element:ElementDemand = _dataOfLevel.collectList[i];
					var collectedNum:int = _d.getCollectItemNum(element);
				
					if( collectedNum < element.num)
					{
						collectSatisfied = false;
						break;
					}
					else
					{
						collectSatisfied = true;
					}
				}
			}
			
//			trace(" collectSatisfied  == " + collectSatisfied);
			
			//失败
			if(_d.swapStep >= _dataOfLevel.stepLimit && (!collectSatisfied || !scoreSatisfied) )
			{
				return ConstGameStatus.GAME_STATUS_FAIL;
			}
			//成功
			else if(_d.swapStep <= _dataOfLevel.stepLimit && collectSatisfied && scoreSatisfied)
			{
				return ConstGameStatus.GAME_STATUS_SUCC;
			}
			//没完
			else
			{
				return ConstGameStatus.GAME_STATUS_UNCOMPLETE;
			}
		}
	}
}