package framework.util
{
	public class ArrayReplacer
	{
		
		private var _array:Array = [];
		
		public function ArrayReplacer()
		{
			
		}
		
		public function getArray():Array
		{
			return _array.concat();
		}
		
		public function setArray(array:Array):void
		{
			_array = array;	
		}
		
		public var isChanged:Boolean = false;
		
		public function replace(newArray:Array, addNewCallback:Function, removeCallback:Function, updateNewArray:Boolean = true):void
		{
			isChanged = false;
			var _newArray:Array = newArray.concat();
			
			var item:Object;
			
			for each(item in _array)
			{
				var index:int = _newArray.indexOf(item);
				if(index >= 0)
				{
					_newArray.splice(index, 1);
				}
				else
				{
					removeCallback(item);
					isChanged = true;
				}
			}
			
			for each(item in _newArray)
			{
				addNewCallback(item);
				isChanged = true;
			}
			
			
			if(updateNewArray)
			{				
				_array = newArray.concat();
			}
		}
		
	}
}