package framework.util.rsv
{
	public class RsvSplitManager
	{
		public function RsvSplitManager()
		{
		}
		
		private static const splitingFilesIdPathPair:Array = [];
		
		public static function addPair(id:String, path:String):void
		{
			if(getFilePath(id) == null)
			{
				splitingFilesIdPathPair.push([id, path]);
			}
		}
		
		public static function getFilePath(id:String):String
		{
			for each(var item:Array in splitingFilesIdPathPair)
			{
				if(item[0] == id)
				{
					return item[1];
				}
			}
			return null;
		}
		
		public static function getSplitFileUrl(path:String, className:String):String
		{
			var url:String = path + className + ".swf";
			return url;
		}
		
		public static function getSplitFileId(path:String, className:String):String
		{
			var url:String = "[ID]" + path + className + ".swf";
			return url;
		}

	}
}