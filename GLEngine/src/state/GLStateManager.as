package state
{
	import flash.utils.Dictionary;
	
	import base.GLBase;

	/**
	 * @author caihua
	 * @comment 状态机管理器
	 * 创建时间：2014-9-3 上午10:00:46 
	 */
	public class GLStateManager extends GLBase
	{
		private var _states:Dictionary;
		private var _currentState:String = "";
		
		public function GLStateManager()
		{
			_states = new Dictionary();
			super("GLStateManager");
		}
		
		/**
		 * 切换状态
		 */
		public function changeState(stateName:String , params:Object = null):void
		{
			if(!__hasState(stateName))
			{
				return;
			}
			__exitState(_currentState , params);
			__enterState(stateName , params);
		}
		
		/**
		 * 注册状态
		 */
		public function registerState(glState:IState):void
		{
			_states[glState.getStateName()] = glState;
		}
		
		/**
		 * 获取当前状态机
		 */
		public function getCurrentState():String
		{
			return _currentState;
		}
		
		private function __hasState(stateName:String):Boolean
		{
			if(stateName == "" || _states[stateName] == null)
			{
				return false;
			}
			return true;
		}
		
		private function __enterState(stateName:String , params:Object = null):void
		{
			_currentState = stateName;
			var glState:IState = _states[stateName]; 
			glState.onEnterState(params);
		}
		
		private function __exitState(stateName:String , params:Object = null):void
		{
			_currentState = "";
			var glState:IState = _states[stateName]; 
			glState.onExitState(params);	
		}
	}
}