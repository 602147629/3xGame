package data
{
	import base.GLBase;

	/**
	 * @author caihua
	 * @comment 数据基类
	 * 创建时间：2014-9-3 下午2:45:40 
	 */
	public class GLDataBase extends GLBase
	{
		protected var _databaseName:String
		protected var _dataContains:Array;
		
		public function GLDataBase(dataName:String)
		{
			super(dataName);
			
			_dataContains = new Array();
		}
		
		public function get databaseName():String
		{
			return _databaseName;
		}
		
		public function setData(key:String ,val:*):void
		{
			_dataContains[key] = val;
		}
		
		public function getData(key:String ,defval:* = null):*
		{
			if(!_dataContains[key])
			{
				return defval;
			}
			
			return _dataContains[key];
		}
		
		public function clear():void
		{
			_dataContains = [];
		}
	}
}