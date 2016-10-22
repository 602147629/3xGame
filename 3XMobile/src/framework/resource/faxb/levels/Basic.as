package framework.resource.faxb.levels
{
	[XmlType(name="basic", propOrder="")]
	public class Basic
	{
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="layer", required="true")]
		public var layer: int;
		
		[XmlAttribute(name="objectType", required="true")]
		public var objectType: int;
		
		[XmlAttribute(name="picType", required="true")]
		public var picType: int;
		
		[XmlAttribute(name="dstX", required="false")]
		public var dstX: int;
		
		[XmlAttribute(name="dstY", required="false")]
		public var dstY: int;
		
		[XmlAttribute(name="num", required="false")]
		public var num: int;
	}
}