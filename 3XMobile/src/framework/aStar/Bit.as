package framework.aStar
{
	public class Bit
	{
		public static function setBit(target:uint, index:int, value:Boolean):uint
		{
			if(value)
			{
				target = target | (1 << index);
			}
			else
			{
				target = target & ~(1 << index);
			}
			return target;
		}
		
		public static function getBit(target:uint, index:int):Boolean
		{
			return target == (target | (1 << index));
		}
	}
}
