package framework.util.linkedList
{
	public class LinkedListObject implements ILinkedListObject
	{
		protected var _previous:ILinkedListObject;
		protected var _next:ILinkedListObject;
		private var _data:Object;
		
		public function LinkedListObject()
		{
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		public function get previous():ILinkedListObject
		{
			return _previous;
		}
		
		public function set previous(object:ILinkedListObject):void
		{
			_previous = object;
		}
		
		public function get next():ILinkedListObject
		{
			return _next;
		}
		
		public function set next(object:ILinkedListObject):void
		{
			_next = object;
		}
		
		public function remove():void
		{
			if(next != null)
			{
				next.previous = previous;
			}
			previous.next = next;
			
			next = null;
			previous = null;
		}
		
		public function append(object:ILinkedListObject):void
		{
			if(next != null)
			{
				object.next = next;
				next.previous = object;
			}
			else
			{
				object.next = null;
			}
			
			object.previous = this;
			next = object;
		}
		
		public function insert(object:ILinkedListObject):void
		{
			if(previous != null)
			{
				previous.next = object;
			}
			object.next = this;
			this.previous = object;
		}
		
	}
}