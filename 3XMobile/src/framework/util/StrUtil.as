

package framework.util
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import framework.text.LangProxy;

	public class StrUtil
	{
		public static const SLASH_CHAR : String = "/";
		
		
		public function StrUtil()
		{
		}
		
		public static function splitLast(s:String, sep:String, conclude:int=-1):Array
		{
			var i:int = s.lastIndexOf(sep);
			if(i == -1)
				return new Array(s, "");
			else
				return new Array(s.substring(0, i + (conclude == 0 ? 1 : 0)), 
								s.substring(i + (conclude == 1 ? 0 : 1), s.length));
		}
		
		public static function endsWith(s:String, end:String):Boolean
		{
			if(end == null || end.length == 0)
				return false;
				
			return s.lastIndexOf(end) == s.length - end.length;
		}
		public static function formatfloating(n:Number):String
		{
			var str:String = n+"";
			var index:int = str.indexOf(".");
			
			if(index == -1)
			{
				return str + ".0";
			}
			
			return str.substring(0,index + 2);
		}
		
		
		public static function formatTimeByMinSec(second:int):String
		{
			var str:String;
			
			var min:String = String(int(second/60));
			var sec:String = String(int(second%60));
			
			if(sec.length == 1)
			{
				sec = "0" + sec;
			}
			
			if(min.length == 1)
			{
				min = "0" + min;
			}
			
			
			str = min + ":" + sec;
			return str;	
		}
		
		
		
		// days ,hour
		// hour, min
		// min, sec
		public static function formatTimeOnly2Number(s:int):String
		{
			if(s >= 3600 * 24)
			{
				return StrUtil.formatTimeCurrentLang(s,true,false);
			}
			else if(s >= 3600)
			{
				return StrUtil.formatTimeCurrentLang(s,false,false);
			}
			else
			{
				return StrUtil.formatTimeCurrentLang(s,false,true);
			}
			return "";
		}
		
		public static function formatTimeCurrentLangSmartLen(s:int,withSecond:Boolean = true):String
		{
			if(s >= 3600 * 24)
			{
				return StrUtil.formatTimeCurrentLang(s,true,withSecond);
			}
			else
			{
				return StrUtil.formatTimeCurrentLang(s,false,withSecond);
			}
			return "";
		}
		
		
		public static function formatTimeShortStyleSmartLen(s:int):String
		{
			if(s >= 3600 * 24)
			{
				return StrUtil.timeToString(s,true);
			}
			else
			{
				return StrUtil.timeToString(s,false);
			}
			return "";
		}
		
		
		
		public static const TIME_LANG:Object = {
			en_1day:"1 day",
			en_days:" days",
			en_1hr:"1 hr",
			en_hrs:" hrs",
			en_1min:"1 min",
			en_mins:" mins",
			en_1sec:"1 sec",
			en_secs:" secs",
			en_0sec:"0 sec",
			
			de_1day:"1 Tag",
			de_days:" Tage",
			de_1hr:"1 Std.",
			de_hrs:" Std.",
			de_1min:"1 Min.",
			de_mins:" Min.",
			de_1sec:"1 Sek.",
			de_secs:" Sek.",
			de_0sec:"0 Sek.",
			
			fr_1day:"1 jr",
			fr_days:" jrs",
			fr_1hr:"1 hr",
			fr_hrs:" hrs",
			fr_1min:"1 min",
			fr_mins:" mins",
			fr_1sec:"1 sec",
			fr_secs:" secs",
			fr_0sec:"0 sec"
			
		};
		
		public static const TIME_LANG_SINGLE_WORD:Object = {
			en_d:"d",
			en_h:"h",
			en_m:"m",
			en_s:"s",
			
			de_d:"t",
			de_h:"s",
			de_m:"m",
			de_s:"s",
			
			fr_d:"j",
			fr_h:"h",
			fr_m:"m",
			fr_s:"s"
		};
		
		public static const NUMBER_LANG_DECOLLATOR:Object = {
			en:",",
			de:".",
			fr:" "
		}
		
		private static function currentSupportTimeLang():String
		{
			if( LangProxy.instance.getCurrentLanguage() == "fr"
			|| LangProxy.instance.getCurrentLanguage() == "de"
			)
				return LangProxy.instance.getCurrentLanguage();
			
			return "en";
		}
		
		private static function currentSupportTimeLangText(key:String):String
		{
			var k:String = currentSupportTimeLang();
			return TIME_LANG[k + "_" + key ];
		}
		
		private static function currentSupportTimeLangShortText(key:String):String
		{
			var k:String = currentSupportTimeLang();
			return TIME_LANG_SINGLE_WORD[k + "_" + key ];
		}
		
		private static function currentSupportNumberLangDecollator():String
		{
			var k:String = currentSupportTimeLang();
			return NUMBER_LANG_DECOLLATOR[k];
		}
		
		public static function getRawTimeStr(second:Number):String
		{
			var str:String;
			//60*60*24*365年
			//60*60*24*30月
			//60*60*24日
			//60*60时
			//60分
			var y:int =  Math.round(second/31536000);
			if(y > 0 )
			{
				return y + "年";
			}
			var m:int = Math.round(second/2592000);
			if(m > 0 )
			{
				return m + "月";
			}
			var d :int = Math.round(second/86400);
			if(d > 0 )
			{
				return d + "天";
			}
			var h :int = Math.round(second/3600);
			if(h > 0 )
			{
				return h + "小时";
			}
			var min :int = Math.round(second/60);
			if(min > 0 )
			{
				return min + "分钟";
			}
			return Math.round(second) + "秒";
		}
		
		public static function formatTimeCurrentLang(s:int, onlyDayHour:Boolean = false, withSecond:Boolean = true, useHourInsteadOfDay:Boolean = false):String
		{
			var text:String = "";
			var left:int = s;
			
			var day:int = 0;
			if(!useHourInsteadOfDay)
			{
				day = int(left / (3600 * 24));
				left = left % (3600 * 24);
			}
			
			var hour:int = int(left / 3600);
			left = left % 3600;
			var min:int = int(left / 60);
			left = left % 60;
			var sec:int = left;
			
			if(day == 1)
			{
				text += " ";
				text += currentSupportTimeLangText("1day");
			}
			else if(day > 1)
			{
				text += " ";
				text += day + currentSupportTimeLangText("days");
			}
			
			if(hour == 1)
			{
				text += " ";
				text += currentSupportTimeLangText("1hr");
			}
			else if(hour > 1)
			{
				text += " ";
				text += hour + currentSupportTimeLangText("hrs");
			}
			
			if(onlyDayHour)
			{
				return text;
			}
			
			if(min == 1)
			{
				text += " ";
				text += currentSupportTimeLangText("1min");
			}
			else if(min > 1)
			{
				text += " ";
				text += min + currentSupportTimeLangText("mins");
			}
			
			
			if(withSecond)
			{
				if(sec == 1)
				{
					text += " ";
					text += currentSupportTimeLangText("1sec");
				}
				else if(sec > 1)
				{
					text += " ";
					text += sec + currentSupportTimeLangText("secs");
				}
				
				if(s == 0)
				{
					text = currentSupportTimeLangText("0sec");
				}
			}
			
			return text;
		}
		
		public static function watchInfo(o:*,level:int, prefix:String):String
		{
			var info:String = "";
			
			if(level >= 6)
			{
				info += prefix + "TOO DEEP";
				info +="\r\n";
				return info;
			}
			
			if(o == null)
			{
				return prefix + "null\r\n";
			}
			
			var i:int;
			if(o is Array)
			{
				info += prefix + "(Array length: " + o.length +")\r\n";
				for(i = 0; i < o.length ; i++)
				{
					info += prefix + "(Array element:" + i + ")\r\n";
					info +=  watchInfo(o[i],level,prefix + "--");
				}
				return info;
			}
			else if(getQualifiedClassName(o).indexOf("::") == -1 || getQualifiedClassName(o).indexOf("flash.") == 0)// top level classes or built-in classes
			{
				info += prefix + o.toString() + "\r\n";
				return info;
			}
			
			var data : XML = describeType(o);
			if(data.variable.length() == 0)// || "rpc.simcity.audit")
			{
				info += prefix + String(o);
				info +="\r\n";
			}
			
			var type:String;
			var name:String;
			for each(var variable : XML in data.variable)
			{
				type = variable.@type;
				name =  variable.@name;
				var value:* = o[name];
				
				//no recurrence
				if(type.indexOf("::") == -1
					&& type!="Array"
				)
				{
					info += prefix + type +" "+name + " = " + value;
					info +="\r\n";
				}
					//go on recurrence
				else
				{
					info += prefix + type +" "+ name;
					if(value)
					{
						info +="\r\n";
						info +=  watchInfo(value,level + 1,prefix + "--");
						
					}
					else
					{
						info += " = " + value + "\r\n";
					}
				}
			}
			
			for each(var accessor:XML in data.accessor)
			{
				name = accessor.@name;
				
				try
				{
					if(o[name] != null)
					{
						info += prefix + name + " = " + o[name].toString() + "\r\n";
					}
				}catch(e:Error)
				{
					
				}
			}
			
			return info;
		}
		
		public static function formatNumber(n:*):String
		{
			if (n == null)
			{
				return "0";
			}	
			
			var str:String = String(n);
			
			var returnStr:String;
			
			var num:int = 0;
			var arr:Array = [];
			
			for (var i:int = str.length-1 ; i >= 0 ; i-- )
			{
				var index:int = (str.length - 1) - i;
				if (index % 3 == 0 && index!=0)
				{
					num ++;
					arr.push(i);
				}
			}
			
			for(var j:int = 0; j< num;j++)
			{
				returnStr = str.slice(0, arr[j]+1 ) + currentSupportNumberLangDecollator() +str.slice(arr[j]  + 1  );
				str = returnStr;
			}
			
			if (returnStr == null)
			{
				returnStr = str;
			}
			
			return returnStr;
		}
		
		public static function parseTime(s:String):int
		{
			var len:int = s.length;
			var start:int = 0;
			var total:int = 0;
			var mul:int = 0;
			for(var i:int=0; i<len; i++)
			{
				if(s.charAt(i) == "m")
					mul = 60;
				else if(s.charAt(i) == "h")
					mul = 3600;
				else if(s.charAt(i) == "s")
					mul = 1;
				
				if(mul != 0)
				{
					total += int(s.substring(start, i)) * mul;
					start = i+1;
					mul = 0;
				}
			}
			if(total == 0)
			{
				total = isNaN(int(s)) ? 0 : int(s);
			}
			return total * 1000;
		}
		
		public static function timeToString(sec:int,onlyDayHour:Boolean = false):String
		{
			var day:int = sec / (3600 * 24);
			sec -= day * (3600 * 24);
			var hour:int = sec / 3600;
			sec -= hour * 3600;
			var min:int = sec / 60;
			sec -= min * 60;
			
			var ret:String = "";
			
			if(day > 0)
			{
				ret += day + currentSupportTimeLangShortText("d");
			}
			if(hour > 0)
			{
				if(day > 0)
				{
					ret += " ";
				}
				ret += hour + currentSupportTimeLangShortText("h");
			}
			
			if(onlyDayHour)
			{
				return ret;
			}
			
			if(min > 0)
			{
				if(hour > 0 || day > 0)
				{
					ret += " ";
				}
				ret += min + currentSupportTimeLangShortText("m");
			}
			if(sec > 0)
			{
				if(hour > 0 || min > 0 || day > 0)
				{
					ret += " ";
				}
				ret += sec + currentSupportTimeLangShortText("s");
			}
			return ret;
		}
		public static function timeToStringM(sec:int):String
		{
			var hour:int = sec / 3600;
			sec -= hour * 3600;
			var min:int = sec / 60;
			sec -= min * 60;
			
			
			var ret:String = "";
			if(hour<10)
			{
				ret+="0";
			}
			ret += hour+":";
			if(min<10)
			{
				ret+="0";
			}
			ret += min+":";
			if(sec<10)
			{
				ret+="0";
			}
			ret += sec;
			return ret;
		}
		
		
		public static function replace(source:String,target:String,content:String):String
		{
			while(source.indexOf(target)!=-1)
			{
				source=source.replace(target,content);
			}
			return source;
		}
		
		public static function generateParameterStringForHttpURL(parameterObject:Object, withQuestionMark:Boolean = false):String
		{
			var parameterString:String = "";
			if(parameterObject != null)
			{
				for(var key:String in parameterObject)
				{
					parameterString += "&" + key + "=" + parameterObject[key];
				}
				if(parameterString != "")
				{
					parameterString = parameterString.substr(1);
					if(withQuestionMark)
					{
						parameterString = "?" + parameterString;
					}
				}
			}
			return parameterString;
		}
	}
}