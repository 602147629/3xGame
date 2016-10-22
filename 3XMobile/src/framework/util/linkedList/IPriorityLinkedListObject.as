package framework.util.linkedList
{
	public interface IPriorityLinkedListObject extends ILinkedListObject
	{
		function getPriority():int;
		function setPriority(priority:int):void;
	}
}