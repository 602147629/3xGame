package framework.sound
{
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * AudioM, working on the 'mixer' paradigm.
	 * Sounds must be pre-registered with getSound and given a category.
	 * 
	 * The mixer chain concept. Volume and pan. category->sound->channel
	 * 
	 * @author Jack Tang
	 */
	public class PFAudioEngine
	{
		public static var CATEGORY_MUSIC : String = "music";
		public static var CATEGORY_SOUND : String = "sfx";
		public static var CATEGORY_VOICE : String = "voice";
		public static var CATEGORY_DEFAULT : String = CATEGORY_SOUND;
		
		protected static var _instance : PFAudioEngine;
		
		private var activeSoundChannels : Vector.<PFSoundChannel> = new Vector.<PFSoundChannel>();
		private var loadedGameSounds : Dictionary = new Dictionary(); // name:PFSound
		private var categoryVolumes : Dictionary = new Dictionary();
		private var categoryMute : Dictionary = new Dictionary();		
		private var globalVolume : Number = 1;
		
		public function PFAudioEngine()
		{
			initCategoriesVolume();
		}
		
		/**
		 * initialize the volume setting for all categories
		 */
		private function initCategoriesVolume() : void
		{
			setVolumeCategory(CATEGORY_MUSIC, 1);
			setVolumeCategory(CATEGORY_SOUND, 1);
			setVolumeCategory(CATEGORY_VOICE, 1);
		}
		
		public function getGlobalVolume() : Number
		{
			return globalVolume;
		}
		
		public function setGlobalVolume(volume : Number) : void
		{
			globalVolume = volume;
			refreshMixer();
		}
		
		/**
		 * Get volume setting by category
		 * 
		 * @param categoryName String
		 * @return current volume setting of the category
		 */		
		public function getVolumeCategory(categoryName : String) : Number
		{
			if (categoryVolumes[categoryName] == null || categoryMute[categoryName] == null)
			{
				return 1;
			}
			
			if (categoryMute[categoryName])
			{
				return 0;
			}
			
			return categoryVolumes[categoryName];
		}
		
		/**
		 * Set volume for categories
		 * 
		 * @param categoryName String
		 * @param volume Number
		 */
		public function setVolumeCategory(categoryName : String, volume : Number) : void
		{
			categoryVolumes[categoryName] = volume;
			categoryMute[categoryName] = (volume == 0);
			refreshMixer();
		}
		
		/**
		 * @return whether a category is currently muted.
		 */
		public function isCategoryMuted(categoryName : String) : Boolean
		{
			return categoryMute[categoryName];
		}
		
		public function muteCategory(categoryName : String, mute : Boolean) : void
		{
			categoryMute[categoryName] = mute;
			refreshMixer();
		}		
		
		public function refreshMixer() : void
		{
			// set the sound volume of code started sound
			for ( var i : int=0; i < activeSoundChannels.length; i++ )
			{
				activeSoundChannels[i].refreshMixer();
			}
		}		
		
		public function getActiveSoundChannels() : Vector.<PFSoundChannel>
		{
			return activeSoundChannels;
		}
		
		public function getNumberOfActiveSoundChannels() : uint
		{
			return activeSoundChannels.length;
		}
		
		public function findActiveSoundChannelById(index : uint) : PFSoundChannel
		{
			return activeSoundChannels[index];
		}
		
		public function addSoundChannel(channel : PFSoundChannel) : void
		{
			activeSoundChannels.push(channel);
		}		
		
		public function removeSoundChannel(channel : PFSoundChannel) : void
		{
			var index : int = activeSoundChannels.indexOf(channel);
			if (index != -1)
			{
				activeSoundChannels.splice(index, 1);
			}
		}
		
		/**
		 * @return loaded PFSound by name
		 */
		public function getSound(name : String, category : String = null) : PFSound
		{
			if (category == null)
			{
				category = CATEGORY_DEFAULT;
			}
			
			if (loadedGameSounds[name] != null)
			{
				return loadedGameSounds[name] as PFSound;
			}
			
			// sound not loaded, try load it from the memory
			var sound : Sound;
			
			try
			{
				var soundClass : Class = Class(getDefinitionByName(name));
				sound = new soundClass();
			}
			catch (e : Error)
			{
//				PFDebug.trace(PFDebugChannels.AUDIO, "Could not load sound:" + name);
			}
			
			if ( sound == null )
			{
				sound = new Sound();
				sound.load(new URLRequest(name));
			}
			
			return preloadSound(sound, name, category);
		}
		
		public function preloadSound(sound : Sound, name : String, category : String) : PFSound
		{
			//PFDebug.assert( isSoundCached( name ) == false, "already cached" );
			
			var gameSound : PFSound = new PFSound(sound, name, category);
			cacheLoadedGameSound(gameSound);
			
			return gameSound;
		}
		
		public function cacheLoadedGameSound(sound : PFSound) : void
		{
			loadedGameSounds[sound.name] = sound;
		}
		
		public function unloadCachedSound(soundName : String) : void
		{
			if( loadedGameSounds[soundName] != null )
			{
				loadedGameSounds[soundName] = null;
				delete loadedGameSounds[soundName];
			}
		}
		
		public function unloadAllCachedSound() : void
		{
			for each( var sound:PFSound in loadedGameSounds )
			{
				loadedGameSounds[sound.name] = null;
				delete loadedGameSounds[sound.name];
			}
		}
		
		public function getLoadedGameSoundsCacheSize() : uint
		{
			var count:uint = 0;
			for each( var sound:PFSound in loadedGameSounds )
			{
				count++;
			}
			return count;
		}
		
		public function isSoundCached(name:String):Boolean
		{
			return loadedGameSounds[name] != null;
		}
		
		public static function get instance() : PFAudioEngine
		{
			if (_instance == null)
			{
				_instance = new PFAudioEngine();
			}
			
			return _instance;
		}
	}
}