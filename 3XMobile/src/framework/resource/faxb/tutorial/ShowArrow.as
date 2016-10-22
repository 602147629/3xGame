package framework.resource.faxb.tutorial
{
	[XmlType(name="showArrow", propOrder="showArea")]
	public class ShowArrow
	{
		[XmlElement(name="showArea")]
		public var showArea: Vector.<ShowArea>;
		
		[XmlAttribute(name="levelId", required="true")]
		public var levelId: int;
		
		[XmlAttribute(name="callbackFunction", required="true")]
		public var callbackFunction: String;
	}
}