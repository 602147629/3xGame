package com.hch.util
{
	import mx.utils.ObjectUtil;
	
	/**
	 * 装箱助手类 
	 * @author peng.zhi
	 * 
	 */
	public class CPackUtils
	{
		public function CPackUtils()
		{
			
		}
		/**
		 * 赋值每个属性给指定对象
		 * 要求每个属性都具有set get 方法 
		 * 对于只读属性，不包含在其中
		 * @param obj 指定对象
		 * @param output 输出对象
		 * @param includenullValue 是否包含null 对象 默认为T
		 * 
		 */
		public static function packtoObject(obj:Object,output:Object,includenullValue:Boolean = true):void
		{
			var options:Object = new Object();
			options.includeReadOnly = false;
			var classproperties:Array = ObjectUtil.getClassInfo(obj,null,options).properties as Array;
			var n:QName;
			if(includenullValue)
			{
				for each(n in classproperties)
				{
					output[n.localName] = obj[n.localName];
				}
			}
			else
			{
				for each(n in classproperties)
				{
					if(obj[n.localName] != null)
						output[n.localName] = obj[n.localName];
				}
			}
		}
		/**
		 * 简易拆箱函数 
		 * @param srcobj 序列化原对象，
		 * @param destobj 序列化目的对象
		 * @param templatefromsrc T以原对象为模板进行序列号 F以目的对象为模板进行序列化
		 * 注意,为true的时候,一般destobj 为 dynamic class 否则可能引发异常
		 * 
		 */
		public static function unPackettoObject(srcobj:Object,destobj:Object,templatefromsrc:Boolean = true):void
		{
			var options:Object = new Object();
			options.includeReadOnly = false;
			var classproperties:Array;
			if(templatefromsrc)
				classproperties = ObjectUtil.getClassInfo(srcobj,null,options).properties as Array;
			else
				classproperties = ObjectUtil.getClassInfo(destobj,null,options).properties as Array;
			//根据实际对象获得属性
			for each(var n:QName in classproperties)
			{
				destobj[n.localName] = srcobj[n.localName];
			}
			
		}
	}
}