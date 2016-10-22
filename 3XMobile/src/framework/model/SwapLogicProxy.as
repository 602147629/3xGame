package framework.model
{
	import com.games.candycrush.board.Board;
	import com.games.candycrush.board.ItemFactory;
	
	import framework.fibre.patterns.Proxy;
	import framework.ui.MediatorPanelMainUI;
	
	public class SwapLogicProxy extends Proxy
	{
		public static const NAME:String = "WrapLogicProxy";
		
		public static var inst:SwapLogicProxy;
		public static const STATE_GAME:int = 0;
		public static const STATE_PAUSE:int = 1;
		
		public var board:Board;
		
		private var _state:int;
		
		public function SwapLogicProxy()
		{
			inst = this;
			super(NAME);
		}
		
		public function init():void
		{
			board = new Board(MediatorPanelMainUI.MAX_LINE_NUMBER, MediatorPanelMainUI.MAX_LINE_NUMBER, new ItemFactory());
		}
		
		override public function tickObject(psdTickMs:Number):void
		{
			if(!isPaused())
			{
				if(board != null)
				{					
					board.tick(psdTickMs);
				}
			}
		}
		
		public function setPause(isPause:Boolean):void
		{
			if(isPause)
			{
				_state = STATE_PAUSE;
			}
			else
			{
				_state = STATE_GAME;
			}
		}
		
		public function isPaused() : Boolean
		{
			return this._state != STATE_GAME;
		}
		
		
	}
}