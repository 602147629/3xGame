package framework.sound
{
	import framework.util.XmlUtil;
	

	public class StaticSoundConfigEntry
	{
		private var _soundId:String;
		private var _soundEvent:String;
		private var _category : int;
		private var _variations : uint;
		private var _loops : int;
		private var _params:Array;
		private var _soundParams : SoundParameters;
		
		public function StaticSoundConfigEntry(xml:XML)
		{
			_soundId = XmlUtil.attrString(xml, "value");
			_soundEvent = XmlUtil.attrString(xml, "event");
			_category = XmlUtil.attrInt(xml, "category", 1);
			_soundParams = createSoundParameters(xml);
			_variations = XmlUtil.attrInt(xml, "variations", 1);
			_loops = XmlUtil.attrInt(xml, "loops");
			
			
			var paramList:XMLList = xml.elements();
			if (paramList.length() > 0)
			{
				_params = new Array();
				
				for each(var params_xml:XML in paramList)
				{
					var parameter:String = XmlUtil.attrString(params_xml, "parameter", null);
					
					if(parameter != null)
					{
						_params.push(parameter);
					}
					else
					{						
						_params.push(params_xml.name().toString());
					}
				}
			}
		}
		
		private function createSoundParameters(xml : XML) : SoundParameters
		{
			var volume : String = XmlUtil.attrString(xml, "volume");
			var every : String = XmlUtil.attrString(xml, "every");
			var fadeOut : String = XmlUtil.attrString(xml, "fadeOut");
			return new SoundParameters(volume, every, fadeOut);
		}
		
		public function get soundParams() : SoundParameters
		{
			return _soundParams;
		}
		
		public function get soundId():String
		{
			return _soundId;
		}
		
		public function get variations() : uint
		{
			return _variations;
		}
		
		public function get category() : int
		{
			return _category;
		}
		
		private function getSoundName(variationIndex : uint) : String
		{
			if (variationIndex < 10)
			{
				return soundId + "0" + variationIndex;
			}
			
			return soundId + variationIndex;
		}
		
		public function getAllSoundNames():Vector.<String>
		{
			var sounds:Vector.<String> = new Vector.<String>();
			for(var i:int = 1; i<=_variations; i++)
			{
				sounds.push(getSoundName(i));
			}
			return sounds;
		}
		
		public function get loops() : int
		{
			return _loops;
		}
		
		public function matchCondition(event:String, condition:String): Boolean
		{
			return _soundEvent == event
				&& (_params == null || _params.indexOf(condition) >= 0);
		}
	}
}