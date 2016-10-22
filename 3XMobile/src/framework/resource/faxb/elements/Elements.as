package framework.resource.faxb.elements
{
	[XmlType(name="Root", propOrder="element")]
	public class Elements
	{
		[XmlElement(name="element", required="true")]
		public var element: Vector.<Element>;
	}
}