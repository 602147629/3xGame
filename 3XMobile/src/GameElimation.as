package
{
	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-9-25 下午5:14:38 
	 */
	import engine_starling.SApplication;
	
	import starling.utils.AssetManager;
	import gamestate.GameStateLogin;
	import gamestate.GameStateGaming;
	
	public class GameElimation extends SApplication
	{
		public function GameElimation()
		{
			super();
		}
		
		override protected function _onInitBefore():void
		{
			
		}
		
		override protected function _onInitAfter():void
		{
			
		}
		
		override protected function _onInitResource(assets:AssetManager):void
		{
			_loadResource();
		}
		
		override protected function _onInitGameState():void
		{
			stateManager.RegisterGameState(new GameStateLogin());
			stateManager.RegisterGameState(new GameStateGaming());
		}
	}
}