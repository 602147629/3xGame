package com.hch.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * 文件操作类 
	 * @author caihua
	 */
	public class CFileUtil
	{
		public function CFileUtil()
		{
		}
		
		/**
		 * 获取文件列表 
		 * @param path 文件后缀名称 包括“.",不区分大小写,文件后缀数组
		 * 
		 * @return 
		 * 
		 */
		public static function getFileList(path:File,filter:Array):Array
		{
			var ret:Array = new Array();
			var mfilterArray:Array = new Array();
			for each(var mfilter:String in filter)
			{
				mfilterArray.push(mfilter.toLowerCase());
			}
			_getfilepop(path,ret,mfilterArray);
			return ret;
		}
		
		private static function _getfilepop(path:File,ret:Array,filter:Array):void
		{
			if(!path.isDirectory)/*是文件*/
			{
				var extidx:int = path.nativePath.lastIndexOf(".");
				if(extidx == -1)
					return;
				var ext:String = path.nativePath.substr(extidx).toLowerCase();
				for each(var mfilter:String in filter)
				{
					if(ext == mfilter)
					{
						ret.push(path);
					}
				}
			}
			else
			{
				for each(var f:File in path.getDirectoryListing())
				{
					_getfilepop(f,ret,filter);
				}
			}
		}
		
		/**
		 *  取得路径中的后缀
		 * caihua
		 * 2011年8月18日
		 * @param	路径
		 * @return  null：路径无效，or 后缀，不包含"."
		 */
		public static function getPathExt(path:String):String
		{
			var extidx:int = path.lastIndexOf(".");
			if (extidx == -1)
			{
				return null;
			}
			
			var rtn:String = path.substr(extidx + 1);
			return rtn;
		}
		
		
		/**
		 * 读取文件简单类 
		 * @param file
		 * @return 
		 * 
		 */
		public static function FileRead(file:File,fileMode:String = FileMode.READ):ByteArray
		{
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fs.readBytes(bytes);
			
			fs.close();
			bytes.position = 0;
			return bytes;
		}
		
		public static function FileWriteBytes(file:File,bytes:ByteArray,fileMode:String = FileMode.WRITE):void
		{
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
		}
		public static function FileWriteString(file:File,str:String,fileMode:String = FileMode.WRITE):void
		{
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
		}
		
		/**
		 * 绝对路径 转换应用程序 相对路径 
		 * @param Path 绝对路径
		 * @return 
		 * 
		 */
		public static function AbsolutePath2AppRelativePath(Path:String):String
		{
			var appPath:String = File.applicationDirectory.nativePath;
			var rpath:String = new File(Path).url;
			return null;
		}
		
		/**
		 * CSV文件转换为对象操作,返回的Key全部为小写
		 * 
		 * @param bytes 原始数据流
		 * @param dataStartIndex 数据开始行数
		 * @param TitlesFilter 不区分大小写
		 * @param includeTitle 是否包含标题
		 * @param skipEmpty 是否略过空值的行
		 * @param charSet 字符集
		 * @return 
		 * 
		 */
		public static function CSVToObject(bytes:ByteArray,dataStartIndex:int = 1,TitlesFilter:Array = null,includeTitle:Boolean = true,skipEmpty:Boolean = true,charSet:String = "ANSI"):Object
		{
			var srcString:String = bytes.readMultiByte(bytes.length,charSet);
			var dataArraySrc:Array = srcString.split('\r\n');
			//			var titles:Array = String(dataArraySrc[0]).toLowerCase().split(",");
			var titles : Array = String(dataArraySrc[0]).toLowerCase().split(/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/g);
			var mTitileFiters:Array = null;
			if(TitlesFilter != null)
			{
				mTitileFiters = new Array();
				for each( var filter:String in TitlesFilter)
				{
					mTitileFiters.push(filter.toLowerCase());
				}
			}
			
			var dataArrayOut:Array = new Array();
			//			最后一行为空
			for(var i:int=dataStartIndex;i<dataArraySrc.length;i++)
			{
				var obj:Object = new Object();
				
				var dataArray2:Array = dataArraySrc[i].split(/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/g);
				
				
				//标题数量和值数量不匹配,增不添加
				if(titles.length != dataArray2.length)
					continue;
				
				//第一个值为空,则不添加
				if(skipEmpty && dataArray2[0]=="")
					continue;
				
				//本行数据为注释行
				if(dataArray2[0].indexOf("#") == 0)
				{
					continue;
				}
				for(var j:int = 0;j<dataArray2.length;j++)
				{
					if(mTitileFiters == null || mTitileFiters.lastIndexOf(titles[j])!= -1)
					{
						
						//						String(dataArray2[j]).replace("\"\"","\"
						//去除收尾引号
						if(String(dataArray2[j]).charAt(0) == "\"")
						{
							dataArray2[j] = String(dataArray2[j]).substr(1,String(dataArray2[j]).length - 2);
							//转换"" 为 " 去除"
							dataArray2[j] = String(dataArray2[j]).replace(/\"\"/g,"\"");
						}
						if(dataArray2[j] != "")
						{
							obj[titles[j]] = dataArray2[j];
						}
					}
				}
				dataArrayOut.push(obj);
				
			}
			return dataArrayOut;
		}
		
		
		/**
		 * 生成属性class 
		 * @param classname
		 * @param propertys
		 * @return 
		 * 
		 */
		public static function GenPropertyClass(packname:String,classname:String,propertys:Array):String
		{
			var outStringArr:Array = new Array();
			var outstring:String = "";
			outstring += "package "+packname+"\n";
			outstring +="{\n	import engine_starling.data.SDataBaseJson;\n";
			outstring +="	public class " + classname + " extends SDataBaseJson\n";
			outstring +="	{\n";
			outstring +="		public function " + classname + "()\n";
			outstring +="		{\n";
			
			outstring +="			_propertys.push(";
			for each(var property:String in propertys)
			{
				outStringArr.push("\"" + property + "\"");
				
			}
			outstring += outStringArr.join();
			outstring +=");\n"
			outstring +="		}\n";
			
			for each (var property:String in propertys)
			{
				outstring += _GenProperty(property);
				outstring += "\n";
			}
			outstring +="	}\n";
			outstring +="}\n";
			
			return outstring;
			
		}
		
		private static function _GenProperty(propertyname:String):String
		{
			var outstring:String = "		private var _" + propertyname +":* = null;\n";
			outstring += "		public function get "+ propertyname +"():*{return _" + propertyname + ";}\n";
			outstring += "		public function set "+ propertyname +"(value:*):void{_" + propertyname + "=value;}\n";
			return outstring;
		}
		
		
		public static function GenPythonClass(classname:String,propertys:Array):String
		{
			var outstring:String = "";
			//			outstring +="# -*- coding: utf-8 -*-\n";
			//			outstring +="# gen by tools\n";
			outstring +="from datas.ADBJSON import ADBJsonBase\n";
			outstring +="class "+classname+"(ADBJsonBase):\n";
			outstring +="	def __init__(self,configdict = None):\n";
			outstring +="		ADBJsonBase.__init__(self)\n";
			for each (var property:String in propertys)
			{
				outstring +="		self._"+property+"  = None\n";
			}
			outstring +="		if configdict != None:\n";
			outstring +="			self.loadfromdict(configdict)\n";
			return outstring;
		}
		
		
		/**
		 * 导出CSV到JSON文件
		 * @param bytes
		 * @param suffix 文件后缀类型  c客户端 s服务端
		 * @param dataStartIndex 数据开始行数
		 * @param exported_title 本次导出的字段名
		 * @param charSet 字符集
		 * @return 
		 */
		public static function ExportCSVToJson(bytes:ByteArray,suffix:String,dataStartIndex:int = 1,exported_title:Array = null,charSet:String = "ANSI"):Object
		{
			var srcString:String = bytes.readMultiByte(bytes.length,charSet);
			var dataArraySrc:Array = srcString.split('\r\n');
			//			var titles:Array = String(dataArraySrc[0]).toLowerCase().split(",");
			var titles : Array = String(dataArraySrc[0]).toLowerCase().split(/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/g);
			var mTitileFiters:Array = null;
			var skipEmpty:Boolean = true;
			var length:int = 0;
			if(suffix != null)
			{
				
				//填充本次要导出的列名
				//				获取列名后缀
				mTitileFiters = new Array();
				length = titles.length;
				for (var i:int = 0;i<length;i++)
				{
					//包含_后缀
					if((titles[i] as String).split("$").length>1)
					{
						var mtitlesuffix:String = (titles[i] as String).split("$").pop().toLowerCase();
						if(mtitlesuffix.indexOf(suffix)!= -1)
						{
							mTitileFiters.push(titles[i]);
							
							if(exported_title != null)
								exported_title.push((titles[i] as String).replace("$cs","").replace("$sc","").replace("$c","").replace("$s",""));
						}
					}
					
				}
				
				//
				
			}
			
			var dataArrayOut:Array = new Array();
			//			最后一行为空
			var endofdouhao:Boolean = false;
			for(var i:int=dataStartIndex;i<dataArraySrc.length;i++)
			{
				var obj:Object = new Object();
				var str:String = dataArraySrc[i];
				
				//修复csv末尾逗号问题
				if (str.lastIndexOf(',') != str.length - 1)
				{
					str+=',';
				}
				
				var dataArray2:Array = str.split(/,(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))/g);
				
				//数据是否有效
				var objvaild:Boolean = false;
				if (dataArray2.length == titles.length + 1)
				{
					dataArray2.pop();
				}
				//标题数量和值数量不匹配,增不添加
				if(titles.length != dataArray2.length)
					continue;
				
				//第一个值为空,则不添加
				if(skipEmpty && dataArray2[0]=="")
					continue;
				
				//本行数据为注释行
				if(dataArray2[0].indexOf("#") == 0)
				{
					continue;
				}
				
				for(var j:int = 0;j<dataArray2.length;j++)
				{
					if(mTitileFiters == null || mTitileFiters.lastIndexOf(titles[j])!= -1)
					{						
						//						String(dataArray2[j]).replace("\"\"","\"
						//去除收尾引号
						if(String(dataArray2[j]).charAt(0) == "\"")
						{
							dataArray2[j] = String(dataArray2[j]).substr(1,String(dataArray2[j]).length - 2);
							//转换"" 为 " 去除"
							dataArray2[j] = String(dataArray2[j]).replace(/\"\"/g,"\"");
						}
						
						
						if(dataArray2[j] != "")
						{
							//去除 _c _cs _s....
							var realtitle:String = (titles[j] as String).replace("$cs","").replace("$sc","").replace("$c","").replace("$s","");
							obj[realtitle] = dataArray2[j];
							objvaild = true;
						}
					}
					
				}
				if(objvaild)
				{
					dataArrayOut.push(obj);
				}
				
			}
			return dataArrayOut;
		}
	}
}