package com.ui.util
{
	/**
	 * @author caihua
	 * @comment 工具类
	 * 创建时间：2014-6-26 19:56:24 
	 */
	final public class CStringUtil
	{
		/**
		 * 计算中文字符串字节长度
		 */
		public static function length(str:String):int
		{
			var length:int = 0;
			for(var i:int=0 ; i<str.length ; i++)
			{
				var char:String = str.charAt(i);
				length += char.charCodeAt(0)>255 ? 2:1;
			}
			return length;
		}

		/**
		 * 中文字符串截断，len为字节长度
		 */
		public static function substr(str:String , length:int , suffix:String=""):String
		{
			var substr:String = "";
			var len:int = 0;
			for(var i:int=0 ; i<str.length ; i++)
			{
				var char:String = str.charAt(i);
				len += char.charCodeAt(0)>255 ? 2:1;
				if(len > length)
				{
					return (substr+suffix);
				}
				substr += char;
			}
			return substr;
		}

		/**
		 * 去掉字符串前后的空格
		 */
		public static function trim(char:String):String
		{
			if(null == char)
			{
				return null;
			}
			return CStringUtil.rtrim(CStringUtil.ltrim(char));
		}

		/**
		 * 去掉字符串前面的空格
		 */
		public static function ltrim(char:String):String
		{
			if(null == char)
			{
				return null;
			}
			var pattern:RegExp=/^\s*/;
			return char.replace(pattern,"");
		}

		/**
		 * 去掉字符串后面的空格
		 */
		public static function rtrim(char:String):String
		{
			if(null == char)
			{
				return null;
			}
			var pattern:RegExp=/^\s*$/;
			return char.replace(pattern,"");
		}
		
		/**
		 * 时间转换格式，最小秒
		 */
		public static function s2dhms(interval:int):String
		{
			var day:int = Math.floor(interval / 86400);
			var hour:int = Math.floor((interval - day*3600*24)/3600);
			var minute:int = Math.floor((interval - day * 3600 * 24 - hour * 3600) / 60);
			var second:int = interval - day * 3600 * 24 - hour * 3600-minute*60;
			
			if(day > 0)
			{
				if (0 == hour && 0 == minute && 0 == second)
				{
					return day + "天";
				} 
				else if (0 == minute && 0 == second)
				{
					return day + "天" + hour + "小时";
				}
				else if (0 == second)
				{
					return day + "天" + hour + "小时" + minute + "分";
				}
				else
				{
					return day + "天" + hour + "小时" + minute + "分" + second + "秒";
				}
			}
			else if(hour > 0)
			{
				if (0 == minute && 0 == second)
				{
					return hour+"小时";
				}
				else if (0 == second)
				{
					return hour+"小时"+minute+"分";
				}
				else
				{
					return hour + "小时" + minute + "分" + second + "秒";
				}
			}
			else if(minute > 0)
			{
				if (0 == second)
				{
					return minute + "分钟";
				}
				else
				{
					return minute + "分" + second + "秒";
				}
			}
			else
			{
				return second + "秒";
			}
		}
		
		/**
		 * 时间转换格式，最小秒 mm:ss
		 */
		public static function s2ms(interval:int):String
		{
			var minute:int = Math.floor((interval) / 60);
			var second:int = interval - minute*60;
			
			var result:String = "";
			
			if(minute < 10)
			{
				result += "0" + minute +":";
			}
			else
			{
				result += minute +":";
			}
			if(second < 10)
			{
				result += "0" + second;
			}
			else
			{
				result +=  second;
			}
			
			return result;
		}
		
		/**
		 * 时间转换格式，最小分钟
		 */
		public static function s2dhm(interval:int):String
		{
			var day:int = Math.floor(interval / 86400);
			var hour:int = Math.floor((interval - day*3600*24)/3600);
			var minute:int = Math.ceil((interval - day*3600*24 - hour*3600)/60);
			
			if(day > 0)
			{
				if(0 == minute)
				{
					if (0 == hour || 24 == hour)
					{
						if(24 == hour)
						{
							return (day + 1) +"天";
						}
						return day + "天";
					}
					else
					{
						return day + "天" + hour + "小时";
					}
				}
				else
				{
					if(60 == minute)
					{
						hour = hour+1;
						if(24 == hour)
						{
							return (day+1)+"天";
						}
						return day+"天"+hour+"小时";
					}
					return day+"天"+hour+"小时"+minute+"分钟";
				}
			}
			else if(hour > 0)
			{
				if(0 == minute)
				{
					return hour+"小时";
				}
				else
				{
					if(60 == minute)
					{
						hour = hour + 1;
						if(24 == hour)
						{
							return "1天";
						}
						return hour + "小时";
					}
					return hour+"小时"+minute+"分钟";
				}
			}
			else
			{
				if(0 == minute)
				{
					minute = 1;
				}
				return minute+"分钟";
			}
		}
		
		/**
		 * 数字转换成字符串
		 */
		public static function num2String(num:Number):String
		{
			var numstr:String
			if(num > 0)
			{
				numstr = "+"+String(num);
			}
			else
			{
				numstr = "-"+String(0-num);
			}
			return numstr;
		}
		
		/**
		 * 数字转换成单位
		 */
		public static function num2text(num:Number, minNum:Number=0):String
		{
			if (0 == minNum)
			{
				minNum = 100000;
			}
			var text:String;
			if(num >= minNum)
			{
				text = Math.floor(num/10000) + "万";
			}
			else if (num > 100000000)
			{
				text = Math.floor(num/100000000) + "亿";
			}
			else
			{
				text = String(num);
			}
			return text;
		}
		
		/**
		 * 时区以东八区北京时间为准
		 */
		public static function string2date(str:String):Date
		{
			var strArr:Array = str.split(" ");
			var dateArr:Array = strArr[0].split("-");
			var timeArr:Array = strArr[1].split(":");
			
			var date:Date = new Date();
			var utc:Number = Date.UTC(dateArr[0], int(dateArr[1]) - 1, dateArr[2], timeArr[0], timeArr[1], timeArr[2]);
			var offset:Number = 8 * 60 * 60000;
			date.setTime(utc - offset);
			return date;
		}
		
		/**
		 * 时区以东八区北京时间为准
		 */
		public static function date2string(date:Date):String
		{
			var month:String = String((date.month + 1));
			month = month.length == 1 ? "0" + month : month;
			
			var day:String = String(date.date);
			day = day.length == 1 ? "0" + day : day;
			
			var hours:String = String(date.hours);
			hours = hours.length == 1 ? "0" + hours : hours;
			
			var minutes:String = String(date.minutes);
			minutes = minutes.length == 1 ? "0" + minutes : minutes;
			
			var seconds:String = String(date.seconds);
			seconds = seconds.length == 1 ? "0" + seconds : seconds;
			
			return date.fullYear + "-" + month + "-" + day + " " + hours + ":" + minutes + ":" + seconds;
		}
		
		/**
		 * 是否在同一天
		 */
		public static function inSameDay(left:Date, right:Date):Boolean
		{
			return left.fullYear == right.fullYear && left.month == right.month && left.day == right.day;
		}
		
		/**
		 * 生日得出岁数
		 * @param	str
		 * @return
		 * 
		 */
		public static function birthday2Age(str:String):int
		{
			var birthYear:Number = dateString2date(str).getUTCFullYear();
			var thisYear:Number = (new Date()).getUTCFullYear();
			return int(thisYear - birthYear);
		}
		
		private static function dateString2date(str:String):Date
		{
			var strArr:Array = str.split(" ");
			var dateArr:Array = strArr[0].split("-");
			
			var date:Date = new Date();
			var utc:Number = Date.UTC(dateArr[0], int(dateArr[1]) - 1, dateArr[2]);
			var offset:Number = 8 * 60 * 60000;
			date.setTime(utc - offset);
			return date;
		}
		
		public static function commandParse(command:String):Object
		{
			var res:Object = { };
			if (command == "" || command == null) return res;
			
			var resArr:Array = command.split(",");
			for each(var item:String in resArr)
			{
				var kv:Array = item.split(":");
				res[kv[0]] = kv[1];
			}
			
			return res;
		}
		
		public static function swfUrl2KeyAndVer(swfurl:String):Array
		{
			var idx:int = swfurl.indexOf("-");
			var extidx:int = swfurl.indexOf(".");
			var key:String = swfurl.slice(0, idx);
			
			var ver:String = swfurl.slice(idx+1, extidx);
			key = key.replace(/\//g, '.');
			
			return [key, ver];
		}
		
		public static function splitNumtoStr(num:int):Array
		{
			var arr:Array = [];
			var str:String = num.toString();
			for(var i:int=0;i<str.length;i+=1)
			{
				arr.push(str.slice(i,i + 1));
			}
			return arr;
		}
		
		/**
		 * 0~10 数字转汉字
		 */
		public static function num2cn(num:int):String
		{
			if (num > 10) return "";
			var cn:Array = ["零","一", "二", "三", "四", "五", "六", "七", "八", "九", "十"];
			return cn[num];
		}
	}
}
