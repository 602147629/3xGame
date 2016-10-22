package framework.util
{
	import framework.util.ResHandler;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	public class UrlImageLoadingTask
	{
		private var referenceController:UrlImageLoadController;
		
		public var url:String;
		public var container:DisplayObjectContainer;
		public var innerContainer:Sprite;
		public var isFillScale:Boolean;
		
		public static var runningTask:int;
		public static var cachedBitmapData:Object = new Object();

		public function UrlImageLoadingTask(group:UrlImageLoadController, url:String, container:DisplayObjectContainer, innerContainer:Sprite, isFillScale:Boolean)
		{
			this.referenceController = group;
			
			this.url = url;
			this.container = container;
			this.innerContainer = innerContainer;
			this.isFillScale = isFillScale;
		}
		
		public function load():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, picLoadedCompleteHandle);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, picLoadedErrorHandle);
			
			if(Debug.isOnWeb)
			{
				loader.load(new URLRequest(url), new LoaderContext(true, null, SecurityDomain.currentDomain));
			}
			else
			{
				loader.load(new URLRequest(url), new LoaderContext(true, null));
			}
			
			++runningTask;
		}
		
		private function picLoadedCompleteHandle(e:Event):void
		{
			var loader:Loader = (e.target as LoaderInfo).loader;
			
			var width:int = loader.width;
			var height:int = loader.height;
			
			var bitmapData:BitmapData = new BitmapData(width, height);
			var drawSuccess:Boolean;
			try
			{
				bitmapData.draw(loader);
				drawSuccess = true;
			}
			catch(e:Error)
			{
				drawSuccess = false;
			}
			
			if(drawSuccess)
			{
				cachedBitmapData[url] = bitmapData;
				
				var bitmap:Bitmap = createBitmapForUrlImage(container, bitmapData, isFillScale);
				innerContainer.addChild(bitmap);
			}
			else
			{
				var fakePic:MovieClip = ResHandler.getMcFirstLoad("FakeHeadPicture");
				centerUrlImage(container, fakePic, isFillScale);
				innerContainer.addChild(fakePic);
			}
			
			--runningTask;
			referenceController.start();
			
		}
		
		public static function createBitmapForUrlImage(container:DisplayObjectContainer, bitmapData:BitmapData, isFillScale:Boolean):Bitmap
		{
			var bitmap:Bitmap = new Bitmap(bitmapData);
			centerUrlImage(container, bitmap, isFillScale);
			return bitmap;
		}
		
		public static function centerUrlImage(container:DisplayObjectContainer, content:DisplayObject, isFillScale:Boolean):void
		{
			if(isFillScale)
			{
				var containerMc:MovieClip = container as MovieClip;
				if(containerMc!= null && containerMc.oldWidth != null)
				{
					content.scaleX = containerMc.oldWidth / container.scaleX / content.width;
					content.scaleY = containerMc.oldHeight / container.scaleY / content.height;
				}
			}
			content.x = -content.width /2;
			content.y = -content.height /2;
			
		}
		
		private function picLoadedErrorHandle(e:Event):void
		{
			var loader:Loader = (e.target as LoaderInfo).loader;
			loader.unload();
			
			--runningTask;
			referenceController.start();
		}
	}
}