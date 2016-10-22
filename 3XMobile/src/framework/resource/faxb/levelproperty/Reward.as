package framework.resource.faxb.levelproperty
{
	[XmlType(name="reward", propOrder="star")]
	public class Reward
	{
		[XmlElement(name="star", required="true")]
		public var star: Vector.<Star>;
	}
}