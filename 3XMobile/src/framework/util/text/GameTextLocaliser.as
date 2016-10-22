package framework.util.text
{	
	import framework.localisation.internaldetails.TextLocaliser;
	
	public class GameTextLocaliser extends framework.localisation.internaldetails.TextLocaliser
	{
		public function GameTextLocaliser()
		{
			super();
		}
		
		public function registerMeta(token : String, replacement : String) : void
		{
			var count:int = _textReplacers.length;
			var replacer:GameTextReplacer;
			
			for (var i:int = 0; i < count; ++i)
			{
				if(_textReplacers[i] is GameTextReplacer)
				{
					replacer = _textReplacers[i] as GameTextReplacer;
					if(replacer.originalToken == token)
					{
						replacer.setReplacement(replacement);
						return;
					}
				}
			}
			addReplacer(new GameTextReplacer(token, replacement));
		}
	}
	
	
}