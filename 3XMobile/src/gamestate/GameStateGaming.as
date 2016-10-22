package gamestate
{
	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-9-25 下午6:00:32 
	 */
	import lib.engine.iface.game.IGameState;
	
	public class GameStateGaming implements IGameState
	{
		public function GameStateGaming()
		{
		}
		
		public function getStateName():String
		{
			return "GameStateGaming";
		}
		
		public function onEnterState(params:Object=null):void
		{
		}
		
		public function onExitState(params:Object=null):void
		{
		}
	}
}