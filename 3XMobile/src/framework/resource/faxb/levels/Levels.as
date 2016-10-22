package framework.resource.faxb.levels
{
	[XmlType(name="Levels", propOrder="level")]
	public class Levels
	{
		[XmlElement(name="level", required="true")]
		public var level: Vector.<Level>;
	}
}