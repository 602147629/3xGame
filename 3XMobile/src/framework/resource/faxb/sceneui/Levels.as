package framework.resource.faxb.sceneui
{
	[XmlType(name="levels", propOrder="level")]
	public class Levels
	{
		[XmlElement(name="level", required="true")]
		public var level: Vector.<Level>;
		
		[XmlAttribute(name="y", required="true")]
		public var y: int;
		
		[XmlAttribute(name="x", required="true")]
		public var x: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
	}
}