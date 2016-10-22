package framework.model
{
	import framework.fibre.patterns.Proxy;

	/** 
	 * @author melody
	 */	
	
	public class UserInfoProxy extends Proxy
	{
		public static const NAME:String = "userInfoProxy";
		private var _userInfo:UserInfo;
		
		private var _userId:String;
		public function UserInfoProxy()
		{
			super(NAME);
		}
		
		public function get userInfo():UserInfo
		{
			return _userInfo;
		}
		public function set userInfo(value:UserInfo):void
		{
			_userInfo = value;
		}
		public function get userId():String
		{
			return _userId;
		}
		public function set userId(value:String):void
		{
			_userId=value;
		}
	}
}