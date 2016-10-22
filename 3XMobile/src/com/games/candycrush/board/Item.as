package com.games.candycrush.board
{
    import com.games.candycrush.ItemType;
    import com.games.candycrush.input.SwapInfo;
    
    import framework.model.ConstantItem;
    import framework.model.RandomItem;
    import framework.model.objects.BasicObject;
    import framework.model.objects.GridObject;
    import framework.ui.MediatorPanelMainUI;

    public class Item
    {
        private var _shieldTicks:int = -1;
        protected var _isTemp:Boolean = false;
        private var _removalTicks:int = -1;
       
        public var _canChangeRemovalTicks:Boolean = true;
        private var _hasGivenScore:Boolean = false;
        private var _busy:Boolean = false;
        private var _destructionPlan:IDestructionPlan = null;
        public var destructionColor:int = 0;
        public var _destroyTicks:int = 0;
        
        public var bounce:Number = 0;
        private var _moveTicks:int = 0;
        public var _lastTick:int = 0;
        protected var _board:Board;
        private var _listener:MediatorPanelMainUI;
        private var _killer:Item = null;

		private var _toBeRemoved:Boolean = false;
        public var _swap:SwapInfo;
        private var _id:int;
        public var color:int;
        public var _specialType:int = 0;
		private var _objectType:int;
		public var _gridObj:GridObject;
		private var _isRecordScore:Boolean;
		private var _destroyed:Boolean = false;
//		public static const MAX_COLOR_NUM:int = 6;
		
		public var randomRandom:RandomItem;
		public static const INVALID_COLOR:int = -1;
		public static const INVALID_COLOR2:int = 6;
		
		private static var _runningId:int = -1;
//        public var view:ItemView = null;
//        public var parentDecl:ItemDecl = null;
		
		private var _normalId:int;
		private var _isCrossDeleted:Boolean;
		private var _isCrossDeletedBySpecialEffect:Boolean;
		
		private var _isCanMove:Boolean;
		
		private var _isDeletedByColorAbsorb:Boolean;
		
		private var _deleteBySpecialEffectStatus:int;
		private var _isDeleteByMatch:Boolean;
		
		private var _x:int;
		private var _y:int;
		private var _srcX:int;
		private var _srcY:int;
		
		private var _dropX:int;
		private var _dropY:int;
		
		private var _isFly:Boolean;

        public function Item(lastX_:Number, lastY_:Number, color:int = -1)
        {
            this.x = lastX_;
            this.y = lastY_ /*+ 0.5*/;
            this.srcX = lastX_;
            this.srcY = lastY_;
            this.color = color;
			id = getNextItemId();
			
			_isCanMove = true;
			reset();
        }
		
		private function reset():void
		{
			_isDeletedByColorAbsorb = false;
			_deleteBySpecialEffectStatus = -1;
			_isRecordScore = false;
			_isFly = false;
			
		}

		public function get isCrossDeletedBySpecialEffect():Boolean
		{
			return _isCrossDeletedBySpecialEffect;
		}

		public function get isDeleteBySpecialEffectStatus():int
		{
			return _deleteBySpecialEffectStatus;
		}

		public function set isDeleteBySpecialEffectStatus(value:int):void
		{

			_deleteBySpecialEffectStatus = value;
		}

		public function getNextItemId() : int
		{
			
			_runningId = _runningId + 1;
			return /*++this.*/_runningId;
		}
		
		private var _normalBasic:BasicObject;
		public function setGridObject(gridObj:GridObject, mainUI:MediatorPanelMainUI, isInitByBasic:Boolean = true):void
		{
			_gridObj = gridObj;
			
			reset();
			
			if(isInitByBasic)
			{
				if(isHasBug())
				{
					setTopBasicObject();
				}
				else
				{
					_normalBasic = getNormalBasicObject();
					
					if(_normalBasic != null)
					{
						_specialType = getSpecialTypeById(_normalBasic.id);
						
						if(_normalBasic.isVariableObject())
						{
							color = _normalBasic.picType - 1;
						}
						else if(_normalBasic.isGiftItem())
						{
							color = _normalBasic.picType - 7;
							_specialType = ItemType.INVALID;
						}
						else if(_normalBasic.isJellyItem())
						{
							color = _normalBasic.picType - 13;
							_specialType = ItemType.INVALID;
						}
						else if(_normalBasic.isClockItem())
						{
							color = _normalBasic.picType - 19;
							_specialType = ItemType.INVALID;
						}
						else
						{					
							color = _normalBasic.picType;
						}
						
						
						
						
						setProperty();
						
						//contains bug and rope vine
						if(isHasVine())
						{
							_isCanMove = false;	
						}
						else
						{							
							_isCanMove = true;
						}
					}
					else
					{
						setTopBasicObject();
					}
				}				
			}
			
			init(mainUI);
		}
		
		private function setTopBasicObject():void
		{
			color = INVALID_COLOR;
			
			_normalBasic = getTopBasicObjectNotContainObstacle();
			
			if(_normalBasic == null)
			{
				if(_gridObj.basicObjects.length > 0)
				{					
					_normalBasic = _gridObj.basicObjects[_gridObj.basicObjects.length - 1];
				}
			}
			
			CONFIG::debug
			{
				ASSERT(_normalBasic != null, "normalbasic can not is null in item!");
			}
			
			_specialType = ItemType.INVALID;
			_isCanMove = _normalBasic.isMove;
			
			setProperty();
		}
		
		public function isSpecialItem():Boolean
		{
			return _specialType > ItemType.NONE;
		}
		
		private function setProperty():void
		{
			_objectType = _normalBasic.objectType;
			_normalId = _normalBasic.id;
			_isCrossDeleted = _normalBasic.isCrossDeleted;
			_isCrossDeletedBySpecialEffect = _normalBasic.isCrossDeletedBySpecialBomb;
		}
		
		public function isJellyItem():Boolean
		{
			return _normalBasic != null && _normalBasic.isJellyItem();
		}
		
		public function isFindBug():Boolean
		{
			return _normalBasic != null && _normalBasic.blockType == BasicObject.BLOCK_BUG;
		}
		
		public function isColorItem():Boolean
		{
			return color != INVALID_COLOR;
		}
		
		public function isHasLevel():Boolean
		{
			return _normalBasic.isHasLevel();
		}
		
		public function isVariableItem():Boolean
		{
			return _normalBasic != null && _normalBasic.isVariableObject();
		}
		
		public function isHasVine():Boolean
		{
			var topBasic:BasicObject = getTopBasicObjectNotContainObstacle();
			if(topBasic != null && topBasic.blockType == BasicObject.BLOCK_VINE)
			{
				return true;
			}
			return false;
		}
		
		public function isHasBug():Boolean
		{
			for each(var basic:BasicObject in _gridObj.basicObjects)
			{
				if(basic.blockType == BasicObject.BLOCK_BUG)
				{
					return true;
				}
			}
			return false;
		}
		
		public function findRopeType():Vector.<int>
		{
			var type:Vector.<int> = null;
			for each(var basic:BasicObject in _gridObj.basicObjects)
			{
				if(basic.blockType == BasicObject.BLOCK_ROPE)
				{
					if(type == null)
					{
						type = new Vector.<int>();
					}
					if(basic.id == ConstantItem.GRID_ID_ROPE_H)
					{
						type.push(BasicObject.DIRECTION_TYPE_H);
					}
					else
					{
						type.push(BasicObject.DIRECTION_TYPE_V);	
					}
				}
			}
			
			return type;
		}
		
		public function isBlockOrHideGrid():Boolean
		{
			return (_normalBasic != null && _normalBasic.isBlockAndHide()) ;
		}
		
		public function isHide():Boolean
		{
			return _normalBasic != null && _normalBasic.isHide();
		}
		
		public function isStopLineDrop():Boolean
		{
			return isHasVine() || isHasRopeV();
		}
		
		public function isTransportDrop():Boolean
		{
			var currentTopGrid:GridObject = _listener.currentLevelData.getGrid(x, y);
			var transpointEnd:BasicObject = currentTopGrid.getTransportStart();
			if(transpointEnd != null)
			{
				return true;
			}
			return false;
		}
		
		public function isIceBlank():Boolean
		{
			return (_normalBasic != null && _normalBasic.blockType == BasicObject.BLOCK_TYPE_ICE) ;
		}
		
		public function isObstacleBlank():Boolean
		{
			return _normalBasic != null && (_normalBasic.blockType == BasicObject.BLOCK_ROPE || _normalBasic.blockType == BasicObject.BLOCK_TRANSFER_POINT);
		}
		
		public function isBlankGrid():Boolean
		{
			return isIceBlank() || isObstacleBlank();
		}
		
		public function isCanNearFill():Boolean
		{
			return !isBlockOrHideGrid() && !isBlankGrid()&& !isHasVine();
		}
		
		public function isCanFalling():Boolean
		{
			return !isBlockOrHideGrid() && !isBlankGrid()&& !isStopLineDrop();
		}
		
		public function isCrossDeleted():Boolean
		{
			return _isCrossDeleted;
		}
		
		private function getSpecialTypeById(id:int):int
		{
			if(id >= ConstantItem.SPECIAL_ITEM_START_INDEX && id <= ConstantItem.SPECIAL_ITEM_END_INDEX )
			{
				if(id == ConstantItem.GRID_ID_COLOR)
				{
					return ItemType.COLOR;
				}
				var type:int = (id - ConstantItem.MAX_CARD_NUM) % 3;
				switch(type)
				{
					case 0:
					{
						
						return ItemType.COLUMN;
					}
					case 1:
					{
						return ItemType.LINE;
					}
					case 2:
					{
						return ItemType.DIAMOND;
					}
					default:
					{
						break;
					}
				}
			}
			
			return ItemType.NONE;
		}
		
		public function getNormalBasicObject():BasicObject
		{
			return _gridObj.getNormalBasicObject();
		}
		
		public function isHasRopeV():Boolean
		{
			return _gridObj.isHasRopeV();
			/*var length:int = _gridObj.basicObjects.length;
			var basic:BasicObject = length > 0 ? _gridObj.basicObjects[length - 1] : null;
			
			if(basic != null && basic.id == ConstantItem.GRID_ID_ROPE_V)
			{
				return true;
			}
			
			return false;*/
		}
		
		public function isHasRopeH():Boolean
		{
			return _gridObj.isHasRopeH();
		}
		
		
		
		public function getTopBasicObjectNotContainObstacle():BasicObject
		{		
			if(_gridObj == null)
			{
				return null;
			}
			return _gridObj.getTopBasicObjectNotContainObstacle();
		}
		
        public function init(param1:MediatorPanelMainUI) : void
        {
            this._listener = param1;
            return;
        }// end function

        public function setBoard(board:Board) : void
        {
            this._board = board;
            return;
        }// end function

        public function setShieldTicks(param1:int) : void
        {
            this._shieldTicks = param1;
            return;
        }// end function

        public function hasShield() : Boolean
        {
            return this._shieldTicks > 0;
        }// end function

        public function isTemp() : Boolean
        {
            return this._isTemp;
        }// end function

        public function setRemovalTicks(removedTick:int) : void
        {
            if (!this._canChangeRemovalTicks)
            {
                return;
            }
            this._removalTicks = removedTick;
            this._toBeRemoved = true;
            return;
        }// end function

        public function hasItemGivenScore() : Boolean
        {
            return this._hasGivenScore;
        }// end function

        public function markScoreGiven() : void
        {
            this._hasGivenScore = true;
            return;
        }// end function

        public function isBusy() : Boolean
        {
            return this._busy || this._removalTicks > 0;
        }// end function

        public function canBeMatched() : Boolean
        {
            return this.isBusy() == false && !this._toBeRemoved && !this._destroyed;
        }// end function

        public function isLocked() : Boolean
        {
            return !this.canBeMatched();
        }// end function

        public function isToBeRemoved() : Boolean
        {
            return this._toBeRemoved;
        }// end function

        public function hasDestructionItem() : Boolean
        {
            return this._destructionPlan && this._destructionPlan.getDestructionItem() != null;
        }// end function

        public function setDestructionPlan(desPlan:IDestructionPlan) : void
        {
            this._destructionPlan = desPlan;
            return;
        }// end function

        public function getDestructionPlan() : IDestructionPlan
        {
            return this._destructionPlan;
        }// end function

        public function wannaDie() : Boolean
        {
            return this._removalTicks == 0;
        }// end function

        public function destroy() : Boolean
        {
            if (this.hasShield())
            {
                return false;
            }
            this._destroyed = true;
            return true;
        }// end function

        public function isDestroyed() : Boolean
        {
            return this._destroyed;
        }// end function
		
		public function isCreateDeleteCross(influenceItem:Item):Boolean
		{
			if(canRemove() && ! _isDeletedByColorAbsorb)
			{
				if(_isFly)
				{
					return false;
				}
				if(isHasVine())
				{
					return false;
				}
				if(isDeleteByMatch)
				{
					return true;
				}
				else if(isColorItem())
				{
					if(!influenceItem.isCrossDeletedBySpecialEffect)
					{
						if(isDeleteBySpecialEffectStatus > 0)
						{
							return false;
						}
					}

					return true;

				}
				
				return false;
			}
			
			return false;
		}

        public function canRemove() : Boolean
        {
            return _destroyed;
        }

        public function savePos() : void
        {
			this.srcX = this.x;
            this.srcY = this.y;
            return;
        }// end function

        public function moveComplete() : void
        {
            return;
        }// end function


        public function beginMovement(dstX:Number, dstY:Number, moveComplete:Function) : void
        {

            this._busy = true;
            if (this._listener != null)
            {
                this._listener.beginMove(this, dstX, dstY, moveComplete);
            }
        }

        public function tick(tickNumber:int) : void
        {
        /*    this._lastTick = tickNumber;
            if (this._moveTicks > 0)
            {
                
                _moveTicks = _moveTicks - 1;
                if (_moveTicks == 0)
                {
                    this._busy = false;
                }
            }*/
            if (this._removalTicks > 0)
            {               
                _removalTicks = _removalTicks - 1;
            }
          /*  if (this._destroyed && this._destroyTicks > 0)
            {
                   
                _destroyTicks = this._destroyTicks - 1;
            }*/
      
           
            _shieldTicks = this._shieldTicks - 1;
           
        }// end function

        public function isKillerOrParentKiller(param1:Item) : Boolean
        {
            return this._killer == param1;
        }// end function

        public function killByItem(item:Item) : void
        {
            var iDesPlan:IDestructionPlan = null;
            var currentItem:Item = this;
            while (currentItem != null)
            {
                
                currentItem._killer = item;
                iDesPlan = currentItem.getDestructionPlan();
                currentItem = iDesPlan ? (iDesPlan.getDestructionItem()) : (null);
            }
            return;
        }// end function

        public function get row() : int
        {
            return int(this.y);
        }// end function

        public function get column() : int
        {
            return int(this.x);
        }// end function

        public function set special(param1:int) : void
        {
            this._specialType = param1;           
        }

        public function get special() : int
        {
            return this._specialType;
        }

        public function setParentDecl(param1:Item) : void
        {
//            this.parentDecl = ItemDecl.fromItem(param1);
           
        }
		public function get busy():Boolean
		{
			return _busy;
		}

		public function set busy(value:Boolean):void
		{
			_busy = value;
		}

		public function get normalId():int
		{
			return _normalId;
		}

		public function set normalId(value:int):void
		{
			_normalId = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		public function get y():int
		{
			return _y;
		}

		public function set y(value:int):void
		{
			_y = value;
			
			if(randomRandom != null)
			{
				randomRandom.y = value;
			}
		}

		public function get x():int
		{
			return _x;
		}

		public function set x(value:int):void
		{
			_x = value;
			
			if(randomRandom != null)
			{
				randomRandom.x = value;
			}
		}

		public function get objectType():int
		{
			return _objectType;
		}

		public function set objectType(value:int):void
		{
			_objectType = value;
		}
		
		public function getIdBySpecialType():int
		{
			if(_specialType == ItemType.NONE)
			{
				return color;
			}
			else if(_specialType == ItemType.COLUMN)
			{
				return ConstantItem.MAX_CARD_NUM + color * 3; 
			}
			else if(_specialType == ItemType.LINE)
			{
				return ConstantItem.MAX_CARD_NUM + color * 3 + 1;
			}
			else if(_specialType == ItemType.DIAMOND)
			{
				return ConstantItem.MAX_CARD_NUM + color * 3 + 2;
			}
			else if(_specialType == ItemType.COLOR)
			{
				return ConstantItem.GRID_ID_COLOR;
			}
			
			return -1;
		}

		public function get srcX():int
		{
			return _srcX;
		}

		public function set srcX(value:int):void
		{
			_srcX = value;
			
			_dropX = _dropY = -1;
		}

		public function get srcY():int
		{
			return _srcY;
		}

		public function set srcY(value:int):void
		{
			_srcY = value;
		}

		public function get isRecordScore():Boolean
		{
			return _isRecordScore;
		}

		public function set isRecordScore(value:Boolean):void
		{
			_isRecordScore = value;
		}

		public function get isCanMove():Boolean
		{
			return _isCanMove;
		}
		
		public function getMoveBasicObject():BasicObject
		{
			var basicObj:BasicObject = getNormalBasicObject();
			if(basicObj == null)
			{
				basicObj = getTopBasicObjectNotContainObstacle();
				if(basicObj.isMove)
				{
					return basicObj;
				}
				else if(basicObj.blockType == BasicObject.BLOCK_VINE || basicObj.blockType == BasicObject.BLOCK_BUG)
				{
					return getAcanMoveBasic();
					
				}
				
			}
			
			return basicObj;
		}
		
		public function getAcanMoveBasic():BasicObject
		{
			for each(var basic:BasicObject in _gridObj.basicObjects)
			{
				if(basic.isMove)
				{
					return basic;
				}
			}
			
			return null;
		}

		public function get normalBasic():BasicObject
		{
			return _normalBasic;
		}
		
		public function isMoveCollect():Boolean
		{
			return _normalBasic != null && _normalBasic.isMoveCollect();
		}
		
		public function isCanNotForceSwap():Boolean
		{
			return _specialType == ItemType.INVALID || isMoveCollect();
		}
		
		public function isRemovable():Boolean
		{
			return normalBasic.isCanBeRemoved;
		}
		
		public function isCanAddScore():Boolean
		{
			return !isRecordScore && !isBlockOrHideGrid();
		}

		public function get isDeletedByColorAbsorb():Boolean
		{
			return _isDeletedByColorAbsorb;
		}

		public function set isDeletedByColorAbsorb(value:Boolean):void
		{
			_isDeletedByColorAbsorb = value;
		}

		public function get isDeleteByMatch():Boolean
		{
			return _isDeleteByMatch;
		}

		public function set isDeleteByMatch(value:Boolean):void
		{
			_isDeleteByMatch = value;
		}

		public function get dropX():int
		{
			return _dropX;
		}

		public function set dropX(value:int):void
		{
			_dropX = value;
		}

		public function get dropY():int
		{
			return _dropY;
		}

		public function set dropY(value:int):void
		{
			_dropY = value;
		}

		public function get isFly():Boolean
		{
			return _isFly;
		}

		public function set isFly(value:Boolean):void
		{
			_isFly = value;
		}


// end function

    }
}
