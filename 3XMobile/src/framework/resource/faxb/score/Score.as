package framework.resource.faxb.score
{
	[XmlType(name="score", propOrder="")]
	public class Score
	{
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
		
		[XmlAttribute(name="bombScore", required="true")]
		public var bombScore: int;
		
		[XmlAttribute(name="multiple", required="true")]
		public var multiple: int;
		
		[XmlAttribute(name="bombSingleScore", required="true")]
		public var bombSingleScore: int;
		
		[XmlAttribute(name="isTimesMultiple", required="true")]
		public var isTimesMultiple: String;
	}
}