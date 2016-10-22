package framework.util.cacher
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	import framework.client.mechanic.movieclipCacher.MovieClipCacherUtility;
	import framework.resource.Resource;
	import framework.util.ResHandler;
	import framework.util.rsv.Rsv;

	public class PlaceholderHelper
	{
		public static const PLACEHOLDER_NAME_BITMAP:String = "sandglassBitMap";
		public static const PLACEHOLDER_NAME:String = "sandglass";
		
		public static const PLACEHOLDER_TYPE_NONE:int = 0;
		public static const PLACEHOLDER_TYPE_PLAYER:int = 1;
		public static const PLACEHOLDER_TYPE_SANDGLASS:int = 2;
		
		public function PlaceholderHelper()
		{
		}
		
		public static function addLoadingBitMapToSpaceHolder(holder:CachePlaceholder, res:Resource, loading:DisplayObject):void
		{
			if(loading == null)
			{
				switch(res.placeHolderType)
				{
					case PLACEHOLDER_TYPE_NONE:
						loading = new Sprite();
						break;
					case PLACEHOLDER_TYPE_PLAYER:
						loading = getLoadingBitMap();
						break;
					case PLACEHOLDER_TYPE_SANDGLASS:
						loading = getLoadingAnim();
						break;
				}
			}
			holder.setContent(loading);
			
			loading.x = 0;
			loading.y = 0;
		}
		
		
		
		public static function addLoadingAnimToSpaceHolder(holder:CachePlaceholder, res:Resource, loading:DisplayObject, dontUseBuildingPlaceholder:Boolean):void
		{		
			if(loading == null && !dontUseBuildingPlaceholder)
			{
				if(res != null)
				{
					loading = getLoadingAnim();
				}
			}
			
			if(loading == null)
			{
				loading = getLoadingAnim();
			}
			
			holder.setContent(loading);
			
			/*if(!isBuildingPlaceholder && res != null)
			{
				loading.x = 0;
				loading.y = 0;
			}*/
		}

		private static function getLoadingAnim():DisplayObject
		{		
			var loading:MovieClip = ResHandler.getMcFromDomain(PLACEHOLDER_NAME);
//			loading = MovieClipCacherUtility.createMovieClipCacherAsynchronous(loading, getQualifiedClassName(loading));
			loading.play();
			loading.name = PLACEHOLDER_NAME;
			return loading;
//			var holder:DisplayObject = getLoadingBitMap();
//			holder.x = - holder.width/2;
//			holder.y = - holder.height;
//			return holder;
		}
		
		private static function getLoadingBitMap():DisplayObject
		{
			var loading:DisplayObject = new Bitmap(Rsv.inst.getFile(PLACEHOLDER_NAME_BITMAP).bitmapData);
			loading.name = PLACEHOLDER_NAME_BITMAP;
			return loading;
		}
		
		public static function getLoadingPriority():Boolean
		{
			return true;
		}
		

	}
}