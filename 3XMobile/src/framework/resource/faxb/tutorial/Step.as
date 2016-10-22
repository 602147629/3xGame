package framework.resource.faxb.tutorial
{
	[XmlType(name="step", propOrder="execute,completeCondition")]
	public class Step
	{
		[XmlElement(name="startCondition", required="true")]
		public var startCondition: String;
		
		[XmlElement(name="execute", required="true")]
		public var execute: Execute;
		
		[XmlElement(name="completeCondition", required="true")]
		public var completeCondition: CompleteCondition;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
	}
}