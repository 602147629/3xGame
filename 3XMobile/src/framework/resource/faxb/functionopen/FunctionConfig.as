package framework.resource.faxb.functionopen
{
	[XmlType(name="functionConfig", propOrder="")]
	public class FunctionConfig
	{
		[XmlAttribute(name="y", required="true")]
		public var y: int;
		
		[XmlAttribute(name="x", required="true")]
		public var x: int;
		
		[XmlAttribute(name="name", required="true")]
		public var name: String;
		
		[XmlAttribute(name="level", required="true")]
		public var level: int;
		
		[XmlAttribute(name="key", required="true")]
		public var key: String;
		
		[XmlAttribute(name="id", required="true")]
		public var id: int;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
	}
}