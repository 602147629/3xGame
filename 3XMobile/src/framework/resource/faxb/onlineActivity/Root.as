package framework.resource.faxb.onlineActivity
{
	[XmlType(name="root", propOrder="activity")]
	public class Root
	{
		[XmlElement(name="activity", required="true")]
		public var activity: Activity;
		
		[XmlAttribute(name="version", required="true")]
		public var version: Number;
	}
}