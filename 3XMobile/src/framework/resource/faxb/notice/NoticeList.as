package framework.resource.faxb.notice
{
	[XmlType(name="NoticeList", propOrder="update")]
	public class NoticeList
	{
		[XmlElement(name="update", required="true")]
		public var update: Vector.<Update>;
	}
}