package framework.text
{
	
	//don't inport other classes
	public class LangMapping
	{
		
		public static const LANG_EN:String = "en";
		public static const LANG_FR:String = "fr";
		public static const LANG_DE:String = "de";
		
		public static const SUPPORT_LANG:Array = [LANG_EN,LANG_FR];
		
		
		private static const mapping:Object = {"en":"zh,en",
									             "fr":"fr",
												 "de":"de"
		}
		
		public function LangMapping()
		{
			
		}
		
		public static function getLangCodeFromPfLang(PfLang:String):String
		{
			
			for(var key:String in mapping)
			{
				var index:int = String(mapping[key]).indexOf(PfLang);
				if(index != -1)
				{
					return key;
				}
			}
			
			return LANG_EN;
		}
	}
}