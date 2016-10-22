package framework.util.cacher
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import framework.resource.ResourceFile;

	public class BackgroundTaskManager
	{
		public function BackgroundTaskManager()
		{
		}
		
		private static var pendingTasks:Dictionary = new Dictionary(true);
		private static var activingCachedPlaceholders:Dictionary = new Dictionary(true);
		
		private static const NORMAL_CACHE_WORKLOAD:Number = 5;
		private static const NORMAL_CACHE_WORKLOAD_HIGH:Number = 100;
		private static var currentCacheWorkload:Number = NORMAL_CACHE_WORKLOAD;
		
		public static function setCacheToHighWorkload(isMoreTime:Boolean):void
		{
			if(isMoreTime)
			{
				currentCacheWorkload = NORMAL_CACHE_WORKLOAD_HIGH;
			}
			else
			{
				currentCacheWorkload = NORMAL_CACHE_WORKLOAD;
			}
		}
		
		
		public static function isTherePendingTasks():Boolean
		{
			for(var key:Object in pendingTasks)
			{
				return true;
			}
			return false;
		}
		
		public static function get pendingTasksCount():int
		{
			var c:int = 0;
			for(var key:Object in pendingTasks)
			{
				c++;
			}
			return c;
		}
		
		public static function get activingCachePlaceholdersCount():int
		{
			var c:int = 0;
			for(var key:Object in activingCachedPlaceholders)
			{
				c++;
			}
			return c;
		}
		
		public static function getActivingCachePlaceholders():Dictionary
		{
			return activingCachedPlaceholders;
		}
		
		private static function addPendingTask(holder:CachePlaceholder, task:BackgroundTask):void
		{
			CONFIG::debug
			{
				ASSERT(holder != null, "ASSERT");
			}
			pendingTasks[holder] = task;
		}

		public static function addActivingCachedPlaceholder(holder:CachePlaceholder):void
		{
			CONFIG::debug
			{
				ASSERT(holder != null, "ASSERT");
			}
			activingCachedPlaceholders[holder] = new Object();
		}
		
		public static function rescaleAllActivingCachedPlaceholders(level:Number):void
		{
			
			for(var key:Object in activingCachedPlaceholders)
			{
				var holder:CachePlaceholder = key as CachePlaceholder;
				if(!holder.beNotAffectedByChangeScale)
				{
					var task:BackgroundTask = new BackgroundTask(BackgroundTask.REFRESH_CACHE, holder, level);
					addPendingTask(holder, task);
				}
			}
			
		}

		private static const cacheTaskResourceClassIdWhileLoading:Object = new Object();
		private static const loadTaskResourceClassIdWhileLoading:Object = new Object();
		
		public static function traceTaskInLoading():void
		{
			CONFIG::debug
			{
				TRACE_LOADING("\n\n<<	background tasks list");
				
				var key:Object;
				var size:int;
				
				var totalSize:int = 0;
				
				for(key in cacheTaskResourceClassIdWhileLoading)
				{
					size = cacheTaskResourceClassIdWhileLoading[key];
					TRACE_LOADING("[cache task], className = " + key + ", size = " + size);
					totalSize += size;
				}
				
				for(key in loadTaskResourceClassIdWhileLoading)
				{
					size = loadTaskResourceClassIdWhileLoading[key];
					TRACE_LOADING("[load task], className = " + key + ", size = " + size);
					totalSize += size;
				}
				
				TRACE_LOADING("total size = " + totalSize);
			}
		}
		
		private static function addCacheTaskRecordInLoading(id:String):void
		{
			CONFIG::debug
			{
				cacheTaskResourceClassIdWhileLoading[id] = 0;
			}			
		}

		private static function addLoadTaskRecordInLoading(id:String):void
		{
			CONFIG::debug
			{
				loadTaskResourceClassIdWhileLoading[id] = 0;
			}			
		}
		
		private static function setReordSize(id:String, size:int):void
		{
			CONFIG::debug
			{
				if(cacheTaskResourceClassIdWhileLoading[id] != null)
				{
					cacheTaskResourceClassIdWhileLoading[id] = size;
				}
				if(loadTaskResourceClassIdWhileLoading[id] != null)
				{
					loadTaskResourceClassIdWhileLoading[id] = size;
				}
			}
		}
		
		public static function addBackgroundCacheTask(holder:CachePlaceholder, level:Number):void
		{
			var task:BackgroundTask = new BackgroundTask(BackgroundTask.REFRESH_CACHE, holder, level);
			addPendingTask(holder, task);
			
			CONFIG::debug
			{
				addCacheTaskRecordInLoading(holder.owner.className);
			}
		}
		
		public static function addBackgroundLoadTask(holder:CachePlaceholder):void
		{
			var task:BackgroundTask = new BackgroundTask(BackgroundTask.GENERATE_ASSET, holder, 0);
			
			addPendingTask(holder, task);
			
			CONFIG::debug
			{
				addLoadTaskRecordInLoading(holder.owner.className);
			}
		}
		
		private static var cacheTaskTimer:Timer=null;
		public static function startBackgroundCaching():void
		{
			if(cacheTaskTimer == null)
			{
				cacheTaskTimer = new Timer(50);
				cacheTaskTimer.addEventListener(TimerEvent.TIMER, lsnCacheTaskTimer);
			}
			cacheTaskTimer.start();
		}
		
		public static function pauseBackgroundCaching():void
		{
			if(cacheTaskTimer!=null)
			{
				cacheTaskTimer.stop();
			}
		}
		
		
		
		private static function lsnCacheTaskTimer(e:TimerEvent):void
		{
			var startTime:Number = getTimer();

			for(var holder:Object in pendingTasks)
			{
				var task:BackgroundTask = pendingTasks[holder];

				var complete:Boolean = true;
				switch (task.type)
				{
					case BackgroundTask.REFRESH_CACHE:
					{
						complete = refreshOneCache(task.level, task.container);
						break;
					}
						
					case BackgroundTask.GENERATE_ASSET:
					{
						complete = refreshOneAsset(task.container);
						break;
					}	
						
				}
				
				if(complete)
				{
					delete pendingTasks[holder];
				}

				if(getTimer() - startTime > currentCacheWorkload)
				{
					break;
				}

			}
			
		}
		
		
		private static function refreshOneCache(level:Number, holder:CachePlaceholder):Boolean
		{
			var creator:CacheToImageCreator=holder.initParameter as CacheToImageCreator;
			if(creator)
			{
				var success:Boolean = creator.trySetCachedContentToSpaceholder(holder, level);
				if(success)
				{
					setReordSize(holder.owner.className, holder.owner.file.referenceRsvFile.fileSize);
				}
				return success;
			}
			return false;
		}
		
		private static function refreshOneAsset(holder:CachePlaceholder):Boolean
		{
			var data:BackgroundLoadParameter = holder.initParameter as BackgroundLoadParameter;
			if(data)
			{
				if(holder.owner.file.content != null)
				{
					var asset:DisplayObject;
					
					var swfClass:Class = holder.owner.swfClass;
					if(swfClass != null)
					{
						asset = new swfClass();
						AssetPreprocessor.preprocessor(asset as MovieClip,data.frame);										
					}
					else if(holder.owner.file.fileType == ResourceFile.FILETYPE_BITMAP)
					{
						asset = new Bitmap(holder.owner.file.content as BitmapData);
					}
					
					holder.setContent(asset);
					holder.isLoaded = true;
					
					if(holder.cbReady!=null)
					{
						holder.cbReady(asset);
						holder.cbReady = null;
					}
					
					setReordSize(holder.owner.className, holder.owner.file.referenceRsvFile.fileSize);
					return true;
					
				}
				
				
			}
			return false;
		}
		
		
	}
}