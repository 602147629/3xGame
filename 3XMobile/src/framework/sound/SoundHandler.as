package framework.sound
{
	import flash.media.Sound;
	
	import framework.core.tick.GameTicker;
	import framework.core.tick.ITickObject;
	import framework.model.BackgroundLoadProxy;
	import framework.resource.Resource;
	import framework.resource.ResourceManager;
	import framework.util.Util;

	public class SoundHandler implements ITickObject
	{
		public static const CATEGORY_MUSIC:int = 0;
		public static const CATEGORY_SOUND:int = 1;
		public static const CATEGORY_AMBIENCE:int = 2;
		
		public static const NUMBER_OF_CATEGORIES:int = 3;
		
		public static const LOOPS_PLAY_ONCE:int = 0;
		public static const LOOPS_ALWAYS:int = -1;
		
		private static var _instance:SoundHandler;
		
		private var soundPlaying:Vector.<Vector.<SoundElement>>;
		private var soundBuffering : Vector.<Vector.<SoundBufferElement>>;
		
		private var _isPlayMusic:Boolean;
		private var _isPlaySound:Boolean;
		
		private var _backGroundMusicId:String;
		
		public function SoundHandler()
		{
			_isPlayMusic = false;
			_isPlaySound = false;

			soundPlaying = new Vector.<Vector.<SoundElement>>();
			soundBuffering = new Vector.<Vector.<SoundBufferElement>>();
			
			for(var i:int = 0; i < NUMBER_OF_CATEGORIES; i++)
			{
				soundPlaying.push(new Vector.<SoundElement>());
				soundBuffering.push(new Vector.<SoundBufferElement>());
			}
			
//			PFAudioEngine.instance.setVolumeCategory(CATEGORY_AMBIENCE.toString(), StaticResProxy.inst.staticAmbienceConfig.getAmbience(1).getGlobalVolume());
			
			GameTicker.getInstance().addToTickQueue(this);
		}
		
		public static function get instance():SoundHandler
		{
			if(_instance == null)
			{
				_instance = new SoundHandler();
			}
			return _instance;
		}
		
		public function tickObject(psdTickMs:Number) : void
		{
			bufferAudioChecker();
		}
		
		public function isTickPaused() : Boolean
		{
			return false;
		}
		
		private function bufferAudioChecker():void
		{
			for(var i:int = 0; i < NUMBER_OF_CATEGORIES; i++)
			{
				var bufferAudios:Vector.<SoundBufferElement> = soundBuffering[i];
				if(bufferAudios.length > 0)
				{
					var bufferAudio:SoundBufferElement = bufferAudios.shift();
					
					var soundRes:Resource = ResourceManager.getInstance().getResource(bufferAudio.soundName);
					var swfClass : Class =  soundRes.swfClass;
					if(swfClass != null)
					{				
						play(bufferAudio.soundName, bufferAudio.category, bufferAudio.soundParams, bufferAudio.soundVariation, bufferAudio.loops);
					}
					else
					{
						bufferAudios.push(bufferAudio);
					}
					
				}
			}

			
/*			var bufferLength : int = bufferAudios.length;
			for (var i : int = bufferLength - 1; i >= 0; i--)
			{
				var bufferAudio : SoundBufferItem = bufferAudios[i];
				var soundRes:Resource = ResourceManager.getInstance().getResource(bufferAudio["name"]);
				var swfClass : Class =  soundRes.swfClass;
				if(swfClass != null)
				{				
					play(bufferAudio.soundName, bufferAudio.category, bufferAudio.soundParams, bufferAudio.soundVariation, bufferAudio.loops);
					bufferAudios.splice(i, 1);
					break;
				}
			}	
*/			
		}
		
		public function removeFromBufferAudio(soundId : String, category : int):void
		{
			for each(var item:SoundBufferElement in soundBuffering[category])
			{
				if(item.id == soundId)
				{
					var index:int = soundBuffering[category].indexOf(item);
					soundBuffering[category].splice(index, 1);
					
//					TRACE_AMBIENCE_SOUND("soundBufferRemoved: "+ item.soundName +" category: "+category); 
					break;
				}
			}
		}
		
		public function getPlayingSound(category : int) : Vector.<SoundElement>
		{
			return soundPlaying[category];
		}
		
		public function muteByCategory(category : int) : void
		{
			for each (var sound : SoundElement in soundPlaying[category])
			{
				sound.setVolume(0);
			}
		}
		 
		public function unmuteByCategory(category : int) : void
		{
			for each (var sound : SoundElement in soundPlaying[category])
			{
				sound.setVolume(sound.volume);
			}
		}
		
		public function stopSoundByCategory(category : int):void
		{
			var sounds : Vector.<SoundElement> = soundPlaying[category];
			var maxIndex : int = sounds.length - 1;
			
			for (var i : int = maxIndex; i >= 0; i--)
			{
				sounds[i].stop();
			}
		}
		
		public function stopLoopSound(category : int):void
		{
			var sounds : Vector.<SoundElement> = soundPlaying[category];
			var maxIndex : int = sounds.length - 1;
			
			for (var i : int = maxIndex; i >= 0; i--)
			{
				if(sounds[i].isLoopSound())
				{					
					sounds[i].stop();
				}
			}
		}
		
		public function stopSoundById(soundId : String, category : int) : void
		{
			for each(var soundElement:SoundElement in soundPlaying[category])
			{
				if (soundElement.id == soundId)
				{
					soundElement.stop();
					return;
				}
			}
		}
		
		public function getIsPlayingId():Array
		{
			var array:Array = [];
			for each (var _s:SoundElement in soundPlaying)
			{
				if (_s.isPlaying)
				{
					array.push(_s.name);
				}
			}
			return array;
		}
		
		public function playBackgroundMusic(soundName:String, loop:int = LOOPS_ALWAYS):void
		{
			if(!Debug.isOpenMusic)
			{
				return;
			}
			if(loop == LOOPS_ALWAYS)
			{				
				_backGroundMusicId = soundName;
			}
			
			play(soundName, CATEGORY_MUSIC, new SoundParameters(), null, loop);
		}
		
		public function play(soundName : String, category : int, soundParams : SoundParameters, soundVariation : SoundVariation, loops : int = 0) : void
		{
 			if ( !isValidToPlay(category) )
			{
				return;
			}
			
			if(category == CATEGORY_MUSIC)
			{
				_backGroundMusicId = null;
			}
			
			var res:Resource;
			
			res = ResourceManager.getInstance().getResource(soundName);
			
			CONFIG::debug
			{	
				ASSERT(res != null, "can not find this sound in ui.xml when try to play it: "+soundName);
			}
			
			if (category == CATEGORY_MUSIC)
			{
				stopSoundByCategory(category);
			}
			
			if( res.swfClass != null )
			{
				
				
				var sound : SoundElement = addSound(res, soundName, category, loops, soundParams, soundVariation);
				addSoundPlaying(sound, category);
			}
			else
			{
				//other sound donot need buffer to play again
//				if(category == SoundHandler.CATEGORY_MUSIC || isAmbienceLoopSound(category, loops))
//				{
//					soundBuffering[category].push(createAudioBuffer(soundName, category, loops, soundParams, soundVariation));
//				}
				
				var isCanPlayNow:Boolean = false;
				
			/*	if(isVariationSound(soundVariation))
				{
					var soundNameCanPlay:String = getCanPlaySoundName(soundVariation);
					if(soundNameCanPlay != null)
					{
						play(soundNameCanPlay, category, soundParams, soundVariation, loops);
						
						isCanPlayNow = true;
					}
				}*/
				
				if(!isCanPlayNow /*&& (category == SoundHandler.CATEGORY_MUSIC || isAmbienceLoopSound(category, loops))*/)
				{
					if(category == CATEGORY_MUSIC)
					{
						soundBuffering[category].length = 0;
					}
					
					if(isCanPushToBufferSound(soundName, category, soundParams, soundVariation, loops))
					{							
						var item:SoundBufferElement = createAudioBuffer(soundName, category, loops, soundParams, soundVariation);
						soundBuffering[category].push(item);
					}
				}
				
//				if(!Debug.DISABLE_LOAD_SOUND)
				{
					loadDemandedAudio(soundName);
				}
			}
		}
		
		private function isCanPushToBufferSound(soundName : String, category : int, soundParams : SoundParameters, soundVariation : SoundVariation, loops : int):Boolean
		{
//			if(category == CATEGORY_SOUND && loops == LOOPS_ALWAYS)
//			{
//				return false;	
//			}
			return !isExistInSoundBuffer(soundName, category);
		}
		
		private function getCanPlaySoundName(soundVariation : SoundVariation):String
		{
			var soundNames:Vector.<String> = soundVariation.getSoundNames();
			
			for each(var soundName:String in soundNames)
			{
				var res:Resource = ResourceManager.getInstance().getResource(soundName);
				if(res.swfClass != null)
				{
					return soundName;
				}
			}
			
			return null;
		}
		
		private function isExistInSoundBuffer(soundName : String, category : int):Boolean
		{
			for each(var item:SoundBufferElement in soundBuffering[category])
			{
				if(item.soundName == soundName)
				{
					return true;
				}
			}
			return false;
		}
		
		private function isVariationSound(soundVariation : SoundVariation):Boolean
		{
			return soundVariation.numOfVariations > 1;
		}
		
		private function loadDemandedAudio(soundName : String) : void
		{
			TRACE_LOADING("\n" + soundName + " is load on demand\n");
			
			var resource : Resource = ResourceManager.getInstance().getResource(soundName);
			
			if (resource != null)
			{
				BackgroundLoadProxy.inst.increasePriorityToLoadingThread(resource.file.pathId);
			}
			else
			{
//				TRACE_SOUND_ERROR(soundName + " is not defined in the res config file!");
			}
		}
		
		private function isAmbienceLoopSound(category : int, loops : int ):Boolean
		{ 
			return category == CATEGORY_AMBIENCE && loops == LOOPS_ALWAYS;
		}
		
		public function isValidToPlay(category : int) : Boolean
		{
			return (category == SoundHandler.CATEGORY_MUSIC && _isPlayMusic) 
				|| (category == SoundHandler.CATEGORY_SOUND && _isPlaySound)
				|| (category == SoundHandler.CATEGORY_AMBIENCE && _isPlaySound)
		}
		
		private function createAudioBuffer(soundName : String, category : int, loops : int, soundParams : SoundParameters, soundVariation : SoundVariation) : SoundBufferElement
		{
			var item:SoundBufferElement = new SoundBufferElement();
			
			item.soundName = soundName;
			item.category = category;
			item.loops = loops;
			item.soundParams = soundParams;
			item.soundVariation = soundVariation;
			
			return item;
			
		}
		
		private function addSoundPlaying(effectSound:SoundElement, type:int):void
		{
			if(effectSound != null)
			{
				effectSound.play();
				
				if(soundPlaying[type].indexOf(effectSound) < 0)
				{
					soundPlaying[type].push(effectSound);
				}
			}
		}
		
		public function onStop(soundElement:SoundElement):void
		{
			Util.removeElementFromVector(soundPlaying[soundElement.category], soundElement);	
		}
		
		private function addSound(res : Resource, name : String, type : int, loops : int, soundParams : SoundParameters, soundVariation : SoundVariation):SoundElement
		{
			var pfSound : PFSound = new PFSound(Sound(res.getContent()), name, type.toString());
			var soundElement:SoundElement = new SoundElement(pfSound, type, loops, soundParams, soundVariation);
			return soundElement;
		}
		
		public function setMusicStatus(isPlay:Boolean):void
		{
			_isPlayMusic = isPlay;
			
			if ( isPlay )
			{
				unmuteByCategory(SoundHandler.CATEGORY_MUSIC);
				

				if(_backGroundMusicId != null)
				{
					playBackgroundMusic(_backGroundMusicId);
				}
			}
			else
			{
				muteByCategory(SoundHandler.CATEGORY_MUSIC);
			}
		}
		
		public function isEnableMusic():Boolean
		{
			return _isPlayMusic;
		}
		
		public function setSoundStatus(isPlay:Boolean):void
		{
			_isPlaySound = isPlay;
			
			if ( isPlay )
			{
				unmuteByCategory(SoundHandler.CATEGORY_SOUND);
//				MediatorAmbient.inst.resetAmbienceSound();				
			}
			else
			{
				muteByCategory(SoundHandler.CATEGORY_SOUND);
				stopSoundByCategory(SoundHandler.CATEGORY_AMBIENCE);				
			}
		}
		
		public function isEnableSound():Boolean
		{
			return _isPlaySound;
		}
	}
}
import framework.sound.SoundParameters;
import framework.sound.SoundVariation;



class SoundBufferElement
{
	public var soundName:String;
	public var category:int;
	public var loops:int;
	public var soundParams:SoundParameters;
	public var soundVariation:SoundVariation;
	
	public function get id() : String
	{
		if (soundVariation != null)
		{
			return soundVariation.soundId;
		}
		
		CONFIG::debug
		{
			ASSERT(false, "Sound Variation is null: name = " + soundName);
		}
		
		return null;
	}
	
}

