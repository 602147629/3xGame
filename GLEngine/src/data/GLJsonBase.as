package data
{
	/**
	 * @author caihua
	 * @comment 配置基类
	 * 创建时间：2014-9-3 下午4:20:51 
	 */
	import util.JsonUtil;
	
	public class GLJsonBase
	{
		public function GLJsonBase()
		{
		}
		
		public function loadJson(jsonOb:Object):GLJsonBase
		{
			JsonUtil.json2Object(jsonOb,this);
			return this;
		}
	}
}