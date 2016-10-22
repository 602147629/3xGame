package framework.model
{
	import framework.resource.ResourceFactory;

	public class LoadStrategyFile
	{
		private var _id:String;
		private var _classId:String;
		private var _resourceId:String;
		
		public function LoadStrategyFile(fileXml:XML)
		{
			_id = fileXml.@id;
			_classId = fileXml.@classId;
			_resourceId = fileXml.@resourceId;
		}
		
		public function getId():String
		{
			return _id;
		}
		
		public function getClassId():String
		{
			return _classId;
		}
		
		public function getResourceId():String
		{
			return _resourceId;
		}
		
	}
}