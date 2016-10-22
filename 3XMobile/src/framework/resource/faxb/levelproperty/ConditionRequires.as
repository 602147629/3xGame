package framework.resource.faxb.levelproperty
{
	[XmlType(name="conditionRequires", propOrder="condition")]
	public class ConditionRequires
	{
		[XmlElement(name="condition", required="true")]
		public var condition: Condition;
	}
}