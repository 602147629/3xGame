package framework.resource.faxb.onlineActivity
{
	[XmlType(name="activity", propOrder="level")]
	public class Activity
	{
		[XmlElement(name="level", required="true")]
		public var level: Vector.<ActivityLevel>;
		
		[XmlAttribute(name="type", required="true")]
		public var type: int;
		
		[XmlAttribute(name="startTime", required="true")]
		public var startTime: int;
		
		[XmlAttribute(name="endTime", required="true")]
		public var endTime: int;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
	}
}