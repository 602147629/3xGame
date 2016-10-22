package manager
{
	import data.GLDataBase;
	import data.GLDataOfUser;

	/**
	 * @author caihua
	 * @comment 用户数据管理器
	 * 创建时间：2014-9-3 下午3:33:16 
	 */
	public class GLDataManager extends GLDataBase
	{
		private static var INSTANCE:GLDataManager = null;
		
		public static function get o():GLDataManager
		{
			if(INSTANCE == null)
			{
				INSTANCE = new GLDataManager(new Single());
			}
			return INSTANCE;
		}
		
		public function GLDataManager()
		{
			super("GLDataManager");
			
			__init();
		}
		
		private function __init():void
		{
			__register(new GLDataOfUser());
			
		}
		
		/**
		 * 注册数据
		 */
		private function __register(d:GLDataBase):void
		{
			setData(d.databaseName, d);
		}
		
		/**
		 * 清理用户数据
		 */
		public function clearAll():void
		{
			super.clear();
			__init();
		}
		
		public function get dataOfUser():GLDataOfUser
		{
			return getData("CDataOfUser");
		}
	}
}

class Single
{
	
}