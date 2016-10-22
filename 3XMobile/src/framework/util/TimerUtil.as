package framework.util
{
	/** 
	 * @author melody
	 */	
	public class TimerUtil
	{
		public function TimerUtil()
		{
		}
		public  static function getCountDownStr(second:Number):String {
			second=Math.max(0,second);
			var txt:String = "";
			var n:uint = 0;
			var minute:uint = 60;
			var hour:uint = 3600;
			if (second >= hour) {
				var h:uint = Math.floor(second / hour);
				var hStr:String = h + ":";
				txt += hStr;
				second = second - h * hour;
				n++;
			}else{
				n++;
				hStr="00" + ":";
				txt += hStr;
			}
			if (second > minute) {
				var m:uint = Math.floor(second / minute);
				var mStr:String = (m < 10 ? "0" + m : m) + ":";
				txt += mStr;
				second = second - m * minute;
				n++;
			} else {
				txt += ("00" + ":");
				n++;
			}
			//Math.round(ms)
			var s:uint = Math.round(second);
			var sStr:String = s < 10 ? "0" + s : s + "";
			txt += sStr;
			
			return txt;
		}
	}
}