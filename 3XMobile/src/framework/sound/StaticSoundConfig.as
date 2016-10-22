package framework.sound
{
	import framework.model.StaticResProxy;
	import framework.resource.GameResource;
	import framework.resource.Resource;
	import framework.resource.ResourceFile;
	import framework.resource.ResourceManager;
	
	
	
	public class StaticSoundConfig extends GameResource
	{
		private var soundList:Vector.<StaticSoundConfigEntry>;
		public function StaticSoundConfig()
		{
		}
		
		override public function init(xml:XML, file:ResourceFile, parent:Resource, resId:String = null):void
		{
			resType = GAMETYPE_SIM_SOUND_CONFIG;
			
			super.init(xml, file, parent, resId);
			
			StaticResProxy.inst.staticSoundConfig = this;
			
			initChildren(xml);
		}
		
		private function initChildren(xml:XML):void
		{
			var entryList:XMLList = xml.Sound;
			
			soundList = new Vector.<StaticSoundConfigEntry>();
			
			for each(var entryXml:XML in entryList)
			{
				var soundEntry:StaticSoundConfigEntry = new StaticSoundConfigEntry(entryXml);
				soundList.push(soundEntry);		
			}
		}
		
		public function getSoundList():Vector.<StaticSoundConfigEntry>
		{
			return soundList;
		}
		
		//TODO: optimize this methord, use dictionary instead of vector for soundlist
		//use event+condition as key
		public function getEntry(event:String, condition:String):StaticSoundConfigEntry
		{
			for each(var soundConfigEntry:StaticSoundConfigEntry in soundList)
			{
				if(soundConfigEntry.matchCondition(event, condition))
				{
					return soundConfigEntry;
				}
			}
			
			return null;
		}
	}
}
