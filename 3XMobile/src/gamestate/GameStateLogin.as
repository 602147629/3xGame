package gamestate
{
	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-9-25 下午5:59:28 
	 */
	import lib.engine.iface.game.IGameState;
	
	public class GameStateLogin implements IGameState
	{
		public function GameStateLogin()
		{
			
		}
		
		public function getStateName():String
		{
			return "GameStateLogin";
		}
		
		public function onEnterState(params:Object=null):void
		{
		}
		
		public function onExitState(params:Object=null):void
		{
		}
	}
}