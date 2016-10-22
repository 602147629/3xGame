package framework.resource.faxb.notice
{
	[XmlType(name="update", propOrder="")]
	public class Update
	{
		[XmlAttribute(name="title", required="true")]
		public var title: String;
		
		[XmlAttribute(name="starttime", required="true")]
		public var starttime: String;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="endtime", required="true")]
		public var endtime: String;
		
		[XmlAttribute(name="content", required="true")]
		public var content: String;
	}
}