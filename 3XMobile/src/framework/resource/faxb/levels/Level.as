package framework.resource.faxb.levels
{
	[XmlType(name="level", propOrder="grid")]
	public class Level
	{
		[XmlElement(name="grid", required="true")]
		public var grid: Vector.<Grid>;
		
		[XmlAttribute(name="id", required="true")]
		public var id:int;
		
		[XmlAttribute(name="startLine", required="true")]
		public var startLine:int;
		
		[XmlAttribute(name="maxLine", required="true")]
		public var maxLine:int;
	}
}