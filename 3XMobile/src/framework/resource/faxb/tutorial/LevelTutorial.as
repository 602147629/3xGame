package framework.resource.faxb.tutorial
{
	[XmlType(name="levelTutorial", propOrder="step")]
	public class LevelTutorial
	{
		[XmlElement(name="step", required="true")]
		public var step: Vector.<Step>;
		
		[XmlAttribute(name="levelId", required="true")]
		public var levelId: int;
	}
}