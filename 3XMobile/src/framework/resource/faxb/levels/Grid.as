package framework.resource.faxb.levels
{
	[XmlType(name="grid", propOrder="basic")]
	public class Grid
	{
		[XmlElement(name="basic")]
		public var basic: Vector.<Basic>;
		
		[XmlAttribute(name="x", required="true")]
		public var x: int;
		
		[XmlAttribute(name="y", required="true")]
		public var y: int;
	}
}