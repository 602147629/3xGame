package framework.resource.faxb.levelproperty
{
	[XmlType(name="condition", propOrder="")]
	public class Condition
	{
		[XmlAttribute(name="requiresLevel")]
		public var requiresLevel: int;
		
		[XmlAttribute(name="requireAllstar")]
		public var requireAllstar: int;
		
		[XmlAttribute(name="friendHelp")]
		public var friendHelp: int;
	}
}