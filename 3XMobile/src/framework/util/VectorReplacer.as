package framework.util
{
	public class VectorReplacer
	{
		private var _array:Vector.<Object> = new Vector.<Object>();
		
		public function VectorReplacer()
		{
		}
		
		public function getArray():Vector.<Object>
		{
			return _array.concat();
		}
		
		public function setArray(array:Vector.<Object>):void
		{
			_array = array;	
		}
		
		public function replace(newArray:Vector.<Object>, addNewCallback:Function, removeCallback:Function, updateNewArray:Boolean = true):void
		{
			var _newArray:Vector.<Object> = newArray.concat();
			
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
				}
			}
			
			for each(item in _newArray)
			{
				if(addNewCallback != null)
				{
					addNewCallback(item);	
				}
			}
			
			
			if(updateNewArray)
			{				
				_array = newArray.concat();
			}
		}

	}
}