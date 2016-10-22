package framework.resource.faxb.starreward
{
	[XmlType(name="items", propOrder="")]
	public class Items
	{
		[XmlAttribute(name="num", required="true")]
		public var num: int;
		
		[XmlAttribute(name="itemId", required="true")]
		public var itemId: int;
	}
}