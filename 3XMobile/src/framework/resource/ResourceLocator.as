package framework.resource
{
	import framework.util.XmlUtil;

	public class ResourceLocator
	{
		
		public function ResourceLocator(xml:XML, domain:int)
		{
			name = xml.@name;
			baseGroup = xml.parent().@path;
			src = xml.@src;
			length = XmlUtil.attrNumber(xml, "length", 0);
			size = XmlUtil.attrNumber(xml, "size", 0);
			
			this.domain = domain;
			
		}
		
		public static function getKeyFromGamePath(path:String):String
		{
/*			var index:int = path.lastIndexOf("/");
			if(index == -1)
			{
				return path;
			}
*/
			
			CONFIG::assetcaching
			{
				var index:int = path.lastIndexOf("/");
				var key:String = path.substring(index + 1, path.lastIndexOf("."));
				return key;
			}
			
			return path;
			
		}
		
		public var name:String;
		public var baseGroup:String;
		public var src:String;
		public var length:int;
		public var size:int;
		public var domain:int;
		
	}
}