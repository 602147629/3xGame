package framework.util.text
{
	import framework.localisation.ITextReplacer;
	import framework.resource.ResourceLocator;
	
	public class GameTextReplacer implements framework.localisation.ITextReplacer
	{
		private var _token : String;
		private var _replacement : String;
		private var _originalToken:String;
		
		public function GameTextReplacer(token : String, replacement : String)
		{
			_originalToken = token;
			_token = "%" + token + "%";
			_replacement = replacement;
		}
		
		public function get token():String
		{
			return _token;
		}
		
		public function get originalToken():String
		{
			return _originalToken;
		}

		public function replaceText(text:String):String
		{
			if(text == null) {
				return null;
			}
			
			return text.replace(_token, _replacement);
		}
		
		public function setReplacement(replacement:String):void
		{
			_replacement = replacement;
		}
		
		public function hasSameToken(replacer:GameTextReplacer):Boolean
		{
			if(replacer != null)
			{
				return _token == replacer.token;
			}
			return false;
		}
		
		
	}
}