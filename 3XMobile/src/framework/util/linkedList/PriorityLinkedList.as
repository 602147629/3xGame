package framework.util.linkedList
{
	public class PriorityLinkedList extends LinkedList
	{
		public function PriorityLinkedList()
		{
			super();
		}
		
		override public function add(object:ILinkedListObject):void
		{
			CONFIG::debug
			{
				ASSERT(object is IPriorityLinkedListObject, "Only should be used for IPriorityLinkedListObject object!!");
				ASSERT(object != null, "Target object should be not null!!");
				ASSERT(!checkIsInLinkedList(object), "Object has already been added into this list");
			}
			
			var newObject:IPriorityLinkedListObject = object as IPriorityLinkedListObject;
			
			var previous:ILinkedListObject = null;
			var iterator:LinkedListIterator = getIterator();
			while(iterator.hasNext())
			{
				var current:IPriorityLinkedListObject = iterator.next() as IPriorityLinkedListObject;
				if(current.getPriority() < newObject.getPriority())
				{
					break;
				}
				
				previous = current;
			}
			
			if(previous == null)
			{
				previous = head;	
			}
			
			previous.append(object);
		}
	}
}