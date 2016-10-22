package framework.resource.faxb.levelproperty
{
	[XmlType(name="levels", propOrder="conditionOrs,conditionRequires,level")]
	public class Levels
	{
		[XmlElement(name="conditionOrs", required="true")]
		public var conditionOrs: ConditionOrs;
		
		[XmlElement(name="conditionRequires", required="true")]
		public var conditionRequires: ConditionRequires;
		
		[XmlElement(name="level", required="true")]
		public var level: Vector.<Level>;
		
		[XmlAttribute(name="unlockSilver", required="true")]
		public var unlockSilver: int;
		
		[XmlAttribute(name="unlockGold", required="true")]
		public var unlockGold: int;
		
		[XmlAttribute(name="startlevel", required="true")]
		public var startlevel: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="endlevel", required="true")]
		public var endlevel: int;
	}
}