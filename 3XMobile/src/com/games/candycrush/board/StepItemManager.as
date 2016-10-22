package com.games.candycrush.board
{
	import framework.model.objects.BasicObject;

	public class StepItemManager
	{
		public var jellyItems:Vector.<StepCheckItem>;
		public var clockItems:Vector.<StepCheckItem>;
		public function StepItemManager()
		{
			jellyItems = new Vector.<StepCheckItem>();
		}
		
		public function reset():void
		{
			jellyItems = new Vector.<StepCheckItem>();
			clockItems = new Vector.<StepCheckItem>();
		}
		
		public function getLeftNum(basic:BasicObject):int
		{
			if(basic.blockType == BasicObject.BLOCK_JELLY_ITEM)
			{
				for(var i:int=0; i < jellyItems.length; i++)
				{
					var jellyItem:StepCheckItem = jellyItems[i];
					if(jellyItem.basicId == basic.id)
					{
						return jellyItem.leftStep;
					}
				}
			}
			else if(basic.blockType == BasicObject.BLOCK_CLOCK_ITEM)
			{
				for(var j:int=0; j < clockItems.length; j++)
				{
					var clockItem:StepCheckItem = clockItems[j];
					if(clockItem.basicId == basic.id)
					{
						return clockItem.leftStep;
					}
				}
			}
			
			return -1;
		}
		
		public function removeClockItem(basic:BasicObject):void
		{
			for(var i:int=0; i < clockItems.length; i++)
			{
				var clockItem:StepCheckItem = clockItems[i];
				if(clockItem.basicId == basic.id)
				{
					clockItems.splice(i, 1);
					break;
				}
			}
		}
		
		public function removeJellyItem(basic:BasicObject):void
		{
			for(var i:int=0; i < jellyItems.length; i++)
			{
				var jellyItem:StepCheckItem = jellyItems[i];
				if(jellyItem.basicId == basic.id)
				{
					jellyItems.splice(i, 1);
					break;
				}
			}
		}
		
		public function updateJellyStep():void
		{
			for each(var jellyItem:StepCheckItem in jellyItems)
			{
				jellyItem.updateStep();
			}			
		}
		
		public function getOverSteps():Vector.<StepCheckItem>
		{
			var array:Vector.<StepCheckItem> = new Vector.<StepCheckItem>();
			for each(var jellyItem:StepCheckItem in jellyItems)
			{
				if(jellyItem.isOver())
				{
					array.push(jellyItem);
				}
			}	
			
			return array;
		}
		
		public function updateClockStep():void
		{
			for each(var clockItem:StepCheckItem in clockItems)
			{
				clockItem.updateStep();
			}
		}
	}
}