package framework.resource.faxb.levelproperty
{
	[XmlType(name="createElement", propOrder="")]
	public class CreateElement
	{
		[XmlAttribute(name="rate", required="true")]
		public var rate: int;
		
		[XmlAttribute(name="elementId", required="true")]
		public var elementId: int;
	}
}