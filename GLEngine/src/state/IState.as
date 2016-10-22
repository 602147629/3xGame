package state
{
	/**
	 * @author caihua
	 * @comment 状态机接口
	 * 创建时间：2014-9-2 下午7:50:46 
	 */
	public interface IState
	{
		/**
		 * 获取状态名称
		 */
		function getStateName():String;
		/**
		 * 进入状态 
		 * 
		 */
		function onEnterState(params:Object = null):void;
		
		/**
		 * 退出状态 
		 */
		function onExitState(params:Object = null):void;
	}
}