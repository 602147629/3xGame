package framework.sound
{
	public class SoundParameters
	{
		private var volumeRange:ValueRange = new ValueRange(1, 1);
		private var everyRange:ValueRange = new ValueRange(0, 0);
		private var fadeOutRange:ValueRange = new ValueRange(0, 0);
		
		public function SoundParameters(volumeRange : String = null, everyRange : String = null, fadeOutRange : String = null)
		{
			if (volumeRange)
			{
				this.volumeRange = ValueRange.makeFromString(volumeRange);
			}
			
			if (everyRange)
			{
				this.everyRange = ValueRange.makeFromString(everyRange);
			}
			
			if (fadeOutRange)
			{
				this.fadeOutRange = ValueRange.makeFromString(fadeOutRange);
			}
		}
		
		public function randomizeValues() : void
		{
			everyRange.randomize();
			volumeRange.randomize();
			fadeOutRange.randomize();
		}
		
		public function get every() : uint
		{
			return everyRange.getValue();
		}
		
		public function get volume() : Number
		{
			return volumeRange.getValue();
		}
		
		public function get fadeOut() : uint
		{
			return fadeOutRange.getValue();
		}
		
		public function toString() : String
		{
			return "volume range: " + volumeRange.toString()
				+ "; every range: " + everyRange.toString();
		}
	}
}
