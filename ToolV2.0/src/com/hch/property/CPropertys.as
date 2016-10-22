package com.hch.property
{
	import com.hch.iface.ISerialization;
	import com.hch.util.CFileUtil;
	import com.hch.util.CPackUtils;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	/**
	 * 通用属性基类 
	 * @author caihua
	 * 此类的存储格式为JSON
	 * 
	 * 访问属性的格式为 Propertys.p.xxx 其中 xxx为属性的名称
	 * 其中，设置重复对象的方式为
	 * Propertys.p.xxx = new Array();
	 * Propertys.p.xxx[0] = new Object();
	 * Propertys.p.xxx[0].tt = "cctv";
	 */
	public class CPropertys implements ISerialization
	{
		protected var _p:Object;
		private var _propertyfile:File;
		private var _suffix:String = "\\propertys.txt";
		
		private static var INSTANCE:CPropertys = null;
		
		public function CPropertys()
		{
			_p = new Object();
			_propertyfile = new File(File.applicationStorageDirectory.nativePath + _suffix);
			trace(_propertyfile.nativePath);
		}
		
		public static function getInstance():CPropertys
		{
			if(null == INSTANCE)
			{
				INSTANCE = new CPropertys();
			}
			return INSTANCE;
		}
		
		/**
		 * 保存配置文件 
		 */
		public function save():void
		{
			saveto(_propertyfile);
		}
		
		public function saveto(file:File):void
		{
			var s:String = serialization();
			CFileUtil.FileWriteString(file,s);
		}
		
		public function load():void
		{
			loadfrom(_propertyfile);
		}
		
		public function loadfrom(file:File):void
		{
			var fs:FileStream = new FileStream();
			if(!file.exists)
			{
				fs.open(file,FileMode.WRITE);
				fs.close();
			}
			var bytes:ByteArray = new ByteArray();
			bytes = CFileUtil.FileRead(file);
			bytes.position = 0
			if(bytes.bytesAvailable == 0)
			{
				return;
			}
			unSerialization(bytes.toString());
		}
		
		public function serialization():String
		{
			return JSON.stringify(_p);
		}
		
		public function unSerialization(object:String):void
		{
			_p = JSON.parse(object);
			CPackUtils.unPackettoObject(_p,_p);
		}
		
		/**
		 * 是否具有属性 
		 * @param V 属性名称
		 * @return 
		 */
		public function hasProperty(V:*=null):Boolean
		{
			return _p.hasOwnProperty(V);
		}
		
		public function get propertyContainer():Object
		{
			return _p;
		}
	}
}