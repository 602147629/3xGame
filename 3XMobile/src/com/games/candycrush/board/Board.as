package com.games.candycrush.board
{
    import com.game.consts.ConstGameStatus;
    import com.game.module.CDataManager;
    import com.game.module.task.CTaskStepChecker;
    import com.games.candycrush.ItemType;
    import com.games.candycrush.board.match.Match;
    import com.games.candycrush.board.match.MatchPattern;
    import com.games.candycrush.board.match.NoMoreMoves;
    import com.games.candycrush.board.match.OrthoPatternMatcher;
    import com.games.candycrush.input.SwapInfo;
    import com.math.IntCoord;
    import com.ui.iface.MouseManager;
    import com.ui.util.CBaseUtil;
    import com.ui.widget.CWidgetFloatText;
    
    import flash.display.MovieClip;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;
    
    import framework.fibre.core.Fibre;
    import framework.model.ConstantItem;
    import framework.model.DataManager;
    import framework.model.DataRecorder;
    import framework.model.EmptyGrid;
    import framework.model.RandomItem;
    import framework.model.ScoreItem;
    import framework.model.SwapLogicProxy;
    import framework.model.objects.BasicObject;
    import framework.model.objects.GridObject;
    import framework.model.objects.LevelData;
    import framework.resource.faxb.levelproperty.Color;
    import framework.resource.faxb.levelproperty.CreateElement;
    import framework.resource.faxb.levelproperty.CreateItems;
    import framework.resource.faxb.levelproperty.ElementDemand;
    import framework.resource.faxb.levels.Basic;
    import framework.resource.faxb.levels.Grid;
    import framework.rpc.NetworkManager;
    import framework.sound.MediatorAudio;
    import framework.tutorial.TutorialManagerProxy;
    import framework.ui.MediatorPanelMainUI;
    import framework.view.notification.GameNotification;

    public class Board
    {
        private var _toRemoveIds:Object;

        private var _height:int;
        private var _width:int;
        private var _mGrids:Vector.<Vector.<Item>>;
        public var _mInt:Vector.<Vector.<int>>;
        private var _mIntIsDirty:Boolean;
		private var _isForceRefresh:Boolean;
		
        private var _deletedItems:Vector.<Item>;
		
		private var _bingoItems:Vector.<Item>;
		
		private var _bingoTimer:Timer;
		
        private var _fallingColumns:Vector.<FallingColumn>;
        private var _isStable:Boolean = false;
		private var _isPlayBombOver:Boolean = true;
        private var _isReasonableStable:Boolean = false;
        private var _unstableActionThisTick:Boolean = false;

        private var _listener:MediatorPanelMainUI;
        private var _itemFactory:ItemFactory;
        private var _swaps:Vector.<SwapInfo>;
        private var _numSwaps:int = 0;
        private var _lastSwap:SwapInfo = null;
        private var _toRemoveCoords:Vector.<IntCoord>;

        private static const MatchPattern3:Array = [new MatchPattern(MATCH_ID_3, 3, 1, true)];
        private static const MatchPatterns:Array = [
			new MatchPattern(MATCH_ID_5, 5, 1, true), 
			new MatchPattern(MATCH_ID_TorL, 3, 3, false), 
			new MatchPattern(MATCH_ID_4, 4, 1, true)/*, 
			new MatchPattern(MATCH_ID_3, 3, 1, true)*/];
        
		
		public static const AllMatchPatternTypes:Array = [5, 2, 4, 3];
		
        public static const MATCH_ID_5:int = 5;
        public static const MATCH_ID_TorL:int = 2;
        public static const MATCH_ID_4:int = 4;
        public static const MATCH_ID_3:int = 3;
		
        public static const SWITCHSTATE_BEGIN:int = 0;
        public static const SWITCHSTATE_SUCCESS:int = 1;
        public static const SWITCHSTATE_FAIL:int = 2;
		
		public static const MAX_SCROLL_LINE:int = 7;
		
		private var _dataRecord:DataRecorder;
		
		private var _startColumn:int;
		private var _endColumn:int;
		private var _startRow:int;
		private var _endRow:int;
		
		private var _stepItemsManager:StepItemManager;
		private var _isNeedCheckMoveCollect:Boolean;
		private var _boardExtension:BoardExtentionLogic;

        public function Board(width:int, height:int, itemFactory:ItemFactory)
        {

            this._toRemoveIds = {};
  
            this._mGrids = new Vector.<Vector.<Item>>;
            this._mInt = new Vector.<Vector.<int>>;
            this._deletedItems = new Vector.<Item>();
			this._bingoItems = new Vector.<Item>();
			
            this._fallingColumns = new Vector.<FallingColumn>;
			
			_dataRecord = new DataRecorder(this);
			_dataRecord.reset();
         
            this._swaps = new Vector.<SwapInfo>;
            this._toRemoveCoords = new Vector.<IntCoord>;
 
            this._width = width;
            this._height = height;
            this._itemFactory = itemFactory;
            this._itemFactory.init(this);
            var indexRow:int = 0;
            while (indexRow < height)
            {
                
                this._mGrids.push(new Vector.<Item>(width, true));
                this._mInt.push(new Vector.<int>(width, true));
                indexRow++;
            }			
			
            var indexCol:int = 0;
            while (indexCol < width)
            {
                
                this._fallingColumns.push(new FallingColumn());
                indexCol++;
            }

           
			itemFactory.rnd.setSeed(DataManager.getInstance().initSeed);
			
			_startColumn = 0;
			_endColumn = _width;
			_startRow = 0;
			_endRow = _height;
			
			_stepItemsManager = new StepItemManager();
			
			_boardExtension = new BoardExtentionLogic(this);
        }

        private function ready() : void
        {          
			_isPause = true;
			_isStartBingo = false;
			_isWaitFinishLevel = false;
			setTimeout(timerHandler, 1000);
			
			_dataRecord.reset();
			
			_stepChecker = new CTaskStepChecker(_dataRecord);
			
			resetValidateData();
			_isNeedCheckMoveCollect = CDataManager.getInstance().dataOfLevel.getCollectedDemand().length > 0;
			
			_currentMaxLine = MediatorPanelMainUI.MAX_LINE_NUMBER;
			
        }
		
		private var _stepChecker:CTaskStepChecker;
		
		private function useItemBecomeColor():void
		{
			var normalItems:Vector.<Item> = findAllNormalItemContainsVariable();
			
			if(normalItems.length > 0)
			{
				var randomIndex:int = _itemFactory.rnd.nextInt(normalItems.length, -1, -1, this, null, false);
				var item1:Item = normalItems[randomIndex];					
				//			normalItems.splice(randomIndex, 1);
				
				if(item1.isVariableItem())
				{
					item1.normalBasic.objectType = BasicObject.TYPE_NORMAL;
				}
				
				item1.special = ItemType.COLOR;
				
				setGridData(item1.x, item1.y, item1);
				this._listener.addItemToUI(item1, item1.x, item1.y, false);
				
				refreshInt();
			}
			
		}
		
		private function useItemBecomeLineAndDiamond():void
		{
			var normalItems:Vector.<Item> = findAllNormalItemContainsVariable();
			
			if(normalItems.length > 0)
			{
				var randomIndex:int = _itemFactory.rnd.nextInt(normalItems.length, -1, -1, this, null, false);
				var item1:Item = normalItems[randomIndex];					
				normalItems.splice(randomIndex, 1);
				
				if(item1.isVariableItem())
				{
					item1.normalBasic.objectType = BasicObject.TYPE_NORMAL;
				}
				item1.special = ItemType.LINE;
				
				setGridData(item1.x, item1.y, item1);
				this._listener.addItemToUI(item1, item1.x, item1.y, false);
			}
			
			
			if(normalItems.length > 0)
			{
				randomIndex = _itemFactory.rnd.nextInt(normalItems.length, -1, -1, this, null, false);
				item1= normalItems[randomIndex];					
				//			normalItems.splice(randomIndex, 1);
				if(item1.isVariableItem())
				{
					item1.normalBasic.objectType = BasicObject.TYPE_NORMAL;
				}
				item1.special = ItemType.DIAMOND;
				
				setGridData(item1.x, item1.y, item1);
				this._listener.addItemToUI(item1, item1.x, item1.y, false);
			}
			
			
		}
		
		
		public static const USE_NONE:int = 0;
		public static const USE_CLEAN_POINT:int = 1;
		public static const USE_1_TO_2:int = 2;
		public static const USE_SWAP_ITEM:int = 3;
		private var _useItemStatus:int;
		
		public function useCleanPoint(gridX:int, gridY:int):void
		{
			var item:Item = getGridItem(gridX, gridY);
			if(item != null && !item.isMoveCollect())
			{
				CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_WOODEN_MALLET);
				resetValidateData(false);
				
		
				if(!item.isHasVine() && item.isSpecialItem())
				{
					var itemsDeleted:Vector.<Vector.<Item>> = new Vector.<Vector.<Item>>;
					var itemsColLine:Vector.<Item> = new Vector.<Item>();
					itemsColLine.push(item);
					itemsDeleted.push(itemsColLine);
					addAlldeletedItemsBySpecialItem(itemsDeleted);
				}
				else
				{
					addForRemoval(item.x, item.y);
				}

				_useItemStatus = USE_NONE;
				NetworkManager.instance.sendServerUseTool(ConstantItem.ITEM_CLEAN_ONE_POINT);
				
				executeDeleteLogic(false, false);
				resetBomeTime();
				
				checkJellyItemAddStep();

				var map:Vector.<GridObject> = _listener.currentLevelData.grids;
				NetworkManager.instance.sendSwapInfo(0, 0, 1, 1, map, _dataRecord, false);
				
				_listener.startPlayMoveAnimation();
				
				MouseManager.instance.removeCursorByKey(MouseManager.CURSOR_KEY_HUMMER , true);
			}
			
		}
		
		private function resetBomeTime():void
		{
			_bombTimes = 0;
		}
		
		public function useItemFrom_1_TO_2(gridX:int, gridY:int):void
		{
			var item:Item = getGridItem(gridX, gridY);
			if(item != null && item.special == ItemType.NONE&&item.isColorItem())
			{
				
				
				var direction:int = int(Math.random() * 2);
				if(direction == 0)
				{				
					item.special = ItemType.LINE;
				}
				else
				{
					item.special = ItemType.COLUMN;
				}
				
				if(item.isVariableItem())
				{
					item.normalBasic.objectType = BasicObject.TYPE_NORMAL;
				}
				
				setGridData(item.x, item.y, item);
				
				CONFIG::debug
				{
					TRACE_LOG("use magic wand success ! + item normalId "+ item.normalId);
				}
				
				this._listener.addItemToUI(item, item.x, item.y, false);
				
				_useItemStatus = USE_NONE;
				NetworkManager.instance.sendServerUseTool(ConstantItem.ITEM_CHANGE_1TO2);
				
				MouseManager.instance.removeCursorByKey(MouseManager.CURSOR_KEY_MAGICWOOD , true);
				
				CBaseUtil.playSound(MediatorAudio.EVENT_SOUND_MAGIC_WAND);
			}
		}
		
		public function useItem(itemId:int):void
		{
			CONFIG::debug
			{
				TRACE_JLM("use Item id: " + itemId);
			}
			
			//when not dropItem, bombIimer wont be refresh.
			resetBomeTime();
			_listener.cleanMouseStatus();
			
			switch(itemId)
			{
				case ConstantItem.ITEM_ADD_A_COLOR:
					useItemBecomeColor();
					NetworkManager.instance.sendServerUseTool(itemId);
					break;
				case ConstantItem.ITEM_ADD_STEP_3:
					CDataManager.getInstance().dataOfLevel.stepLimit += 3;
					NetworkManager.instance.sendServerUseTool(itemId);
					break;
				case ConstantItem.ITEM_ADD_STEP_5:
					CDataManager.getInstance().dataOfLevel.stepLimit += 5;
					NetworkManager.instance.sendServerUseTool(itemId);
					break;
				case ConstantItem.ITEM_CHANGE_1TO2:
					_useItemStatus = USE_1_TO_2;
					//魔法棒
					MouseManager.instance.useSpecialCursor(MouseManager.CURSOR_KEY_MAGICWOOD);
					
					break;
				case ConstantItem.ITEM_CLEAN_ONE_POINT:
					_useItemStatus = USE_CLEAN_POINT;
					//变锤子
					MouseManager.instance.useSpecialCursor(MouseManager.CURSOR_KEY_HUMMER);
					
					break;
				case ConstantItem.ITEM_CREATE_LINE_AND_DIAMOND:
					useItemBecomeLineAndDiamond();
					NetworkManager.instance.sendServerUseTool(itemId);
					break;
				case ConstantItem.ITEM_REFRESH_MAP:
					refreshMap(true);
					NetworkManager.instance.sendServerUseTool(itemId);
					break;
				case ConstantItem.ITEM_REFRESH_MORE_TIMES:
					refreshMap(true);
					NetworkManager.instance.sendServerUseTool(itemId);
					break;
				case ConstantItem.ITEM_SWAP_2_ITEMS:
					_useItemStatus = USE_SWAP_ITEM;
					//强制交换
					MouseManager.instance.useSpecialCursor(MouseManager.CURSOR_KEY_FORCESWAP);
					break;
			}
		}
		

		private function getExistInMap(id:int):int
		{
			var existNumber:int = 0;
			var colIndex:int = 0;
			var rowIndex:int = 0;
			
			while(rowIndex < _height)
			{
				colIndex = 0;
				while(colIndex < _width)
				{
					var item:Item = getGridItem(colIndex, rowIndex);
					if(item != null && item._gridObj != null && item._gridObj.getBasicObjectById(id) != null)
					{
						++existNumber;
					}
					
					++colIndex;
				}
				++rowIndex;
			}
			return existNumber;
		}
		
		private function getNeedCreateCollectedNumber():Vector.<ElementDemand>
		{
			var elements:Vector.<ElementDemand>;
			var demands:Vector.<ElementDemand> = CDataManager.getInstance().dataOfLevel.getCollectedDemand();
			if(demands.length > 0)
			{
				elements = new Vector.<ElementDemand>();
				
				for each(var needNumElement:ElementDemand in demands)
				{
					var needNumber:int = 0;
					needNumber = needNumElement.num - _dataRecord.getHasBeenCollected(needNumElement.id) - getExistInMap(needNumElement.id);
					if(needNumber > 0)
					{
						var elementDemand:ElementDemand = new ElementDemand();
						elementDemand.id = needNumElement.id;
						elementDemand.num = needNumber;
						
						elements.push(elementDemand);
					}
					
					
				}
				
			}
			return elements;
		}
		
		private function timerHandler():void
		{
//			_isPause = false;
			forceRefresh();
			
//			SwapLogicProxy.inst.setPause(false);
			
			//check currentLevel has been pass
			
			if(Debug.ISONLINE)
			{
				if(!CDataManager.getInstance().dataOfGameUser.isLevelPassed(CDataManager.getInstance().dataOfLevel.level))
				{				
					TutorialManagerProxy.inst.setLevelStatus(CDataManager.getInstance().dataOfLevel.level);
				}
			}
			else
			{
				TutorialManagerProxy.inst.setLevelStatus(CDataManager.getInstance().dataOfLevel.level);
			}
			
			initBoat();
		}

      

        public function getColumn(param1:int) : int
        {
            return param1 < 0 ? (0) : (param1 >= this._width ? ((this._width - 1)) : (param1));
        }

        public function getRow(param1:int) : int
        {
            return param1 < 0 ? (0) : (param1 >= this._height ? ((this._height - 1)) : (param1));
        }

        public function inRange(col:int, row:int) : Boolean
        {
            return col >= 0 && col < this._width && row >= 0 && row < this._height;
        }

        public function getGridItem(col:int, row:int) : Item
        {
            if (!this.inRange(col, row))
            {
                return null;
            }
            return this._mGrids[row][col];
        }
		
		

        public function getUnifiedGridItem(col:int, row:int) : Item
        {
			return getGridItem(col, row);
           /* if (!this.inRange(col, row))
            {
                return null;
            }
            return this._unifiedGrid[row][col];*/
        }
		
		
		private function updateRemoveItems():void
		{
			//addRemovedIdArray
			this.updateWannaDies();
			//removeUI
			this.updateRemovePendingItems();
			//check crossDeleted
			checkCrossDeleted();
			//removeData				
			this.updateRemoveDeadItems();
			
			updateSingleEmptyGrid();
		}
		
		private function addAlldeletedItemsBySpecialItem(itemsDeleted:Vector.<Vector.<Item>>):void
		{	
			while(itemsDeleted.length > 0)
			{
				var items:Vector.<Item> = itemsDeleted.shift();
				updateRemovedItemsBySpecialMatch(items, itemsDeleted, false);
			}
		}
		
		private var _isStartBombOneByOne:Boolean;
		private var bombOneByOneList:Vector.<Item>;
		private function startBombOneByOne():void
		{
			var item:Item = null;
			while(bombOneByOneList != null && bombOneByOneList.length > 0)
			{
				var itemTemp:Item = bombOneByOneList.shift();
				if(itemTemp != null && !itemTemp.isDestroyed())
				{

					var nowItem:Item = getGridItem(itemTemp.x, itemTemp.y);
					if(nowItem.isSpecialItem() && itemTemp == nowItem)
					{
						item = itemTemp;	
						break;
					}
				}
			}
			
			if(item != null)
			{
				var itemsDeleted:Vector.<Vector.<Item>> = new Vector.<Vector.<Item>>;
				var itemsColLine:Vector.<Item> = new Vector.<Item>();
				itemsColLine.push(item);
				itemsDeleted.push(itemsColLine);
				addAlldeletedItemsBySpecialItem(itemsDeleted);
				_isStartBombOneByOne = true;
			}
			else
			{
				//break this status
				_isStartBombOneByOne = false;
			}
		}
		
		private var _isSpecialSwap:Boolean;
		
		private static const BOMB_TYPE_D_DIAMOND:int = 0;
		private static const BOMB_TYPE_D_COLUMN:int = 1;
		private static const BOMB_TYPE_D_LINE:int = 2;
		
		private function updateSpecialSwap():Boolean
		{
			var color:int = -1;
			var colorItem:Item;
			
			_currentSwapInfo.item_a.isRecordScore = true;
			_currentSwapInfo.item_b.isRecordScore = true;
			var center:Point = new Point(_currentSwapInfo.dstX, _currentSwapInfo.dstY);
			var itemsDeleted:Vector.<Vector.<Item>> = new Vector.<Vector.<Item>>;
			if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLUMN, ItemType.LINE)
			|| ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.LINE, ItemType.LINE)
			|| ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLUMN, ItemType.COLUMN)
			)
			{		
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_L_L).bombScore, _currentSwapInfo.item_a, DataRecorder.SCORE_SWAP_L_L);
				itemsDeleted.push(getDeletedItems(_currentSwapInfo.item_a, false, -1, DataRecorder.SCORE_SWAP_L_L));			
				itemsDeleted.push(getDeletedItems(_currentSwapInfo.item_b, false, -1, DataRecorder.SCORE_SWAP_L_L));
				
				addAlldeletedItemsBySpecialItem(itemsDeleted);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS3, null);
			}
			else if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.DIAMOND, ItemType.DIAMOND))
			{
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_D_D).bombScore, _currentSwapInfo.item_a, DataRecorder.SCORE_SWAP_D_D);
				itemsDeleted.push(getDeletedItemsBySpecialBomb(center.x, center.y, BOMB_TYPE_D_DIAMOND));
				addAlldeletedItemsBySpecialItem(itemsDeleted);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS5, null);
			}
			else if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.DIAMOND, ItemType.COLUMN))
			{
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_L_D).bombScore, _currentSwapInfo.item_a, DataRecorder.SCORE_SWAP_L_D);
				addForRemoval(_currentSwapInfo.item_a.x, _currentSwapInfo.item_a.y);
				addForRemoval(_currentSwapInfo.item_b.x, _currentSwapInfo.item_b.y);
				if(_currentSwapInfo.item_a.y != _currentSwapInfo.item_b.y)
				{
					itemsDeleted.push(getDeletedItemsBySpecialBomb(center.x, center.y, BOMB_TYPE_D_COLUMN));
				}
				else
				{
					itemsDeleted.push(getDeletedItemsBySpecialBomb(center.x, center.y, BOMB_TYPE_D_COLUMN, new Point(_currentSwapInfo.srcX, _currentSwapInfo.srcY) ));
				}
				
				addAlldeletedItemsBySpecialItem(itemsDeleted);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS4, null);
			}
			else if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.DIAMOND, ItemType.LINE))
			{
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_L_D).bombScore, _currentSwapInfo.item_a, DataRecorder.SCORE_SWAP_L_D);
				addForRemoval(_currentSwapInfo.item_a.x, _currentSwapInfo.item_a.y);
				addForRemoval(_currentSwapInfo.item_b.x, _currentSwapInfo.item_b.y);
				
				if(_currentSwapInfo.item_a.x != _currentSwapInfo.item_b.x)
				{
					itemsDeleted.push(getDeletedItemsBySpecialBomb(center.x, center.y, BOMB_TYPE_D_LINE));
				}
				else
				{
					itemsDeleted.push(getDeletedItemsBySpecialBomb(center.x, center.y, BOMB_TYPE_D_LINE, new Point(_currentSwapInfo.srcX, _currentSwapInfo.srcY) ));
				}
		
				addAlldeletedItemsBySpecialItem(itemsDeleted);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS4, null);
			}
			else if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLOR, ItemType.COLOR))
			{
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_C_C).bombScore, _currentSwapInfo.item_a, DataRecorder.SCORE_SWAP_C_C);
				//clear all
				var indexX:int = 0;
				var indexY:int = 0;
				while(indexX < _width)
				{
					indexY = 0;
					while(indexY < _height)
					{
						var itemScore:Item = addForRemoval(indexX, indexY);
						if(itemScore != null)
						{
							if(itemScore.isCanAddScore() && itemScore.special == ItemType.NONE)
							{
								itemScore.isDeleteBySpecialEffectStatus = DataRecorder.SCORE_SWAP_C_C;
								itemScore.isRecordScore = true;
								_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_C_C).bombSingleScore, itemScore, DataRecorder.SCORE_SWAP_C_C, true);
							}
						}
						indexY++; 
					}
					indexX++;
				}
				
				_listener.playGameAnimation("deleteAllItemsAni", 4, 4, true);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS7, null);
			}
			else if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLOR, ItemType.DIAMOND))
			{
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_C_D).bombScore, _currentSwapInfo.item_a,DataRecorder.SCORE_SWAP_C_D);
				//same color become diamond
				if(_currentSwapInfo.item_a.special == ItemType.DIAMOND)
				{
					color = _currentSwapInfo.item_a.color;
					colorItem = _currentSwapInfo.item_b;
				}
				else
				{
					color = _currentSwapInfo.item_b.color;
					colorItem = _currentSwapInfo.item_a;
				}
				
				bombOneByOneList = new Vector.<Item>();
				var itemsDiamond:Vector.<Item> = getDeletedItems(colorItem, false, color, DataRecorder.SCORE_SWAP_C_D, false);
				for each(var item:Item in itemsDiamond)
				{
					item.special = ItemType.DIAMOND;
					if(item.isVariableItem())
					{
						item.normalBasic.objectType = BasicObject.TYPE_NORMAL;
					}
					
					setGridData(item.x, item.y, item);
					_listener.addItemToUI(item, item.x, item.y, false);
					bombOneByOneList.push(item);
				}
				
				addForRemoval(colorItem.x, colorItem.y);
//				itemsDiamond.push(colorItem);
//				itemsDeleted.push(itemsDiamond);
//				addAlldeletedItemsBySpecialItem(itemsDeleted);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS7, null);
				return true;				
			}
			else if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLOR, ItemType.COLUMN)
				|| ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLOR, ItemType.LINE)
			)
			{
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_SWAP_C_L).bombScore, _currentSwapInfo.item_a, DataRecorder.SCORE_SWAP_C_L);
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_BOMB_LINE).bombScore, _currentSwapInfo.item_b, DataRecorder.SCORE_BOMB_LINE);
				//same color become 2
				if(_currentSwapInfo.item_a.special != ItemType.COLOR)
				{
					color = _currentSwapInfo.item_a.color;
					colorItem = _currentSwapInfo.item_b;
				}
				else
				{
					color = _currentSwapInfo.item_b.color;
					colorItem = _currentSwapInfo.item_a;
				}
				
				var itemsColLine:Vector.<Item> = getDeletedItems(colorItem, false, color, DataRecorder.SCORE_SWAP_C_L, false);
				bombOneByOneList = new Vector.<Item>();
				for each(var item1:Item in itemsColLine)
				{
					var index:int = itemFactory.rnd.nextInt(2, -1, -1, this, null, false);
					
					if(index == 0)
					{						
						item1.special = ItemType.COLUMN;
					}
					else
					{
						item1.special = ItemType.LINE;
					}
					
					if(item1.isVariableItem())
					{
						item1.normalBasic.objectType = BasicObject.TYPE_NORMAL;
					}
					
//					item1.isRecordScore = false;
					setGridData(item1.x, item1.y, item1);
					_listener.addItemToUI(item1, item1.x, item1.y, false);
					
					bombOneByOneList.push(item1);
				}
				
				addForRemoval(colorItem.x, colorItem.y);

				/*itemsDeleted.push(itemsColLine);
				addAlldeletedItemsBySpecialItem(itemsDeleted);*/
				
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_ELIMINATE_EFFECTS7, null);
				return true;
			}
			else if(ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLOR, ItemType.NONE) || ItemFactory.isSwapOfTypes(_currentSwapInfo, ItemType.COLOR, ItemType.INVALID))
			{
//				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_BOMB_COLOR).bombScore);
				_currentSwapInfo.item_a.isRecordScore = false;
				_currentSwapInfo.item_b.isRecordScore = false;
				
				//same color delete
				
				if(_currentSwapInfo.item_a.special == ItemType.NONE)
				{
					color = _currentSwapInfo.item_a.color;
					colorItem = _currentSwapInfo.item_b;
				}
				else
				{
					color = _currentSwapInfo.item_b.color;
					colorItem = _currentSwapInfo.item_a;
				}
				
				var items:Vector.<Item> = getDeletedItems(colorItem, false, color);
//				items.push(colorItem);
				addForRemoval(colorItem.x, colorItem.y);
				itemsDeleted.push(items);
			
				addAlldeletedItemsBySpecialItem(itemsDeleted);
			}
			
			return false;
		}
		
	/*	private function addRemovedScore():void
		{
			for each(var item:Item in _deletedItems)
			{				
				_dataRecord.addRemoveItemScore(item, _bombTimes + 1);
			}
		}*/
		
		private var _isZeroLeftHasSend:Boolean;
		private function checkMoveCollects():Boolean
		{
			if(!_isNeedCheckMoveCollect || _isExecuteCheck)
			{
				return false;
			}
			_isExecuteCheck = true;
			var isNeedCheck:Boolean = false;
			var gridX:int = _startColumn;
			while(gridX < _endColumn)
			{
				var gridY:int = _startRow;
				
				while(gridY < _endRow)
				{
					var item:Item = getGridItem(gridX, gridY);
					if(item &&　item.isMoveCollect())
					{
						if(_listener.currentLevelData.getGrid(gridX, gridY).isCollectContainer)
						{					
							item.destroy();
							isNeedCheck = true;
						}
					}
					++gridY;
				}		
				++gridX;
			}
			
			if(isNeedCheck)
			{

				
				resetMoveAnimationIndex();
				removeMoveCollectsFromFallingColumn();
//				resetFallingColumn();
				
				this.updateRemoveDeadItems();			
				updateSingleEmptyGrid();
				dealHideAndBlockGridFunction();
				
				
				//start fallAnimation
				//todo will show old animatin that has been played.
				this.updateFallingItems();
				
				_listener.startPlayMoveAnimation();
				_isExecuteCheck = false;
				
				if(Debug.ISONLINE)
				{
					NetworkManager.instance.sendMapValidate(randomList, scoreItems, _listener.currentLevelData.grids, _dataRecord.loopScore, _bombTimes);
					resetValidateData();	
				}
			}
			
			
			
			return isNeedCheck;
		}
		
		private var _isExecuteCheck:Boolean;
		public var scoreItems:Vector.<ScoreItem>;
		public var randomList:Vector.<RandomItem>;
		
		private function resetValidateData(isNormalClear:Boolean = true):void
		{
			
			if(!isNormalClear && (randomList != null && randomList.length > 0 || scoreItems != null && scoreItems.length > 0))
			{
				if(Debug.ISONLINE)
				{
					//bingo time create randoms  not send
					NetworkManager.instance.sendMapValidate(randomList, scoreItems, _listener.currentLevelData.grids, _dataRecord.loopScore, _bombTimes);
//					resetValidateData();
				}	
			}
			
			scoreItems = new Vector.<ScoreItem>();
			_dataRecord.resetLoopScore();
			randomList = new Vector.<RandomItem>();
			
			
		}
		private function executeDeleteLogic(isSwapOpen:Boolean, isClear:Boolean = true):void
		{
			_isSwapOpen = isSwapOpen;
			_isExecuteCheck = false;
//			_deletedItems = new Vector.<Item>();
			if(isClear)
			{				
				resetValidateData(false);
			}
			
			if(_isSpecialSwap)
			{
				_isSpecialSwap = false;
				
				_isSpecialPause = updateSpecialSwap();
				
				if(_isSpecialPause)
				{
					SwapLogicProxy.inst.setPause(true);
					_listener.setMouseEnable(false);
					var timer:Timer = new Timer(2000, 1);
					timer.addEventListener(TimerEvent.TIMER, timerResponse);
					timer.start();
					
					return;
				}
				updateRemoveItems();
			}
			
			updateMatchCheck();
			cleanMatchs();
			
			updateRemoveItems();
						
			var isNeedUpdateRemoveItems:Boolean = insertSpecialItem();
			if(isNeedUpdateRemoveItems)
			{
				updateRemoveItems();
			}
						
//			dealNormalGridFunction();
			dealHideAndBlockGridFunction();
			
			//start fallAnimation
			updateFallingItems();
			
			/*if(isHasCanFillBlankGrid())
			{
				_isCheckDropLoop = true;
				return;
			}*/
			
				
			if(Debug.ISONLINE)
			{			
				NetworkManager.instance.sendMapValidate(randomList, scoreItems, _listener.currentLevelData.grids, _dataRecord.loopScore, _bombTimes);
				resetValidateData();
			}
			
			++_bombTimes;
			if(_bombTimes > MAX_BOMB_TIME)
			{
				_bombTimes = MAX_BOMB_TIME;
			}
		}
		
		private var _isCheckDropLoop:Boolean;
		
	/*	private function dealNormalGridFunction():voidW
		{
			this.addMoveItemsFromGridToFallingColumns();
			this.updateAddItemsOnTop();
		}*/
		
		private function cleanMatchs():void
		{
			_matchs = new Vector.<Match>();
		}
		
		private function addMoveItemsFromGridToFallingColumnsContainsBlockGrid():void
		{
			var item:Item = null;
			var gridX:int = 0;
			while (gridX < this._width)
			{				
				var fallingColulmn:FallingColumn = _fallingColumns[gridX];
				var firstEmptyIndex:int = fallingColulmn.emptyGrids.length > 0 ? fallingColulmn.emptyGrids[0].startEmptyIndex : -1;
				
				var isNeedFixFirstEmptyIndex:Boolean = false;
				
				//from low to high
				for(var i:int = 0; i < fallingColulmn.emptyGrids.length; i++)
				{
					var empty:EmptyGrid = fallingColulmn.emptyGrids[i];
					var emptyLength:int = empty.emptyLength;
					var startIndex:int = empty.startEmptyIndex;
					
					var dropGridY:int = startIndex - emptyLength;
					
// 					if(isNeedFixFirstEmptyIndex)
					{
						isNeedFixFirstEmptyIndex = false;
						firstEmptyIndex = startIndex;
					}
					
					var currentDstX:int = gridX;
					//checkTranspointFirst
					var currentTopGrid:GridObject = _listener.currentLevelData.getGrid(gridX, dropGridY + 1);
					var transpointEnd:BasicObject = currentTopGrid.getTransportEnd();
					if(transpointEnd != null)
					{			
						var transPointDropX:int = transpointEnd.dstX;
						var transPointDropY:int = transpointEnd.dstY;
						while(transPointDropY >= 0)
						{
							item = getGridItem(transPointDropX, transPointDropY);
							/*skip ice  because it has been deal when updateSingleGrid  it is blankGrid*/
							if(item != null && !item.isBlankGrid())
							{
								if(item.isBlockOrHideGrid() || item.isStopLineDrop())
								{
									isNeedFixFirstEmptyIndex = true;
									break;	
								}
									/*else if(item.isIceBlank())
									{
									break;
									}*/
								else
								{
									if(firstEmptyIndex >= 0)
									{
										
										var gridObjTransEnd1:GridObject = _listener.currentLevelData.getGrid(currentDstX, firstEmptyIndex);													
										var isTranspointEnd:Boolean = gridObjTransEnd1.getTransportEnd()!= null ;
										
										moveGrid(item, currentDstX, firstEmptyIndex);
										
										if(isTranspointEnd)
										{
											currentDstX = gridObjTransEnd1.getTransportEnd().dstX;
											firstEmptyIndex = gridObjTransEnd1.getTransportEnd().dstY;									
										}
										else
										{
											--firstEmptyIndex;
										}
										
									}
									else
									{
										break;
									}
									
								}
							}
							else
							{							
								var gridObjTranspoint:GridObject = _listener.currentLevelData.getGrid(transPointDropX, transPointDropY);
								if(gridObjTranspoint.isStopDrop())
								{
									isNeedFixFirstEmptyIndex = true;
								}
								break;
							}					
							--transPointDropY;
						}
					}
					else
					{
						var dropX:int = gridX;
						var dropY:int = dropGridY;
						var isChangeTransport:Boolean = false;
						
						//find dropGrid 
						while(dropY >= 0)
						{		
							//drop column
							item = getGridItem(dropX, dropY);
							/*skip ice  because it has been deal when updateSingleGrid  it is blankGrid*/
							if(item != null && !item.isBlankGrid())
							{
								var isCanNotDrop:Boolean = item.isTransportDrop() && !isChangeTransport;
								if(item.isBlockOrHideGrid() || item.isStopLineDrop() || isCanNotDrop)
								{
									isNeedFixFirstEmptyIndex = true;
									break;	
								}
									/*else if(item.isIceBlank())
									{
									break;
									}*/
								else
								{
									if(firstEmptyIndex >= 0)
									{
										//if it has fill to endPint ,then change fillIndex;
										var gridObjTransEnd:GridObject = _listener.currentLevelData.getGrid(currentDstX, firstEmptyIndex);													
										var isTranspointReason:Boolean = gridObjTransEnd.getTransportEnd()!= null ;
										
										moveGrid(item, currentDstX, firstEmptyIndex);
										
										if(isTranspointReason)
										{
											currentDstX = gridObjTransEnd.getTransportEnd().dstX;
											firstEmptyIndex = gridObjTransEnd.getTransportEnd().dstY;									
										}
										else
										{
											--firstEmptyIndex;
										}
									}
									else
									{
										break;
									}
									
								}
							}
							else
							{					
								var gridObj:GridObject = _listener.currentLevelData.getGrid(dropX, dropY);
								if(gridObj.isStopDrop())
								{
									isNeedFixFirstEmptyIndex = true;
								}
								break;
							}
							
							var middleTransGrid:GridObject = _listener.currentLevelData.getGrid(dropX, dropY);
							var transpointEnd1:BasicObject = middleTransGrid.getTransportEnd();
							if(transpointEnd1 != null)
							{			
								dropX = transpointEnd1.dstX;
								dropY = transpointEnd1.dstY;
								isChangeTransport = true;
							}
							else
							{								
								--dropY;
							}
						}
					}
										
				}
				gridX++;
			}
			
			//contains blank grid
		}
		
		private function getTranspointEndGrid(gridX:int, gridY:int):BasicObject
		{
			var gridObjTransEnd:GridObject =  _listener.currentLevelData.getGrid(gridX, gridY);													 ;
			return gridObjTransEnd.getTransportEnd();
		}
		
		
		private function deleteFromGridLayer(gridX:int, gridY:int, id:int):void
		{
			var bug:BasicObject = new BasicObject(id);
			var gridObject:GridObject = _listener.currentLevelData.getGrid(gridX, gridY);
			gridObject.deleteSameLayerObject(bug);
		}
		
		private function addToGridLayer(gridX:int, gridY:int, id:int):void
		{
			var bug:BasicObject = new BasicObject(id);
			var gridObject:GridObject = _listener.currentLevelData.getGrid(gridX, gridY);
			gridObject.pushObject(bug);
		}
		
		private function findNearColumnIndex(gridX:int, gridY:int):int
		{
			var gridM:GridObject = _listener.currentLevelData.getGrid(gridX, gridY);
			var isHasRopeV:Boolean = gridM.isHasRopeV();
			var item:Item;
			if(gridX - 1 >= 0)
			{
				var blankGrid:GridObject = _listener.currentLevelData.getGrid(gridX, gridY+1);
				var isBlankHasRopeH:Boolean = blankGrid.isHasRopeH();
				item = getGridItem(gridX - 1, gridY);
				if(item != null && item.isCanNearFill())
				{
					if(item.isHasRopeV())
					{
						if(!isHasRopeV)
						{
							return gridX - 1;
						}
					}
					else if(isHasRopeV)
					{												
						if(!isBlankHasRopeH)
						{
							return gridX - 1;
						}
					}
					else
					{					
						if(gridM.isHasRopeH()&&blankGrid.isHasRopeH())
						{
							
						}
						else
						{							
							return gridX - 1;
						}
					}
				}
			}
			
			if(gridX + 1 < _width)
			{
				item = getGridItem(gridX + 1, gridY);
				var blankRightGrid:GridObject = _listener.currentLevelData.getGrid(gridX+1, gridY+1);
				var isRightBlankHasRopeH:Boolean = blankRightGrid.isHasRopeH();
				if(item != null && item.isCanNearFill())
				{
					
					if(item.isHasRopeV())
					{
						if(!isHasRopeV && !item.isHasRopeH())
						{
							return gridX + 1;
						}
					}				
					else if(isHasRopeV)
					{				
						if(!isRightBlankHasRopeH)
						{
							return gridX + 1;
						}
					}
					else
					{
						if(item.isHasRopeH() && isRightBlankHasRopeH)
						{
							
						}
						else
						{						
							return gridX + 1;
						}
					}
				}
			}
			return -1;
		}
		
		private function moveGrid(item:Item, dstX:int, dstY:int):void
		{
			item.dropX = dstX;
			item.dropY = dstY - 1;
			//带虫子 的斜向下落 有bug
			var oldpositionNewCreateItem:Item;
			var oldX:int ;
			var oldY:int ;
			if(item.normalId == ConstantItem.GRID_ID_BUG)
			{
				/*item.srcX = item.x;
				item.srcY = item.y;*/
				oldX = item.x;
				oldY = item.y;
				item.x = dstX;
				item.y = dstY;
				
				var oldNormalId:int = item.getMoveBasicObject().id;
				//delete old
				//								insertToMGrid(item.srcX, item.srcY, null);
				deleteFromGridLayer(oldX, oldY, item.normalId);
				deleteFromGridLayer(oldX, oldY, oldNormalId);
				
				if(oldX != item.srcX || oldY != item.srcY)
				{					
					_listener.drawGridObject(oldX, oldY);
				}
				oldpositionNewCreateItem = _listener.currentLevelData.getGrid(oldX, oldY).getEffectItem(_listener);
				insertToMGrid(oldX, oldY, oldpositionNewCreateItem);
				
				
				
				insertToMGrid(item.x, item.y, item);
				addToGridLayer(item.x, item.y, item.normalId);				
				addToGridLayer(item.x, item.y, oldNormalId);
				item.setGridObject(_listener.currentLevelData.getGrid(item.x, item.y), _listener);
				
				item.dropX = dstX;
				item.dropY = dstY - 1;
				_fallingColumns[dstX].insertItem(item);
			}
			else
			{
//				_listener.removeNormalItemUI(item, item.x, item.y);
				/*item.srcX = item.x;
				item.srcY = item.y;*/
				oldX = item.x;
				oldY = item.y;
				item.x = dstX;
				item.y = dstY;
			
				//								insertToMGrid(item.srcX, item.srcY, null);
				deleteFromGridLayer(oldX, oldY, item.normalId);
				oldpositionNewCreateItem = _listener.currentLevelData.getGrid(oldX, oldY).getEffectItem(_listener);
				insertToMGrid(oldX, oldY, oldpositionNewCreateItem);
				
				
				insertToMGrid(item.x, item.y, item);
				addToGridLayer(item.x, item.y, item.normalId);
				item.setGridObject(_listener.currentLevelData.getGrid(item.x, item.y), _listener);
				
				item.dropX = dstX;
				item.dropY = dstY - 1;
				_fallingColumns[dstX].insertItem(item);
			}	
		}
		
		private function fillBlankEmptyGridFromNearGrid():void
		{
			updateSingleEmptyGrid();
			
			var gridX:int = 0;
			while(gridX < _width)
			{
				var fallingCol:FallingColumn = _fallingColumns[gridX];
				
				for(var i:int = 0; i < fallingCol.emptyGrids.length; i++)
				{
					var empty:EmptyGrid = fallingCol.emptyGrids[i];
					var emptyLength:int = empty.emptyLength;
					var startIndex:int = empty.startEmptyIndex;
					
					var gridY:int = startIndex - emptyLength;
					
					if(gridY >= 0)
					{						
						//find near grid to fill
						var fillX:int = findNearColumnIndex(gridX, gridY);
						
						if(fillX != -1)
						{						
							var item:Item = getGridItem(fillX, gridY);
										
							moveGrid(item, gridX, startIndex);		
						}
					}
					else 
					{
						//use topGridToFill
					}
				}
												
				++gridX;
			}
		}
		
		private function isHasFillGrid(gridX:int, gridY:int):Boolean
		{
			if(gridY == 0)
			{
				return true;
			}
			
			//jumpToTranspointColumn
			var transReceive:BasicObject = _listener.currentLevelData.getGrid(gridX, gridY).getTransportEnd();
			if(transReceive != null)
			{
				var receiveY:int = transReceive.dstY;
				while(receiveY >= 0)
				{
					var transStartItem:Item = getGridItem(transReceive.dstX, receiveY);
					if(transStartItem != null)
					{
						if(transStartItem.isBlockOrHideGrid() || transStartItem.isStopLineDrop())
						{
							break;
//							return false;
						}
						else if(transStartItem.isCanFalling())
						{			
							return true;
						}
					}
					--receiveY;
				}	
			}
			
			//todo think all conditions
			var testY:int = gridY - 1;
				
			var fillX:int = findNearColumnIndex(gridX, testY);
			if(fillX >= 0)
			{
				return true;
			}
		
			while(testY >= 0)
			{
				var middleGrid:Item = getGridItem(gridX, testY);
				if(middleGrid != null)
				{
					if(middleGrid.isBlockOrHideGrid() || middleGrid.isStopLineDrop())
					{
						return false;
					}
					else if(middleGrid.isCanFalling())
					{
						
						return true;
					}
				}		
				--testY;
			}
			
			
			return true;
		}
		
		private function removeMoveCollectsFromFallingColumn():void
		{
			var gridX:int = 0;
			while(gridX < _width)
			{
				var items:Vector.<Item> = _fallingColumns[gridX].getItems();
				for(var i:int = items.length - 1; i >= 0; i--)
				{
					var item:Item = items[i];
					if(item.isDestroyed() && item.isMoveCollect())
					{
						items.splice(i, 1);
					}
				}
				++gridX;
			}
		}
		
		private function isHasCanFillBlankGrid():Boolean
		{
			
			var gridX:int = 0;
			while (gridX < this._width)
			{
				var fallingColulmn:FallingColumn = _fallingColumns[gridX];
				for(var i:int = 0; i < fallingColulmn.emptyGrids.length; i++)
				{
					var empty:EmptyGrid = fallingColulmn.emptyGrids[i];
					var emptyLength:int = empty.emptyLength;
					var startIndex:int = empty.startEmptyIndex;
					
					var testGridY:int = startIndex - emptyLength + 1;

					if(isHasFillGrid(gridX, testGridY))
					{
						TRACE_EMPTY_GRID("findFillGrid!  gridX: "+gridX + " testGridY "+ testGridY );
						return true;
					}
				}
				
				++gridX;
			}
			
			
		/*	var colIndex:int = 0;
			var rowIndex:int = 0;
			//removeFromMgrids
			while (rowIndex < this._height)
			{
				
				colIndex = 0;
				while (colIndex < this._width)
				{
					
					var gridItem:Item = this.getGridItem(colIndex, rowIndex);
					if (gridItem == null || gridItem.isIceBlank())
					{
						if(isHasFillGrid(colIndex, rowIndex))
						{							
							return true;
						}
					}
					colIndex++;
				}
				rowIndex++;
			}*/
			
			return false;
		}
		
		private function dealHideAndBlockGridFunction():void
		{
			updateSingleEmptyGrid();
			var timer:int = getTimer();
			while(isHasCanFillBlankGrid())
			{
				addMoveItemsFromGridToFallingColumnsContainsBlockGrid();
								
				//todo deal transpoint problem
				updateSingleEmptyGrid();
				addMoveItemsFromGridToFallingColumnsContainsBlockGrid();
				
				fillBlankEmptyGridFromNearGrid();
				
				updateSingleEmptyGrid();
				
				addMoveItemsFromGridToFallingColumnsContainsBlockGrid();
				
				updateAddItemsOnTop();
				
				updateSingleEmptyGrid();
				
				if(getTimer() - timer >= 2000)
				{
					CONFIG::debug
					{
						ASSERT(false, "find enter to dead loop!" );
					}
					
					break;
				}
			}
		}
		
		private var _isFinishLevel:Boolean;
		private function timerResponseFinishLevel(e:TimerEvent):void
		{
			if(_bingoTimer == null)
			{
				return;
			}
			if(this._bingoItems.length == 0)
			{
				_bingoTimer.removeEventListener(TimerEvent.TIMER, timerResponseFinishLevel);
				_bingoTimer.stop();
				_bingoTimer = null;
				setTimeout(showBingoTimeOver, 1500);
			}
			else
			{
				var item:Item = this._bingoItems.shift();
				this._listener.showBingoTime(item, item.x, item.y, false, true);
				_bingoTimer.delay = Math.max(100, (_bingoTimer.delay - 100));
				_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_STEP).bombScore, item, DataRecorder.SCORE_STEP); 
			}
		}
		
	
		
		private function showBingoTimeOver():Boolean
		{
			bombOneByOneList = new Vector.<Item>();
			
			var rowIndex:int = 0;
			while(rowIndex < _height)
			{
				var colIndex:int = 0;
				while(colIndex < _width)
				{
					var item:Item = getGridItem(colIndex, rowIndex);
					if(item != null && item.isSpecialItem())
					{
						bombOneByOneList.push(item);
					}
					
					++colIndex;
				}
				
				++rowIndex;	
			}
			
			/*var length:int = itemsDeleted.length;
			var itemD:Vector.<Vector.<Item>> = new Vector.<Vector.<Item>>();
			itemD.push(itemsDeleted);
			
			addAlldeletedItemsBySpecialItem(itemD);*/
			
			_isFinishLevel = true;
					
			startBombOneByOne();
			if(_isStartBombOneByOne)
			{				
				executeMiddle();
			}
			
			SwapLogicProxy.inst.setPause(false);
			
			return !_isStartBombOneByOne;
		}
		
		private function timerResponse(e:TimerEvent):void
		{
			_isSpecialPause = false;
			
			startBombOneByOne();
			
			executeMiddle();
			
			SwapLogicProxy.inst.setPause(false);
			_listener.setMouseEnable(true);
		}
		
		private function executeMiddle():void
		{
			updateRemoveItems();
			dealHideAndBlockGridFunction();
			this.updateFallingItems();
			
			//let tick open mouse
			if(Debug.ISONLINE)
			{			
				NetworkManager.instance.sendMapValidate(randomList, scoreItems, _listener.currentLevelData.grids, _dataRecord.loopScore, _bombTimes);
				resetValidateData();
			}
		}
		
		private var _isSpecialPause:Boolean;
		
		private function insertSpecialItem():Boolean
		{
			var matchs:Vector.<Match> = getSpecialMatches();
			var isNeedUpdateDeadItems:Boolean = false;;
			
			var addItems:Vector.<Item> = new Vector.<Item>();
			for(var i:int = 0; i < matchs.length; i++)
			{
				var match:Match = matchs[i];
				if(createSpecialItem(match, addItems))
				{
					isNeedUpdateDeadItems = true;
				}
			}
			
			for each(var item:Item in addItems)
			{
				var gridX:int = item.x;
				var gridY:int = item.y;
				createFallingEmptyGrid(gridX);
				var isFalling:Boolean = false;
				
				//if create position will drop, it will be clear when remove item
				_initializeAndAddItem(item, false);
				
				if(_isStartBingo)
				{
					bombOneByOneList.push(item);
				}
			}
			
			
			
			return isNeedUpdateDeadItems;		
		}
		
		private var _moveAnimationStepNeed:int;
		private var _moveAnimationHasDone:int;
		
		private var _isStartPlayMoveAni:Boolean = true;
		
		private var _currentSwapInfo:SwapInfo;
		private var _isStopLogic:Boolean;
		
		private function checkDropLoop():void
		{
			/*if(_isCheckDropLoop)
			{
			if(isAnimationPlayOver())
			{
			resetFallingColumn();
			dealHideAndBlockGridFunction();				
			//start fallAnimation
			updateFallingItems();
			
			_listener.startPlayMoveAnimation();
			}
			
			updateSingleEmptyGrid();
			if(isHasCanFillBlankGrid())
			{
			return;					
			}
			_isCheckDropLoop = false;
			
			if(Debug.ISONLINE)
			{			
			NetworkManager.instance.sendMapValidate(randomList, scoreItems, _listener.currentLevelData.grids, _dataRecord.loopScore, _bombTimes);
			resetValidateData();
			}
			
			++_bombTimes;
			return;
			}*/
		}
		
	
        public function tick(tickNumber:int) : void
        {
			Debug.stableLog = "";
			
			_listener.checkAnimationStart();
			
			Debug.stableLog += "isStopLogic: "+_isStopLogic;
			
			if(_isStopLogic)
			{			
				return;
			}
			
			checkDropLoop();
			
			Debug.stableLog += " refreashInt: "+_mIntIsDirty + " forceRefresh: " + _isForceRefresh;
			
            updateIntBoard();
			
			excuteCheckUnstableLogic();
			
			Debug.stableLog += " animationOver: "+ _listener.isAnimationOver() + " needAnimation: "+ _moveAnimationStepNeed +" downAni: "+ _moveAnimationHasDone;
			
            var isNeedDelete:Boolean = updateSwapCheck();
            if(isNeedDelete)
			{				
				executeDeleteLogic(true);
			}
			
            updateStability();
//            this.reset();
          
			checkStartBingo();
			
			_listener.updateScore();
			
			updateHint();
			
			
	
//			_listener.checkAnimationStart();
        }
		
		private function moveGridData(moveLength:int):void
		{
			for(var i:int = moveLength; i < _height; i++)
			{
				for(var j:int = 0; j < _width; j++)
				{
					var gridNew:GridObject = _listener.currentLevelData.getGrid(j, i-moveLength);
					gridNew.clear();
					var grid:GridObject = _listener.currentLevelData.getGrid(j, i);
					for(var k:int = 0; k < grid.basicObjects.length; k++)
					{
						var basic:BasicObject = grid.basicObjects[k];
						gridNew.pushObject(basic);
					}
					
					var item:Item = gridNew.getEffectItem(_listener);
					this._set(gridNew.x, gridNew.y, item, false);					
					if(item != null)
					{						
						_initializeAndAddItem(item, false);
					}
				}
			}
		}
		
		private function pushNewDataToGrid(moveLength:int):void
		{
			for(var i:int = 0; i < moveLength; i++)
			{
				for(var j:int = 0; j < _width; j++)
				{								
					var gridData:Grid = _listener.currentLevelOriginData.grid[j + (i+_currentMaxLine)*_width];
					var gridNew:GridObject = _listener.currentLevelData.getGrid(j, _height - moveLength + i);
					gridNew.clear();
					
					for(var k:int = 0; k < gridData.basic.length; k++)
					{
						var basicData:Basic = gridData.basic[k];
						var basicObj:BasicObject = new BasicObject(basicData.id);
						gridNew.pushObject(basicObj);
					}
					
					var item:Item = gridNew.getEffectItem(_listener);
					this._set(gridNew.x, gridNew.y, item, false);					
					if(item != null)
					{						
						_initializeAndAddItem(item, false);
					}
				}
			}
		}
		
		private var _currentMaxLine:int;
		private function checkStartScrollScreen():void
		{
			if(_currentMaxLine < _listener.currentLevelOriginData.maxLine)
			{
				if(_isStable)
				{
					var diamondLine:int = getNeedScrollScreen();
					if(diamondLine >= MAX_SCROLL_LINE || diamondLine < 0)
					{
						//stopLogic
						_listener.setMouseEnable(false);
						SwapLogicProxy.inst.setPause(true);
						//setData
						var moveLength:int = 0;
						
						if(diamondLine < 0)
						{
							var needLine:int = getNeedHasDiamondLine();
							moveLength = 4 + needLine - _currentMaxLine;
						}
						else
						{
							moveLength = diamondLine - MAX_SCROLL_LINE + 2;
						}
						
						
						
						if(_currentMaxLine + moveLength >= _listener.currentLevelOriginData.maxLine)
						{
							moveLength = _listener.currentLevelOriginData.maxLine - _currentMaxLine;
						}
						//playScrollAnimation
						_listener.playMiddleScrollScreen(moveLength, _currentMaxLine);		
						
						//setData				
						moveGridData(moveLength);
						pushNewDataToGrid(moveLength);						
						
						_currentMaxLine += moveLength;
						
						forceRefresh();
					}
					
				}
			}
			
		}
		
		private function getNeedScrollScreen():int
		{
			//line6
			//line7 donot has hill
			
			for(var i:int = 0; i < _height; i++)
			{
				for(var j:int = 0; j < _width; j++)
				{
					var grid:GridObject = _listener.currentLevelData.getGrid(j, i);
					if(grid.getBasicObjectByBlockType(BasicObject.BLOCK_SMALL_HILL) != null)
					{
						return i;
					}
				}				
			}

			return -1;
		}
		
		private function isHasSmallHillGrid(grid:Grid):Boolean
		{
			for each(var basic:Basic in grid.basic)
			{
				if(basic.id >= ConstantItem.SMALL_HILL_START_INDEX && basic.id <= ConstantItem.SMALL_HILL_END_INDEX)
				{
					return true;
				}				
			}
			
			return false;	
		}
		
		private function getNeedHasDiamondLine():int
		{
			for(var i:int = _currentMaxLine; i < _listener.currentLevelOriginData.maxLine; i++)
			{
				for(var j:int = 0; j < _width; j++)
				{
					var grid:Grid = _listener.currentLevelOriginData.grid[j + (i)*_width];
					
					if(isHasSmallHillGrid(grid))
					{
						return i;
					}
				}				
			}
			
			return -1;
		}
		
		private function checkStartBingo():void
		{
			if(_isStable && _isNoticeFinishLevel && _isPlayBombOver)
			{
				_isNoticeFinishLevel = false;
				//stopTick
				SwapLogicProxy.inst.setPause(true);
				//stopInput
				//				_isPause = true;
				_listener.setMouseEnable(false);
				_listener.playBombAnimation("effect.bingo", caculateFinishLevel);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_BINGO, null, Fibre.SOUND_NOTIFICATION);
				//				caculateFinishLevel();
			}
		}
		
		private function updateHint():void
		{
			if(_isStable && !_isStartBingo)
			{				
				if(TutorialManagerProxy.inst.isStartCheckTutorial)
				{
					if(_tickHint % 90 == 0)
					{
						resetHint();
						showHint(TutorialManagerProxy.inst.getStepHint());
					}
				}
				else
				{
					if(_tickHint % 150 == 149)
					{
						resetHint();
						showHint(getHint());						
					}
				}
				++_tickHint;			
			}
		}
		
		private var _tickHint:int;
		public function resetHint():void
		{
			_tickHint = 0;
		}
		
		private function showHint(hint:Array):void
		{
			
			
			if(hint != null)
			{
				var position:Point = hint[0];
				var direction:int = hint[1];
				
				_listener.showHintAnimation(position.x, position.y, direction);
				
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_SHOW_HINT, null, Fibre.SOUND_NOTIFICATION);
			}			
		}
     

        private function updateRemoveDeadItems() : void
        {
            var gridItem:Item = null;
           
            var colIndex:int = 0;
            var rowIndex:int = 0;
			
			//removeFromMgrids
            while (rowIndex < this._height)
            {
                
                colIndex = 0;
                while (colIndex < this._width)
                {
                    
                    gridItem = this.getGridItem(colIndex, rowIndex);
                    if (gridItem != null && gridItem.canRemove())
                    {
//						_deletedItems.push(gridItem);
						/*if(!gridItem.isHasVine())
						{							
							_dataRecord.addRemoveItemScore(gridItem, _bombTimes + 1);
						}*/
						
                        this.removeItem(gridItem);
                    }
                    colIndex++;
                }
                rowIndex++;
            }
			    
        }

        private function secondDebugTrace() : void
        {
            return;
        }

        private function updateStability() : void
        {
            _isReasonableStable = calculateReasonableStability();
				
	        _isStable = _isReasonableStable;    /*? (this.calculateStability()) : (false);*/
	
    
            _unstableActionThisTick = false;
            
        }
		
		private function updateSingleEmptyGrid():void
		{
			var gridX:int = 0;
			while (gridX < this._width)
			{
				createFallingEmptyGrid(gridX);		
				gridX++;
			}
		}
		
		private function createFallingEmptyGrid(gridX:int):void
		{
			var gridY:int = _height -1;
			
			var startEmptyIndex:int = -1;
			var emptyLength:int = 0;
			
			var emptyGrids:Vector.<EmptyGrid> = new Vector.<EmptyGrid>();
			
			
			
			// from up to down 0
			while (gridY >= 0)
			{
				
				
				var item:Item = getGridItem(gridX, gridY);				
				if ((item == null || item.isBlankGrid()) /*&& isHasFillGrid(gridX, gridY)*/)
				{
					var gridObj:GridObject =  _listener.currentLevelData.getGrid(gridX, gridY);
					
					//todo transpoint can not drop
					var gridObjEnd:GridObject = _listener.currentLevelData.getGrid(gridX, gridY+1);
					
					var isTranspointReason:Boolean = gridObj.getTransportStart()!= null || (gridObjEnd != null && gridObjEnd.getTransportEnd() != null);
					//hasRope or transpointStart
					if(gridObj.isStopDrop()|| isTranspointReason)
					{
						if(startEmptyIndex != -1)
						{							
							createEmptyGrid(emptyGrids, startEmptyIndex, emptyLength);
						}
						
						startEmptyIndex = -1;
						emptyLength = 0;
						
						if(startEmptyIndex == -1)
						{
							startEmptyIndex = gridY;
						}
						// can not fill not push
						
						emptyLength++;
					}
					else
					{
						if(startEmptyIndex == -1)
						{
							startEmptyIndex = gridY;
						}
						// can not fill not push
						
						emptyLength++;
					}
					
				}
				else if(startEmptyIndex != -1)
				{
					createEmptyGrid(emptyGrids, startEmptyIndex, emptyLength);
					
					startEmptyIndex = -1;
					emptyLength = 0;
				}
				
				gridY--;
			}
			
			if(startEmptyIndex != -1)
			{
				createEmptyGrid(emptyGrids, startEmptyIndex, emptyLength);
				
				startEmptyIndex = -1;
				emptyLength = 0;
			}
			
			var maxLength:int = 0;
			for each(var empty:EmptyGrid in emptyGrids)
			{
				maxLength += empty.emptyLength;	
				CONFIG::debug
				{
					TRACE_EMPTY_GRID("gridX: "+gridX + " startIndex: "+ empty.startEmptyIndex + " length: "+ empty.emptyLength);
				}
			}
			_fallingColumns[gridX].needCreateNewItemNumber = maxLength;
			_fallingColumns[gridX].emptyGrids = emptyGrids;
			
			
			//				_fallingColumns[gridX].emptyLength = emptyLength;
		}
		
		private function createEmptyGrid(emptyGrids:Vector.<EmptyGrid>, startEmptyIndex:int, emptyLength:int):void
		{
			var emptyGrid:EmptyGrid = new EmptyGrid();
			emptyGrid.startEmptyIndex = startEmptyIndex;
			emptyGrid.emptyLength = emptyLength;
			emptyGrids.push(emptyGrid);
		}
		
		private function findDropLength(gridX:int):int
		{
			//find top length
			var fallNumber:int = _fallingColumns[gridX].emptyGrids[_fallingColumns[gridX].emptyGrids.length - 1].emptyLength;
			
		/*	var gridY:int = 0;
			while(gridY < fallNumber)
			{
				var item:Item = getGridItem(gridX, gridY);
				if(getGridItem(gridX, gridY) != null )
				{
					return gridY;
				}
				++gridY;
			}*/
			
			return fallNumber;
		}
		
		private function dealCrossDeletedItem(item:Item):void
		{
			//data
			item.destroy();
			//ui
			
			//score
		}
		
		private function checkCrossDeleted():void
		{
			var colIndex:int = 0;
			var rowIndex:int = 0;
			
			var dealItems:Vector.<Item> = new Vector.<Item>();
			//removeFromMgrids
			while (rowIndex < this._height)
			{
				
				colIndex = 0;
				while (colIndex < this._width)
				{
					
					var gridItem:Item = this.getGridItem(colIndex, rowIndex);
					
					if (gridItem != null && gridItem.isCrossDeleted() && !gridItem.canRemove())
					{
						var item:Item;

						//up
						if(rowIndex - 1 >= 0)
						{
							item = getGridItem(colIndex, rowIndex - 1);
							if(item != null && item.isCreateDeleteCross(gridItem))
							{
								dealItems.push(gridItem);
								colIndex++;
								continue;
							}
						}
						//left
						if(colIndex - 1 >= 0)
						{
							item = getGridItem(colIndex - 1, rowIndex);
							if(item != null && item.isCreateDeleteCross(gridItem))
							{
								dealItems.push(gridItem);
								colIndex++;
								continue;
							}
						}
						
						//right
						if(colIndex + 1 < _width)
						{
							item = getGridItem(colIndex + 1, rowIndex);
							if(item != null && item.isCreateDeleteCross(gridItem))
							{
								dealItems.push(gridItem);
								colIndex++;
								continue;
							}
						}
						
						
						//down
						if(rowIndex + 1 < _height)
						{
							item = getGridItem(colIndex, rowIndex + 1);
							if(item != null && item.isCreateDeleteCross(gridItem))
							{
								dealItems.push(gridItem);
								colIndex++;
								continue;
							}
						}
						
					}
					colIndex++;
					
				}
				rowIndex++;
			}
			
			for each(var itemDeal:Item in dealItems)
			{				
				dealCrossDeletedItem(itemDeal);
			}
		}
		
		private function isNeedPushCollect(leftCollectNum:int, needId:int):Boolean
		{
			if(leftCollectNum > 0)
			{
				var leftStep:int = _dataRecord.getLeftStep();
				var checkStep:int = CDataManager.getInstance().dataOfLevel.getCheckStep();
				if(leftStep <= checkStep * leftCollectNum)
				{
					return true;
				}
				
				if(getExistInMap(needId) == 0)
				{
					return true;
				}
				
			}
			return false;
		}
		
        private function updateAddItemsOnTop() : void
        {
			updateSingleEmptyGrid();
			
			var isNotCreate:Boolean = false;
			var elementCollectCreateNum:int = 0;
			var elementId:int = 0;
			var elements:Vector.<ElementDemand> =  getNeedCreateCollectedNumber();
			if(elements != null && elements.length > 0)
			{
				// push lose collect step by step
				elementCollectCreateNum = elements[0].num;
				elementId = elements[0].id;
				isNotCreate = true;
			}
			
		
            var fallItemsNumber:int = 0;
            var gridY:int = 0;
            var index:int = 0;
            var gridX:int = 0;
            while (gridX < this._width)
            {
               if(isCanAddToTop(gridX))
			   {
				   fallItemsNumber = findDropLength(gridX);
				   index = 0;
				   while (index < fallItemsNumber)
				   {
					   if(isNotCreate && isNeedPushCollect(elementCollectCreateNum, elementId))
					   {
						   isNotCreate = false;
						   createObstacleObjectById(gridX, index, fallItemsNumber, elementId);
					   }
					   else
					   {
						   var createItems:CreateItems = CDataManager.getInstance().dataOfLevel.getCreateItems();
						   
						   if(createItems == null)
						   {
							   
							   createNewItemOnTop(gridX, index, fallItemsNumber);
						   }
						   else
						   {
							   var newGridY:int = - (index + 1) + fallItemsNumber;
							   var ranitems:Array = new Array();
							   var ranIndex:int = _itemFactory.rnd.nextInt(100, gridX, newGridY, this, null, true, ranitems);
							   if(ranIndex == -1)
							   {								   
								   CBaseUtil.showConfirm("数据异常，请重新登录", NetworkManager.instance.restartGame);
								   stopLogic();
								   return;
							   }
							   var randomItem:RandomItem = ranitems[0];
							   for each(var element:CreateElement in createItems.createElement)
							   {
								   if(ranIndex < element.rate)
								   {
									   var newItem:Item = createObstacleObjectById(gridX, index, fallItemsNumber, element.elementId);
									   newItem.randomRandom = randomItem;
									   TRACE_VALIDATE_RANDOM("ranIndex: "+ ranIndex+" id: "+element.elementId +" x: "+gridX + " y: "+newGridY);
									   break;
								   }
							   }
						   }
					   }
					   
					   
					   index++;
				   }   
			   }
				
               gridX++;
            }
            return;
        }
		
		private function isCanAddToTop(gridX:int):Boolean
		{
			var item:Item = getGridItem(gridX, 0);
			if(item == null || item.isBlankGrid())
			{
				return true;
			}
			return false;
		}
       

        private function reset() : void
        {
            this._toRemoveIds = {};
            return;
        }

        private function updateWannaDies() : void
        {
            var colIndex:int = 0;
            var rowIndex:int = 0;
            while (rowIndex < this._height)
            {
                
                colIndex = 0;
                while (colIndex < this._width)
                {
                    
                    if (this.getUnifiedGridItem(colIndex, rowIndex) != null && this.getUnifiedGridItem(colIndex, rowIndex).wannaDie())
                    {
                        this._reallyAddForRemoval(colIndex, rowIndex);
                    }
                    colIndex++;
                }
                rowIndex++;
            }
        }

        private function updateRemovePendingItems() : void
        {
            var intCoord:IntCoord = null;
            var item:Item = null;
            var isDestory:Boolean = false;
            if (this._toRemoveCoords.length == 0)
            {
                return;
            }
			//todo research
            /*this._recursionFind(tickNumber);*/
			
            var index:int = 0;
            while (index < this._toRemoveCoords.length)
            {
                
                intCoord = this._toRemoveCoords[index];
                item = this.getUnifiedGridItem(intCoord.x, intCoord.y);
                if (/*item.isBusy() ||*/ item.isDestroyed())
                {
                }
                else
                {
                    isDestory = item.destroy();	
                    if (isDestory)
                    {
						
                        this._unstableActionThisTick = true;
//                        this._listener.removeNormalItemUI(item, item.column, item.row, true);
                    }
                }
                index++;
            }
            this._toRemoveCoords.length = 0;
           
        }

        private function addMoveItemsFromGridToFallingColumns() : void
        {         
            var item:Item = null;
			var gridX:int = 0;
            while (gridX < this._width)
            {				
				var fallingColulmn:FallingColumn = _fallingColumns[gridX];
				var firstEmpty:int = fallingColulmn.emptyGrids.length > 0 ? fallingColulmn.emptyGrids[0].startEmptyIndex : -1;
				
				for(var i:int = 0; i < fallingColulmn.emptyGrids.length; i++)
				{
					var empty:EmptyGrid = fallingColulmn.emptyGrids[i];
	                var emptyLength:int = empty.emptyLength;
					var startIndex:int = empty.startEmptyIndex;
	
					var gridY:int = startIndex - emptyLength;
					while(gridY >= 0)
					{
						item = getGridItem(gridX, gridY);
						if(item != null)
						{
//							_listener.removeNormalItemUI(item, gridX, gridY);
							item.srcY = item.y;
							
							item.y = firstEmpty--;
							_fallingColumns[gridX].insertItem(item);
						}
						else
						{
							break;
						}					
						--gridY;
					}					
				}
                gridX++;
            }
        }

        public function saveOldItemPositions() : void
        {
            var item:Item = null;
            /*for each (item in this._allItems)
            {
                
                item.savePos();
            }*/
            return;
        }
		
		public function getMatch():OrthoPatternMatcher
		{
			var matcher:OrthoPatternMatcher = new OrthoPatternMatcher(_mInt, MatchPattern3, 3);
			return matcher;
		}
		
		public function testColorIsMatch(gridX:int, gridY:int, matcher:OrthoPatternMatcher):Boolean
		{			
			var match1:Match = matcher.matchXY(gridX, gridY);
			if(match1 != null)
			{
				return true;
			}
			
			return false;
		}
		
		private function isHasAllMatchs():Boolean
		{
			var matcher:OrthoPatternMatcher = new OrthoPatternMatcher(_mInt, MatchPattern3, 3);
			
			cleanMatchs();

			var gridX:int = 0;
			while(gridX < _width)
			{
		
				var gridY:int = 0;
				while (gridY < _height)
				{
//					var item:Item = getGridItem(gridX, gridY);
					var match1:Match = matcher.matchXY(gridX, gridY);
					if(match1 != null)
					{
						_matchs.push(match1);
					}
					
					gridY++;
				}
				
				gridX++;
			}
			
			return _matchs.length > 0;
		}
		
		private function isHasUnstableFallingMatchs():Boolean
		{
			var matcher:OrthoPatternMatcher = new OrthoPatternMatcher(_mInt, MatchPattern3, 3);
			
			cleanMatchs();
			//falling columns
			
			var gridX:int = 0;
			while(gridX < _width)
			{
				var fallingColumn:FallingColumn  = _fallingColumns[gridX];
				var items:Vector.<Item> = fallingColumn.getItems();
				var index:int = 0;
				while (index < items.length)
				{
					var item:Item = items[index];
					var match1:Match = matcher.matchXY(item.x, item.y);
					if(match1 != null)
					{
						_matchs.push(match1);
					}
					
					index++;
				}
				
				gridX++;
			}
			
			resetFallingColumn();
			
			return _matchs.length > 0;
		}
		
		private function resetFallingColumn():void
		{
			var gridX:int = 0;
			while(gridX < _width)
			{
				_fallingColumns[gridX].reset();
				++gridX;
			}
		}
		
		private var _bombTimes:int = 0;
		private static const MAX_BOMB_TIME:int = 6;
		private var _matchs:Vector.<Match>;
        private function updateSwapCheck() : Boolean
        {
            var swapInfo:SwapInfo = null;
            var isSwapSuccess:Boolean = false;
            var isReaction:Boolean = false;
            var isSpecialSuccess:Boolean = false;
			
			var isNeedDelete:Boolean = false;
            if (_swaps.length == 0)
            {
                return false;
            }
            var swapInfos:Vector.<SwapInfo> = new Vector.<SwapInfo>();
            for each (swapInfo in _swaps)
            {
                
                if (swapInfo.isBusy())
                {
                    swapInfos.push(swapInfo);
                    continue;
                }
				
			 
				CONFIG::debug
				{
					
					ASSERT(!swapInfo.item_a.isBusy() && !swapInfo.item_b.isBusy(),  "can not busy!");
				}
				
				resetHint();
				
                isSwapSuccess = swapInfo.isFailed == false;
                isReaction = this.isSwapReaction(swapInfo);
				
                isSpecialSuccess = false;
                if (isSwapSuccess)
                {
					
					resetBomeTime();

                    isSpecialSuccess = swapInfo.isSpecialSwap();
					_isSpecialSwap = isSpecialSuccess;
       
					
                    if (isReaction || isSpecialSuccess)
                    {
						
						_dataRecord.addStep();
						
						isNeedDelete = true;
						
						CONFIG::debug
						{
							ASSERT(_currentSwapInfo == null, "has currentInfo not send !");	
						}
						
						_currentSwapInfo = swapInfo;
						_currentSwapInfo.isUsed = false;
						
						
                        this._listener.switchMade(swapInfo, SWITCHSTATE_SUCCESS);
						CONFIG::debug
						{
							TRACE_LOG("success swap and returning" + " isNormalSwap: " + isReaction + " isSpecialWrap: " + isSpecialSuccess);
						}
						
                        continue;
                    }
                    this._listener.switchMade(swapInfo, SWITCHSTATE_FAIL);
                    this._doSwap(swapInfo.srcX, swapInfo.srcY, swapInfo.dstX, swapInfo.dstY, true, swapInfos);
					_currentSwapInfo = null;
					CONFIG::debug
					{
						TRACE_LOG("failed swap and returning");
					}
				
                    
                }
            }
            this._swaps = swapInfos;
            return isNeedDelete;
        }

        private function isSwapReaction(swapInfo:SwapInfo) : Boolean
        {
            var matcher:OrthoPatternMatcher = new OrthoPatternMatcher(_mInt, MatchPattern3, 3);
			
			cleanMatchs();
			//falling columns
			
			
			var match1:Match = matcher.matchXY(swapInfo.srcX, swapInfo.srcY);
			if(match1 != null)
			{
				_matchs.push(match1);
			}
			
			var match2:Match = matcher.matchXY(swapInfo.dstX, swapInfo.dstY);
			if(match2 != null)
			{
				_matchs.push(match2);
			}
			
            return  _matchs.length > 0 ;
        }
		
		
		private var _isPause:Boolean;
		
//		public static const INVALID_COLOR:int = -2;
		private function refreshInt(isRefreshMap:Boolean = false):void
		{
			var item:Item = null;
			var rowIndex:int = 0;
			var colIndex:int = 0;
			while (rowIndex < this._height)
			{
				
				colIndex = 0;
				var str:String = "";
				
				if(isRefreshMap)
				{
					str += " refresh map : /n";
				}
				
				while (colIndex < this._width)
				{
					
					item = this.getGridItem(colIndex, rowIndex);
					
					if(item != null)
					{
						
						str += " x:" + colIndex + " y:"+ rowIndex + " id:"+ item.normalId;
					}
					else
					{
						str += " x:" + colIndex + " y:"+ rowIndex +" is null!";
					}
															
					setMint(item, colIndex, rowIndex);
					colIndex++;
				}
				
				CONFIG::debug
				{
					TRACE_GRID_MAP(str);
				}
				rowIndex++;
			}
		}
		
		private function setMint(item:Item, colIndex:int, rowIndex:int):void
		{
			this._mInt[rowIndex][colIndex] = item != null /*&& item.canBeMatched()*/ ? (item.color) : (Item.INVALID_COLOR);
		}
		
		private var _updateMapTimes:int = 0;
		
		private function isAnimationPlayOver():Boolean
		{
			return _moveAnimationStepNeed <= _moveAnimationHasDone && _isStartPlayMoveAni  && _listener.isAnimationOver() ;
		}
		
		private function  excuteCheckUnstableLogic():void
		{
			
			//动画结束  开始执行逻辑
			if(isAnimationPlayOver())
			{
				var isCheckObstacle:Boolean = /*_moveAnimationStepNeed >= 3 &&*/ _dataRecord.getLeftStep() > 0 && !_isWaitFinishLevel;
				
				resetMoveAnimationIndex();
				
				if(_isWaitRefreshFalling)
				{				
					_isWaitRefreshFalling = false;
					if(isHasUnstableFallingMatchs())
					{
						_isStable = false;
						
						startBombOneByOne();					
						if(_isStartBombOneByOne)
						{
//							executeMiddle();
//							return;
						}
						
						executeDeleteLogic(false, !_isStartBombOneByOne);
					}
					else
					{
						isPause = false;
						setStable(isCheckObstacle);
						
						//in list to refresh
						if(_isWaitRefreshAllMap)
						{
							forceRefresh();
							_isWaitRefreshAllMap = false;
						}
					}
				}
				else if(_isWaitRefreshAllMap)
				{
					_isWaitRefreshAllMap = false;
					resetFallingColumn();
					if(isHasAllMatchs())
					{					
						_isStable = false;
						
						executeDeleteLogic(false);
						
					}
					else
					{
						isPause = false;							
						setStable(false);
						
						if(_isWaitRefreshFalling)
						{
							if(_moveAnimationStepNeed < 0)
							{
								_moveAnimationHasDone = 0;
								_moveAnimationStepNeed = 0;
							}		
							_isStartPlayMoveAni = true;
							_mIntIsDirty = true;
							_isWaitRefreshFalling = false;
						}
						
					}				
					
				}
				
			}
			
		}
		
		private var _isWaitRefreshFalling:Boolean = false;
		private var _isWaitRefreshAllMap:Boolean = false;
        private function updateIntBoard() : void
        {		
			if(!_isForceRefresh && !this._mIntIsDirty)
            {
                return;
            }
           	
			refreshInt();
			
			CONFIG::debug
			{
				TRACE_GRID_MAP("update grid Map time is " + _updateMapTimes);
				++_updateMapTimes;
			}
			
			if(_mIntIsDirty)
			{
				_mIntIsDirty = false;
				_isWaitRefreshFalling = true;
			}
			if(_isForceRefresh)
			{
				_isForceRefresh = false;
				_isWaitRefreshAllMap = true;
			}
			
			
			
        }
		
		private function refreshMapUI():void
		{
			for each(var gridObject:GridObject in _listener.currentLevelData.grids)
			{
				var itemOld:Item = getGridItem(gridObject.x, gridObject.y);
				if(itemOld != null && itemOld.isColorItem() && itemOld.normalId < ConstantItem.MAX_CARD_NUM)
				{						
					_listener.addItemToUI(itemOld, itemOld.x, itemOld.y, false);
				}
			}
		}
		
		private var _isMustRefresh:Boolean;
		private function refreshMap(isRefresh:Boolean):void
		{
			_isMustRefresh = isRefresh;
	
			CONFIG::debug
			{
				TRACE_JLM("check is Need refresh Map ! mustRefresh" + _isMustRefresh);
			}
				
			//after swap, items has been deleted, but intMap not refresh ,then enter to check refresh function.
			refreshInt();
			
			if(_isMustRefresh || !isPossibleMovesLeft())
			{
				if(!_isMustRefresh)
				{					
					CWidgetFloatText.instance.showTxt("没有可以消除的蔬菜，自动刷新", 1000);
				}
				else
				{
					CWidgetFloatText.instance.showTxt("使用道具刷新", 1000);
				}
				
				CONFIG::debug
				{
					TRACE_JLM("refresh Map ! isMustRefresh: " + isRefresh);
				}
				
				SwapLogicProxy.inst.setPause(true);
				_listener.setMouseEnable(false);
				var timer:Timer = new Timer(1500, 1);
				timer.addEventListener(TimerEvent.TIMER, timerResponseRefreshMap);
				timer.start();
				
			}			
		}
		
		private function timerResponseRefreshMap(e:TimerEvent):void
		{
			startRefreshMap();
			
			SwapLogicProxy.inst.setPause(false);
			_listener.setMouseEnable(true);
		}
		
		private function startRefreshMap():void
		{
			var tryTimes:int = 0;
			while(_isMustRefresh || !isPossibleMovesLeft())
			{
				if(tryTimes >= 5)
				{
					_listener.showExitGameWhenCanNotRefresh();
					return;
				}
					
				_isMustRefresh =  false;
				
				//it can be improved
				var positionList:Vector.<Point> = new Vector.<Point>();
				var itemsId:Vector.<int> = new Vector.<int>();
				for each(var gridObject:GridObject in _listener.currentLevelData.grids)
				{
					var itemOld:Item = getGridItem(gridObject.x, gridObject.y);
					if(itemOld != null && itemOld.isColorItem() && itemOld.normalId < ConstantItem.MAX_CARD_NUM && !itemOld.isHasVine())
					{
						positionList.push(new Point(gridObject.x, gridObject.y));
						itemsId.push(itemOld.normalId);
					}
				}
				
				//todo improve logic find someitem nearby
				
				for each(var position:Point in positionList)
				{
					var index:int = int(Math.random() * itemsId.length);
					var normalId:int = itemsId[index];
					itemsId.splice(index, 1);
					
					var item:Item = new Item(position.x, position.y);
					
					insertToMGrid(item.x, item.y, item);
					setGridDataById(item.x, item.y, item, normalId);	
				}
				 		
				refreshInt();
				++tryTimes;
			}
			
			refreshMapUI();
			forceRefresh();
		}
		
		/*private function startRefreshMap():void
		{
			while(_isMustRefresh || !isPossibleMovesLeft())
			{				
				_isMustRefresh =  false;
				
				for each(var gridObject:GridObject in _listener.currentLevelData.grids)
				{
					var itemOld:Item = getGridItem(gridObject.x, gridObject.y);
					if(itemOld != null && itemOld.isNormalItem() && itemOld.normalId < ConstantItem.MAX_CARD_NUM)
					{						
						var item:Item = _itemFactory.createRandomItem(gridObject.x, gridObject.y, false); 
						insertToMGrid(item.x, item.y, item);
						setGridData(item.x, item.y, item);	
					}
				}
				
				refreshInt();
			}
			
			refreshMapUI();
			forceRefresh();
		}*/
		
		public function forceRefresh():void
		{
			_isForceRefresh = true;
			if(_moveAnimationStepNeed < 0)
			{
				_moveAnimationHasDone = 0;
				_moveAnimationStepNeed = 0;
			}		
			_isStartPlayMoveAni = true;
		}
		
		private function resetMoveAnimationIndex():void
		{
			_moveAnimationStepNeed = -1;
			_moveAnimationHasDone = -2;
			_isStartPlayMoveAni = false;
		}
		
		private function playUnbelivalbeAnimation():void
		{
			var callBack:Function;
			callBack = function ():void
			{
				_isPlayBombOver = true;
				_listener.setMouseEnable(true);
			}
			if(_bombTimes == 2)
			{
				_isPlayBombOver = false;
				_listener.setMouseEnable(false);
				
				_listener.playBombAnimation("effect.good",callBack);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_GOOD, null, Fibre.SOUND_NOTIFICATION);
			}else if(_bombTimes == 3)
			{
				_isPlayBombOver = false;
				_listener.setMouseEnable(false);
				_listener.playBombAnimation("effect.great",callBack);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_GREAT, null, Fibre.SOUND_NOTIFICATION);
			}else if(_bombTimes == 4)
			{
				_isPlayBombOver = false;
				_listener.setMouseEnable(false);
				_listener.playBombAnimation("effect.excellent",callBack);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_EXCELLENT, null, Fibre.SOUND_NOTIFICATION);
			}else if(_bombTimes == 5)
			{
				_isPlayBombOver = false;
				_listener.setMouseEnable(false);
				_listener.playBombAnimation("effect.amazing",callBack);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_AMAZING, null, Fibre.SOUND_NOTIFICATION);
			}else if(_bombTimes >= 6)
			{
				_isPlayBombOver = false;
				_listener.setMouseEnable(false);
				_listener.playBombAnimation("effect.unbelievable",callBack);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_UNBELIEVABLE, null, Fibre.SOUND_NOTIFICATION);
			}	
		}
		
		private function checkJellyItemAddStep():void
		{
			if(CDataManager.getInstance().dataOfLevel.isNeedCheckJellyItem())
			{
				if(_isStartBingo)
				{
					return;
				}
				
				var number:int = 0;
				for(var id1:String in dataRecord.removeOnceList)
				{
					var id:int = int(id1);
					if(id >= ConstantItem.JELLY_START_INDEX && id <= ConstantItem.JELLY_END_INDEX)
					{
						number += dataRecord.removeOnceList[id1];					
					}	
				}
				
				if(number > 0)
				{
					CDataManager.getInstance().dataOfLevel.stepLimit += BasicObject.getElement(ConstantItem.JELLY_START_INDEX).addStep * number;
					CWidgetFloatText.instance.showTxt("增加 "+ BasicObject.getElement(ConstantItem.JELLY_START_INDEX).addStep * number +" 步!", 500);
				}
			}
			
		}
		
		private function checkJellyItemDispose():void
		{
			if(CDataManager.getInstance().dataOfLevel.isNeedCheckJellyItem())
			{
				_stepItemsManager.updateJellyStep();
				var overSteps:Vector.<StepCheckItem> = _stepItemsManager.getOverSteps();
				var isDelete:Boolean = false;
				for each(var grid:GridObject in _listener.currentLevelData.grids)
				{
					var jellyGrid:BasicObject = grid.getBasicObjectByBlockType(BasicObject.BLOCK_JELLY_ITEM);
					if(jellyGrid != null)
					{
						_listener.drawGridObject(grid.x, grid.y);
						
						for(var i:int = 0; i < overSteps.length; i++)
						{
							var overStep:StepCheckItem = overSteps[i];
							if(overStep.basicId == jellyGrid.id)
							{								
								overSteps.splice(i, 1);
								//fly jelly
								var item:Item = getGridItem(grid.x, grid.y);
								item.isFly = true;
								addForRemoval(grid.x, grid.y);
								
								isDelete = true;
								break;
							}
						}
					}

				}
				
				if(isDelete)
				{
					executeDeleteLogic(false, false);
					resetBomeTime();
					
					var map:Vector.<GridObject> = _listener.currentLevelData.grids;
					NetworkManager.instance.sendSwapInfo(0, 0, 1, 1, map, _dataRecord, false);
				}
				

			}
		}
		
		private function checkClockItem():void
		{
			if(CDataManager.getInstance().dataOfLevel.isNeedCheckClockItem())
			{
				_stepItemsManager.updateClockStep();
				
				if(_stepItemsManager.clockItems.length > 0)
				{
					for each(var grid:GridObject in _listener.currentLevelData.grids)
					{
						var clockGrid:BasicObject = grid.getBasicObjectByBlockType(BasicObject.BLOCK_CLOCK_ITEM);
						if(clockGrid != null)
						{
							_listener.drawGridObject(grid.x, grid.y);
						}
					}
					
					if(_stepItemsManager.clockItems[0].isOver())
					{
						//wait server send bingo
						_isWaitFinishLevel = true;
						_listener.setMouseEnable(false);
						_listener.cleanMouseStatus();
						
						if(!Debug.ISONLINE)
						{							
							_listener.showExitGameWhenClockKnock();
						}
					}
				}
			
				
				
			}
			
		}
		
		private function setStable(isCheckObstacle:Boolean):void
		{		
			startBombOneByOne();
			
			if(_isStartBombOneByOne)
			{
				executeMiddle();
				return;
			}
			
			playUnbelivalbeAnimation();
			
			resetBomeTime();
			
			if(isCheckObstacle && _currentSwapInfo != null)
			{
				var isFindVariable:Boolean = checkVariableItems();
				var isFindBug:Boolean = checkMoveBugs();
				
				if(isFindVariable || isFindBug)
				{
					forceRefresh();
					return;
				}
			}
			
			_isStable = true;
			
			var isStepStable:Boolean = _currentSwapInfo != null;
			//checkJellyAddStep useItem delete
			checkJellyItemAddStep();

			
			if(Debug.ISONLINE)
			{
				//todo defend 130025 if fail return;
				if(_isWaitFinishLevel && !_isFinishLevel)
				{
					return;
				}
				
				var map:Vector.<GridObject> = _listener.currentLevelData.grids;
				//							var score:int = _dataRecord.score;	
				if(_isFinishLevel)
				{
					_isFinishLevel = false;
					NetworkManager.instance.sendFinishLevel( map, _dataRecord);
					SwapLogicProxy.inst.setPause(true);
				}
				else
				{
					if(_currentSwapInfo != null)
					{					
						NetworkManager.instance.sendSwapInfo(_currentSwapInfo.srcX, _currentSwapInfo.srcY, _currentSwapInfo.dstX, _currentSwapInfo.dstY, map, _dataRecord, true);
						
						
						if(_dataRecord.getLeftStep() == 0)
						{
							_isWaitFinishLevel = true;
							_listener.setMouseEnable(false);
							_listener.cleanMouseStatus();
						}
					}
					else
					{
						NetworkManager.instance.sendSwapInfo(0, 0, 1, 1, map, _dataRecord, false);
					}
					
				}				
			}
			
			if(!Debug.ISONLINE)
			{
				dataRecord.resetOnceList();
			}
			_currentSwapInfo = null;
			
			if(!NetworkManager.instance.isMatching)
			{
				var status:int = CTaskStepChecker.getPassLevelStatus(_dataRecord, CDataManager.getInstance().dataOfLevel); 
				if(status == ConstGameStatus.GAME_STATUS_SUCC || status == ConstGameStatus.GAME_STATUS_FAIL)
				{
					//wait server send bingo
					_isWaitFinishLevel = true;
					_listener.setMouseEnable(false);
					_listener.cleanMouseStatus();
					
					_stepChecker.__onTime();
				}		
			}
				
			dataRecord.currentScore = 0;
			
			if(!_isWaitFinishLevel)
			{
				if(_dataRecord.getLeftStep() > 0)
				{				
					refreshMap(false);
				}
				
				if(isStepStable)
				{				
					checkJellyItemDispose();
					checkClockItem();
					checkBoat();
				}
				checkStartScrollScreen();
				
				TutorialManagerProxy.inst.checkTutorialCondition();
			}
			
			
		}
		
		private function initBoat():void
		{
			if(CDataManager.getInstance().dataOfLevel.isHasBoat)
			{
				var colIndex:int = 0;
				var rowIndex:int = 0;
				
				var boatPoint:Point = new Point(_width, _height); 
				while(rowIndex < _height)
				{
					colIndex = 0;
					while(colIndex < _width)
					{
						var item:Item = getGridItem(colIndex, rowIndex);
						if(item != null && item.normalId == ConstantItem.COLLECTED_MOVE_START_INDEX)
						{
							if(item.y < boatPoint.y)
							{
								boatPoint = new Point(item.x, item.y);
							}							
						}
										
						++colIndex;
					}
					++rowIndex;
				}
				
				stopLogic();
				_listener.playBoatAnimation(boatPoint.x, boatPoint.y, openLogic);
			}
		}
		
		private function checkBoat():void
		{
			if(CDataManager.getInstance().dataOfLevel.isHasBoat)
			{
				var colIndex:int = 0;
				var rowIndex:int = 0;
				
				var boatPoint:Point = new Point(_width, _height); 
				while(rowIndex < _height)
				{
					colIndex = 0;
					while(colIndex < _width)
					{
						var item:Item = getGridItem(colIndex, rowIndex);
						if(item != null && item.normalId == ConstantItem.COLLECTED_MOVE_START_INDEX)
						{
							if(item.y == 0)
							{
								
								//gameOver
								stopLogic();							
								_listener.showExitGameWhenHatDisappear(item);
								removeItem(item);
							}
							else
							{
								var startPoint:Point;
								var endPoint:Point;
								var item1:Item = getGridItem(colIndex, rowIndex - 1);
								if(item1 == null)
								{
									startPoint = new Point(colIndex, rowIndex);
									endPoint = new Point(colIndex, rowIndex -1);
								}
								else if(item1 != null && item1.isCanMove)
								{
									startPoint = new Point(colIndex, rowIndex);
									endPoint = new Point(colIndex, rowIndex -1);
								}
								else if(rowIndex - 2 >= 0)
								{
									var item2:Item = getGridItem(colIndex, rowIndex - 2);
									if(item2 == null)
									{
										startPoint = new Point(colIndex, rowIndex);
										endPoint = new Point(colIndex, rowIndex -2);
									}
									else if(item2 != null && item2.isCanMove)
									{
										startPoint = new Point(colIndex, rowIndex);
										endPoint = new Point(colIndex, rowIndex -2);
									}
								}
								
								if(startPoint != null)
								{
									if(endPoint.y < boatPoint.y)
									{
										boatPoint = endPoint;
										
									}
									forceSwap(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
								}
							}
						}
						
						++colIndex;
					}
					++rowIndex;
				}
				
				if(boatPoint.y != _height)
				{
					stopLogic();
					_listener.playBoatAnimation(boatPoint.x, boatPoint.y, openLogic);
				}
			}
		}
		
		private function stopLogic():void
		{
			_listener.setMouseEnable(false);
			_listener.cleanMouseStatus();
			SwapLogicProxy.inst.setPause(true);	
		}
		
		private function openLogic():void
		{
			_listener.setMouseEnable(true);
			SwapLogicProxy.inst.setPause(false);	
		}
		
		
		private function isHasNextBugPoint(gridX:int, gridY:int):Boolean
		{
			if(inRange(gridX, gridY))
			{
				var item:Item = getGridItem(gridX, gridY);
				if(item != null && item.isCanMove &&!item.isFindBug() &&item.isColorItem() && !item.isJellyItem()/*!item.isBlockOrHideGrid()*/)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function getNextPosition(gridX:int, gridY:int):Point
		{
			var item:Item;
			var points:Vector.<Point> = new Vector.<Point>;
			//up
			if(isHasNextBugPoint(gridX, gridY -1))
			{
				points.push(new Point(gridX, gridY - 1));
			}
			//left
			if(isHasNextBugPoint(gridX - 1, gridY))
			{
				points.push(new Point(gridX - 1, gridY));
			}
					
			//right
			if(isHasNextBugPoint(gridX + 1, gridY))
			{
				points.push(new Point(gridX + 1, gridY));
			}
			
			//down
			if(isHasNextBugPoint(gridX, gridY + 1))
			{
				points.push(new Point(gridX, gridY + 1));
			}
			
			var point:Point = null;
			
			if(points.length > 0)
			{				
				point = points[itemFactory.rnd.nextInt(points.length, -1, -1,this, null, false)];
			}
	
			return point;
		}
		
		private function getNextColor(currentColor:int, gridX:int, gridY:int, item:Item, isUseServerRandom:Boolean, matcher:OrthoPatternMatcher):int
		{
			var nextColor:int = -1;
			
			var colors:Vector.<Color> = CDataManager.getInstance().dataOfLevel.limitColors();
			var length:int = colors.length;
			var indexs:Vector.<int> = new Vector.<int>();
//			var itemNear:Item;
			while(true)
			{
				if(indexs.length == length)
				{
					ASSERT(false, "can not find right color! changeVariable color");
				}
				var index:int = int(Math.random() * length);
				if(indexs.indexOf(index) < 0)
				{
					indexs.push(index);
					nextColor = colors[index].id;
	
					if(nextColor != currentColor)
					{
						var match:Match = matcher.testMatchXY(nextColor, gridX, gridY);
						if(match == null)
						{
							break;
						}
					}
				}	
			}
			return nextColor;
		}
		
		private var _moveBugNeedNum:Boolean;
		private function checkMoveBugs():Boolean
		{

			var item:Item = null;
			var colIndex:int = 0;
			var rowIndex:int = 0;
			var isFindBugMove:Boolean = false; 
			_moveBugNeedNum = false;
			var dstPoints:Vector.<Point> = new Vector.<Point>();
			while (rowIndex < this._height)
			{				
				colIndex = 0;
				while (colIndex < this._width)
				{
					
					item = getGridItem(colIndex, rowIndex);
					if(item != null && item.isHasBug())
					{
						var isFindSame:Boolean = false;
						for each(var point:Point in dstPoints)
						{
							if(item.x == point.x && item.y == point.y)
							{
								isFindSame = true;
								break;
							}
						}
						
						if(isFindSame)
						{
							++colIndex;
							continue;
						}
						
						var nextPoint:Point = getNextPosition(colIndex, rowIndex);
						
						if(nextPoint != null)
						{
							_moveBugNeedNum = true;
							//move bug
							dstPoints.push(nextPoint);
							var startX:int = colIndex;
							var startY:int = rowIndex;
							
							var dstX:int = nextPoint.x;
							var dstY:int = nextPoint.y;
							
							_listener.moveBug(new Point(colIndex, rowIndex), nextPoint, null, true, null);
							
							item.setGridObject(_listener.currentLevelData.getGrid(startX, startY), _listener);
							
							var itemNext:Item = getGridItem(nextPoint.x, nextPoint.y);
							itemNext.setGridObject(_listener.currentLevelData.getGrid(nextPoint.x, nextPoint.y), _listener);
							isFindBugMove = true;
						}
					}
					
					++colIndex;
				}
				++rowIndex;
			}
			
			return isFindBugMove;
		}
		
		private function checkVariableItems():Boolean
		{
			var isFindVariable:Boolean = false;
			var item:Item = null;
			
			var match:OrthoPatternMatcher = getMatch();
			var colIndex:int = 0;
			var rowIndex:int = 0;
			while (rowIndex < this._height)
			{				
				colIndex = 0;
				while (colIndex < this._width)
				{
					
					item = getGridItem(colIndex, rowIndex);
					if(item != null && item.normalBasic.isVariableObject())
					{
						var nextColor:int = getNextColor(item.color, colIndex, rowIndex, item, false, match);
						
						var itemChange:Item = _listener.changeColor(item, nextColor);
						insertToMGrid(itemChange.x, itemChange.y, itemChange);
						
						isFindVariable = true;
						
						setMint(itemChange, itemChange.x, itemChange.y);
					}
		
					++colIndex;
				}
				++rowIndex;
			}
			
			return isFindVariable;
		}

        public function isPossibleMovesLeft() : Boolean
        {
            var item:Item = null;
            var itemRight:Item = null;
            var itemDown:Item = null;
            if (NoMoreMoves.linear3(this._mInt, this))
            {
                return true;
            }
            var rowIndex:int = 0;
            var colIndex:int = 0;
            while (rowIndex < this._height)
            {
                
                colIndex = 0;
                while (colIndex < this._width)
                {
                    
                    item = this.getGridItem(colIndex, rowIndex);
                    if (item == null || item.special <= 0 || !item.isCanMove)
                    {
                    }
                    else
                    {
						var itemUp:Item = getGridItem(colIndex, rowIndex - 1);
						var itemLeft:Item = getGridItem(colIndex - 1, rowIndex);
						itemRight = getGridItem((colIndex + 1), rowIndex);						
						itemDown = getGridItem(colIndex, (rowIndex + 1));
						
                        if (ItemType.isColorBomb(item.special))
                        {
							if(itemLeft != null && itemLeft.isCanMove && !item.isHasRopeH())
							{
								return true;	
							}
							if(itemRight != null && itemRight.isCanMove && !itemRight.isHasRopeH())
							{	
								return true;
							}
							if(itemUp != null && itemUp.isCanMove && !itemUp.isHasRopeV())
							{
								return true;
							}
							if(itemDown != null && itemDown.isCanMove && !item.isHasRopeV())
							{								
	                            return true;
							}
                        }
                        
                        if (itemRight && itemRight.special > 0 && itemRight.isCanMove &&!itemRight.isHasRopeH())
                        {
                            return true;
                        }
                       
                        if (itemDown && itemDown.special > 0 && itemDown.isCanMove && !item.isHasRopeV())
                        {
                            return true;
                        }
                    }
                    colIndex++;
                }
                rowIndex++;
            }
            return false;
        }

        private function getAllDeletedMatches() : Vector.<Match>
        {
			return _matchs;
   /*         this.updateIntBoard();
            return new OrthoPatternMatcher(this._mInt, MatchPatterns, 3).matchAll();*/
        }
		
		private function getSpecialMatches():Vector.<Match>
		{
			return new OrthoPatternMatcher(_mInt, MatchPatterns, 3).matchAll();
		}

        private function updateMatchCheck() : Boolean
        {
			_bombPoints = new Vector.<Point>();
			
            var match:Match = null;
            var gridItem:Item = null;
            var specialItem:Item = null;
//            var _loc_7:int = 0;
            var northIndex:int = 0;
            var westIndex:int = 0;
            var powers:Array = null;
            var powerUpCood:IntCoord = null;
            var orthoMatchs:Vector.<Match> = this.getAllDeletedMatches();
            var itemsDeleted:Vector.<Vector.<Item>> = new Vector.<Vector.<Item>>;
			
            if (orthoMatchs.length > 0)
            {
                this._unstableActionThisTick = true;
            }
            for each (match in orthoMatchs)
            {
                northIndex = match.north;
                while (northIndex <= match.south)
                {
                    
                    gridItem = addForRemoval(match.x, northIndex, 0, true);
					
					if(gridItem != null && gridItem.isSpecialItem())
					{
						itemsDeleted.push(getDeletedItems(gridItem));
					}
					
                    northIndex++;
                }
				
                westIndex = match.west;
                while (westIndex <= match.east)
                {
                    
                    gridItem = this.addForRemoval(westIndex, match.y, 0 , true);
					if(gridItem != null && gridItem.isSpecialItem())
					{
						itemsDeleted.push(getDeletedItems(gridItem));
					}
					
                    westIndex++;
                }
			
            }
			
			while(itemsDeleted.length > 0)
			{
				var items:Vector.<Item> = itemsDeleted.shift();
				updateRemovedItemsBySpecialMatch(items, itemsDeleted);
			}
			
            
            return orthoMatchs.length > 0;
        }
		
		private function updateRemovedItemsBySpecialMatch(items:Vector.<Item>, itemsDeleted:Vector.<Vector.<Item>>, isPushBombPoint:Boolean = true):void
		{
			for(var i:int = 0; i < items.length; i++)
			{
				var gridItem:Item = this.getUnifiedGridItem(items[i].x, items[i].y);
				if(gridItem != null && gridItem.isSpecialItem() && !gridItem.isToBeRemoved())
				{
					itemsDeleted.push(getDeletedItems(gridItem, isPushBombPoint));
				}
				addForRemoval(items[i].x, items[i].y);
			}
		}
		
		private function getDeletedItemsBySpecialBomb(centerX:int, centerY:int, bombType:int, otherPoint:Point = null):Vector.<Item>
		{
			var itemTemp:Item;
			var items:Vector.<Item> = new Vector.<Item>();
			var left:int;
			var right:int;
			if(bombType == BOMB_TYPE_D_DIAMOND)
			{
				var maxDistance:int = 4;
				
				var startX:int = centerX - maxDistance < 0 ? 0 : centerX - maxDistance ;
				var endX:int = centerX + maxDistance >= _width ? _width - 1: centerX + maxDistance;
				
				var startY:int = 0 ;
				var endY:int = 0;
								
				for(var i:int = startX; i <= endX; i++)
				{
					var distance:int = Math.abs(centerX - i);
					
					var gridDis:int = maxDistance - distance;
					
					startY = centerY - gridDis < 0 ? 0 : centerY - gridDis;
					endY = centerY + gridDis >=_height ? _height - 1: centerY + gridDis;
					var itemT:Item;
					for(var j:int = startY; j <= endY; j++)
					{
						itemT = getGridItem(i, j);
						if(itemT != null)
						{
//							items.push(itemT);
							itemT.isDeleteBySpecialEffectStatus = DataRecorder.SCORE_SWAP_D_D;
							insertDeletedItem(items, itemT);
							if(itemT.isCanAddScore() && itemT.special == ItemType.NONE)
							{
								itemT.isRecordScore = true;
								_dataRecord.addScore(DataManager.getInstance().getScoreById(itemT.isDeleteBySpecialEffectStatus).bombSingleScore, itemT, itemT.isDeleteBySpecialEffectStatus, true);
							}
//							if(true)
//							{
//								_bombPoints.push(new Point(itemT.x, itemT.y));
//							}
						}				
					}
				}
			}
			else if(bombType == BOMB_TYPE_D_COLUMN)
			{
				itemTemp = new Item(centerX, centerY);
				itemTemp.special = ItemType.COLUMN;
				itemTemp.isRecordScore = true;
				items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
				
				if(otherPoint == null)			
				{
					left = centerX - 1;
					right = centerX + 1;
					
					items = addColumns(left, right, centerY, items);
				}
				else
				{
					itemTemp = new Item(otherPoint.x, otherPoint.y);
					itemTemp.special = ItemType.COLUMN;			
					items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
					itemTemp.isRecordScore = true;
					
					if(otherPoint.x < centerX)
					{
						left = otherPoint.x - 1;
						right = centerX + 1;
					}
					else
					{
						left = centerX - 1;
						right = otherPoint.x + 1;
					}
					
					items = addColumns(left, right, centerY, items);
				}
				
			}
			else if(bombType == BOMB_TYPE_D_LINE)
			{
				itemTemp = new Item(centerX, centerY);
				itemTemp.special = ItemType.LINE;			
				itemTemp.isRecordScore = true;
				
				items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
				if(otherPoint == null)
				{
					left = centerY - 1;
					right = centerY + 1;
				}
				else
				{
					itemTemp = new Item(otherPoint.x, otherPoint.y);
					itemTemp.special = ItemType.LINE;
					itemTemp.isRecordScore = true;
					
					items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
					
					if(otherPoint.y < centerY)
					{
						left = otherPoint.y - 1;
						right = centerY + 1;
					}
					else
					{
						left = centerY - 1;
						right = otherPoint.y + 1;
					}
				}
				
				items = addLines(left, right, centerX, items);
			}
			
			return items;
		}
		
		private function addLines(left:int, right:int, centerX:int, items:Vector.<Item>):Vector.<Item>
		{
			var itemTemp:Item; 
			if(left >= 0)
			{
				itemTemp = new Item(centerX, left);
				itemTemp.special = ItemType.LINE;
				itemTemp.isRecordScore = true;
				items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
			}
			
			if(right < _height)
			{
				itemTemp = new Item(centerX, right);
				itemTemp.special = ItemType.LINE;
				itemTemp.isRecordScore = true;
				items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
			}
			
			return items;
		}
		
		private function addColumns(left:int, right:int, centerY:int, items:Vector.<Item>):Vector.<Item>
		{
			var itemTemp:Item; 
			if(left >= 0)
			{
				itemTemp = new Item(left, centerY);
				itemTemp.special = ItemType.COLUMN;	
				itemTemp.isRecordScore = true;
				items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
			}
			
			if(right < _width)
			{
				itemTemp = new Item(right, centerY);
				itemTemp.special = ItemType.COLUMN;
				itemTemp.isRecordScore = true;
				items = items.concat(getDeletedItems(itemTemp, false, -1, DataRecorder.SCORE_SWAP_L_D));
			}
			
			return items;
		}
		
		private var _bombPoints:Vector.<Point>;
		
		private function insertDeletedItem(items:Vector.<Item>, itemT:Item):void
		{
			if(!itemT.isHide())
			{
				items.push(itemT);
			}
		}
	
		private function getDeletedItems(item:Item, isPushBombPoints:Boolean = true, colorDefault:int = -1, scoreType:int = -1, isCaculateScore:Boolean = true):Vector.<Item>
		{
			
			var items:Vector.<Item> = new Vector.<Item>();
			if(item.isHasVine())
			{
				return items;
			}
			var east:int;
			var west:int;
			var south:int;
			var north:int;
			
			var indexX:int = 0;
			var indexY:int = 0;
			var itemT:Item;
			
			
			if(item.special == ItemType.LINE)
			{
				if(!item.isRecordScore)
				{
					item.isRecordScore = true;
					_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_BOMB_LINE).bombScore, item, DataRecorder.SCORE_BOMB_LINE);
				}
				indexX = 0;		
				while(indexX < _width)
				{
					itemT = getGridItem(indexX, item.y);
					
					if(itemT != null)
					{				
//						items.push(itemT);
						insertDeletedItem(items, itemT);
						
						if(scoreType != -1)
						{							
							itemT.isDeleteBySpecialEffectStatus = scoreType;
						}
						else
						{
							itemT.isDeleteBySpecialEffectStatus = DataRecorder.SCORE_BOMB_LINE;
						}
						if(isCaculateScore && itemT.isCanAddScore() && itemT.special == ItemType.NONE)
						{
							itemT.isRecordScore = true;
			
							_dataRecord.addScore(DataManager.getInstance().getScoreById(itemT.isDeleteBySpecialEffectStatus).bombSingleScore, itemT, itemT.isDeleteBySpecialEffectStatus, true);
						}
						if(isPushBombPoints)
						{
							_bombPoints.push(new Point(itemT.x, itemT.y));
						}
					}
					indexX++;
				}
			}
			else if(item.special == ItemType.COLUMN)
			{
				if(!item.isRecordScore)
				{
					item.isRecordScore = true;
					_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_BOMB_LINE).bombScore, item, DataRecorder.SCORE_BOMB_LINE);
				}
				
				indexY = 0;
				while(indexY < _height)
				{
					itemT = getGridItem(item.x, indexY);
					if(itemT != null)
					{
//						items.push(itemT);
						if(scoreType != -1)
						{							
							itemT.isDeleteBySpecialEffectStatus = scoreType;
						}
						else
						{
							itemT.isDeleteBySpecialEffectStatus = DataRecorder.SCORE_BOMB_LINE;
						}
						insertDeletedItem(items, itemT);
						if(isCaculateScore && itemT.isCanAddScore() && itemT.special == ItemType.NONE)
						{
							itemT.isRecordScore = true;

							_dataRecord.addScore(DataManager.getInstance().getScoreById(itemT.isDeleteBySpecialEffectStatus).bombSingleScore, itemT, itemT.isDeleteBySpecialEffectStatus, true);
						}
						
						if(isPushBombPoints)
						{
							_bombPoints.push(new Point(itemT.x, itemT.y));
						}
					}
						
					indexY++;
				}
			}
			else if(item.special == ItemType.DIAMOND)
			{
				if(!item.isRecordScore)
				{
					item.isRecordScore = true;
					_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_BOMB_DIAMOND).bombScore, item, DataRecorder.SCORE_BOMB_DIAMOND);
				}
				
				var startX:int = item.x - 2 < 0 ? 0 : item.x - 2 ;
				var endX:int = item.x + 2 >= _width ? _width - 1: item.x + 2;
				
				var startY:int = 0 ;
				var endY:int = 0;
				
			
				for(var i:int = startX; i <= endX; i++)
				{
					var distance:int = Math.abs(item.x - i);
					
					switch(distance)
					{
						case 2:	
							startY = item.y;
							endY = item.y;
							break;
						case 1:
							startY = item.y - 1 < 0 ? 0 : item.y - 1;
							endY = item.y + 1 >=_height ? _height - 1: item.y + 1;
							break;
						case 0:
							startY = item.y - 2 < 0 ? 0 : item.y - 2;
							endY = item.y + 2 >=_height ? _height - 1: item.y + 2;
							break;
						
					}
					for(var j:int = startY; j <= endY; j++)
					{
						itemT = getGridItem(i, j);
						if(itemT != null)
						{
//							items.push(itemT);
							if(scoreType != -1)
							{								
								itemT.isDeleteBySpecialEffectStatus = scoreType;
							}
							else
							{
								itemT.isDeleteBySpecialEffectStatus = DataRecorder.SCORE_BOMB_DIAMOND;
							}
							insertDeletedItem(items, itemT);
							if(isCaculateScore && itemT.isCanAddScore() && itemT.special == ItemType.NONE)
							{
								itemT.isRecordScore = true;
	
								_dataRecord.addScore(DataManager.getInstance().getScoreById(itemT.isDeleteBySpecialEffectStatus).bombSingleScore, itemT, itemT.isDeleteBySpecialEffectStatus, true);
							}
							
							
							if(isPushBombPoints)
							{
								_bombPoints.push(new Point(itemT.x, itemT.y));
							}
						}				
					}
				}
			}
			else if(item.special == ItemType.COLOR)
			{
				if(!item.isRecordScore)
				{
					_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_BOMB_COLOR).bombScore, item, DataRecorder.SCORE_BOMB_COLOR);
					item.isRecordScore = true;
				}	
				
				var color:int =	colorDefault;
				if(color == -1)
				{
					while(true)
					{
						
						color = itemFactory.getRandomColor(-1, -1, null ,false);
						if(getSameColorItem(color))
						{
							break;
						}
					}
				}
				
				
				indexX = 0;
				while(indexX < _width)
				{
					indexY = 0;
					while(indexY < _height)
					{
						itemT = getGridItem(indexY, indexX);
						if(itemT != null)
						{
							if(itemT.color == color)
							{
								//clock jelly gift
								if(itemT.special == ItemType.INVALID && scoreType != -1)
								{
									//can not transfer line and diamond
									++indexY;
									continue;
								}
								
//								items.push(itemT);
								if(scoreType != -1)
								{									
									itemT.isDeleteBySpecialEffectStatus = scoreType;
								}
								else
								{
									itemT.isDeleteBySpecialEffectStatus = DataRecorder.SCORE_BOMB_COLOR;
									itemT.isDeletedByColorAbsorb = true;
								}
								insertDeletedItem(items, itemT);
								if(isCaculateScore && itemT.isCanAddScore() && itemT.special == ItemType.NONE)
								{
									itemT.isRecordScore = true;		
									_dataRecord.addScore(DataManager.getInstance().getScoreById(itemT.isDeleteBySpecialEffectStatus).bombSingleScore, itemT, itemT.isDeleteBySpecialEffectStatus, true);
								}	
							}
						}				
						++indexY;
					}
					++indexX;
				}
				
			}
			else
			{
				return null;
			}
			return items;
		}
		
		private function getSameColorItem(color:int):Boolean
		{
			var indexX:int = 0;
			while(indexX < _width)
			{
				var indexY:int = 0;
				while(indexY < _height)
				{
					var itemT:Item = getGridItem(indexY, indexX);
					if(itemT != null)
					{
						if(itemT.color == color)
						{
							return true;	
						}
					}				
					++indexY;
				}
				++indexX;
			}
			
			return false;
		}
		
		

        public function addForRemoval(gridX:int, gridY:int, removeTicks:int = 0, isDeleteByMatch:Boolean = false) : Item
        {
            var item:Item = getGridItem(gridX, gridY);
			
			
			if(item == null)
			{
				CONFIG::debug
				{
					TRACE_GRID("find num gird when want to delete it grix: " + gridX + " gridY: " + gridY);
				}
				return null;
			}
			
			if(!item.isRemovable())
			{
				return null;	
			}
			
            if (this._toRemoveIds[item.id] != null)
            {
                return null;
            }
			if(item.isToBeRemoved())
			{
				return null;
			}			
			item.isDeleteByMatch = isDeleteByMatch;
			
            item.setRemovalTicks(removeTicks);
            return item;
        }

        private function _reallyAddForRemoval(gridX:int, gridY:int) : void
        {
            var item:Item = this.getUnifiedGridItem(gridX, gridY);
            this._toRemoveIds[item.id] = 1;
            this._toRemoveCoords.push(new IntCoord(gridX, gridY));
            return;
        }

		
        private function updateFallingItems() : void
        {
			_moveAnimationStepNeed = 0;
			_moveAnimationHasDone = 0;
			_isStartPlayMoveAni = true;
			
			_moveAnimationStepNeed = getAllDropNumbers();
			
			if(_moveAnimationStepNeed == 0)
			{
				//one item destory and not fallingItems.
				_mIntIsDirty = true;
				return;
			}
			
            var fallingCol:FallingColumn = null;
            var index:int = 0;
            while (index < this._width)
            {
                
                fallingCol = this._fallingColumns[index];
				startPlayFallingAnimation(fallingCol);
                index++;
            }
        }
		
		private function getAllDropNumbers():int
		{
			var num:int = 0;
			var index:int = 0;
			var fallingCol:FallingColumn = null;
			while (index < this._width)
			{
				
				fallingCol = this._fallingColumns[index];
				var index1:int = 0;
				var items:Vector.<Item> = fallingCol.getItems();
				while (index1 < items.length)
				{									
					++num;
					
					index1++;
					
				}
				index++;
			}
			
			
			return num;
		}
		
		private function startPlayFallingAnimation(fallingColumn:FallingColumn):void
		{
			var index:int = 0;
			var items:Vector.<Item> = fallingColumn.getItems();
			while (index < items.length)
			{									
				_listener.playFallingAnimation(items[index], fallCompleteAndUpdateData);
				index++;
				
			}
		}

        private function updateBoardItems(tickNumber:int) : void
        {
            var indexWidth:int = 0;
            var item:Item = null;
            var indexHeight:int = 0;
            while (indexHeight < this._height)
            {
                
                indexWidth = 0;
                while (indexWidth < this._width)
                {
                    
                    item = this.getGridItem(indexWidth, indexHeight);
                    if (item != null)
                    {
                        item.tick(tickNumber);
                    }
                    indexWidth++;
                }
                indexHeight++;
            }
            return;
        }
		
		private function isCanSwap(itemA:Item, itemB:Item) : Boolean
		{
			var srcX:int = itemA.x;
			var dstX:int = itemB.x;
			var srcY:int = itemA.y;
			var dstY:int = itemB.y;
			
			var directionA:Vector.<int> = itemA.findRopeType();
			var directionB:Vector.<int> = itemB.findRopeType();
			
			if(directionA == null && directionB == null)
			{
				return true;
			}
			
			
			if(Math.abs(srcX - dstX) != 0)
			{
				if(srcX > dstX && isFindDirection(directionA, BasicObject.DIRECTION_TYPE_H))
				{
					_listener.playRopeAnimation(itemA.x, itemA.y, BasicObject.DIRECTION_TYPE_H);
					return false;
				}
				else if(srcX < dstX && isFindDirection(directionB, BasicObject.DIRECTION_TYPE_H))
				{
					_listener.playRopeAnimation(itemB.x, itemB.y, BasicObject.DIRECTION_TYPE_H);
					return false;
				}
			}
			else if(Math.abs(srcY - dstY) != 0)
			{
				if(srcY < dstY && isFindDirection(directionA, BasicObject.DIRECTION_TYPE_V))
				{
					_listener.playRopeAnimation(itemA.x, itemA.y, BasicObject.DIRECTION_TYPE_V);
					return false;
				}
				else if(srcY > dstY && isFindDirection(directionB, BasicObject.DIRECTION_TYPE_V))
				{
					_listener.playRopeAnimation(itemB.x, itemB.y, BasicObject.DIRECTION_TYPE_V);
					return false;
				}
			}
			
			return true;
		}
		
		private function isFindDirection(directions:Vector.<int>, dstDirection:int):Boolean
		{
			for each(var direction:int in directions)
			{
				if(direction == dstDirection)
				{
					return true;
				}
			}
			return false;
		}

        public function trySwap(srcX:int, srcY:int, dstX:int, dstY:int) : Boolean
        {
            if (!this._isStable)
            {
                return false;
            }
            if (!(Math.abs(srcX - dstX) == 0 && Math.abs(srcY - dstY) == 1 || Math.abs(srcY - dstY) == 0 && Math.abs(srcX - dstX) == 1))
            {
                return false;
            }
            var itemA:Item = this.getGridItem(srcX, srcY);
            var itemB:Item = this.getGridItem(dstX, dstY);
            if (itemA == null || itemB == null)
            {
                return false;
            }
            if (itemA.isBusy() || itemB.isBusy())
            {
                return false;
            }
			
			if(!isCanSwap(itemA, itemB))
			{
				return false;
			}
			
            this._doSwap(srcX, srcY, dstX, dstY, false);
            return true;
        }
		
		public function useSwapItem(srcX:int, srcY:int, dstX:int, dstY:int):void
		{
			forceSwap(srcX, srcY, dstX, dstY);
			_useItemStatus = USE_NONE;
			
			NetworkManager.instance.sendServerUseTool(ConstantItem.ITEM_SWAP_2_ITEMS);
			
			forceRefresh();
			
			MouseManager.instance.removeCursorByKey(MouseManager.CURSOR_KEY_FORCESWAP , true);
		}
		
		private function moveComplete():void
		{
			++_moveAnimationHasDone;
		}
		
		public function forceSwap(srcX:int, srcY:int, dstX:int, dstY:int):void
		{
			var itemA:Item = this.getGridItem(srcX, srcY);
			var itemB:Item = this.getGridItem(dstX, dstY);
			
			itemA.beginMovement(dstX, dstY, moveComplete);
			itemB.beginMovement(srcX, srcY, moveComplete);
			
			this._set(srcX, srcY, itemB, false);
			
			var normalA:BasicObject = itemA.getMoveBasicObject();
			_listener.updateGridNormalItemData(srcX, srcY, itemB);
			
			this._set(dstX, dstY, itemA, false);
			_listener.updateGridNormalItemData(dstX, dstY, itemA, normalA);
			
//			_mIntIsDirty = false;
			forceRefresh();
			_moveAnimationStepNeed += 2;
		}

        private function _doSwap(srcX:int, srcY:int, dstX:int, dstY:int, isFailed:Boolean, swaps:Vector.<SwapInfo> = null) : void
        {
			
            var itemA:Item = this.getGridItem(srcX, srcY);
            var itemB:Item = this.getGridItem(dstX, dstY);
			
			if(itemA == null || itemB == null)
			{
				CONFIG::debug
				{					
					TRACE_JLM("find swap bug???");
				}
				return;
			}
			
			CONFIG::debug
			{
				TRACE_LOG("srcX: " + srcX +" srcY: "+srcY + " dstX: "+dstX+" dstY: "+dstY);
				TRACE_LOG("itemA: color" + itemA.color +" x: "+itemA.x + " y: "+itemA.y);
				TRACE_LOG("itemB: color" + itemB.color +" x: "+itemB.x + " y: "+itemB.y);
			}
			
            if (itemA.isLocked() || itemB.isLocked())
            {
                return;
            }
			
			/*_moveAnimationStepNeed = 2;
			_moveAnimationHasDone = 0;
			_isStartPlayMoveAni = true;*/
			
            itemA.beginMovement(dstX, dstY, moveComplete);
            itemB.beginMovement(srcX, srcY, moveComplete);
            if (swaps == null)
            {
                swaps = this._swaps;
            }
            var swapInfo:SwapInfo = new SwapInfo(srcX, srcY, dstX, dstY, itemA, itemB);
			swapInfo.isFailed = isFailed;
            swaps.push(swapInfo);
            this._lastSwap = swapInfo;
            this._listener.switchMade(swapInfo, SWITCHSTATE_BEGIN);
           
            _numSwaps = this._numSwaps + 1;
			
            this._set(srcX, srcY, itemB, true);
			
			var normalA:BasicObject = itemA.getMoveBasicObject();
			_listener.updateGridNormalItemData(srcX, srcY, itemB);
				
            this._set(dstX, dstY, itemA, true);
			_listener.updateGridNormalItemData(dstX, dstY, itemA, normalA);
        }

        private function _set(dstX:int, dstY:int, item:Item, isRefresh:Boolean) : void
        {
           insertToMGrid(dstX, dstY, item);
			if(isRefresh)
			{				
	            this._mIntIsDirty = true;
			}
			
			if(item != null)
			{
				item.x = dstX;
				item.srcX = item.x;
				item.y = dstY;
				item.srcY = item.y;
			}
            

            return;
        }
		
		private function setGridsItemDataAndUI():void
		{
			var colIndex:int = 0;
			var rowIndex:int = 0;
			while (rowIndex < _height)
			{			
				colIndex = 0;
				while (colIndex < _width)
				{
					var grid:GridObject = _listener.currentLevelData.getGrid(colIndex, rowIndex);
					var item:Item = grid.getEffectItem(_listener);
					this._set(colIndex, rowIndex, item, false);
					
					if(item != null)
					{						
						_initializeAndAddItem(item, false);
					}	
					colIndex++;
				}
				rowIndex++;
			}
		}
		
		public function preInitGrid(level:LevelData, mainUI:MediatorPanelMainUI):void
		{
			var colIndex:int = 0;
			var rowIndex:int = 0;
			while (rowIndex < _height)
			{
				
				colIndex = 0;
				while (colIndex < _width)
				{
					var grid:GridObject = level.getGrid(colIndex, rowIndex);
									
					var item:Item = grid.getEffectItem(mainUI);
					this._set(colIndex, rowIndex, item, false);
			
					colIndex++;
				}
				rowIndex++;
			}
			refreshInt();
		}
		
        public function initGrids(level:LevelData, mainUI:MediatorPanelMainUI) : void
        {
			_stepItemsManager.reset();
			
			_listener = mainUI;
			
            var colIndex:int = 0;
            var rowIndex:int = 0;
            while (rowIndex < _height)
            {
                
                colIndex = 0;
                while (colIndex < _width)
                {
					var grid:GridObject = level.getGrid(colIndex, rowIndex);
					
					var jellyBasic:BasicObject = grid.getBasicObjectByBlockType(BasicObject.BLOCK_JELLY_ITEM);
					if(jellyBasic != null)
					{						
						var stepJellyItem:StepCheckItem = new StepCheckItem(CDataManager.getInstance().dataOfLevel.jellyLeftStep, jellyBasic.id);
						_stepItemsManager.jellyItems.push(stepJellyItem);
					}
					var clockBasic:BasicObject = grid.getBasicObjectByBlockType(BasicObject.BLOCK_CLOCK_ITEM);
					if(clockBasic != null)
					{
						var stepClockItem:StepCheckItem = new StepCheckItem(CDataManager.getInstance().dataOfLevel.clockLeftStep, clockBasic.id);
						_stepItemsManager.clockItems.push(stepClockItem);
					}
					var item:Item = grid.getEffectItem(mainUI);
					this._set(colIndex, rowIndex, item, false);
					
					if(item != null)
					{						
						_initializeAndAddItem(item, false);
					}	
                    colIndex++;
                }
                rowIndex++;
            }
			
			CDataManager.getInstance().dataOfLevel.createMaxJellyNum += _stepItemsManager.jellyItems.length;
           	
			ready();
        }


        public function removeItem(item:Item) : void
        {
			CONFIG::debug
			{
				TRACE_GRID("remove itemFromGrid x: " + item.x + " y: "+ item.y);
			}
//			this._mGrids[item.row][item.column] = null;
			
//			this._mIntIsDirty = true;
			if(item.isHasVine())
			{
				forceRefresh();	
			}			
			else if(!item.isFly)
			{							
				_dataRecord.addRemoveItemScore(item, _bombTimes + 1);
			}
			
			if(item.isHasBug())
			{
				forceRefresh();
			}
			
            var itemChange:Item = this._listener.destroyItem(item, _bombTimes + 1);
			insertToMGrid(item.x, item.y, itemChange);
        }


        public function setListener(param1:IBoardListener) : void
        {
           /* this._listener = param1 as GameView;
            return;*/
        }
		
		private function findAllNormalItemContainsVariable():Vector.<Item>
		{			
			var normalItems:Vector.<Item> = new Vector.<Item>();
			var rowIndex:int = 0;
			while(rowIndex < _height)
			{
				var colIndex:int = 0;
				while(colIndex < _width)
				{
					var item:Item = getGridItem(colIndex, rowIndex);
					if(item != null && item.isColorItem() && item.special == ItemType.NONE && !item.isHasVine() )
					{
						normalItems.push(item);
					}
					
					++colIndex;
				}
				
				++rowIndex;	
			}
			
			return normalItems;
		}
		
		private var _isWaitFinishLevel:Boolean;
		private var _isStartBingo:Boolean;
		private var _isNoticeFinishLevel:Boolean;
		
		private var _isPlayToolAnimation:Boolean;
		
		public function noticeFinishLevel():void
		{
			if(!_isStartBingo)
			{
				_isStartBingo = true;
				_isNoticeFinishLevel = true;
				
			}
			
		}
		private function caculateFinishLevel(target:MovieClip = null):void
		{
			CBaseUtil.sendEvent(GameNotification.EVENT_STOP_TASK);
			
			
			var leftSetp:int = _dataRecord.getLeftStep();
			if(leftSetp > 0)
			{
		
				var normalItems:Vector.<Item> = findAllNormalItemContainsVariable();
				
				var i:int = 0;
				while(normalItems.length > 0 && leftSetp > 0)
				{
					var randomIndex:int = _itemFactory.rnd.nextInt(normalItems.length, -1, -1, this, null, false);
					var item1:Item = normalItems[randomIndex];					
					normalItems.splice(randomIndex, 1);
					--leftSetp;
					
					var index:int = itemFactory.rnd.nextInt(2, -1, -1, this, null, false);
					
					if(index == 0)
					{						
						item1.special = ItemType.COLUMN;
					}
					else
					{
						item1.special = ItemType.LINE;
					}
					
					if(item1.isVariableItem())
					{
						item1.normalBasic.objectType = BasicObject.TYPE_NORMAL;
					}
					
					setGridData(item1.x, item1.y, item1);
					this._bingoItems.push(item1);
					
//					_dataRecord.addScore(DataManager.getInstance().getScoreById(DataRecorder.SCORE_STEP).bombScore, item1, DataRecorder.SCORE_STEP); 
				}
			}
			else
			{
				
			}
			
			if(this._bingoItems.length > 0)
			{
				//循环播放
				_bingoTimer = new Timer(500);
				_bingoTimer.addEventListener(TimerEvent.TIMER, timerResponseFinishLevel);
				_bingoTimer.start();
			}
			else
			{
				var isStable:Boolean = showBingoTimeOver();
				
				if(isStable)
				{
					setStable(false);
				}
			}
		}
		
		private function insertToMGrid(gridX:int, gridY:int, item:Item):void
		{
			
			CONFIG::debug
			{
				ASSERT(gridX >= 0 && gridY >= 0, "grid must in range!");
				
				if(item == null)
				{
					TRACE_INSERT_GRID("x: "+gridX + " y: "+gridY+" setToNull");
				}
				else
				{					
					TRACE_INSERT_GRID("normalId:" + item.normalId + "srcX: "+ item.srcX + " srcY: "+item.srcY + " to dstX: "+gridX+" dstY: "+gridY);
				}
			}
			
			_mGrids[gridY][gridX] = item;
		}

        private function fallCompleteAndUpdateData(item:Item) : void
        {
            item.srcX = item.x;
			item.srcY = item.y;

//            this._fallingColumns[item.x].remove(item);
			
			CONFIG::debug
			{
				TRACE_GRID("add itemFromGrid x: " + item.x + " y: "+ item.y);
			}
   
			insertToMGrid(item.x, item.y, item);
			addToGridLayer(item.x, item.y, item.normalId);
			_listener.drawGridObject(item.x, item.y);
			
			_moveAnimationHasDone ++;
            item.moveComplete();
			
			if(_moveAnimationHasDone == _moveAnimationStepNeed)
			{			
				_mIntIsDirty = true;
				
				if(_mIntIsDirty)
				{				
					var isNeedCheck:Boolean = checkMoveCollects();			
					if(isNeedCheck)
					{
						
						_mIntIsDirty = false;
					}
					else
					{
						_mIntIsDirty = true;
					}
				}
			}
        }

        private function calculateReasonableStability() : Boolean
        {
            if (this._swaps.length > 0)
            {
				Debug.stableLog += " _swaps > 0";
                return false;
            }
            if (this._unstableActionThisTick)
            {
				Debug.stableLog += " unstableActionTick"
                return false;
            }
            var index:int = 0;
            while (index < this._width)
            {
                
                if (!this._fallingColumns[index].isEmpty())
                {
					Debug.stableLog += " fallingColumn item  index: "+ index;
                    return false;
                }
                index++;
            }
			
			if(_currentSwapInfo != null)
			{
				Debug.stableLog += "_currentSwapInfo not is null!";
				return false;
			}
            return true;
        }

        public function isStable() : Boolean
        {
            return this._isStable;
        }

        private function calculateStability() : Boolean
        {
            var item:Item = null;
            var rowIndex:int = 0;
            var colIndex:int = 0;
            while (rowIndex < this._height)
            {
                
                colIndex = 0;
                while (colIndex < this._width)
                {
                    
                    item = this.getUnifiedGridItem(colIndex, rowIndex);
                    if (item && (item.isBusy() || item.isDestroyed() || item.isToBeRemoved()))
                    {
                        return false;
                    }
                    item = this.getGridItem(colIndex, rowIndex);
                    if (item && (item.isBusy() || item.isDestroyed() || item.isToBeRemoved()))
                    {
                        return false;
                    }
                    colIndex++;
                }
                rowIndex++;
            }
            return true;
        }

		
		private function findNotEmptyGridNumber(emptyGrids:Vector.<EmptyGrid>, finalIndex:int, gridX:int):int
		{
			var startIndex:int = emptyGrids.length > 0 ? emptyGrids[0].startEmptyIndex : 0;
			
			var number:int = 0;
			if(startIndex != 0)
			{				
				for(var i:int = startIndex ; i > finalIndex ; i--)
				{
					if(getGridItem(gridX, i) != null)
					{
						++number;
					}
				}
			}
			return number;
		}
		
		private var _isSwapOpen:Boolean;
		
		private function createSpecialItem(match:Match, addItems:Vector.<Item>):Boolean
		{
			
			var gridX:int = match.x;
			var gridY:int = match.y;
			
			if(_isSwapOpen)
			{
				var itemPosition:Item;
				if(_currentSwapInfo.item_a.color == match.color)
				{
					itemPosition = _currentSwapInfo.item_a;
				}
				else if(_currentSwapInfo.item_b.color == match.color)
				{
					itemPosition = _currentSwapInfo.item_b;
				}
				
				if(itemPosition != null /*&& itemPosition._specialType == ItemType.NONE*/)
				{	
					gridX = itemPosition.x;
					gridY = itemPosition.y;
				}	
			}
			
			
			var item:Item = _itemFactory.createSpecialBombByMatch(match, gridX, gridY);
			
			_dataRecord.addSpecialItemCreateScore(item, _bombTimes + 1);
			//todo getY
//			item.y = dstY;
			
			var itemsDeleted:Vector.<Vector.<Item>> = new Vector.<Vector.<Item>>;
			if(isInBombPoint(item.x, item.y))
			{
				itemsDeleted.push(getDeletedItems(item, false));
				
				while(itemsDeleted.length > 0)
				{
					var items:Vector.<Item> = itemsDeleted.shift();
					updateRemovedItemsBySpecialMatch(items, itemsDeleted, false);
				}
				
				return true;
			}
			
			insertToMGrid(gridX, gridY, item);
			setGridData(gridX, gridY, item);
			
			addItems.push(item);
			
			return false;			
		}
		
		private function setGridData(gridX:int, gridY:int, item:Item):void
		{
			var grid:GridObject = _listener.currentLevelData.getGrid(gridX, gridY);
			//				grid.basicObjects = new Vector.<BasicObject>();	
			var basicObj:BasicObject;
			if(item.normalBasic != null && item.normalBasic.objectType != BasicObject.TYPE_NORMAL)
			{
				if(item.normalBasic.isMove)
				{						
					basicObj = item.normalBasic;
				}
				else if(item.normalBasic.blockType == BasicObject.BLOCK_VINE || item.isFindBug())
				{
					basicObj = item.getAcanMoveBasic();
				}
			}
			else
			{
				//normal basicObject or null
				basicObj = new BasicObject(item.getIdBySpecialType());
			}
			
			CONFIG::debug
			{
				ASSERT(basicObj != null, "can not push null basicObject to grid!");
			}
			//pushMoveBasicToNewPosition
			grid.pushObject(basicObj);
			
			item.setGridObject(grid, _listener);
		}
		
		private function setGridDataById(gridX:int, gridY:int, item:Item, normalId:int):void
		{
			var grid:GridObject = _listener.currentLevelData.getGrid(gridX, gridY);
			var basicObj:BasicObject = new BasicObject(normalId);
			grid.pushObject(basicObj);
			
			item.setGridObject(grid, _listener);
		}
		
		private function isInBombPoint(gridX:int, gridY:int):Boolean
		{
			for each(var point:Point in _bombPoints)
			{
				if(gridX== point.x && gridY == point.y)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function updateFallingColumn(fallingCol:FallingColumn):void
		{
			var emptyGrids:Vector.<EmptyGrid> = fallingCol.emptyGrids;
			
			for(var j:int = emptyGrids.length - 1; j >= 0; j --)
			{
				var empty:EmptyGrid = emptyGrids[j];
				
				if(empty.isRemoved)
				{
					emptyGrids.splice(j, 1);
				}
			}
			
			var maxLength:int = 0;
			for(var i:int = 0; i < emptyGrids.length; i++)
			{
				maxLength += emptyGrids[i].emptyLength;
			}
			
			fallingCol.needCreateNewItemNumber = maxLength;
		}
		
		private function isMatchEmptyGrid(emptyGrid:EmptyGrid, gridY:int):Boolean
		{
			var startIndex:int = emptyGrid.startEmptyIndex;
			var emptyLength:int = emptyGrid.emptyLength;
			var finalIndex:int = startIndex - emptyLength;
			for(var j:int = startIndex; j > finalIndex; j--)
			{
				if(gridY == j)
				{
					if(j == startIndex)
					{
						emptyGrid.startEmptyIndex = startIndex - 1;
					}
					
					emptyGrid.emptyLength = emptyGrid.emptyLength - 1;
					
					if(emptyGrid.startEmptyIndex < 0 || emptyGrid.emptyLength <= 0)
					{
						emptyGrid.isRemoved = true;
					}
					
					
					return true;
				}
			}
			
			return false;
		}
		
		/*private function isFindHideAndBlockGrid(gridX:int, gridY:int):Boolean
		{
			return getGridItem(gridX, gridY) != null && getGridItem(gridX, gridY).isBlockOrHideGrid(); 
		}*/

        private function createNewItemOnTop(gridX:int, index:int, dropLength:int, id:int = -1) : void
        {			
           if(id == -1)
		   {			   
	           createNormalItem(gridX, index, dropLength);
		   }
		   else
		   {
			   createObstacleObjectById(gridX, index, dropLength, id);
		   }
        }
		
		private function createObstacleObjectById(gridX:int, index:int, dropLength:int, id:int):Item
		{
			var fallingCol:FallingColumn = null;
			var item:Item = new Item(gridX, -1, -1);
			fallingCol = _fallingColumns[gridX];
			
			item.srcY =  - (index + 1) ;
			item.y = dropLength + item.srcY;
			
			insertToMGrid(item.x, item.y, item);			
			fallingCol.insertItem(item);
			item.setBoard(this);
			
			var grid:GridObject = _listener.currentLevelData.getGrid(item.x, item.y);
			var basic:BasicObject = new BasicObject(id);
			grid.pushObject(basic);
			
			item.setGridObject(grid, _listener);
			
			return item;
		}
		
		private function createNormalItem(gridX:int, index:int, dropLength:int):void
		{
			var fallingCol:FallingColumn = null;
			var item:Item = this._itemFactory.createRandomItem(gridX,  - (index + 1) + dropLength, true);
			fallingCol = this._fallingColumns[gridX];
			
			item.srcY =  - (index + 1) ;
			item.y = dropLength + item.srcY;
			
			
			insertToMGrid(item.x, item.y, item);
			setGridData(item.x, item.y, item);
			
			fallingCol.insertItem(item);
			this._initializeAndAddItem(item, true);
		}

        private function _initializeAndAddItem(item:Item, isFalling:Boolean) : void
        {
//            this._allItems.push(item);
//            this._byIndex[item.id] = item;
            item.setBoard(this);
            this._listener.addItemToUI(item, item.x, item.y, isFalling);
            return;
        }

        public function getColorHistogram() : Vector.<int>
        {
            var _loc_3:int = 0;
            var _loc_4:Item = null;
            var _loc_1:Vector.<int> = new Vector.<int>;
            var _loc_2:int = 0;
            while (_loc_2 < this._height)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this._width)
                {
                    
                    _loc_4 = this.getGridItem(_loc_3, _loc_2);
                    if (!_loc_4)
                    {
                    }
                    else
                    {
                        if (_loc_4.color >= _loc_1.length)
                        {
                            _loc_1.length = _loc_4.color + 1;
                        }
                        var _loc_5:* = _loc_1;
                        var _loc_6:* = _loc_4.color;
                        var _loc_7:* = _loc_1[_loc_4.color] + 1;
                        _loc_5[_loc_6] = _loc_7;
                    }
                    _loc_3++;
                }
                _loc_2++;
            }
            return _loc_1;
        }

        public function getMostCommonColor(param1:Array = null) : int
        {
            if (param1 == null)
            {
                param1 = [];
            }
            var _loc_2:* = this.getColorHistogram();
            var _loc_3:int = -1;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            while (_loc_5 < _loc_2.length)
            {
                
                if (_loc_2[_loc_5] > _loc_4 && param1.indexOf(_loc_5) == -1)
                {
                    _loc_3 = _loc_5;
                    _loc_4 = _loc_2[_loc_5];
                }
                _loc_5++;
            }
            return _loc_3;
        }

        public function transform(param1:int, param2:int, param3:int, param4:int = -1) : void
        {
            var item:Item = this.getGridItem(param1, param2);
            ASSERT(item != null, "Transformed Item can\'t be null");
            if (!item)
            {
                return;
            }
            item.special = param3;
            this._itemFactory.addDestructionPlan(item);
            if (param4 >= 0)
            {
                item.color = param4;
            }
            return;
        }

        public function width() : int
        {
            return this._width;
        }

        public function height() : int
        {
            return this._height;
        }

  
        public function getFallingColumn(index:int) : FallingColumn
        {
            return this._fallingColumns[index];
        }

        private function getMatchPattern(patternId:int) : MatchPattern
        {
            if (patternId < MATCH_ID_TorL || patternId > MATCH_ID_5)
            {
				CONFIG::debug
				{
					ASSERT(false, "find pattern not exist! pattern is "+ patternId);
				}
				return null;
            }
//            return MatchPatterns[[1, 3, 2, 0][patternId - 2]];
			return MatchPatterns[findPatternIndex(patternId)];
        }
		
		private function findPatternIndex(patternId:int):int
		{
			var index:int = AllMatchPatternTypes.indexOf(patternId);
			return index;
		}

        public function getHint() : Array
        {
			var hintArray:Array = null;
            hintArray = NoMoreMoves.linear3match(_mInt, this);
			
			if(hintArray != null)
			{
				return hintArray;
			}
			var rowIndex:int = 0;
			var colIndex:int = 0;
			while (rowIndex < this._height)
			{
				
				colIndex = 0;
				while (colIndex < this._width)
				{
					
					var item:Item = this.getGridItem(colIndex, rowIndex);
					if (item == null || item.special <= 0 || !item.isCanMove)
					{
					}
					else
					{
						var itemUp:Item = getGridItem(colIndex, rowIndex - 1);
						var itemLeft:Item = getGridItem(colIndex - 1, rowIndex);
						var itemRight:Item = getGridItem((colIndex + 1), rowIndex);						
						var itemDown:Item = getGridItem(colIndex, (rowIndex + 1));
						
						if (ItemType.isColorBomb(item.special))
						{
							if(itemLeft != null && itemLeft.isCanMove && !item.isHasRopeH())
							{
								return [new Point(itemLeft.x, itemLeft.y), ConstantItem.DIRECTION_H];	
							}
							if(itemRight != null && itemRight.isCanMove && !itemRight.isHasRopeH())
							{	
								return [new Point(item.x, item.y), ConstantItem.DIRECTION_H];
							}
							if(itemUp != null && itemUp.isCanMove && !itemUp.isHasRopeV())
							{
								return [new Point(itemUp.x, itemUp.y), ConstantItem.DIRECTOIN_V];
							}
							if(itemDown != null && itemDown.isCanMove && !item.isHasRopeV())
							{								
								return [new Point(item.x, item.y), ConstantItem.DIRECTOIN_V];
							}
						}
						
						if (itemRight && itemRight.special > 0 && itemRight.isCanMove &&!itemRight.isHasRopeH())
						{
							return [new Point(item.x, item.y), ConstantItem.DIRECTION_H];
						}
						
						if (itemDown && itemDown.special > 0 && itemDown.isCanMove && !item.isHasRopeV())
						{
							return [new Point(item.x, item.y), ConstantItem.DIRECTOIN_V];
						}
					}
					colIndex++;
				}
				rowIndex++;
			}
			
			return null;
        }

        public function getSpecificHint(patterns:Array) : Match
        {
            var patternId:int = 0;
            var _loc_4:MatchPattern = null;
            var _loc_5:OrthoPatternMatcher = null;
            var _loc_6:int = 0;
            var _loc_7:int = 0;
            var _loc_2:Match = null;
            for each (patternId in patterns)
            {
                
                _loc_4 = this.getMatchPattern(patternId);
                _loc_5 = new OrthoPatternMatcher(this._mInt, [_loc_4], 3);
                _loc_6 = 0;
                while (_loc_6 < this._height)
                {
                    
                    _loc_7 = 0;
                    while (_loc_7 < this._width)
                    {
                        
                        _loc_2 = this.__checkMatchIfSwapped(_loc_5, _loc_7, _loc_6, (_loc_7 + 1), _loc_6);
                        if (_loc_2)
                        {
                            return _loc_2;
                        }
                        _loc_2 = this.__checkMatchIfSwapped(_loc_5, _loc_7, _loc_6, _loc_7, (_loc_6 + 1));
                        if (_loc_2)
                        {
                            return _loc_2;
                        }
                        _loc_7++;
                    }
                    _loc_6++;
                }
            }
            return null;
        }

        private function __checkMatchIfSwapped(param1:OrthoPatternMatcher, col:int, row:int, param4:int, param5:int) : Match
        {
            if (!this.inRange(col, row) || !this.inRange(param4, param5))
            {
                return null;
            }
            var _loc_6:int = this._mInt[row][col];
            var _loc_7:int = this._mInt[param5][param4];
            this._mInt[row][col] = _loc_7;
            this._mInt[param5][param4] = _loc_6;
            var match:Match = param1.matchXY(col, row);
            if (param1.matchXY(col, row))
            {
                match.associatedSwap = new SwapInfo(param4, param5, col, row);
            }
            else
            {
                match = param1.matchXY(param4, param5);
                if (match)
                {
                    match.associatedSwap = new SwapInfo(col, row, param4, param5);
                }
            }
            this._mInt[row][col] = _loc_6;
            this._mInt[param5][param4] = _loc_7;
            return match;
        }
		public function get isPause():Boolean
		{
			return _isPause;
		}

		public function set isPause(value:Boolean):void
		{
			_isPause = value;
		}

		public function get itemFactory():ItemFactory
		{
			return _itemFactory;
		}

		public function set itemFactory(value:ItemFactory):void
		{
			_itemFactory = value;
		}

		public function get dataRecord():DataRecorder
		{
			return _dataRecord;
		}

		public function get useItemStatus():int
		{
			return _useItemStatus;
		}

		public function get isStartBingo():Boolean
		{
			return _isStartBingo;
		}

		public function get isStopLogic():Boolean
		{
			return _isStopLogic;
		}

		public function set isStopLogic(value:Boolean):void
		{
			_isStopLogic = value;
		}

		public function get isWaitFinishLevel():Boolean
		{
			return _isWaitFinishLevel;
		}

		public function get stepItemsManager():StepItemManager
		{
			return _stepItemsManager;
		}

		public function get isPlayToolAnimation():Boolean
		{
			return _isPlayToolAnimation;
		}

		public function set isPlayToolAnimation(value:Boolean):void
		{
			_isPlayToolAnimation = value;
		}




    }
}



