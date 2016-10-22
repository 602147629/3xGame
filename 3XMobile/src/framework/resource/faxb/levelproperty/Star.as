package framework.resource.faxb.levelproperty
{
	[XmlType(name="star", propOrder="")]
	public class Star
	{
		[XmlAttribute(name="num", required="true")]
		public var num: int;
		
		[XmlAttribute(name="hp", required="true")]
		public var hp: int;
		
		[XmlAttribute(name="coin", required="true")]
		public var coin: int;
	}
}