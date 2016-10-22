package framework.sound
{
	import framework.types.helpers.MathUtils;
	

	public class SoundVariation
	{
		private var _soundId : String;
		private var _numOfVariations : uint = 1;
		private var everyRange : ValueRange;
		private var playedVariations : Vector.<uint> = new Vector.<uint>();
		private var _soundNames:Vector.<String>;
		
		public function SoundVariation(soundId : String, numOfVariations : uint, every : String = null)
		{
			this._soundId = soundId;
			this._numOfVariations = numOfVariations;
			this.everyRange = ValueRange.makeFromString(every);
			
			initSoundNames();
		}
		
		public function play(category : uint, loops : int, soundParams : SoundParameters) : void
		{
			everyRange.randomize();
			
			if (playedVariations.length == numOfVariations)
			{
				playedVariations.splice(0, playedVariations.length - 1);
			}
			
			var variationIndex : uint = getRandomVariationIndex();
			recordPlayedVariation(variationIndex);
			
			SoundHandler.instance.play(getSoundName(variationIndex), category, soundParams, this, loops);
		}
		
		private function initSoundNames():void
		{
			_soundNames = new Vector.<String>();
			
			for(var i:int = 0; i< numOfVariations; i++)
			{
				var soundName:String = getSoundName(i + 1);
				_soundNames.push(soundName);			
			}			
		}
		
		public function getSoundNames():Vector.<String>
		{	
			return _soundNames;
		}
		
		private function getSoundName(variationIndex : uint) : String
		{
			if (variationIndex < 10)
			{
				return soundId + "0" + variationIndex;
			}
			
			return soundId + variationIndex;
		}
		
		public function get soundId() : String
		{
			return _soundId;
		}
		
		public function get every() : Number
		{
			return everyRange.getValue();
		}
		
		public function get numOfVariations() : uint
		{
			return _numOfVariations;
		}
		
		public function clearPlayedVariations() : void
		{
			playedVariations = new Vector.<uint>();
		}
		
		private function getRandomVariationIndex() : uint
		{
			var index : uint = MathUtils.rnd(1, numOfVariations + 1);
			
			if ( isVariationPlayed(index) )
			{
				return getRandomVariationIndex();
			}
			
			return index;
		}
		
		private function recordPlayedVariation(variationIndex : uint) : void
		{
			if ( !isVariationPlayed(variationIndex) )
			{
				playedVariations.push(variationIndex);
			}
		}
		
		private function isVariationPlayed(variationIndex : uint) : Boolean
		{
			return numOfVariations > 1 && playedVariations.indexOf(variationIndex) != -1;
		}		
	}
}