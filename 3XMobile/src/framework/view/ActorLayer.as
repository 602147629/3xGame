package framework.view
{
	import com.game.module.role.Actor;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import framework.util.DisplayUtil;
	import framework.util.Util;
	import framework.util.XmlUtil;
	
	public class ActorLayer extends Sprite
	{
		public var id:String;
		public var sortType:int;
		
		public static const SORT_UNIQUE:int = 1;
		public static const SORT_NORMAL:int = 2;
		public static const SORT_OBJECT:int = 3;
		public static const SORT_UI:int = 4;
		
		private var _actorObjects:Vector.<Actor>;
		private var _uiObjects:Vector.<MovieClip>;
		
		public function ActorLayer(name:String = null, sortType:int = SORT_NORMAL)
		{
			super();
			
			this.id = name;
			this.sortType = sortType;
			
			if(this.sortType != SORT_UI)
			{
				this.mouseEnabled = false;
				this.mouseChildren = false;
			}
			
			if(this.sortType ==SORT_OBJECT)
			{
				this.mouseEnabled = true;
				this.mouseChildren = true;
			}
			
			_actorObjects = new Vector.<Actor>();
			_uiObjects = new Vector.<MovieClip>();
		}
				
		public function get actorObjects():Vector.<Actor>
		{
			return _actorObjects;
		}

		public function set actorObjects(value:Vector.<Actor>):void
		{
			_actorObjects = value;
		}

		public function addObject(obj:DisplayObject):void
		{

			var actor:Actor = obj as Actor;
			
			CONFIG::debug
			{
				ASSERT(actor != null, "obj is not a Actor:" + getQualifiedClassName(obj));
			}
			
			if(sortType == SORT_NORMAL)
			{
				this.addChild(obj);
				
				Util.addUniqueElementToVector(_actorObjects, obj);
			}
			else if(sortType == SORT_UNIQUE)
			{
				this.addChild(obj);
				
				Util.addUniqueElementToVector(_actorObjects, obj);
			}
			else if(sortType == ActorLayer.SORT_OBJECT)
			{
				addObjectToSortingLayer(actor);
			}
			
		}
		
		public function removeObject(obj:Actor):DisplayObject
		{			
			obj.destory();
			if(_actorObjects != null)
			{
				Util.removeElementFromVector(_actorObjects, obj);
			}
			
			return super.removeChild(obj);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{

			
			if(child is Actor)
			{			
				return removeObject(child as Actor);
			}
			else
			{
				return super.removeChild(child);
			}
		}
		
		
		
			
		private var _checkDisplayListSyncTick:int;

		private function checkDisplayActorValid():void
		{
			CONFIG::debug
			{
				if((_checkDisplayListSyncTick++ & 0xff) == 0 )
				{
					// check if _mapObjects is sync with display list or not
					var count:int = 0;
					for(var j:int = numChildren - 1; j >= 0; j--)
					{
						var child:DisplayObject = super.getChildAt(j);
						if(child is Actor)
						{
							
							if((_actorObjects.indexOf(child as Actor)) == -1)
							{
								ASSERT(false, "Actor(id:" + Actor(child).name + ") is in disply list but not in array");
							}
							else
							{
								count++;
							}
						}
					}
					
					ASSERT(_actorObjects.length == count, "not all Actor in array");
				}

			}

		}
		
		override public function getChildAt(index:int):DisplayObject
		{
			if(this._actorObjects.length > 0)
			{
				CONFIG::debug
				{
					checkDisplayActorValid();
				}
				return _actorObjects[index];
			}
			else
			{
				return super.getChildAt(index);
			}
		}
		
		private function checkDisplayUIChildValid():void
		{
			CONFIG::debug
			{
				if(_uiObjects.length <= 0)
				{
					return;
				}
				
				ASSERT(_uiObjects.length == this.numChildren, "not all ui object in array");
				
			}
		}
		
		public function updateView(psdTickMs:Number):void
		{
			CONFIG::debug
			{
				checkDisplayActorValid();
				checkDisplayUIChildValid();
			}
			

			for(var i:int = _actorObjects.length - 1; i >= 0; --i)
			{
				var object:Actor = _actorObjects[i];
				object.updateView(psdTickMs);
			}
			
		}
		
		

	

		//////////////////////////
		// sorting
		//////////////////////////
		
		public function addObjectToSortingLayer(newChild:DisplayObject):void
		{
			CONFIG::debug
			{
				ASSERT(newChild.hasOwnProperty("z_value"), "ASSERT");
			}
			
			if(newChild is Actor)
			{
				addActorAndSort(Actor(newChild), -0xcdcdcdcd, true);
			}
			else
			{
				addUIAndSort(newChild as MovieClip);
			}
			
		}
		
		
		public function addActorAndSort(actor:Actor, newZValue:Number = 0xffffff, newAddTo:Boolean = false):void
		{
			if(!newAddTo && Math.abs(actor.z_value - newZValue) < 0.1)
			{
				return;
			}
			
			if(_actorObjects.length == 0)
			{
				_actorObjects.push(actor);
				actor.lastPositionInZOrder = 0;
				addChild(actor);
				return;
			}
			
			var originalIndex:int = -1;
			if(!newAddTo)
			{
				originalIndex = deleteActorFromList(actor, _actorObjects);

				actor.z_value = newZValue;
			}

			
			var targetIndex:int = 0;
			if(_actorObjects.length > 0)
			{
				targetIndex = binarySearchInsertPositionByZ(_actorObjects, actor.z_value, 0, _actorObjects.length - 1);
			}
			
			if(targetIndex >= 0)
			{
				_actorObjects.splice(targetIndex, 0, actor);
				actor.lastPositionInZOrder = targetIndex;
				
				if(originalIndex != targetIndex)
				{
					addChildAt(actor, targetIndex);
				}
			}
			else
			{
				CONFIG::debug
				{
					ASSERT(false, "ASSERT");
				}
				
			}
			
			CONFIG::debug
			{
				ASSERT(_actorObjects.length == numChildren, "vector and display list is not sync length: "+_actorObjects.length+" numChildren: "+numChildren);
			}
			
		}
		
		public function addUIAndSort(ui:MovieClip):void
		{
			CONFIG::debug
			{
				ASSERT(ui.hasOwnProperty("z_value"), "ASSERT");
			}

			CONFIG::debug
			{
				ASSERT(!this.contains(ui), getQualifiedClassName(ui) + " already in layer");
			}
			
			if(_uiObjects.length == 0)
			{
				_uiObjects.push(ui);
				addChild(ui);
				return;
			}
			
			var targetIndex:int = binarySearchInsertPositionByZ(_uiObjects, ui.z_value, 0, _uiObjects.length - 1);
			
			if(targetIndex >= 0)
			{
				_uiObjects.splice(targetIndex, 0, ui);
				addChildAt(ui, targetIndex);
			}
			else
			{
				CONFIG::debug
				{
					ASSERT(false, "ASSERT");
				}
			}
			
			CONFIG::debug
			{
				ASSERT(_uiObjects.length == numChildren, "vector and display list is not sync");
			}
		}
		
		public function updateUIZSort(ui:MovieClip, newZValue:Number):void
		{
			CONFIG::debug
			{
				ASSERT(this.contains(ui), "ASSERT");
			}
			
			if(ui.z_value == newZValue)
			{
				return;
			}

			var originalIndex:int = deleteObjectFromList(ui, _uiObjects);
			ui.z_value = newZValue;
			
			var targetIndex:int = binarySearchInsertPositionByZ(_uiObjects, ui.z_value, 0, _uiObjects.length - 1);
			
			if(targetIndex >= 0)
			{
				_uiObjects.splice(targetIndex, 0, ui);
				if(originalIndex != targetIndex)
				{
					addChildAt(ui, targetIndex);
				}
			}
			else
			{
				CONFIG::debug
				{
					ASSERT(false, "ASSERT");
				}

//				_uiObjects.push(ui);
//				addChild(ui);
			}
			
			CONFIG::debug
			{
				ASSERT(_uiObjects.length == numChildren, "vector and display list is not sync");
			}
		}
		
		private static function deleteObjectFromList(mo:Object, vector:Object):int
		{
			var originalIndex:int = -1;

			var targetIndex:int = binarySearchPosition(vector, mo.z_value, 0, vector.length - 1);
			CONFIG::debug
			{
				ASSERT(targetIndex != -1, "ASSERT");
			}
			
			var moz:Number = mo.z_value;
			
			var start:int = targetIndex;
			while(targetIndex < vector.length && vector[targetIndex].z_value == moz)
			{
				if(vector[targetIndex] == mo)
				{
					vector.splice(targetIndex, 1);
					originalIndex = targetIndex;
					break;
				}
				++targetIndex;
			}
			
			if(originalIndex < 0)
			{
				while(--start >= 0 && vector[start].z_value == moz)
				{
					if(vector[start] == mo)
					{
						vector.splice(start, 1);
						originalIndex = start;
						break;
					}
				}
			}
			
			CONFIG::debug
			{
				ASSERT(originalIndex >= 0, "ASSERT");
			}

			return originalIndex;
		}
		
		private static function deleteActorFromList(actor:Actor, vector:Vector.<Actor>):int
		{
			var originalIndex:int = searchActorObject(actor, vector);
			CONFIG::debug
			{
				ASSERT(originalIndex >= 0, "ASSERT");
			}
			
			vector.splice(originalIndex, 1);
			actor.lastPositionInZOrder = -1;
			
			return originalIndex;
		}

		private static function searchActorObject(actor:Actor, vector:Vector.<Actor>):int
		{
			CONFIG::debug
			{
				ASSERT(actor.lastPositionInZOrder >= 0, "ASSERT");
				ASSERT(vector.length > 0, "ASSERT");
			}
			
			var lastIndex:int = actor.lastPositionInZOrder;
			if(lastIndex >= vector.length)
			{
				lastIndex = vector.length - 1;
			}

			var vectorLength:int = vector.length;

			var i:int;
			
			for(i = 0; i < vectorLength; ++i)
			{
				if(vector[i] == actor)
				{
					return i;
				}
			}
			
			/*if(actor.z_value > vector[lastIndex].z_value)
			{
				for(i = lastIndex; i < vectorLength; ++i)
				{
					if(vector[i] == actor)
					{
						return i;
					}
				}
			}
			else if(actor.z_value < vector[lastIndex].z_value)
			{
				for(i = lastIndex; i >= 0; --i)
				{
					if(vector[i] == actor)
					{
						return i;
					}
				}
			}
			else
			{
				for(i = lastIndex; i < vectorLength && vector[i].z_value == actor.z_value; ++i)
				{
					if(vector[i] == actor)
					{
						return i;
					}
				}
				
				for(i = lastIndex; i >= 0 && vector[i].z_value == actor.z_value; --i)
				{
					if(vector[i] == actor)
					{
						return i;
					}
				}
			}*/
			
			CONFIG::debug
			{
				ASSERT(false, "can't find index");
			}
			return -1;
			
		}
		
		/**
		 * search a value's position in sorted vector
		 * 
		 * @return the position of value in the sorted vector, if not in vector, return -1
		 */
		private static function binarySearchPosition(vector:Object, value:Number, low:int, high:int):int
		{
			while(true)
			{
				CONFIG::debug
				{
					ASSERT(low <= high, "ASSERT");
				}
//				if(high < low)
//					return -1;
				
				var mid:int = (low + high) >> 1;
				var midz:Number = vector[mid].z_value;
				if(midz > value)
					high = mid -1;
				else if(midz < value)
					low = mid + 1;
				else
					return mid;
			}
			
			return -1;
		}
		
		/**
		 * find a position for a value in sorted vector
		 * 
		 * @return the position of value can be in the sorted vector, if return -1, the value is bigger than all
		 */
		private static function binarySearchInsertPositionByZ(vector:Object, value:Number, low:int, high:int):int
		{
			while(true)
			{
				CONFIG::debug
				{
					ASSERT(low <= high, "low should always <= high");
				}
//				if(high < low)
//					return -1;
				
				var mid:int = (low + high) >> 1;
				var midz:Number = vector[mid].z_value;
				if(midz > value)
				{
					if(mid == low)
						return low;
					high = mid -1;
				}
				else if(midz < value)
				{
					if(mid == high)
						return high + 1;
					low = mid + 1;
				}
				else
					return mid;
			}
			
			return -1;
		}
		
		public function destroy():void
		{
			if(_actorObjects != null)
			{
				for each(var actor:Actor in _actorObjects)
				{
					actor.destory();
				}
				_actorObjects = null;
			}
			_uiObjects = null;
			
			DisplayUtil.removeFromParent(this);
		}
		
	}
}



