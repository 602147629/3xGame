package state
{
	import base.GLBase;

	/**
	 * @author caihua
	 * @comment 初始状态
	 * 创建时间：2014-9-3 下午5:44:05 
	 */
	public class GLStateInit extends GLBase implements IState
	{
		public function GLStateInit()
		{
			super("GLStateInit");
		}
		
		public function getStateName():String
		{
			return obName;
		}
		
		public function onEnterState(params:Object=null):void
		{
			
		}
		
		public function onExitState(params:Object=null):void
		{
		}
	}
}