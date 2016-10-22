package framework.model
{
	public class ScoreItem
	{
		public function ScoreItem()
		{
		}
		
		public var x:int;
		public var y:int;		
		private var _scoreId:int;
		public var inFluenceId:int;
		public var isSingle:Boolean;
		public var bombTime:int;

		public function get scoreId():int
		{
			return _scoreId;
		}

		public function set scoreId(value:int):void
		{
			_scoreId = value;
		}

	}
}