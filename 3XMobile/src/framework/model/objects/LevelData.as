package framework.model.objects
{
	public class LevelData
	{
		public var grids:Vector.<GridObject>;
		private var _id:int;
		public static const MAX_LINE_NUMBER:int = 9;
		//当前盘面格子数
		public function LevelData(id:int)
		{
			_id = id;
			
			grids = new Vector.<GridObject>();
			
			initGrids();
		}
		
		private function initGrids():void
		{
			for(var i:int = 0; i < MAX_LINE_NUMBER; i++)
			{
				for(var j:int = 0; j < MAX_LINE_NUMBER; j++)
				{
					var grid:GridObject = new GridObject(j, i);
					grids.push(grid);
				}
			}
		}
		
		public function getGrid(x:int, y:int):GridObject
		{
			if(x >= 0 && x < MAX_LINE_NUMBER && y >=0 && y < MAX_LINE_NUMBER)
			{				
				return grids[x + y * MAX_LINE_NUMBER];
			}
			else
			{
				return null;
			}
		}

		public function get id():int
		{
			return _id;
		}

	}
}