package framework.resource.faxb.levelproperty
{
	[XmlType(name="ElementDemand", propOrder="element")]
	public class ElementDemand
	{
		[XmlAttribute(name="showIcon", required="true")]
		public var showIcon: int;
		
		[XmlAttribute(name="num", required="true")]
		public var num: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlElement(name="element")]
		public var element: Vector.<Element>;
	}
}