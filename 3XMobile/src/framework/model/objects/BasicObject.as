package framework.model.objects
{
	import framework.model.ConstantItem;
	import framework.model.DataManager;
	import framework.resource.faxb.elements.Element;
	
	public class BasicObject
	{
		public static const TYPE_CLEAR_ONE_GRID:int = -1;
		public static const TYPE_ADD_EMPTY:int = -2;
		
		public static const TYPE_NORMAL:int = 0;
		public static const TYPE_BLOCK_OVERLAP:int = 1;
		public static const TYPE_BLOCK_MOVE:int = 2;
		public static const TYPE_BLOCK_OVERLAP_NO:int = 3;
		public static const TYPE_COLLECTION:int = 4;
		
		public static const LAYER_NORMAL:int = 4;
		
		public static const BLOCK_TYPE_NORMAL:int = 0;
		public static const BLOCK_TYPE_ICE:int = 1;
		public static const BLOCK_TYPE_VARIABLE_ITEM:int = 2;
		public static const BLOCK_WALL:int = 3;
		public static const BLOCK_SMALL_HILL:int = 4;
		public static const BLOCK_SLIVER_COIN:int = 5;
		public static const BLOCK_VINE:int = 6;
		public static const BLOCK_BUG:int = 7;
		
		public static const BLOCK_ROPE:int = 8;
		public static const BLOCK_TRANSFER_POINT:int = 9;
		public static const BLOCK_DIAMOND:int = 10;
		
		public static const BLOCK_GIFT_ITEM:int = 11;
		public static const BLOCK_JELLY_ITEM:int = 12;
		public static const BLOCK_CLOCK_ITEM:int = 13;		
		
		public static const DIRECTION_TYPE_H:int = 0;
		public static const DIRECTION_TYPE_V:int = 1;
		
		private static const INVALID_NUMBER:int = -1;
		
		private var _objectType:int;
		private var _picType:int;
		private var _id:int;
		private var _layer:int;
		private var _level:int;
		private var _direction:int;
		private var _isMove:Boolean;
		private var _isCrossDeleted:Boolean;
		private var _isCrossDeletedBySpecialBomb:Boolean;
		private var _isCanBeRemoved:Boolean;
		
		private var _dstX:int;
		private var _dstY:int;
		
		private var _blockType:int = 0;
		
		
		public function BasicObject(/*oType:int, picType:int, */id:int)
		{
//			_objectType = oType;
//			_picType = picType;
			_id = id;
			
			
			CONFIG::debug
			{
				ASSERT(_id >= 0, "id must bigger than 0 ! id: " + id);
			}
			var element:Element = getElement(_id);
			_layer = element.layer;
			
			_level = element.level;
			_direction = element.direction;
			_picType = element.picType;
			_objectType = element.objectType;
			_isMove = element.isMove == "true";
			_isCrossDeleted = element.isCrossDeleted == "true";
			_isCanBeRemoved = element.isDeleted == "true";
			_isCrossDeletedBySpecialBomb = element.isCrossDeletedBySpecialBomb == "true";
			
			if(_id >= ConstantItem.ICE_BLOCK_START_INDEX && _id <= ConstantItem.ICE_BLOCK_END_INDEX)
			{
				_blockType = BLOCK_TYPE_ICE;
			}
			else if(_id >= ConstantItem.VARIABLE_OBJECT_START_INDEX && _id <= ConstantItem.VARIABLE_OBJECT_END_INDEX)
			{
				_blockType = BLOCK_TYPE_VARIABLE_ITEM;
			}
			else if(_id >= ConstantItem.GIFT_START_INDEX && _id <= ConstantItem.GIFT_END_INDEX)
			{
				_blockType = BLOCK_GIFT_ITEM;
			}
			else if(_id >= ConstantItem.JELLY_START_INDEX && _id <= ConstantItem.JELLY_END_INDEX)
			{
				_blockType = BLOCK_JELLY_ITEM;
			}
			else if(_id >= ConstantItem.CLOCK_START_INDEX && _id <= ConstantItem.CLOCK_END_INDEX)
			{
				_blockType = BLOCK_CLOCK_ITEM;
			}
			else if(_id >= ConstantItem.SMALL_HILL_START_INDEX && _id <= ConstantItem.SMALL_HILL_END_INDEX)
			{
				_blockType = BLOCK_SMALL_HILL;
			}
			else if(_id >= ConstantItem.WALL_START_INDEX && _id <= ConstantItem.WALL_END_INDEX)
			{
				_blockType = BLOCK_WALL;
			}
			else if(_id == ConstantItem.SLIVER_COIN_INDEX)
			{
				_blockType = BLOCK_SLIVER_COIN;
			}
			else if(_id == ConstantItem.GRID_ID_VINE)
			{
				_blockType = BLOCK_VINE;
			}
			else if(_id == ConstantItem.GRID_ID_BUG)
			{
				_blockType = BLOCK_BUG;
			}
			else if(_id == ConstantItem.GRID_ID_ROPE_H || _id == ConstantItem.GRID_ID_ROPE_V)
			{
				_blockType = BLOCK_ROPE;
			}
			else if(_id == ConstantItem.GRID_ID_DIAMOND)
			{
				_blockType = BLOCK_DIAMOND;
			}
			else if(_id == ConstantItem.GRID_ID_TRANSPORT_START || _id == ConstantItem.GRID_ID_TRANSPORT_END)
			{
				_blockType = BLOCK_TRANSFER_POINT;
			}
		}
		
		public function setDropPosition(dstX:int, dstY:int):void
		{
			_dstX = dstX;
			_dstY = dstY;
		}
		
		public function isVariableObject():Boolean
		{
			return _blockType == BLOCK_TYPE_VARIABLE_ITEM;	
		}
		
		public function isGiftItem():Boolean
		{
			return _blockType == BLOCK_GIFT_ITEM;
		}
		
		public function isJellyItem():Boolean
		{
			return _blockType == BLOCK_JELLY_ITEM;
		}
		
		public function isClockItem():Boolean
		{
			return _blockType == BLOCK_CLOCK_ITEM;
		}
		
		public function isMoveCollect():Boolean
		{
			return _isMove && objectType == TYPE_COLLECTION; 
		}
		
		public function isObstacle():Boolean
		{
			return _blockType == BLOCK_ROPE || _blockType == BLOCK_TRANSFER_POINT;
		}
		
		public function isHasLevel():Boolean
		{
			return _blockType == BLOCK_TYPE_ICE || _blockType == BLOCK_SMALL_HILL || _blockType == BLOCK_WALL;
		}
		
		public function isBlockAndHide():Boolean
		{
			return _blockType == BLOCK_SMALL_HILL || _blockType == BLOCK_WALL || _objectType == TYPE_ADD_EMPTY;
		}
		
		public function isHide():Boolean
		{
			return _objectType == TYPE_ADD_EMPTY;
		}
		
		public function isStopDrop():Boolean
		{
			return  _id == ConstantItem.GRID_ID_ROPE_V || _id == ConstantItem.GRID_ID_VINE;
		}
		
		public function isRopeV():Boolean
		{
			return _id == ConstantItem.GRID_ID_ROPE_V;
		}
		
		public static function getElement(id:int):Element
		{
			for each(var element:Element in DataManager.getInstance().elements.element)
			{
				if(element.id == id)
				{
					return element;
				}
			}
			
			return null;
		}
		
		
		public function get objectType():int
		{
			return _objectType;
		}
		
		public function set objectType(value:int):void
		{
			_objectType = value;
		}
		
		public function get picType():int
		{
			return _picType;
		}
		
		public function set picType(value:int):void
		{
			_picType = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function get layer():int
		{
			return _layer;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

/*		public function get uiIndex():int
		{
			return _uiIndex;
		}

		public function set uiIndex(value:int):void
		{
			_uiIndex = value;
		}*/

		public function get isMove():Boolean
		{
			return _isMove;
		}

		public function set isMove(value:Boolean):void
		{
			_isMove = value;
		}

		public function get blockType():int
		{
			return _blockType;
		}
		
		

		public function get isCrossDeleted():Boolean
		{
			return _isCrossDeleted;
		}

		public function get isCanBeRemoved():Boolean
		{
			return _isCanBeRemoved;
		}

		public function get isCrossDeletedBySpecialBomb():Boolean
		{
			return _isCrossDeletedBySpecialBomb;
		}

		public function set isCrossDeletedBySpecialBomb(value:Boolean):void
		{
			_isCrossDeletedBySpecialBomb = value;
		}

		public function get dstX():int
		{
			return _dstX;
		}

		public function get dstY():int
		{
			return _dstY;
		}


	}
}