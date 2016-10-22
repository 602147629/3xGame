package framework.resource.faxb.levelproperty
{
	[XmlType(name="gameItem", propOrder="item")]
	public class GameItem
	{
		[XmlElement(name="item")]
		public var item: Vector.<Item>;
	}
}