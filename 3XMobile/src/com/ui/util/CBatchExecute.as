package com.ui.util
{
	import flash.events.EventDispatcher;

	/**
	 * @author caihua
	 * @comment 批量执行动作
	 * 创建时间：2014-9-22 上午10:17:24 
	 */
	public class CBatchExecute extends EventDispatcher
	{
		//一次执行多少单元
		private var _loadNumberPerTime:int = 10;
		//延迟多长时间执行
		private var _delayTime:Number = 1;
		//总执行单元队列
		private var _dataQueue:Array;
		//执行动作
		private var _action:Function;
		//执行完成回调
		private var _callBack:Function;
		
		//计数器
		private var _counter:int = 0;
		//需要批次执行的次数
		private var _totalBatchCount:int = 0;
		//已经执行过的批次
		private var _alreadyBatchedCount:int = 0;
		//batch执行是否结束
		private var _isBatchComplete:Boolean = false;
		//执行单元参数
		private var _actionParams:Array = null;
		
		public function CBatchExecute(action:Function , queue:Array , loadNumberPerTime:int = 10, delayTime:Number = 1 , callBack:Function = null , actionParams:Array = null)
		{
			_action = action;
			_dataQueue = queue;
			_loadNumberPerTime = loadNumberPerTime;
			_delayTime = delayTime;
			_callBack = callBack;
			_actionParams = actionParams == null ? [] : actionParams ;
			
			if(_dataQueue.length > 0)
			{
				__startLoad();
			}
		}
		
		private function __startLoad():void
		{
			_totalBatchCount = Math.ceil(_dataQueue.length / _loadNumberPerTime);
			
			new CDelayedCall(__loadOnce , _delayTime , _totalBatchCount , _callBack).start();
		}
		
		private function __loadOnce():void
		{
			for(var i:int = 0 ; i < _loadNumberPerTime ; i++)
			{
				if(_counter >= _dataQueue.length)
				{
					_isBatchComplete = true;
					break;
				}
				var param:Array = _actionParams.slice();
				param.unshift(_dataQueue[_counter++]);
				_action.apply(null , param);
			}
			
//			trace("batch execute : counter = " + _counter);
		}
	}
}