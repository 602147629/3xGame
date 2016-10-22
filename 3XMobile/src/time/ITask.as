package time
{
	/**  
	 * 用于计划任务的任务对象接口 
	 */
	public interface ITask
	{
		function doTask():void;		
		function start():void;
		function reset():void;
		function set name(Object:String) : void;
        function get name() : String; 
		/**
		 *任务延迟 
		 * @param value
		 * 
		 */		
		function set taskDelay(value:Number):void;
		function get taskDelay():Number;
		/**
		 *执行方法 
		 * @param value
		 * 
		 */		
		function set taskDoFun( value:Function ):void;
		function get taskDoFun():Function;
		/**
		 *执行方法参数 
		 * @param value
		 * 
		 */		
		function set taskFunParam(value:Array):void;
		/**
		 *是否暂停 
		 * @param value
		 * 
		 */		
		function set taskIsRun(value:Boolean):void;
		function get taskIsRun():Boolean;
		/**
		 *是否完成 
		 * @param value
		 * 
		 */		
		function set taskIsCompleted(value:Boolean):void;
		function get taskIsCompleted():Boolean;
	}
}