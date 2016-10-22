package framework.resource.faxb.sceneui
{
	[XmlType(name="level", propOrder="")]
	public class Level
	{
		[XmlAttribute(name="y", required="true")]
		public var y: int;
		
		[XmlAttribute(name="x", required="true")]
		public var x: int;
		
		[XmlAttribute(name="levelIcon", required="true")]
		public var levelIcon: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
	}
}