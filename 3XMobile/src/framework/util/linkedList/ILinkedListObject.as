package framework.util.linkedList
{
	public interface ILinkedListObject
	{
		function get previous():ILinkedListObject;
		function set previous(object:ILinkedListObject):void;
		
		function get next():ILinkedListObject;
		function set next(object:ILinkedListObject):void;
		
		function get data():Object;
		function set data(object:Object):void;
		
		function remove():void;
		function append(object:ILinkedListObject):void;
		function insert(object:ILinkedListObject):void;
	}
}