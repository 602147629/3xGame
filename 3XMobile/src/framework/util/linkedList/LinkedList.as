package framework.util.linkedList
{
	public class LinkedList implements ILinkedList
	{
		internal var head:ILinkedListObject;
		
		public function LinkedList()
		{
			head = new LinkedListObject();
		}
		
		
		public function insert(pivot:ILinkedListObject, object:ILinkedListObject):void
		{
			CONFIG::debug
			{
				ASSERT(object != null, "Target object should be not null!!");
				ASSERT(!checkIsInLinkedList(object), "Object has already been added into this list");
				if(pivot != null)
				{
					ASSERT(checkIsInLinkedList(pivot), "Pivot object is not in this list");
				}
			}
			if(pivot == null)
			{
				pivot = first;
				if(pivot == null)
				{
					add(pivot);
					return;
				}
			}
			
			pivot.insert(object);
		}
		
		public function append(pivot:ILinkedListObject, object:ILinkedListObject):void
		{
			CONFIG::debug
			{
				ASSERT(object != null, "Target object should be not null!!");
				ASSERT(!checkIsInLinkedList(object), "Object has already been added into this list");
				if(pivot != null)
				{
					ASSERT(checkIsInLinkedList(pivot), "Pivot object is not in this list");
				}
			}
			
			if(pivot == null)
			{
				pivot = head;
			}
			
			pivot.append(object);
		}
		
		public function checkIsInLinkedList(pivot:ILinkedListObject):Boolean
		{
			var head:LinkedListIterator = getIterator();
			while(head.hasNext())
			{
				var object:ILinkedListObject = head.next();
				if(object == pivot)	
				{
					return true;
				}
			}
			return false;
		}
		
		public function remove(object:ILinkedListObject):void
		{
			if(object != null)
			{
				CONFIG::debug
				{
					ASSERT(checkIsInLinkedList(object), "Target object is not in this list!!");
				}
				object.remove();
			}
		}
		
		public function clear():void
		{
			var handler:Function = function(object:ILinkedListObject):void
			{
				object.previous.next = null;
				object.previous = null;
			};
			traverseExecute(handler);
			CONFIG::debug
			{
				ASSERT(length == 0, "Something is wrong!!");
			}
		}
		
		public function get length():int
		{
			var count:int = 0;
			var handler:Function = function(object:ILinkedListObject):void
			{
				++ count;
			};
			
			traverseExecute(handler);
			
			return count;
		}
		
		public function add(object:ILinkedListObject):void
		{
			CONFIG::debug
			{
				ASSERT(object != null, "Target object should be not null!!");
				ASSERT(!checkIsInLinkedList(object), "Object has already been added into this list");
			}
			
			var lastOne:ILinkedListObject = last;
			if(lastOne == null)
			{
				lastOne = head;
			}
			lastOne.append(object);
		}
		
		public function get last():ILinkedListObject
		{
			var head:LinkedListIterator = getIterator();
			while(head.hasNext())
			{
				var object:ILinkedListObject = head.next();
				if(object.next == null)
				{
					return object;
				}
			}
			return null;
		}
		
		public function get first():ILinkedListObject
		{
			return head.next;
		}
		
		public function getIterator():LinkedListIterator
		{
			return new LinkedListIterator(this);
		}
		
		/**
		 * function hanlder(object:ILinkedListObject):void
		 */
		public function traverseExecute(handler:Function):void
		{
			var head:LinkedListIterator = new LinkedListIterator(this);
			var object:ILinkedListObject;
			while(head.hasNext())
			{
				handler(head.next());
			}
		}
		
		/**
		 * object.functionName():
		 */
		public function traverseInvoke(functionName:String):void
		{
			var head:LinkedListIterator = new LinkedListIterator(this);
			while(head.hasNext())
			{
				var object:ILinkedListObject = head.next();
				object[functionName]();
			}
		}
	}
}