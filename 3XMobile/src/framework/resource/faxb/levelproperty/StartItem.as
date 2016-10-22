package framework.resource.faxb.levelproperty
{
	[XmlType(name="startItem", propOrder="showItem")]
	public class StartItem
	{
		[XmlElement(name="showItem", required="true")]
		public var showItem: Vector.<ShowItem>;
	}
}