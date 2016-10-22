package framework.util.cacher
{
	import framework.resource.Resource;

	public class BackgroundLoadParameter
	{
		public function BackgroundLoadParameter()
		{
		}
		
		
		public var owner:Resource=null;
		public var frame:String=null;

		
		public function init(owner:Resource, frame:String = "1"):void
		{
			this.owner = owner;
			this.frame = frame;
		}
		
	}
}