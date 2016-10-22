package framework.resource.faxb.onlineActivity
{
	[XmlType(name="level", propOrder="item")]
	public class Level
	{
		[XmlElement(name="item")]
		public var item: Item;
		
		[XmlAttribute(name="silver", required="true")]
		public var silver: int;
		
		[XmlAttribute(name="num", required="true")]
		public var num: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
	}
}