package framework.resource
{
	public class BaseURLGroup
	{
		private var _pathes:Vector.<String>;
		private var _name:String;
		
		public function BaseURLGroup(name:String)
		{
			_name = name;
			_pathes = new Vector.<String>();
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function addPath(path:String):void
		{
			_pathes.push(path);
		}
		
		//If use Multi Base urls technique, May be there should have some strategy to even the load for each URL.
		//For now return the first one directly.
		public function getBaseURL():String
		{
			return _pathes[0];
		}
	}
}