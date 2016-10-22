package framework.resource.faxb.items
{
	[XmlType(name="cost", propOrder="")]
	public class Cost
	{
		[XmlAttribute(name="silver", required="true")]
		public var silver: int;
		
		[XmlAttribute(name="gold", required="true")]
		public var gold: int;
	}
}