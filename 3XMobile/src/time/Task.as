package time
{

	/**  
	 * 用于计划任务的任务对象基类	 
	 */
	public class Task implements ITask
	{
		/** 任务名称 **/		
		protected var _name:String = "";
		private var _taskDelay:Number;
		private var _taskDoFun:Function;
		private var _taskDoComFun:Function;
		private var _taskFunParam:Array;
		private var _taskRepeatCount:int;
		private var _taskIsRun:Boolean;
		private var _taskIsCompleted:Boolean;
		private var _currentCount:int;
		
		public function Task()
		{
			this._taskRepeatCount = -1;
			this.reset();
		}
		/**
		 *执行方法 
		 * 
		 */		
		public function doTask():void
		{			
			if( this._taskDoFun != null && this._currentCount != this.taskRepeatCount)
			{
				this._taskDoFun.apply( null, _taskFunParam );
				this._currentCount++;
			}
			else
			{
				this._taskIsCompleted = true;
				if(this._taskDoComFun != null)
					this._taskDoComFun.apply();
			}
		}
		
		/**
		 * 任务开始 
		 * 
		 */		
		public function start():void
		{
			TimerManager.instance.addTask(this);
			this._taskIsRun = true;
		}
		
		/**
		 * 任务重置 
		 * 
		 */		
		public function reset():void
		{
			this._currentCount = 0;
			this._taskIsCompleted = false;
			this._taskIsRun = false;
		}
		
		/**
		 * 任务结束 
		 * 
		 */		
		public function stop():void
		{
			this._currentCount = 0;
			this._taskIsCompleted = true;
			this._taskIsRun = false;
		}

		/** 任务延迟**/
		public function get taskDelay():Number
		{
			return _taskDelay;
		}

		/**
		 * @private
		 */
		public function set taskDelay(value:Number):void
		{
			_taskDelay = value;
		}
		
		/** 任务执行方法 **/
		public function get taskDoFun():Function
		{
			return _taskDoFun;
		}
		
		/**
		 * @private
		 */
		public function set taskDoFun(value:Function ):void
		{
			_taskDoFun = value;
		}
		
		/**
		 *任务执行函数参数 
		 */
		public function set taskFunParam(value:Array):void
		{
			_taskFunParam = value;
		}
		
		public function set taskIsRun(value:Boolean):void
		{
			_taskIsRun = value;
		}
		
		public function get taskIsRun():Boolean
		{
			return _taskIsRun;
		}
		
		public function set name(Object:String):void
		{
			_name = Object;
		}
		
		public function get name():String
		{			
			return _name;
		}	

		public function set taskIsCompleted(value:Boolean):void
		{
			_taskIsCompleted = value;
		}
		
		public function get taskIsCompleted():Boolean
		{
			return _taskIsCompleted;
		}

		/**
		 * 任务执行次数 
		 */
		public function get taskRepeatCount():int
		{
			return _taskRepeatCount;
		}

		/**
		 * @private
		 */
		public function set taskRepeatCount(value:int):void
		{
			_taskRepeatCount = value;
		}

		/**
		 * 当前任务执行次数 
		 */
		public function get currentCount():int
		{
			return _currentCount;
		}

		/**
		 * @private
		 */
		public function set currentCount(value:int):void
		{
			_currentCount = value;
		}

		/**
		 * 任务完成后执行方法 
		 */
		public function get taskDoComFun():Function
		{
			return _taskDoComFun;
		}

		/**
		 * @private
		 */
		public function set taskDoComFun(value:Function):void
		{
			_taskDoComFun = value;
		}


	}
}