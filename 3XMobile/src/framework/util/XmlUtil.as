package framework.util
{
	public class XmlUtil
	{
		public function XmlUtil()
		{
		}
		
		public static function attrString(xml:XML, name:String, defaultValue:String=null, recursive:Boolean=false):String
		{
			var xmllist:XMLList = recursive ? recursiveAttr(xml, name) : xml.@[name];
			var str:String = (xmllist != null)  && xmllist.length() > 0 ? xmllist.toString() : defaultValue;
			
			if(str == "")
			{
				str = null;
			}
			return str;
		}
		
		public static function attrNumber(xml:XML, name:String, defaultValue:Number=0, recursive:Boolean=false):Number
		{
			var xmllist:XMLList = recursive ? recursiveAttr(xml, name) : xml.@[name];
			return xmllist != null && xmllist.length() > 0 ? (Number)(xmllist.toString()) : defaultValue;
		}
		
		public static function attrInt(xml : XML, name : String, defaultValue : int = 0, recursive : Boolean = false) : int
		{
			var xmllist:XMLList = recursive ? recursiveAttr(xml, name) : xml.@[name];
			return xmllist != null && xmllist.length() > 0 ? (int)(xmllist.toString()) : defaultValue;
		}
		
		public static function attrUint(xml : XML, name : String, defaultValue : int = 0, recursive : Boolean = false) : uint
		{
			var xmllist:XMLList = recursive ? recursiveAttr(xml, name) : xml.@[name];
			return xmllist != null && xmllist.length() > 0 ? (uint)(xmllist.toString()) : defaultValue;
		}
		
		public static function attrBoolean(xml:XML, name:String, defaultValue:Boolean = false, recursive:Boolean = false):Boolean
		{
			var xmllist:XMLList = recursive ? recursiveAttr(xml, name) : xml.@[name];
			return xmllist != null && xmllist.length() > 0 ? xmllist.toString() == "true" : defaultValue;
		}
		
		private static function recursiveAttr(xml:XML, name:String):XMLList
		{
			var xmllist:XMLList = xml.@[name];
			if(xmllist.length() > 0)
			{
				return xmllist;
			}
			else
			{ 
				var parent:XML = xml.parent();
				if(parent == null)
					return null;
				else
					return recursiveAttr(parent, name);
			}
		}
		
		public static function attrToString(name:String, data:Object):String
		{
			var s:String = data != null ? data.toString() : "null";
			return " "+name+"=\""+s+"\"";
		}
		
		public static function getFirstChild(xml:XML, name:String):XML
		{
			var list:XMLList = xml[name];
			return list.length() == 0 ? null : list[0];
		}
		
		/**
		<root>
			<count>value</count>
		</root>
		 */
		public static function getFirstChildValueAsString(root:XML):String
		{
			return (root.children()[0] as XML).children()[0];
		}
		
		public static function getFirstChildValueAsInt(root:XML):int
		{
			return int(getFirstChildValueAsString(root));
		}
	}
}