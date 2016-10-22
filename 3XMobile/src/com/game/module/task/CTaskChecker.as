package com.game.module.task
{
	import com.game.consts.ConstTaskType;
	import com.game.module.CDataManager;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.model.DataRecorder;
	import framework.view.mediator.MediatorBase;

	/**
	 * @author caihua
	 * @comment 关卡任务触发器
	 * 创建时间：2014-6-13 上午9:58:38 
	 */
	public class CTaskChecker
	{
		public static function doCheck(d:DataRecorder):void
		{
			var taskType:int = CDataManager.getInstance().dataOfLevel.taskType;
			if(taskType == ConstTaskType.TASK_TYPE_STEP)
			{
				new CTaskStepChecker(d).start();
			}
			else if(taskType == ConstTaskType.TASK_TYPE_TIME)
			{
				new CTaskTimerCheker(d).start();
			}
		}
		
		protected function showResult(params:Object , id:String):void
		{
			var dv:DatagramView = new DatagramView(id);
			for(var k:* in params)
			{
				dv.injectParameterList[k] = params[k];
			}
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,dv);
		}
	}
}