package framework.resource.faxb.award
{
	[XmlType(name="award", propOrder="")]
	public class MatchAward
	{
		[XmlAttribute(name="min", required="true")]
		public var min: int;
		
		[XmlAttribute(name="max", required="true")]
		public var max: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="icon", required="true")]
		public var icon: int;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
	}
}