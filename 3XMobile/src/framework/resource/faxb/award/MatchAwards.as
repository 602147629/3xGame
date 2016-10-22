package framework.resource.faxb.award
{
	[XmlType(name="root", propOrder="match")]
	public class MatchAwards
	{
		[XmlElement(name="match", required="true")]
		public var match: Vector.<MatchInfo>;
	}
}