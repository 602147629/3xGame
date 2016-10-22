package framework.resource.faxb.tutorial
{
	[XmlType(name="completeCondition", propOrder="")]
	public class CompleteCondition
	{
		[XmlAttribute(name="clickSkipButton", required="true")]
		public var clickSkipButton: String;
		
		[XmlAttribute(name="delayTime", required="true")]
		public var delayTime: int;
		
		[XmlAttribute(name="moveGrid", required="true")]
		public var moveGrid: String;
		
		[XmlAttribute(name="clickConfirmButton", required="true")]
		public var clickConfirmButton: String;
	}
}