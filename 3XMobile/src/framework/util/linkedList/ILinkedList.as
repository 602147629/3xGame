package framework.util.linkedList
{
	public interface ILinkedList
	{
		function append(pivot:ILinkedListObject, object:ILinkedListObject):void;
		function remove(object:ILinkedListObject):void;
		function clear():void;
		function get length():int;
		function add(object:ILinkedListObject):void;
		function get last():ILinkedListObject;
		function get first():ILinkedListObject;
	}
}