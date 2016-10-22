package framework.resource.faxb.levelproperty
{
	[XmlType(name="level", propOrder="unlockCondition,createItems,startItem,gameItem,task,score,reward,failCondition,limitColor")]
	public class Level
	{
		[XmlElement(name="unlockCondition", required="true")]
		public var unlockCondition: UnlockCondition;
		
		[XmlElement(name="limitColor", required="false")]
		public var limitColor: LimitColor;
				
		
		[XmlElement(name="createItems", required="true")]
		public var createItems: CreateItems;
		
		[XmlElement(name="startItem", required="true")]
		public var startItem: StartItem;
		
		[XmlElement(name="gameItem", required="true")]
		public var gameItem: GameItem;
		
		[XmlElement(name="Task", required="true")]
		public var task: Task;
		
		[XmlElement(name="Score", required="true")]
		public var score: Score;
		
		[XmlElement(name="reward", required="true")]
		public var reward: Reward;
		
		[XmlElement(name="failCondition", required="true")]
		public var failCondition: FailCondition;
		
		[XmlAttribute(name="type", required="true")]
		public var type: int;
		
		[XmlAttribute(name="startDesc", required="true")]
		public var startDesc: String;
		
		[XmlAttribute(name="starIcon", required="true")]
		public var starIcon: int;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="hp", required="true")]
		public var hp: int;
		
		[XmlAttribute(name="failIcon", required="true")]
		public var failIcon: int;
		
		[XmlAttribute(name="failDesc", required="true")]
		public var failDesc: String;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
		
		[XmlAttribute(name="coin", required="true")]
		public var coin: int;
		
		[XmlAttribute(name="backgroundImage", required="true")]
		public var backgroundImage:String;
		
		[XmlAttribute(name="createJellyMaxNum", required="false")]
		public var createJellyMaxNum:int;
		
		[XmlAttribute(name="jellyLeaveStep", required="false")]
		public var jellyLeaveStep:int;
		
		[XmlAttribute(name="clockLeaveStep", required="false")]
		public var clockLeaveStep:int;
		
		[XmlAttribute(name="isHasBoat", required="false")]
		public var isHasBoat:String;
		
		[XmlAttribute(name="isRandomMap", required="false")]
		public var isRandomMap:String;
		
		
	}
}