package framework.resource.faxb.tutorial
{
	[XmlType(name="grid", propOrder="")]
	public class Grid
	{
		[XmlAttribute(name="x", required="true")]
		public var x: int;
		
		[XmlAttribute(name="y", required="true")]
		public var y: int;
	}
}