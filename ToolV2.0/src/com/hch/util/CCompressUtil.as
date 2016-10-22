package com.hch.util
{
	import flash.utils.ByteArray;

	/**
	 * 文件压缩类 
	 * @author caihua
	 */
	public class CCompressUtil
	{
		public function CCompressUtil()
		{
		}
		/**
		 * 文件压缩类0 
		 * @param srcbytes 数据源二进制数组
		 * @param destbytes 压缩后数据
		 * 
		 */		
		public static function compress(srcbytes:ByteArray,destbytes:ByteArray):void
		{
			srcbytes.position = 0;
			destbytes.clear();
			destbytes.writeBytes(srcbytes);
			destbytes.compress();
			destbytes.position = 0;
		}
		
		public static function uncompress(srcbytes:ByteArray,destbytes:ByteArray):void
		{
			srcbytes.position = 0;
			destbytes.clear();
			destbytes.writeBytes(srcbytes);
			destbytes.uncompress();
			destbytes.position = 0;
		}
	}
}