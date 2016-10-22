package framework.resource.faxb.award
{
	[XmlType(name="match", propOrder="award")]
	public class MatchInfo
	{
		[XmlElement(name="award", required="true")]
		public var award: Vector.<MatchAward>;
		
		[XmlAttribute(name="shortName", required="true")]
		public var shortName: String;
		
		[XmlAttribute(name="rule", required="true")]
		public var rule: String;
		
		[XmlAttribute(name="name", required="true")]
		public var name: String;
		
		[XmlAttribute(name="matchIcon", required="true")]
		public var matchIcon: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="quick", required="true")]
		public var quick: int;
		
		[XmlAttribute(name="index", required="true")]
		public var index: int;
		
		[XmlAttribute(name="maxRank", required="true")]
		public var maxRank: int;
	}
}