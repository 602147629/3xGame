package framework.model
{
	import com.game.module.CDataManager;
	import com.games.candycrush.ItemType;
	import com.games.candycrush.board.Board;
	import com.games.candycrush.board.Item;
	
	import framework.fibre.core.Fibre;
	import framework.model.objects.BasicObject;
	import framework.resource.faxb.levelproperty.Element;
	import framework.resource.faxb.levelproperty.ElementDemand;
	import framework.view.notification.GameNotification;

	public class DataRecorder
	{
		public static const SCORE_LINE_3:int = 0;
		public static const SCORE_LINE_4:int = 1;
		public static const SCORE_LINE_3_3:int = 2;
		public static const SCORE_LINE_5:int = 3;
		public static const SCORE_BOMB_LINE:int = 4;
		public static const SCORE_BOMB_DIAMOND:int = 5;
		public static const SCORE_BOMB_COLOR:int = 6;
		public static const SCORE_SWAP_L_L:int = 7;
		public static const SCORE_SWAP_L_D:int = 8;
		public static const SCORE_SWAP_D_D:int = 9;
		public static const SCORE_SWAP_C_L:int = 10;
		public static const SCORE_SWAP_C_D:int = 11;
		public static const SCORE_SWAP_C_C:int = 12;
		public static const SCORE_ICE:int = 13;
		public static const SCORE_WALL:int = 14;
		public static const SCORE_COLLECT:int = 15;
		public static const SCORE_VINE:int = 16;
		public static const SCORE_BUG:int = 19;
		public static const SCORE_SMALL_HILL:int = 20;
		public static const SCORE_DIAMOND:int = 21;
		public static const SCORE_STEP:int = 22;
		
		private var _swapStep:int;
		private var _totalScore:int;
		private var _currentScore:int;
		private var _collectedItems:Vector.<CollectItem>;
		private var _sliverCoin:int;
		
		private var _loopScore:int;
		
		private var _removeItemList:Array = new Array();
		private var _removeOnceList:Array = new Array();
		
		private var _board:Board;
		public function DataRecorder(board:Board)
		{
			_board = board;
		}
		
		public function resetLoopScore():void
		{
			_loopScore = 0;
		}
		
		public function reset():void
		{
			_swapStep = 0;
			_totalScore = 0;
			_collectedItems = new Vector.<CollectItem>();
			_sliverCoin = 0;
			
			_removeItemList = new Array();
			resetOnceList();
		}
		
		public function resetOnceList():void
		{
			_removeOnceList = new Array();
		}
		
		public function addSliverCoin(num:int = 1):void
		{
			_sliverCoin += num;
		}
		
		public function addCollectItem(id:int, num:int = 1):void
		{
			var collectItem:CollectItem = getCollectItem(id);
			if(collectItem == null)
			{
				collectItem = new CollectItem(id, 0);
			}
			
			collectItem.num += num;
		}
		
		public function getCollectItem(id:int):CollectItem
		{
			for each(var item:CollectItem in _collectedItems)
			{
				if(item.id == id)
				{
					return item;
				}
			}
			return null;
		}
		
		public function addStep(num:int = 1):void
		{
			_swapStep = _swapStep + num;
			
			CONFIG::debug
			{
				TRACE_ANIMATION_MOVE("currentStep: "+_swapStep + " addnum: "+num);
			}	
		}
		
		public function addScore(num:int, item:Item, scoreId:int, isSingle:Boolean = false, influenceId:int = -1, bombTime:int = 1):void
		{
			if(Debug.ISONLINE)
			{
				var scoreItem:ScoreItem = new ScoreItem();
				scoreItem.x = item.x;
				scoreItem.y = item.y;
				scoreItem.scoreId = scoreId;
				scoreItem.isSingle = isSingle;
				scoreItem.bombTime = bombTime;
				if(influenceId >= 0)
				{				
					scoreItem.inFluenceId = influenceId;
				}
				else
				{
					scoreItem.inFluenceId = item.isDeleteBySpecialEffectStatus;
				}
				
				_board.scoreItems.push(scoreItem);
			}
	
			
			if(influenceId >= 0)
			{
				item.isDeleteBySpecialEffectStatus = influenceId;
			}
			
			_currentScore = _currentScore + num;
			_totalScore = _totalScore + num;
			
			_loopScore += num;
			
			CONFIG::debug
			{
				TRACE_SCORE("scoreId: "+ scoreId + " isSingle: " + isSingle + " bombTime: "+bombTime+ " influenceId: "+ influenceId +" scoreAdd: "+ num+ " total: "+ _totalScore);
			}
			
			var data:Object = new Object();
			data.score = num;
			data.itemX = item.x;
			data.itemY = item.y;
			Fibre.getInstance().sendNotification(GameNotification.EVENT_SCORE_ANI , data);
		}
		
		public function addSpecialItemCreateScore(item:Item, comboTimes:int):void
		{
			//add combo score
			if(item.special == ItemType.COLOR)
			{
				if(!item.isRecordScore)
				{
//					item.isRecordScore = true;
					addScore(DataManager.getInstance().getScoreById(SCORE_LINE_5).bombScore * comboTimes, item, SCORE_LINE_5, false, -1, comboTimes);
				}
			}
			else if(item.special == ItemType.COLUMN || item.special == ItemType.LINE)
			{
				if(!item.isRecordScore)
				{
//					item.isRecordScore = true;
					addScore(DataManager.getInstance().getScoreById(SCORE_LINE_4).bombScore * comboTimes, item, SCORE_LINE_4, false, -1, comboTimes);
				}	
			}
			else if(item.special == ItemType.DIAMOND)
			{
				if(!item.isRecordScore)
				{
//					item.isRecordScore = true;
					addScore(DataManager.getInstance().getScoreById(SCORE_LINE_3_3).bombScore * comboTimes, item, SCORE_LINE_3_3, false, -1, comboTimes);
				}
			}
		}
		
		public function addRemoveItemScore(item:Item, comboTimes:int):void
		{
			if(item.isColorItem() && item.normalId < ConstantItem.MAX_CARD_NUM || item.isVariableItem())
			{
				if(!item.isRecordScore)
				{
					item.isRecordScore = true;				
					addScore(DataManager.getInstance().getScoreById( SCORE_LINE_3).bombSingleScore * comboTimes, item, SCORE_LINE_3, true, -1, comboTimes);
				}
			}
			
		/*	if(_removeItemList[item.normalId])
			{
				_removeItemList[item.normalId] ++ ;
			}
			else
			{
				_removeItemList[item.normalId] = 1 ;
			}*/
			
			
			Fibre.getInstance().sendNotification(GameNotification.EVENT_GAME_REMOVE_ITEM , {});
		}
		
		public function getHasBeenCollected(id:int):int
		{
			if(_removeItemList[id] != null)
			{
				return _removeItemList[id];
			}
			else
			{
				return 0 ;
			}
		}
		
		private function recordItemNumber(basic:BasicObject):void
		{
			// normal deleteItem
			/*if(basic.id >= ConstantItem.SPECIAL_ITEM_START_INDEX && basic.id < ConstantItem.SPECIAL_ITEM_END_INDEX)
			{
				if(_removeItemList[basic.picType] != null)
				{
					_removeItemList[basic.picType] ++ ;
				}
				else
				{
					_removeItemList[basic.picType] = 1 ;
				}
			}
			// ice 
			if(basic.blockType == BasicObject.BLOCK_TYPE_ICE)
			{
				if(_removeItemList[ConstantItem.ICE_BLOCK_START_INDEX] != null)
				{
					_removeItemList[ConstantItem.ICE_BLOCK_START_INDEX] ++ ;
				}
				else
				{
					_removeItemList[ConstantItem.ICE_BLOCK_START_INDEX] = 1 ;
				}
			}
			else if(basic.blockType == BasicObject.BLOCK_WALL)
			{
				if(_removeItemList[ConstantItem.WALL_START_INDEX] != null)
				{
					_removeItemList[ConstantItem.WALL_START_INDEX] ++ ;
				}
				else
				{
					_removeItemList[ConstantItem.WALL_START_INDEX] = 1 ;
				}
			}
			else if(basic.blockType == BasicObject.BLOCK_SMALL_HILL)
			{
				if(_removeItemList[ConstantItem.SMALL_HILL_START_INDEX] != null)
				{
					_removeItemList[ConstantItem.SMALL_HILL_START_INDEX] ++ ;
				}
				else
				{
					_removeItemList[ConstantItem.SMALL_HILL_START_INDEX] = 1 ;
				}
			}
			else
			{*/
				if(_removeItemList[basic.id] != null)
				{
					_removeItemList[basic.id] ++ ;
				}
				else
				{
					_removeItemList[basic.id] = 1 ;
				}
//			}
			
			
			if(_removeOnceList[basic.id] != null)
			{
				_removeOnceList[basic.id] ++ ;
			}
			else
			{
				_removeOnceList[basic.id] = 1 ;
			}
		}
		
		public function removeBasic(basic:BasicObject, comboTimes:int, item:Item):void
		{
			if(!item.isFly)
			{				
				recordItemNumber(basic);
				addObstacleScore(basic, comboTimes, item);
			}
			
			
			Fibre.getInstance().sendNotification(GameNotification.EVENT_GAME_REMOVE_ITEM , {});
			
//			Fibre.getInstance().sendNotification(GameNotification.EVENT_GAME_REMOVE_GIFT , {item:item});
			
			if(basic.isGiftItem())
			{
				Fibre.getInstance().sendNotification(GameNotification.EVENT_GAME_REMOVE_GIFT , {item:item});
			}
		}
		
		private function addObstacleScore(basic:BasicObject, comboTimers:int, item:Item):void
		{
			//it influence other point
			/*if(basic.blockType == BasicObject.BLOCK_TYPE_NORMAL || basic.blockType == BasicObject.BLOCK_TYPE_VARIABLE_ITEM)
			{
				
			}
			else*/ 
			if(basic.blockType == BasicObject.BLOCK_TYPE_ICE)
			{
				addScore(DataManager.getInstance().getScoreById(SCORE_ICE).bombScore * comboTimers, item, SCORE_ICE, false, -1, comboTimers);
			}
			else if(basic.blockType == BasicObject.BLOCK_WALL)
			{
				addScore(DataManager.getInstance().getScoreById(SCORE_WALL).bombScore, item, SCORE_WALL);
			}
			else if(basic.blockType == BasicObject.BLOCK_SMALL_HILL)
			{
				addScore(DataManager.getInstance().getScoreById(SCORE_SMALL_HILL).bombScore, item, SCORE_SMALL_HILL);
			}
			else if(basic.blockType == BasicObject.BLOCK_VINE)
			{
				var multipy:Number;
				if(item.isDeleteBySpecialEffectStatus > 0)
				{
					multipy = DataManager.getInstance().getScoreById(item.isDeleteBySpecialEffectStatus).multiple;
				}
				else
				{
					multipy = 1;
				}
				addScore(DataManager.getInstance().getScoreById(SCORE_VINE).bombScore * multipy, item, SCORE_VINE, false, item.isDeleteBySpecialEffectStatus);
			}
			else if(basic.id == ConstantItem.GRID_ID_DIAMOND)
			{
				addScore(DataManager.getInstance().getScoreById(SCORE_DIAMOND).bombScore, item, SCORE_DIAMOND);
			}
			else if(basic.blockType == BasicObject.BLOCK_BUG)
			{
				addScore(DataManager.getInstance().getScoreById(SCORE_BUG).bombScore, item, SCORE_BUG);
			}
			else if(basic.objectType == BasicObject.TYPE_COLLECTION)
			{
				addScore(DataManager.getInstance().getScoreById(SCORE_COLLECT).bombScore, item, SCORE_COLLECT);
			}
		}
		
		

		public function get score():int
		{
			return _totalScore;
		}

		
		public function get swapStep():int
		{
			return _swapStep;
		}
		
		public function set swapStep(value:int):void
		{
			_swapStep = value;
		}
		
		public function getLeftStep():int
		{
			return CDataManager.getInstance().dataOfLevel.stepLimit - _swapStep;
		}
		
		public function get removeItemList():Array
		{
			return _removeItemList;
		}

		public function get currentScore():int
		{
			return _currentScore;
		}

		public function set currentScore(value:int):void
		{
			_currentScore = value;
		}

		public function get loopScore():int
		{
			return _loopScore;
		}

		public function get sliverCoin():int
		{
			return _sliverCoin;
		}

		public function get removeOnceList():Array
		{
			return _removeOnceList;
		}
		
		public function getCollectItemNum(elementDemond:ElementDemand):int
		{
			var collectedNum:int = 0;
			for each(var elementId:Element in elementDemond.element)
			{
				if(removeItemList[elementId.id] != null)
				{
					collectedNum += removeItemList[elementId.id];
				}
			}
			
			return collectedNum;
		}


	}
}
