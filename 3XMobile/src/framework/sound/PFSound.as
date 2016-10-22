package framework.sound
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * PFSound
	 * A wrapper of Class Sound to give more control of each sound instance
	 * 
	 * @author Tommy
	 * @author Jack Tang
	 */
	public class PFSound
	{
		private var sound : Sound;
		public var name : String;
		public var category : String;
		
		protected var volume : Number;
		protected var extractPosition : Number;	// The position in the byte array from which to extract
		protected var pitchShiftFactor : Number; // The factor (from 1.0 to 2.0) to shift the sound pitch
		protected var pitchShiftLoops : uint; // It is used to loop sound by pitch shifting only		
		
		public function PFSound(sound : Sound, name : String, category : String)
		{
			this.category = category;
			this.name = name;
			this.sound = sound;
			this.volume = 1;			
		}
		
		public function getSoundInstance() : Sound
		{
			return sound;
		}
		
		/**
		 * Play Sound
		 * 
		 * @param loops : only -1 means indefinitely play
		 * @param pitchShiftFactor : from 1 to 2
		 */
		public function play(loops : int = 1, pitchShiftFactor : Number = 1) : PFSoundChannel
		{
			try
			{
				var mixVolume : Number = getVolume();
				
				this.extractPosition = 0;
				this.pitchShiftFactor = pitchShiftFactor;				
				
				var soundChannel : SoundChannel;
				if ( pitchShiftFactor == 1 )
				{
					var loopValue : int = ( loops == -1 ) ? 999999 : loops;
					soundChannel = sound.play(0, loopValue, new SoundTransform(mixVolume));
				}
				else
				{
					pitchShiftLoops = loops;
					
					var morphedSound : Sound = new Sound();
					morphedSound.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleDataHandler);
					soundChannel = morphedSound.play(0, 0, new SoundTransform(mixVolume));
				}
				
				var gameSoundChannel : PFSoundChannel = new PFSoundChannel(this, soundChannel);
				PFAudioEngine.instance.addSoundChannel(gameSoundChannel);
				
				return gameSoundChannel;
			}
			catch (e : Error)
			{
				// sound failed to play for some reason
				/*PFDebug.trace(PFDebugChannels.AUDIO, "Error playing sound: " + getQualifiedClassName(sound));
				PFDebug.trace(PFDebugChannels.AUDIO, e.getStackTrace());*/
			}
			
			return null;
		}
		
		/**
		 * stop all the sounds started by this GameSound
		 * 
		 * @param fadeOut boolean
		 */
		public function stop(fadeOut : Boolean = false) : void
		{
			for (var i : int = PFAudioEngine.instance.getNumberOfActiveSoundChannels() - 1; i >= 0; i--)
			{
				var soundChannel : PFSoundChannel = PFAudioEngine.instance.findActiveSoundChannelById(i);
				if (soundChannel.gameSound == this)
				{
					soundChannel.stop(fadeOut);
				}
			}
		}
		
		/**
		 * Set sound volume
		 * 
		 * @param vol number
		 */
		public function setVolume(vol : Number) : void
		{
			volume = vol;
			PFAudioEngine.instance.refreshMixer();
		}
		
		/**
		 * Get sound volume
		 */
		public function getVolume() : Number
		{
			return volume * PFAudioEngine.instance.getVolumeCategory(category) * PFAudioEngine.instance.getGlobalVolume();
		}
		
		/**
		 * Provides sample data to the output Sound object. The Sound object dispatches a 
		 * sampleData event when it needs sample data. This event handler function provides
		 * that data. The method calls the shiftBytes() method to shift the pitch of the 
		 * audio data.
		 */
		private function sampleDataHandler(event : SampleDataEvent):void
		{
			var bytes : ByteArray = new ByteArray();
			var extractLength : uint = 4096;
			
			var oldExtractPosition : Number = extractPosition;
			extractPosition += sound.extract(bytes, extractLength, extractPosition);
			var difference : int = extractPosition - oldExtractPosition;
			
			if (pitchShiftLoops > 0 && difference < extractLength / 2)
			{
				playAgain(pitchShiftLoops - 1);
			}
			else if (pitchShiftLoops == -1 && difference < extractLength / 2)
			{
				playAgain(-1);
			}
			
			event.data.writeBytes(shiftBytes(bytes));
		}
		
		/**
		 * repeat the sound play
		 * 
		 * @param loops int
		 */
		private function playAgain(loops : int) : void
		{
			play(loops, pitchShiftFactor);
		}		
		
		/**
		 * This method abstracts and returns a byte array from sound data 
		 * which is adjusted by the pitch shift factor (the value of pitchShiftFactor property).
		 * 
		 * It uses twom numbers, skipCount and skipRate to determine how frequently to remove sound samples
		 * from the byte array. The pitch shift factor range is from 1.0 (original) to 2.0. If the factor is 2.0, 
		 * skipRate is set to 2.0, and every second sound sample is removed. If the factor is 1.5 (3/2), skipRate is
		 * set to 3.0, and every third sound sample is removed. If the factor is 1.333 (4/3), skipRate is set to 4.0,
		 * and every fourth sound sample is removed. Removing samples causes the pitch of the sound to shift higher.
		 * 
		 * @param bytes ByteArray
		 */
		private function shiftBytes(bytes : ByteArray) : ByteArray
		{
			var skipCount : Number = 0;
			var skipRate : Number = 1 + (1 / (pitchShiftFactor - 1));
			var returnBytes : ByteArray = new ByteArray();
			
			bytes.position = 0;
			while (bytes.bytesAvailable > 0)
			{
				skipCount++;
				if (skipCount <= skipRate)
				{
					returnBytes.writeFloat(bytes.readFloat());
					returnBytes.writeFloat(bytes.readFloat());
				}
				else
				{
					bytes.position += 8;
					skipCount = skipCount - skipRate;
				}
			}
			
			return returnBytes;
		}		
	}
}