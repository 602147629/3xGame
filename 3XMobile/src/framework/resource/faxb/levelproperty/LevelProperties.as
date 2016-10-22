package framework.resource.faxb.levelproperty
{
	[XmlType(name="root", propOrder="levels")]
	public class LevelProperties
	{
		[XmlElement(name="levels", required="true")]
		public var levels: Vector.<Levels>;
		
		[XmlAttribute(name="version", required="true")]
		public var version: Number;
	}
}