package framework.util
{
	import framework.util.text.GameTextLocaliser;
	

	public class TextUtil
	{
		public function TextUtil()
		{
		}
		
		public static function getText(id : String, ... params) : String
		{
//			var textLocaliser:GameTextLocaliser = GameEngine.getInstance().getTextLocaliser() as GameTextLocaliser;  
//			var text:String = textLocaliser.getText(id, params);			
			return "";
		}
		
		public static function registerMeta(token : String, replacement : String) : void
		{
//			var textLocaliser:GameTextLocaliser = GameEngine.getInstance().getTextLocaliser() as GameTextLocaliser;
//			textLocaliser.registerMeta(token, replacement);
		}
		
		public static function fileExtension(fileName:String, symbol:String = "."):String
		{
			if(fileName == null)
				return null;
			var i:int = fileName.lastIndexOf(symbol);
			var tempStr:String = i >= 0 ? fileName.substring(i+1) : "";
			
			return tempStr;
		}
		
		public static function getFileName(fileName:String, symbol:String = "."):String
		{
			if(fileName == null)
				return null;
			var i:int = fileName.lastIndexOf(symbol);
			return i >= 0 ? fileName.substring(0,i) : "";
		}
		
	}
}