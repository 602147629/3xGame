package framework.util
{
	public class MathUtil
	{
		public function MathUtil()
		{
		}
		
		public static function distance(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			return Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));	
		}
		
		public static function scope(value:int, min:int, max:int):int
		{
			if(value < min)
				return min;
			else if(value > max)
				return max;
			else
				return value;
		}
		
		public static function scopeFloat(value:Number, min:Number, max:Number):Number
		{
			if(value < min)
				return min;
			else if(value > max)
				return max;
			else
				return value;
		}
		
		public static function calcDistanceOfUniformlyAcceleratedMotion(v:Number, t:Number, a:Number):Number
		{
			return v * t + 0.5 * a * t * t;
		}
		
		public static function shiftPrecision(v:Number, precision:int):Number
		{
			var vs:String = v.toFixed(precision);
			return Number(vs);
		}
	}
}