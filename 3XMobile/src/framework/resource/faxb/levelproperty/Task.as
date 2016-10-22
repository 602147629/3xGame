package framework.resource.faxb.levelproperty
{
	[XmlType(name="Task", propOrder="elementDemand")]
	public class Task
	{
		[XmlElement(name="ElementDemand")]
		public var elementDemand: Vector.<ElementDemand>;
		
		[XmlAttribute(name="time", required="true")]
		public var time: int;
		
		[XmlAttribute(name="step", required="true")]
		public var step: int;
		
		[XmlAttribute(name="starNum", required="true")]
		public var starNum: int;
	}
}