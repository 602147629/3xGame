package framework.resource.faxb.levelproperty
{
	[XmlType(name="conditionOrs", propOrder="condition")]
	public class ConditionOrs
	{
		[XmlElement(name="condition", required="true")]
		public var condition: Condition;
	}
}