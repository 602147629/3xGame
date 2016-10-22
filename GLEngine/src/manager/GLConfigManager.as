package manager
{
	import data.GLDataBase;

	/**
	 * @author caihua
	 * @comment 配置管理器
	 * 创建时间：2014-9-3 下午3:33:51 
	 */
	
	
	public class GLConfigManager extends GLDataBase
	{
		private static var INSTANCE:GLConfigManager = null;
		
		public static function get o():GLConfigManager
		{
			if(INSTANCE == null)
			{
				INSTANCE = new GLConfigManager(new Single());
			}
			return INSTANCE;
		}
		
		public function GLConfigManager(s:Single)
		{
			super("GLConfigManager");
			
			__initConfig();
		}
		
		private function __initConfig():void
		{
			//注册所有的配置表
			
		}
		
		public function registerConfig(key:String , jsonOb:Object):void
		{
			if(getData(key))
			{
				return;
			}
			setData(key, jsonOb);
		}
		
		public function getConfigCls():String
		{
			return "";
		}
	}
}

class Single
{
	
}