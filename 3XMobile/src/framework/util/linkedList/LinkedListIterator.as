package framework.util.linkedList
{
	public class LinkedListIterator
	{
		private var _next:ILinkedListObject;
		private var _linkedList:LinkedList;
		public function LinkedListIterator(linkedList:LinkedList)
		{
			_next = linkedList.head;
		}
		
		public function next():ILinkedListObject
		{
			_next = _next.next;
			return _next;
		}
		
		public function hasNext():Boolean
		{
			return _next.next != null;
		}
	}
}