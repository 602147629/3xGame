package framework.util.linkedList
{
	public class PriorityLinkedListObject extends LinkedListObject implements IPriorityLinkedListObject
	{
		protected var _priority:int;
		public function PriorityLinkedListObject()
		{
			super();
		}
		
		public function getPriority():int
		{
			return _priority;
		}
		
		public function setPriority(priority:int):void
		{
			_priority = priority;
		}
	}
}