package framework.util
{
	import framework.util.UrlImageLoadingTask;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class UrlImageLoadController
	{
		private var started:Boolean;
		public var tasks:Vector.<UrlImageLoadingTask> = new Vector.<UrlImageLoadingTask>();
		
		public function UrlImageLoadController()
		{
			
		}
		
		public function add(url:String, container:DisplayObjectContainer, innerContainer:Sprite, isFillScale:Boolean):void
		{
			var info:UrlImageLoadingTask = new UrlImageLoadingTask(this, url, container, innerContainer, isFillScale);
			tasks.push(info);
		
			if(started)
			{
				start();
			}
		}
		
		public function start():void
		{
			started = true;
			
			if(UrlImageLoadingTask.runningTask < 1)
			{
				if(tasks.length > 0)
				{
					var info:UrlImageLoadingTask = tasks.shift();
					info.load();
				}
			}
		}
	}
}