package framework.resource.faxb.items
{
	[XmlType(name="item", propOrder="cost,award")]
	public class Item
	{
		[XmlElement(name="cost", required="true")]
		public var cost: Cost;
		
		[XmlElement(name="award", required="true")]
		public var award: Vector.<Award>;
		
		[XmlAttribute(name="type", required="true")]
		public var type: int;
		
		[XmlAttribute(name="limit", required="true")]
		public var limit: int;
		
		[XmlAttribute(name="itemName", required="true")]
		public var itemName: String;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="icon", required="true")]
		public var icon: int;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
	}
}