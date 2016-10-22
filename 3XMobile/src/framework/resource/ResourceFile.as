package framework.resource
{
	import flash.system.ApplicationDomain;
	
	import framework.util.rsv.RsvFile;
	import framework.util.rsv.RsvFileConst;
	

	/**
	 * comments by Ding Ning
	 * each resourceFile is corresponding to a single flash LINKAGE class 
	 */


	public class ResourceFile
	{
		public var referenceRsvFile:RsvFile;
		public var pathId:String;
		public var fileType:int;
		public var content:Object;
		public var swfLib:ApplicationDomain;
		
		public static const FILETYPE_RAW:int = 0;
		public static const FILETYPE_BITMAP:int = 1;
		public static const FILETYPE_SWF:int = 2;
		public static const FILETYPE_XML:int = 3;
		public static const FILETYPE_TEXT:int = 4;
		public static const FILETYPE_VARIABLE:int = 5;


		public function ResourceFile(id:String, referenceRsvFile:RsvFile)
		{
			this.pathId = id;
			this.referenceRsvFile = referenceRsvFile;
		}
		
		public function setContent(t:int, c:Object, ad:ApplicationDomain):void
		{
			fileType = t;
			content = c;
			swfLib = ad;
		}
		
		public static function getFileType(fileExtenstion:String):int
		{
			switch(fileExtenstion)
			{
				case RsvFileConst.TAIL_SWF:
					return FILETYPE_SWF;
				case RsvFileConst.TAIL_PNG:
				case RsvFileConst.TAIL_JPG:
					return FILETYPE_BITMAP;
				default:
					return FILETYPE_XML;
			}
		}
	}
}