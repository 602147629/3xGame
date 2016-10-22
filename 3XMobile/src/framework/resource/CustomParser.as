package framework.resource
{
	import framework.util.rsv.RsvEvent;
	import framework.util.rsv.RsvFile;
	import framework.util.rsv.RsvFileParser;
	
	import flash.utils.ByteArray;

	public class CustomParser extends RsvFileParser
	{
		public function CustomParser(f:RsvFile, cb:Function)
		{
			super(f, cb);
		}
		
		public override function parse():void
		{
			if(_file.extension == "bin")
			{
				// uncompress
				(_file.rawdata as ByteArray).uncompress();
							
				// same as xml file		
				noticeContent(new XML(_file.rawdata), RsvEvent.CONTENTREADY);
			}
			else
			{
				super.parse();
			}
		}
		
	}
}