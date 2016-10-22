package framework.model
{
	public class EmptyGrid
	{
		public var startEmptyIndex:int = -1;
		public var emptyLength:int = 0;
		public var isRemoved:Boolean;
		public function EmptyGrid()
		{
			isRemoved = false;
		}
	}
}