package framework.resource.faxb.elements
{
	[XmlType(name="element", propOrder="")]
	public class Element
	{
		[XmlAttribute(name="picType", required="true")]
		public var picType: int;
		
		[XmlAttribute(name="overrideType", required="true")]
		public var overrideType: String;
		
		[XmlAttribute(name="objectType", required="true")]
		public var objectType: int;
		
		[XmlAttribute(name="level", required="true")]
		public var level: int;
		
		[XmlAttribute(name="layer", required="true")]
		public var layer: int;
		
		[XmlAttribute(name="isMove", required="true")]
		public var isMove: String;
		
		[XmlAttribute(name="addStep", required="true")]
		public var addStep:int;
		
		//普通消除包括 三消 四消 LT消 五消 和四级与一级交换后被清除的所有一级消除体
		[XmlAttribute(name="isCrossDeleted", required="true")]
		public var isCrossDeleted: String;
		
		[XmlAttribute(name="isCrossDeletedBySpecialBomb", required="true")]
		public var isCrossDeletedBySpecialBomb: String;
		
		[XmlAttribute(name="isDeleted", required="true")]
		public var isDeleted: String;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="direct", required="true")]
		public var direction: int;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
		
		[XmlAttribute(name="canOverided", required="true")]
		public var canOverided: String;
		
		[XmlArrtribute(name="awardSilver", required="true")]
		public var awardSilver:int;
		
		
		
		
		
	}
}