package framework.resource.faxb.onlineActivity
{
	[XmlType(name="item", propOrder="")]
	public class ActivityItem
	{
		[XmlAttribute(name="num", required="true")]
		public var num: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
	}
}