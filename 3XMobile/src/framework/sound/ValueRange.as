package framework.sound
{
	import framework.types.helpers.StringUtils;
	

	public class ValueRange
	{
		private var min:Number;
		private var max:Number;
		
		private var value:Number;
		
		public function ValueRange(min:Number, max:Number)
		{
			this.min = min;
			this.max = max;
			
			if (min > max)
			{
				trace("ALERT: Min value is greater than max value: " + toString());
			}
			
			randomize();
		}
		
		public function randomize() : void
		{
			if (max == min)
			{
				value = min;
			}
			else
			{
				value = Math.random()*(max-min) + min;
			}
		}
		
		public function getValue() : Number
		{
			return value;
		}

		public function multiplyBy(number:Number):void
		{
			min *= number;
			max *= number;
		}
		
		public function add(number:Number) : void
		{
			min += number;
			max += number;
		}

		public static function makeFromString(value:String):ValueRange
		{
			if (StringUtils.isNullOrEmpty(value))
			{
				return new ValueRange(0,0);
			}
			else
			{
				var rangeStrings:Array = value.split("-");
				var min:Number = rangeStrings[0];
				var max:Number = rangeStrings.length > 1 ? rangeStrings[1] : min;
				return new ValueRange(min, max);
			}
		}
		
		public function toString() : String
		{
			return min + "," + max;
		}
	}
}