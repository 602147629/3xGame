package com.games.candycrush.board
{
	public class StepCheckItem
	{
		private var _basicId:int;
		private var _leftStep:int;
		private var _item:Item;
		
		public function StepCheckItem(initStep:int, basicId:int)
		{
			_leftStep = initStep;
			_basicId = basicId;
//			_item = item;
			
		}

		public function get leftStep():int
		{
			return _leftStep;
		}
		
		public function updateStep():void
		{
			--_leftStep;
		}
		
		public function isOver():Boolean
		{
			return _leftStep <= 0;
		}

		public function get item():Item
		{
			return _item;
		}

		public function get basicId():int
		{
			return _basicId;
		}


	}
}