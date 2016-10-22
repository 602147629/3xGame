package util
{
	import mx.utils.ObjectUtil;

	/**
	 * @author caihua
	 * @comment json序列化
	 * 创建时间：2014-9-3 下午4:49:19 
	 */
	public class JsonUtil
	{
		/**
		 * json对象序列化到class对象
		 */
		public static function json2Object(jsonSrc:Object , ob:Object , useTemplate:Boolean = false):void
		{
			var options:Object = new Object();
			options.includeReadOnly = false;
			var classproperties:Array;
			if(useTemplate)
			{
				classproperties = ObjectUtil.getClassInfo(jsonSrc , null , options).properties as Array;
			}
			else
			{
				classproperties = ObjectUtil.getClassInfo(ob , null , options).properties as Array;
			}
			
			var length:int = classproperties.length;
			var n:QName;
			for(var i:int =0;i<length;++i)
			{
				n = classproperties[i];
				if(jsonSrc.hasOwnProperty(n.localName))
				{
					ob[n.localName] = jsonSrc[n.localName];
				}
				else
				{
					ob[n.localName] = null;
				}
			}
		}
	}
}