package framework.resource.faxb.starreward
{
	[XmlType(name="root", propOrder="levels")]
	public class StarReward
	{
		[XmlElement(name="levels", required="true")]
		public var levels: Vector.<Levels>;
		
		[XmlAttribute(name="version", required="true")]
		public var version: Number;
	}
}