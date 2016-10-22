package base
{
	/**
	 * @author caihua
	 * @comment 对象的基类
	 * 创建时间：2014-9-3 下午2:47:20 
	 */
	public class GLBase extends Object
	{
		private var _obName:String
		public function GLBase(obName:String)
		{
			_obName = obName;
			super();
		}

		public function get obName():String
		{
			return _obName;
		}
	}
}