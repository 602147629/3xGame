package framework.resource.faxb.levelproperty
{
	[XmlType(name="unlockCondition", propOrder="")]
	public class UnlockCondition
	{
		[XmlAttribute(name="requireLevel", required="true")]
		public var requireLevel: int;
	}
}