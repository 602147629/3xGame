package framework.util
{
	import framework.types.Random;
	
	import rpc.simcity.Seed;
	
	import types.Random;

	public class PseudoRandom extends framework.types.Random
	{
		public static const RANDOM_LOCAL:String = "RandomLocal";
		public static const RANDOM_EVENT:String = "RandomEvent";
		public static const RANDOM_REWARD:String = "RandomReward";
		public static const RANDOM_POLLUTION:String = "RandomPollution";
		public static const RANDOM_RELATIONSHIP:String = "RandomRelationship";
		public static const RANDOM_MYSTERYBOX:String = "RandomMysteryBox";
		public static const RANDOM_ACTION_IN_FRIEND_CITY:String = "RandomActionInFriendCity";
		public static const RANDOM_WHEEL_SPIN:String = "RandomWheelSpin";
		
		private var _seed:Seed;
		private var _type:String;
		
		public function PseudoRandom(seed:Seed, type:String)
		{
			_seed = seed;
			_type = type;
			super(_seed.highSeed, _seed.lowSeed);
		}
		
		override public function nextInt(max:int):uint
		{
			_seed.roll();
			setSeed(_seed.highSeed, _seed.offsetLowSeed);
			
			var weight:uint = super.nextInt(max);
			
			CONFIG::debug
			{
				if(_type != null)
				{
					TRACE_RPC("get next " + _type + " weight:" + weight + " random seed offset:" + _seed.seedOffset);
				}
			}
			
			return weight;
		}
		
		//[min, max)
		public function nextIntRange(min:uint, max:uint):uint
		{
			var weight:int = nextInt(max - min);
			weight += min;
			
			CONFIG::debug
			{
				if(_type != null)
				{
					TRACE_RPC("get next " + _type + " weight:" + weight + " random seed offset:" + _seed.seedOffset);
				}
			}
			
			return weight;
		}

		public function get seed():Seed
		{
			return _seed;
		}

	}
}