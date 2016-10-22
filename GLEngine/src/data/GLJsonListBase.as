package data
{
	import manager.GLConfigManager;

	/**
	 * @author caihua
	 * @comment O/R关系映射 简单持久化
	 * 创建时间：2014-9-3 下午5:33:59 
	 */
	
	public class GLJsonListBase extends GLDataBase
	{
		//配置名
		private var _id:String = "";
		
		public function GLJsonListBase(name:String , _id:String="" , decode:Boolean = true)
		{
			super(name);
			
			if(decode)
			{
				__decode(GLConfigManager.o.getData(name));
			}
		}
		
		public function load():void
		{
			
		}
		
		private function __decode(jsonList:Object):void
		{
			for(var k:* in jsonList)
			{
				setData(k , jsonList[k]);
			}
		}
	}
}