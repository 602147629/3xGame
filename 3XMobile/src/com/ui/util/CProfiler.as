package com.ui.util
{
	import flash.system.System;

	/**
	 * @author caihua
	 * @comment 代码片段分析
	 * 创建时间：2014-9-22 下午2:43:09 
	 */
	public class CProfiler
	{
		private var _startTime:Number ;
		private var _endTime:Number;
		
		private var _startMem:Number;
		private var _endMem:Number;
		
		private static var INSTANCE:CProfiler
		
		public function CProfiler(s:Single)
		{
			
		}
		
		public static function getInstance():CProfiler
		{
			if(!INSTANCE)
			{
				INSTANCE = new CProfiler(new Single);
			}
			return INSTANCE;
		}
		
		public function profilerStart():void
		{
			_startTime = new Date().getTime();
			
			_startMem = System.privateMemory;
		}
		
		public function profilerEnd():void
		{
			_endTime = new Date().getTime();
			
			_endMem = System.privateMemory;
			
			__log();
			
			__clear();
		}
		
		private function __clear():void
		{
			_startTime = 0 ;
			_endTime = 0 ;
			_startMem = 0 ;
			_endMem = 0 ;
		}
		
		private function __log():void
		{
			trace("use time : " + (_endTime - _startTime) / 1000 + " s");
			trace("app mem change : " + (_endMem - _startMem) / 1000 + " kb");
		}
	}
}

class Single
{
	
}