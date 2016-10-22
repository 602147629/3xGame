package com.ui.util
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author caihua
	 * @comment 定时器
	 * 创建时间：2014-6-26  上午9:58:38 
	 */
	public class CTimer
	{
		private var _funcList:Array = new Array();		//回调列表
		private var _timer:Timer;						//定时器

		/** 
		 * 构造函数
		 */
		public function CTimer()
		{
			this._timer = new Timer(1000);
			this._timer.addEventListener(TimerEvent.TIMER, timerHander);
//			this._timer.start();
		}
		
		public function start():void
		{
			if(this._funcList.length == 0)
			{
				return;
			}
			this._timer.start();
		}
		
		/**
		 * 添加调用函数
		 * @param	callback	调用函数
		 * @param	delay		调用间隔秒
		 */
		public function addCallback(callback:Function , delay:Number , repeatCount:int=int.MAX_VALUE, param:Object=null):void
		{
			this._funcList.push([callback, delay , repeatCount, param]);
		}
		
		/**
		 * 剔除调用函数
		 * @param	callback	调用函数
		 */
		public function delCallback(callback:Function):void
		{
			for(var i:int=0 ; i<this._funcList.length; i++)
			{
				var item:Array = this._funcList[i];
				if(callback == item[0])
				{
					this._funcList.splice(i , 1);
					break;
				}
			}
		}
		
		/**
		 * 系统Timer监听函数
		 * @param	e
		 */
		private function timerHander(e:TimerEvent):void
		{
			for(var i:int=0 ; i<this._funcList.length ; i++)
			{
				var item:Array = this._funcList[i];
				var callback:Function = item[0];
				var delay:Number = item[1];
				var repeatCount:int = item[2];
				var param:Object = item[3];
				
				//运行完repeatCount次后删除
				if(0 == repeatCount)
				{
					this.delCallback(callback);
					this._timer.reset();
				}
				
				//符合条件回调
				if(0 == this._timer.currentCount % delay && 0 < repeatCount)
				{
					if (param != null)
					{
						callback(param);
					}
					else
					{
						callback();
					}
					//防止callback中将自身移除
					if (this._funcList.hasOwnProperty(i)) 
					{
						this._funcList[i][2] -- ;
					}
					else
					{
						break;
					}
				}
				else
				{
					trace("exception in timer !");
				}
			}
		}
		
		public function reset():void
		{
			this._timer.reset();
		}
	}
}