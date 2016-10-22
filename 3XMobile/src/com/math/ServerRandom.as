package com.math
{
	import com.games.candycrush.board.Board;
	import com.games.candycrush.board.Item;
	
	import flash.utils.getTimer;
	
	import framework.model.DataManager;
	import framework.model.RandomItem;

	public class ServerRandom
	{
		private var _seed:uint;
		public function ServerRandom()
		{
			_seed = 0;
		}
		
		
		public function getSeed() : uint
		{
			return this._seed;
		}// end function
		
		public function setSeed(seed:uint) : void
		{
			this._seed = seed;
		}
		
		// 生成一个[0, unRange - 1]之间的随机数
		public function nextInt(range:int, x:int, y:int, board:Board, item:Item, isUseServerRandom:Boolean, ranItems:Array = null):int
		{
			if (range == 0)
				return 0;
			
			var isUse:Boolean = false;
			if(Debug.ISONLINE && isUseServerRandom)
			{
				if(x >= 0 && y >= 0)
				{
					isUse = true;
					var randomItem:RandomItem = new RandomItem();
					randomItem.x = x;
					randomItem.y = y;
					randomItem.index = DataManager.getInstance().randomIndex;
					if(DataManager.getInstance().randomIndex >= DataManager.getInstance().seedArray.length)
					{						
						return -1;
					}
					randomItem.result = DataManager.getInstance().seedArray[DataManager.getInstance().randomIndex];
					board.randomList.push(randomItem);
					if(ranItems != null)
					{
						
						ranItems.push(randomItem);
					}
					if(item != null)
					{
						//move item when fill near grid
						item.randomRandom = randomItem;
					}
					
					/*CONFIG::debug
					{
						TRACE_ANIMATION_MOVE("randomIndex: "+ DataManager.getInstance().randomIndex + " result: "+randomItem.result + " range: "+range + " x: "+x+" y: "+y);
					}*/	
					
				}
			}
			else
			{
				
			}
			
			
			var result:uint = random(isUse);
			
			
			CONFIG::debug
			{
				TRACE_JLM("result: "+ result);
			}
			return  result % range;
		}
		
		private function random(isUseServerRandom:Boolean) : uint
		{
			if(Debug.ISONLINE && isUseServerRandom)
			{
				var result1:int = int(DataManager.getInstance().seedArray[DataManager.getInstance().randomIndex]);
				++DataManager.getInstance().randomIndex;
				return result1;
			}
			
//			m_unSeed = m_CK.now();
			
			if(_seed == 0)
			{
				_seed = getTimer();
			}
			
			var next:uint = _seed;
			var result:uint;
			
			next *= 1103515245;
			next += 12345;
			result =  uint((next >> 16)) % 2048;
			
			next *= 1103515245;
			next += 12345;
			result <<= 10;
			result ^= uint((next >> 16)) % 1024;
			
			next *= 1103515245;
			next += 12345;
			result <<= 10;
			result ^=  uint((next >> 16)) % 1024;
			
			_seed = next;
			
			
			/*unsigned int next = m_unSeed;
			unsigned int result;
			
			next *= 1103515245;
			next += 12345;
			result = (unsigned int) (next >> 16) % 2048;
			
			next *= 1103515245;
			next += 12345;
			result <<= 10;
			result ^= (unsigned int) (next >> 16) % 1024;
			
			next *= 1103515245;
			next += 12345;
			result <<= 10;
			result ^= (unsigned int) (next >> 16) % 1024;*/
			return result;
		}
		
	
	}
}