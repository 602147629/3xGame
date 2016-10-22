package framework.model
{
	import framework.fibre.patterns.Proxy;
	
	public class CurrentUserProxy extends Proxy
	{
		public static const CURRENT_USER_PROXY_TICK:String = "CURRENT_USER_PROXY_TICK";

		public static const NAME:String = "CurrentUserProxy";
		
		public var dataInited:Boolean = false;
	
		public var currentUserExpLevel:int;
		
		private static var _instance:CurrentUserProxy;


		
//		private var _lastExpLevel:int;

		public function CurrentUserProxy()
		{
			_instance = this;
			super(NAME);
		}

		public static function get instance() : CurrentUserProxy
		{
			return _instance;
		}
		
		public function startGame():void
		{
			if(dataInited == false)
			{
				GameEngine.getInstance().showAllLayer();
				

				dataInited = true;
			}
		}
		
		override public function tickObject(psdTickMs:Number):void
		{
			
		}
		
		
		
	}
}


