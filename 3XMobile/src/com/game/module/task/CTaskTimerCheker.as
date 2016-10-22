package com.game.module.task
{
	import com.game.consts.ConstGameStatus;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.ui.iface.ITaskChecker;
	import com.ui.util.CTimer;
	
	import framework.model.DataRecorder;
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment 限制时间任务
	 * 创建时间：2014-6-26 下午4:27:29 
	 */
	public class CTaskTimerCheker extends CTaskChecker implements ITaskChecker
	{
		private var _dataOfLevel:CDataOfLevel;
		private var _timer:CTimer;
		private var _d:DataRecorder;
		
		public function CTaskTimerCheker(d:DataRecorder)
		{
			_dataOfLevel = CDataManager.getInstance().dataOfLevel;
			_d = d;
			_timer = new CTimer();
		}
		
		public function start():void
		{
			_timer.addCallback(__onTime , 1);
			_timer.start();
		}
		
		private function __onTime():void
		{
			_dataOfLevel.timeRemain -- ;
			
			//如果在线，不需要检测状态
			if(Debug.ISONLINE)
			{
				return;
			}
			return;
			var status:int = getStatus();
			
			switch(status)
			{
				case ConstGameStatus.GAME_STATUS_FAIL :
					_timer.delCallback(__onTime);
					showResult({level:_dataOfLevel.level , score:_d.score , step:_d.swapStep} , ConstantUI.DIALOG_BARRIER_FAIL);
					break;
				case ConstGameStatus.GAME_STATUS_SUCC :
					_timer.delCallback(__onTime);
					showResult({level:_dataOfLevel.level , score:_d.score , step:_d.swapStep} , ConstantUI.DIALOG_BARRIER_SUCC);
					break;
				case ConstGameStatus.GAME_STATUS_UNCOMPLETE :
					break;
				default :
			}	
		}
		
		/**
		 * 获得时间类型关卡的状态
		 */
		public function getStatus():int
		{
//			trace("CTaskTimerChecker -- time remain : " + _dataOfLevel.timeRemain , " currrent score : "+ _d.score );
			
			//时间到，分不够
			if(_dataOfLevel.timeRemain <= 0 && _d.score < _dataOfLevel.scoreNeed)
			{
				return ConstGameStatus.GAME_STATUS_FAIL;
			}
			//时间没到，分够
			else if(_dataOfLevel.timeRemain >= 0 && _d.score >= _dataOfLevel.scoreNeed)
			{
				return ConstGameStatus.GAME_STATUS_SUCC;
			}
			else
			{
				return ConstGameStatus.GAME_STATUS_UNCOMPLETE;
			}
		}
	}
}