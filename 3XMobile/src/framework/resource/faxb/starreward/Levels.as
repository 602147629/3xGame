package framework.resource.faxb.starreward
{
	[XmlType(name="levels", propOrder="items")]
	public class Levels
	{
		[XmlElement(name="items")]
		public var items: Items;
		
		[XmlAttribute(name="star", required="true")]
		public var star: int;
		
		[XmlAttribute(name="silver", required="true")]
		public var silver: int;
		
		[XmlAttribute(name="level", required="true")]
		public var level: int;
		
		[XmlAttribute(name="gold", required="true")]
		public var gold: int;
	}
}