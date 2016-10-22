package framework.resource.faxb.tutorial
{
	[XmlType(name="clickGrid", propOrder="grid")]
	public class ClickGrid
	{
		[XmlElement(name="grid", required="true")]
		public var grid: Vector.<Grid>;
		
		[XmlAttribute(name="direction", required="true")]
		public var direction:int;
	}
}