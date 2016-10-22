package framework.resource.faxb.levelproperty
{
	[XmlType(name="Score", propOrder="")]
	public class Score
	{
		[XmlAttribute(name="twoStar", required="true")]
		public var twoStar: int;
		
		[XmlAttribute(name="totalStar", required="true")]
		public var totalStar: int;
		
		[XmlAttribute(name="threeStar", required="true")]
		public var threeStar: int;
		
		[XmlAttribute(name="oneStar", required="true")]
		public var oneStar: int;
		
		[XmlAttribute(name="numStar", required="true")]
		public var numStar: int;
	}
}