package framework.resource.faxb.levelproperty
{
	[XmlType(name="createItems", propOrder="createElement")]
	public class CreateItems
	{
		[XmlElement(name="createElement")]
		public var createElement: Vector.<CreateElement>;
	}
}