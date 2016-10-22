package framework.sound
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	import framework.types.GameTimer;
		
	/**
	 * A playing sound channel, which is created when a PFSound is played
	 * 
	 * It is the dynamic, playing sound. Like an instance of a PFSound, if you will.
	 * Support fade out, and independent pan and volume controls.
	 * 
	 * @author Tommy
	 * @author Jack Tang
	 */	
	public class PFSoundChannel extends EventDispatcher
	{
		public static const CHANNEL_PAN_LEFT : Number = -1;
		public static const CHANNEL_PAN_CENTRE : Number = 0;
		public static const CHANNEL_PAN_RIGHT : Number = 1;
		
		private var _gameSound : PFSound;
		private var _soundChannel : SoundChannel;
		
		private var volume : Number;
		private var pan : Number;
		private var fadeOriginalVolume : Number;
		private var fadeTimecum : Number;
		
		public function PFSoundChannel(gameSound : PFSound, soundChannel : SoundChannel)
		{
			this._gameSound = gameSound;
			this._soundChannel = soundChannel;
			
			this.volume = 1;
			this.pan = CHANNEL_PAN_CENTRE;
			
			// add a listener so that it can be removed from the active list when the sound finishes
			soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
		}
		
		public function get gameSound() : PFSound
		{
			return _gameSound;
		}
		
		public function get soundChannel() : SoundChannel
		{
			return _soundChannel;
		}
		
		public function getPan() : Number
		{
			return pan;
		}
		
		public function setPan(pan : Number) : void
		{
			this.pan = pan;			
			refreshMixer();
		}
		
		public function refreshMixer() : void
		{
			if (gameSound != null && soundChannel != null)
			{
				refreshMixerVolume(getVolume());
			}
		}
		
		private function refreshMixerVolume(volume : Number) : void
		{
			soundChannel.soundTransform = new SoundTransform(volume, pan);
		}
		
		public function getVolume() : Number
		{
			return volume * gameSound.getVolume();
		}
		
		public function setVolume(vol : Number) : void
		{
			volume = vol;
			refreshMixer();
		}
		
		public function fadeOut(startVolume : Number, fadeDuration : Number) : void
		{
			fadeOriginalVolume = startVolume;
			fadeTimecum = 0;			
			GameTimer.startTimer(100, onFadeOut, fadeDuration);
		}
		
		private function onFadeOut(fadeDuration : Number) : Boolean
		{
			var newVolume : Number = fadeOriginalVolume - (fadeOriginalVolume * fadeTimecum) / fadeDuration;
			fadeTimecum += 0.1;
			
			if (newVolume <= 0)
			{
				stop();
				return false;
			}
			else
			{
				setVolume(newVolume);
				return true;
			}
		}
		
		private function onSoundComplete(e : Event) : void
		{
			stop();
		}
		
		/**
		 *  if fadeOut is true then the sound volume will fade out smoothly before stopping
		 */
		public function stop(requireFadeOut : Boolean = false, fadeDuration : Number = 3) : void
		{
			soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			
			if (requireFadeOut)
			{
				fadeOut(volume, fadeDuration);
			}
			else
			{
				soundChannel.stop();
				
				// remove from the global sound list
				PFAudioEngine.instance.removeSoundChannel(this);
				
				try
				{
					dispatchEvent(new Event(Event.COMPLETE));
				}
				catch (error : Error) 
				{
//					PFDebug.trace(PFDebugChannels.AUDIO, "Exception on dispatchEvent (audio channel complete):"+(error==null?"Unknown":error.message));
				}
			}
		}	
	}
}