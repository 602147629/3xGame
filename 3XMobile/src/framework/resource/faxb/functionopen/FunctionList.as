package framework.resource.faxb.functionopen
{
	[XmlType(name="FunctionList", propOrder="functionConfig")]
	public class FunctionList
	{
		[XmlElement(name="functionConfig", required="true")]
		public var functionConfig: Vector.<FunctionConfig>;
	}
}