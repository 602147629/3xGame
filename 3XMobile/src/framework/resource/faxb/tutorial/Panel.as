package framework.resource.faxb.tutorial
{
	[XmlType(name="panel", propOrder="")]
	public class Panel
	{
		[XmlAttribute(name="panelId", required="true")]
		public var panelId: String;
		
		[XmlAttribute(name="filp", required="true")]
		public var filp: String;
		
		[XmlAttribute(name="x", required="true")]
		public var x: int;
		
		[XmlAttribute(name="y", required="true")]
		public var y: int;
		
		[XmlAttribute(name="width")]
		public var width: int;
		
		[XmlAttribute(name="height")]
		public var height: int;
		
		[XmlAttribute(name="desc", required="true")]
		public var desc: String;
		
		[XmlAttribute(name="showConfirmButton", required="true")]
		public var showConfirmButton: String;
		
		[XmlAttribute(name="callbackFunction", required="true")]
		public var callbackFunction: String;
	}
}