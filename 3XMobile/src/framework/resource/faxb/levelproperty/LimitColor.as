package framework.resource.faxb.levelproperty
{
	[XmlType(name="limitColor", propOrder="colors")]
	
	public class LimitColor
	{
		[XmlElement(name="color")]
		public var colors: Vector.<Color>;
	}
}