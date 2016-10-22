package framework.resource.faxb.sceneui
{
	[XmlType(name="root", propOrder="levels")]
	public class SceneConfig
	{
		[XmlElement(name="levels", required="true")]
		public var levels: Vector.<Levels>;
	}
}