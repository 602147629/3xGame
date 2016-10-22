package framework.resource.faxb.score
{
	[XmlType(name="root", propOrder="defalutScore,score")]
	public class Scores
	{
		[XmlElement(name="defalutScore", required="true")]
		public var defalutScore: DefalutScore;
		
		[XmlElement(name="score", required="true")]
		public var score: Vector.<Score>;
	}
}