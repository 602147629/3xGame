package time
{

	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * @author WangPanTao
	 * 创建时间：2013-5-17 下午01:50:30
	 * 
	 */
	public class TimerManager
	{
		protected var _taskList:HashMap = new HashMap();
		/** 计时器间隔 **/				
		protected var _delay:int = 40;
		/** 计时器 **/
		protected var _timer:Timer = new Timer(_delay);
		
		protected var _timeCount:Number = 0;
		
		private var _taskId:Number = 0;
		
		/**
		 * 单例实例
		 **/ 
		protected static var _instance : TimerManager;
		
		public function TimerManager()
		{
		}
		
		/**-------------------------------私有方法--------------------------------------------*/		  
		// 计时器事件		 	  
		protected function timerHandler(event:TimerEvent):void
		{					
			this._timeCount ++;
			var timeNum:Number = this._timeCount * this._delay;
			var list:Array = _taskList.keys();
			for each (var k:String in list) 
			{			
				var task:ITask = _taskList.get(k);
				if( !task ) continue;
				if( task.taskIsCompleted )
				{
					removeTask( task.name );
					continue;
				}
				if( int( (timeNum - this._delay)/task.taskDelay) != int(timeNum /task.taskDelay))
				{
					task.doTask();
				}
			}	
		}
		/**
		 * 开始执行计划任务	
		 * 
		 */		
		protected function startDoTask():void
		{		
			if( _timer == null )
			{
				_timer = new Timer( _delay );
			}
			if( !_timer.hasEventListener( TimerEvent.TIMER ) )
			{
				// 添加计时器事件	
				_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			}
			if(!_timer.running)
			{
				_timer.delay = _delay;
				_timer.start();
			}
		}
		/**    
		 * 将任务移除出任务列表
		 * @param task:Task 任务对象	 	  
		 */
		public function removeTask(taskName:String):void
		{	
			if(taskName != "systemTask")
			{
				var task:ITask = _taskList.remove(taskName);
				if(task == null) return;
				task.taskIsCompleted = true;
				if( _taskList.isEmpty() )
				{
					stopDoTask();
				}
			}
		}
		
		/**
		 * 移除所有的task
		 */		
		public function removeAllTask():void
		{
			this._taskList.eachKey( removeTask );
		}
		
		//获得长度
		private function getTaskLength():int
		{
			return _taskList.values().length;
		}
		/**  
		 * 暂停计划任务 	  
		 */
		protected function stopDoTask():void
		{
			if(_timer.running)
			{
				_timer.stop();
			}
			if( _timer.hasEventListener( TimerEvent.TIMER ) )
			{
				// 移除计时器事件	
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
			}
			_timer = null;
		}
		/**-------------------------------公共方法--------------------------------------------*/
		/**  
		 * 添加任务到任务列表
		 * @param task:Task 任务对象	 	  
		 */
		public function addTask(task:ITask):void
		{				
			if( task == null ) return;
			if( task.name == "" )
			{
				task.name = "tk_" + _taskId;
				_taskId++;
			}
			if( !this._taskList.get( task.name ) )
			{
				_taskList.put(task.name,task);
			}
			task.reset();
			startDoTask();
		}
		/** 任务列表 请注意列表中的项必须是ITASK类型**/
		public function get taskList():HashMap
		{
			return _taskList;
		}
		public function getTask( taskName:String ):ITask
		{
			return _taskList.get( taskName );
		}
		/**
		 * 单例模式工厂		
		 */
		public static function get instance() : TimerManager 
		{
			if ( _instance == null ) _instance = new TimerManager( );
			return _instance;
		}
	}
}