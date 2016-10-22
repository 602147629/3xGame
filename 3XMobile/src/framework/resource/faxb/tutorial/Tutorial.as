package framework.resource.faxb.tutorial
{
	[XmlType(name="Tutorial", propOrder="showArrow,levelTutorial")]
	public class Tutorial
	{
		[XmlElement(name="showArrow", required="true")]
		public var showArrow: Vector.<ShowArrow>;
		
		[XmlElement(name="levelTutorial", required="true")]
		public var levelTutorial: Vector.<LevelTutorial>;
	}
}