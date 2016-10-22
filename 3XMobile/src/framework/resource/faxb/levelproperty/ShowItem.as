package framework.resource.faxb.levelproperty
{
	[XmlType(name="showItem", propOrder="")]
	public class ShowItem
	{
		[XmlAttribute(name="unlock", required="true")]
		public var unlock: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
	}
}