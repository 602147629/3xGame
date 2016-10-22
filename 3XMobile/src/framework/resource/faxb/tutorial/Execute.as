package framework.resource.faxb.tutorial
{
	[XmlType(name="execute", propOrder="showArea,clickGrid,panel")]
	public class Execute
	{
		[XmlElement(name="showArea")]
		public var showArea: Vector.<ShowArea>;
		
		[XmlElement(name="clickGrid")]
		public var clickGrid: ClickGrid;
		
		[XmlElement(name="panel", required="true")]
		public var panel: Vector.<Panel>;
		
		[XmlAttribute(name="type", required="true")]
		public var type: int;
		
		[XmlAttribute(name="isDark", required="true")]
		public var isDark: String;
		
		[XmlAttribute(name="complete", required="true")]
		public var complete: String;
	}
}