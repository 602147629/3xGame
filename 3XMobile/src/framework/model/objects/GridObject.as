package framework.model.objects
{
	import com.games.candycrush.board.Item;
	
	import framework.model.ConstantItem;
	import framework.ui.MediatorPanelMainUI;

	public class GridObject
	{
		private var _x:int;
		private var _y:int;	
		public var basicObjects:Vector.<BasicObject>;
		private var _isCollectContainer:Boolean;
		
		public function GridObject(x:int, y:int)
		{
			_x = x;
			_y = y;
			
			clear();
		}
		
		public function clear():void
		{
			basicObjects = new Vector.<BasicObject>();
		}
		
		public function getIndexNumber():int
		{
			return _x + _y * LevelData.MAX_LINE_NUMBER;
		}

		public function get x():int
		{
			return _x;
		}

		public function get y():int
		{
			return _y;
		}
		
		public function deleteSameLayerObject(basicObject:BasicObject):void
		{
			
			
		
			for(var i:int = 0; i < basicObjects.length; i++)
			{
				var base:BasicObject = basicObjects[i];
				
				CONFIG::debug
				{
					ASSERT(base != null, "can not delete a null object!");	
				}
				if(base == null)
				{
					continue;
				}
				else if(/*base.objectType == basicObject.objectType ||*/ base.layer == basicObject.layer)
				{
					basicObjects.splice(i, 1);
					break;
				}
			}
		}
		
		public function pushObject(basicObject:BasicObject):void
		{
			deleteSameLayerObject(basicObject);
			
			basicObjects.push(basicObject);
			basicObjects.sort(sortLayer);
			
//			updateUiIndex();
		}
		
		/*private function updateUiIndex():void
		{
			for(var i:int = 0; i < basicObjects.length; i++)
			{
				var base:BasicObject = basicObjects[i];o
				base.uiIndex = i;
			}
		}*/
		
		private function sortLayer(a:BasicObject, b:BasicObject):int
		{
			if(a.layer < b.layer)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		public function getTransportEnd():BasicObject
		{
			return getBasicObjectById(ConstantItem.GRID_ID_TRANSPORT_END);
		}
		
		public function getTransportStart():BasicObject
		{			
			return getBasicObjectById(ConstantItem.GRID_ID_TRANSPORT_START);
		}
		
		public function getBasicObjectByBlockType(blockType:int):BasicObject
		{
			for each(var basic:BasicObject in basicObjects)
			{
				if(basic.blockType == blockType)
				{
					return basic;
				}				
			}
			
			return null;	
		}
		
		public function getBasicObjectById(id:int):BasicObject
		{
			for each(var basic:BasicObject in basicObjects)
			{
				if(basic.id == id)
				{
					return basic;
				}				
			}
			
			return null;
		}
		
		public function isStopDrop():Boolean
		{
			for each(var basic:BasicObject in basicObjects)
			{
				if(basic.isStopDrop())
				{
					return true;
				}
			
			}
			return false;
		}
		
		public function isHasRopeV():Boolean
		{
			for each(var basic:BasicObject in basicObjects)
			{
				if(basic.isRopeV())
				{
					return true;
				}
				
			}
			return false;
		}
		
		public function isHasRopeH():Boolean
		{
			for each(var basic:BasicObject in basicObjects)
			{
				if(basic.id == ConstantItem.GRID_ID_ROPE_H)
				{
					return true;
				}
				
			}
			return false;
		}
		
		public function getNormalBasicObject():BasicObject
		{
			for each(var basic:BasicObject in basicObjects)
			{
				if(basic.objectType == BasicObject.TYPE_NORMAL)
				{
					return basic;
				}
				else if(basic.isVariableObject())
				{					
					return basic;
				}
				else if(basic.isGiftItem())
				{
					return basic;
				}
				else if(basic.isJellyItem())
				{
					return basic;
				}
				else if(basic.isClockItem())
				{
					return basic;
				}
			}
			return null;
		}
		
		public function getEffectItem(listener:MediatorPanelMainUI):Item
		{
			var effectBasic:BasicObject = getTopBasicObjectNotContainObstacle();
			if(effectBasic != null)
			{
				var item:Item = new Item(x, y);
				item.setGridObject(this, listener);
				return item;
			}
			return null;
		}
		
		public function getTopBasicObjectNotContainObstacle():BasicObject
		{
			//not a rope vine and bug;			
			var length:int = basicObjects.length;
			var basic:BasicObject = null ;
						
			//todo
			
			for(var i:int = length - 1; i >= 0; i--)
			{
				basic = basicObjects[i];
				if(basic.isObstacle())
				{
					basic = null;
					continue;
				}
				else
				{
					break;
				}
			}
			
			//todo if is diamond, return smallHill?
			if(basic != null && basic.objectType == BasicObject.TYPE_COLLECTION)
			{
				for each(var basic1:BasicObject in basicObjects)
				{
					if(basic1.layer == 4)
					{
						basic = basic1;
						break;
					}
				}
			}
			
			return basic;
		}
		
		public function getTopBasicObject():BasicObject
		{
			var length:int = basicObjects.length;
			var basic:BasicObject = length > 0 ? basicObjects[length - 1] : null;
			
			return basic;
		}

		public function get isCollectContainer():Boolean
		{
			return _isCollectContainer;
		}

		public function set isCollectContainer(value:Boolean):void
		{
			_isCollectContainer = value;
		}
		
		public function isHideGrid():Boolean
		{
			return basicObjects.length > 0 && basicObjects[0].objectType == BasicObject.TYPE_ADD_EMPTY;
		}

	}
}