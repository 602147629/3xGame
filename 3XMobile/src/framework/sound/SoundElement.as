package framework.sound
{
	import flash.events.Event;
	
	public class SoundElement 
	{	
		private var sound : PFSound;
		private var soundChanel : PFSoundChannel;
		private var _category : uint;
		
		private var loops : int = 0;
		private var parameters : SoundParameters;
		private var variation : SoundVariation;
		
		private var _isPlaying : Boolean = false;
		
		public function SoundElement(sound : PFSound, category : int, loops : int = 0, parameters : SoundParameters = null, variation : SoundVariation = null)
		{
			this.sound = sound;
			this._category = category;
			this.loops = loops;
			this.parameters = (parameters) ? parameters : new SoundParameters();
			this.variation = (variation) ? variation : null;
		}
		
		public function get id() : String
		{
			if (variation != null)
			{
				return variation.soundId;
			}
			else if(sound != null)
			{
				return sound.name;
			}
				
			CONFIG::debug
			{
				ASSERT(false, "Sound Variation is null: name = " + name);
			}
			
			return null;
		}
		
		public function get name():String
		{
			return sound.name; 
		}
		
		public function get category():int
		{
			return _category;
		}
		
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		public function get volume() : Number
		{
			return parameters.volume;
		}
		
		public function setVolume(value : Number) : void
		{
			if(soundChanel)
			{
				soundChanel.setVolume(value);
			}
		}
		
		public function play() : void
		{
			if ( canPlay() )
			{
				_isPlaying = true;
				parameters.randomizeValues();
				
				soundChanel = sound.play(loops);
				
				if (soundChanel)
				{
					soundChanel.setVolume(volume);
					soundChanel.addEventListener(Event.COMPLETE, onComplete, false, 0, false);
				}
				
				CONFIG::debug
				{
					var debugMsg : String = "soundId: "+name+" soundType: "+category +" loops: "+loops;
					
					if (parameters != null)
					{
						debugMsg += " volume: "+parameters.volume;
					}
					
					TRACE_BOTTOM_ITEM(debugMsg);
				}				
			}
		}
		
		private function canPlay() : Boolean
		{
			return sound != null && !isPlaying && SoundHandler.instance.isValidToPlay(category);
		}
		
		private function onComplete(event:Event):void
		{
			if (soundChanel)
			{
				soundChanel.removeEventListener(Event.COMPLETE, onComplete);
			}
			
			_isPlaying = false;
			
			if(_category == SoundHandler.CATEGORY_SOUND && isPlayOnce())
			{
				stop();
			}		
			else
			{
				if (variation && variation.numOfVariations > 1)
				{
					SoundTriggerQueuer.instance.queueFunctionCall(category, variation.play, variation.every, category, loops, parameters);
					stop(); // stop the current variation since a new one will be created
				}
				else if (parameters.every > 0)
				{
					SoundTriggerQueuer.instance.queueFunctionCall(category, play, parameters.every);
				}
				else
				{
					stop();
				}
			}
		}
		
		private function isPlayOnce():Boolean
		{
			return loops == SoundHandler.LOOPS_PLAY_ONCE;
		}
		
		public function isLoopSound():Boolean
		{
			return loops == SoundHandler.LOOPS_ALWAYS;
		}
		
		public function stop() : void
		{
			if (soundChanel != null)
			{
				soundChanel.removeEventListener(Event.COMPLETE, onComplete);
				
				if (parameters.fadeOut == 0)
				{
					soundChanel.stop();
				}
				else
				{
					soundChanel.stop(true, parameters.fadeOut / 1000);
				}
			}
			
			SoundHandler.instance.onStop(this);
		}
	}
}