package framework.util.cacher
{
	import flash.display.MovieClip;

	public class AssetPreprocessor
	{
		public function AssetPreprocessor()
		{
		}
		
		public static function preprocessor(mc:MovieClip, frame:String):void
		{
			if(frame)
			{
				mc.gotoAndStop(frame);
			}
		}
		
	}
}