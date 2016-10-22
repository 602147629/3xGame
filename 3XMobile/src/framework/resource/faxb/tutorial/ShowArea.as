package framework.resource.faxb.tutorial
{
	[XmlType(name="showArea", propOrder="")]
	public class ShowArea
	{
		[XmlAttribute(name="x", required="true")]
		public var x: int;
		
		[XmlAttribute(name="y", required="true")]
		public var y: int;
		
		[XmlAttribute(name="width", required="true")]
		public var width: int;
		
		[XmlAttribute(name="height", required="true")]
		public var height: int;
	}
}