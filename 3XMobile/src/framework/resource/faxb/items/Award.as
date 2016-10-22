package framework.resource.faxb.items
{
	[XmlType(name="award", propOrder="")]
	public class Award
	{
		[XmlAttribute(name="time", required="true")]
		public var time: int;
		
		[XmlAttribute(name="step", required="true")]
		public var step: int;
		
		[XmlAttribute(name="refreshMap", required="true")]
		public var refreshMap: String;
		
		[XmlAttribute(name="hp", required="true")]
		public var hp: int;
		
		[XmlAttribute(name="hit", required="true")]
		public var hit: int;
		
		[XmlAttribute(name="changeLevel", required="true")]
		public var changeLevel: String;
	}
}