package framework.resource.faxb.items
{
	[XmlType(name="root", propOrder="item")]
	public class Items
	{
		[XmlElement(name="item", required="true")]
		public var item: Vector.<Item>;
	}
}