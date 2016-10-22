package com.games.candycrush.board
{
    import com.games.candycrush.ItemType;
    import com.games.candycrush.board.match.Match;
    import com.games.candycrush.input.SwapInfo;
    import com.math.IntCoord;
    import com.math.Random;
    import com.math.ServerRandom;
    
    import framework.fibre.core.Fibre;
    import framework.model.ConstantItem;
    import framework.sound.MediatorAudio;
    import framework.ui.MediatorPanelMainUI;

    public class ItemFactory
    {
        private var _board:Board;
        private var _runningId:int = 0;
        private var _rnd:ServerRandom;
        private var _shuffler:Random;
 
        public static var DPLAN_ID:int = 0;

        public function ItemFactory(seed:int = 0)
        {
            this._rnd = new ServerRandom();
			_rnd.setSeed(seed);
//            this._shuffler = new Random(this._rnd);
            return;
        }// end function

        public function init(board:Board) : void
        {
            this._board = board;
            return;
        }// end function

       // end function
		
		public function getRandomColor(x:int, y:int, item:Item = null, isUseServerRandom:Boolean = false):int
		{
			CONFIG::debug
			{
				TRACE_JLM("seed: "+ _rnd.getSeed());
			}
			var color:int = 0;
			color = /*1 + */this._rnd.nextInt(ConstantItem.MAX_CARD_NUM, x, y, _board, item, isUseServerRandom);
			
			return color;
		}
		
		
		

        public function createRandomItem(x:int, y:int, isUseServerRandom:Boolean) : Item
        {
			
            var color:int = 0;
            
            var item:Item = new Item(x, y, color);
			color = getRandomColor(x, y, item, isUseServerRandom);
			
			item.color = color;
//            item.id = this.getNextItemId();
			CONFIG::debug
			{
				TRACE_JLM("create New Item random color: "+ color + " x: "+x + " y: "+y);
			}
            return item;
        }// end function

        public function createSpecialBombBySpecialType(gridX:int, gridY:int, color:int, specialType:int) : Item
        {
			CONFIG::debug
			{
				TRACE_JLM("create New Item special color: "+ color + " x: "+ gridX + " y: " + gridY + "specialType: "+ specialType);
			}
            if (ItemType.isDiamond(specialType))
            {
                return this.createDiamondBomb(gridX, gridY, color);
            }
			else if (ItemType.isLineBomb(specialType))
            {
                return this.createLineBomb(gridX, gridY, color);
            }
			else if (ItemType.isColumnBomb(specialType))
            {
                return this.createColumnBomb(gridX, gridY, color);
            }
			else if (ItemType.isColorBomb(specialType))
            {
                return this.createColorBomb(gridX, gridY, color);
            }
            return null;
        }// end function

        public function createSpecialBombByMatch(match:Match, gridX:int, gridY:int) : Item
        {
            var item:Item = null;
            if (match.patternId == Board.MATCH_ID_5)
            {
                item = this.createColorBomb(gridX, gridY, match.color);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_SPECIAL_EFFECTS3, null);
            }
            else if (match.patternId == Board.MATCH_ID_TorL)
            {
                item = this.createDiamondBomb(gridX, gridY, match.color);
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_SPECIAL_EFFECTS2, null);
            }
			else if (match.patternId == Board.MATCH_ID_4)
			{
//				item = new Item(match.x, match.y, match.color);
				//                item.id = this.getNextItemId();
				Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_SPECIAL_EFFECTS1, null);
				if (match.height > 3)
				{
					item = this.createLineBomb(gridX, gridY, match.color);
				}
				else
				{
					item = this.createColumnBomb(gridX, gridY, match.color);
				}
			}
            return item;
        }

        public function createDiamondBomb(x:Number, y:Number, color:int) : Item
        {
            var item:Item = new Item(x, y, color);
            item.special = ItemType.DIAMOND;
            return item;
        }// end function

        public function createLineBomb(x:int, y:int, color:int) : Item
        {
            var item:Item = new Item(x, y, color);
//            item.id = this.getNextItemId();
            item.special = ItemType.LINE;
//            this.addDestructionPlan(item);
            return item;
        }// end function

        public function createColumnBomb(girdX:int, girdY:int, color:int) : Item
        {
            var item:Item = new Item(girdX, girdY, color);
//            item.id = this.getNextItemId();
            item.special = ItemType.COLUMN;
//            this.addDestructionPlan(item);
            return item;
        }// end function

        public function createColorBomb(gridX:int, gridY:int, color:int) : Item
        {
            var item:Item = new Item(gridX, gridY, color);
//			item.id = this.getNextItemId();
            item.special = ItemType.COLOR;
//            this.addDestructionPlan(item);
            return item;
        }// end function

        public function getPowerupCoord(board:Board, powers:Array, swapInfo:SwapInfo) : IntCoord
        {
            var srcPos:IntCoord = null;
            var dstPos:IntCoord = null;
            var item:Item = null;
            var powerUpCoord:IntCoord = null;
            if (swapInfo != null)
            {
                srcPos = new IntCoord(swapInfo.srcX, swapInfo.srcY);
                dstPos = new IntCoord(swapInfo.dstX, swapInfo.dstY);
                for each (powerUpCoord in powers)
                {
                    
                    item = board.getGridItem(powerUpCoord.x, powerUpCoord.y);
                    ASSERT(item != null, "Item in the match can\'t be null! (@getPowerupCoord)");
                    if (item && (item.hasDestructionItem() || item.special != 0))
                    {
                        continue;
                    }
                    if (powerUpCoord.x == dstPos.x && powerUpCoord.y == dstPos.y || powerUpCoord.x == srcPos.x && powerUpCoord.y == srcPos.y)
                    {
                        return powerUpCoord;
                    }
                }
            }
            var array:Array = powers.concat();
            this._shuffler.shuffle(array);
            var index:int = 0;
            while (index < array.length)
            {
                
                powerUpCoord = array[index];
                item = board.getGridItem(powerUpCoord.x, powerUpCoord.y);
                if (item && (!item.hasDestructionItem() && item.special == 0))
                {
                    return powerUpCoord;
                }
                index++;
            }
            return null;
        }// end function

        public function addDestructionPlan(item:Item) : void
        {
          
        }// end function

        public function categorizeAndHandleSwap(swapInfo:SwapInfo, boardListener:MediatorPanelMainUI) : Boolean
        {
			var isCategorizeSuccess:Boolean = false;
			
            /*var items:Vector.<Item> = null;
            var _loc_5:DPlan_ColorColor = null;
            var tempColorItem:Item = null;
            var _loc_7:Boolean = false;
            var _loc_8:Item = null;
            var _loc_9:Item = null;
            var _loc_10:int = 0;
            var _loc_11:Item = null;
            var _loc_12:Item = null;
            var _loc_13:Boolean = false;
            var _loc_14:int = 0;
            var indexHeight:int = 0;
            var indexWidth:int = 0;
            var _loc_17:Item = null;
            var _loc_18:Item = null;
            var _loc_19:int = 0;
            var _loc_20:int = 0;
            var _loc_21:int = 0;
            var _loc_22:int = 0;
            var _loc_23:int = 0;
            var _loc_24:int = 0;
            var _loc_25:Item = null;
            var _loc_26:Item = null;
            
            if (isSwapOfTypes(swapInfo, ItemType.COLOR, ItemType.COLOR))
            {
                _loc_5 = new DPlan_ColorColor(this._board, swapInfo);
                swapInfo.item_a.setDestructionPlan(_loc_5);
                swapInfo.item_b.setDestructionPlan(null);
                this._board.addForRemoval(swapInfo.srcX, swapInfo.srcY, 86);
                this._board.addForRemoval(swapInfo.dstX, swapInfo.dstY, 0);
                if (boardListener)
                {
                    boardListener.specialMixed(ItemType.MIX_COLOR_COLOR, swapInfo, _loc_5.getItems());
                }
                isCategorizeSuccess = true;
            }
            else if (isSwapOfTypes(swapInfo, ItemType.DIAMOND, ItemType.COLOR))
            {
                if (swapInfo.item_a.special & ItemType.DIAMOND)
                {
                    swapInfo.item_b.destructionColor = swapInfo.item_a.color;
                    this._board.addForRemoval(swapInfo.srcX, swapInfo.srcY);
                    tempColorItem = new Temp_Color(swapInfo.dstX, swapInfo.dstY, 0);
                    swapInfo.item_a.color = 0;
                    this._board.setPowerupAt(swapInfo.dstX, swapInfo.dstY, tempColorItem.special, 0, tempColorItem, true);
                }
                else
                {
                    swapInfo.item_a.destructionColor = swapInfo.item_b.color;
                    this._board.addForRemoval(swapInfo.dstX, swapInfo.dstY);
                    tempColorItem = new Temp_Color(swapInfo.srcX, swapInfo.srcY, 0);
                    swapInfo.item_b.color = 0;
                    this._board.setPowerupAt(swapInfo.srcX, swapInfo.srcY, tempColorItem.special, 0, tempColorItem, true);
                }
                if (boardListener)
                {
                    boardListener.specialMixed(ItemType.MIX_COLOR_WRAP, swapInfo);
                }
                isCategorizeSuccess = true;
            }
            else if (isSwapOfTypes(swapInfo, ItemType.LINE, ItemType.COLOR) || isSwapOfTypes(swapInfo, ItemType.COLUMN, ItemType.COLOR))
            {
                _loc_7 = isSwapOfTypes(swapInfo, ItemType.LINE, ItemType.COLOR);
                _loc_8 = ItemType.isColorBomb(swapInfo.item_a.special) ? (swapInfo.item_a) : (swapInfo.item_b);
                _loc_9 = _loc_8 == swapInfo.item_a ? (swapInfo.item_b) : (swapInfo.item_a);
                _loc_10 = _loc_9.color;
                _loc_11 = new Temp_Blank(_loc_8.x, _loc_8.y, 20 + 28);
                _loc_8.setDestructionPlan(new DPlan_Simple(_loc_11));
                _loc_8._destroyTicks = 5;
                _loc_8.destroy();
                _loc_12 = new Temp_Blank(_loc_9.x, _loc_9.y, 20 + 28);
                _loc_9.setDestructionPlan(new DPlan_Simple(_loc_12));
                _loc_9._destroyTicks = 5;
                _loc_9.destroy();
                items = new Vector.<Item>;
                _loc_13 = true;
                _loc_14 = 15 + 12;
                indexHeight = 0;
                while (indexHeight < this._board.height())
                {
                    
                    indexWidth = 0;
                    while (indexWidth < this._board.width())
                    {
                        
                        _loc_17 = this._board.getGridItem(indexWidth, indexHeight);
                        if (!_loc_17 || _loc_17.color != _loc_10 || _loc_17 == _loc_9)
                        {
                        }
                        else
                        {
                            if (ItemType.isLineBomb(_loc_17.special) || ItemType.isColumnBomb(_loc_17.special))
                            {
                                _loc_17.setRemovalTicks(_loc_14);
                            }
                            else
                            {
                                if (_loc_13)
                                {
                                    _loc_18 = new Temp_Line(indexWidth, indexHeight, _loc_10, _loc_14);
                                }
                                else
                                {
                                    _loc_18 = new Temp_Column(indexWidth, indexHeight, _loc_10, _loc_14);
                                }
                                this._board.setPowerupAt(indexWidth, indexHeight, 0, _loc_10, _loc_18, true);
                                items.push(_loc_18);
                                _loc_13 = !_loc_13;
                            }
                            _loc_14 = _loc_14 + 8;
                        }
                        indexWidth++;
                    }
                    indexHeight++;
                }
                if (boardListener)
                {
                    boardListener.specialMixed(ItemType.MIX_COLOR_LINE, swapInfo, items);
                }
                isCategorizeSuccess = true;
            }
            else if (isSwapOfTypes(swapInfo, ItemType.LINE, ItemType.DIAMOND) || isSwapOfTypes(swapInfo, ItemType.COLUMN, ItemType.DIAMOND))
            {
                _loc_19 = swapInfo.dstY;
                _loc_20 = this._board.getRow((_loc_19 - 1));
                _loc_21 = this._board.getRow((_loc_19 + 1));
                _loc_22 = swapInfo.dstX;
                _loc_23 = this._board.getColumn((_loc_22 - 1));
                _loc_24 = this._board.getColumn((_loc_22 + 1));
                items = new Vector.<Item>;
                indexHeight = _loc_20;
                while (indexHeight <= _loc_21)
                {
                    
                    indexWidth = _loc_23;
                    while (indexWidth <= _loc_24)
                    {
                        
                        _loc_25 = this._board.getUnifiedGridItem(indexWidth, indexHeight);
                        if (_loc_25)
                        {
                            _loc_26 = new Temp_Blank(indexWidth, indexHeight, 40);
                            if (indexWidth == _loc_22 && indexHeight == _loc_19)
                            {
                                _loc_25.setDestructionPlan(new DPlan_3x3(this._board, _loc_25, _loc_26));
                                _loc_25.special = 0;
                            }
                            else if (ItemType.isColorBomb(_loc_25.special))
                            {
                                _loc_25.setDestructionPlan(new DPlan_Color(this._board, _loc_25));
                            }
                            else
                            {
                                _loc_25.setDestructionPlan(new DPlan_Simple(_loc_26));
                                _loc_25.special = 0;
                            }
                            _loc_25._destroyTicks = 0;
                            this._board.addForRemoval(indexWidth, indexHeight, 20);
                            items.push(_loc_25);
                        }
                        indexWidth++;
                    }
                    indexHeight++;
                }
                if (boardListener)
                {
                    boardListener.specialMixed(ItemType.MIX_LINE_WRAP, swapInfo, items);
                }
                isCategorizeSuccess = true;
            }
            else if (isSwapOfTypes(swapInfo, ItemType.LINE, ItemType.COLUMN))
            {
                this._board.addForRemoval(swapInfo.srcX, swapInfo.srcY);
                this._board.addForRemoval(swapInfo.dstX, swapInfo.dstY);
                isCategorizeSuccess = true;
            }
            else if (isSwapOfTypes(swapInfo, ItemType.LINE, ItemType.LINE) || isSwapOfTypes(swapInfo, ItemType.COLUMN, ItemType.COLUMN))
            {
                if (ItemType.isLineBomb(swapInfo.item_a.special))
                {
                    this._board.transform(swapInfo.dstX, swapInfo.dstY, ItemType.COLUMN);
                }
                else
                {
                    this._board.transform(swapInfo.dstX, swapInfo.dstY, ItemType.LINE);
                }
                this._board.addForRemoval(swapInfo.srcX, swapInfo.srcY);
                this._board.addForRemoval(swapInfo.dstX, swapInfo.dstY);
                isCategorizeSuccess = true;
            }
            else if (isSwapOfTypes(swapInfo, ItemType.DIAMOND, ItemType.DIAMOND))
            {
                this._board.addForRemoval(swapInfo.srcX, swapInfo.srcY);
                this._board.addForRemoval(swapInfo.dstX, swapInfo.dstY);
                isCategorizeSuccess = true;
            }
            else if (swapInfo.item_a.special & ItemType.COLOR)
            {
                swapInfo.item_a.destructionColor = swapInfo.item_b.color;
                this._board.addForRemoval(swapInfo.dstX, swapInfo.dstY);
                isCategorizeSuccess = true;
            }
            else if (swapInfo.item_b.special & ItemType.COLOR)
            {
                swapInfo.item_b.destructionColor = swapInfo.item_a.color;
                this._board.addForRemoval(swapInfo.srcX, swapInfo.srcY);
                isCategorizeSuccess = true;
            }*/
            return isCategorizeSuccess;
        }// end function

        public static function isSwapOfTypes(swapInfo:SwapInfo, typeA:int, typeB:int, isContain:Boolean = true) : Boolean
        {
			if(swapInfo.item_a.special == ItemType.INVALID || swapInfo.item_b.special == ItemType.INVALID)
			{
				//jelly clock gift
				if(swapInfo.item_a.isColorItem() && swapInfo.item_b.isColorItem())
				{					
					return swapInfo.item_a.special == typeA && swapInfo.item_b.special == typeB || swapInfo.item_a.special == typeB && swapInfo.item_b.special == typeA;
				}
				else
				{					
					return false;
				}
			}
            if (isContain)
            {
				if(typeA != 0 && typeB != 0)
				{
					
	                return (((swapInfo.item_a.special & typeA) != 0 && ((swapInfo.item_b.special & typeB) != 0))|| ((swapInfo.item_a.special & typeB) != 0 && (swapInfo.item_b.special & typeA) != 0));
				}
				else
				{
					return ((swapInfo.item_a.special == typeA) && (swapInfo.item_b.special == typeB)) || ((swapInfo.item_b.special == typeA) && (swapInfo.item_a.special == typeB));
				}
            }
            return swapInfo.item_a.special == typeA && swapInfo.item_b.special == typeB || swapInfo.item_a.special == typeB && swapInfo.item_b.special == typeA;
        }
		public function get rnd():ServerRandom
		{
			return _rnd;
		}

		public function set rnd(value:ServerRandom):void
		{
			_rnd = value;
		}

    }
}
