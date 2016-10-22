package framework.model
{
	import framework.util.rsv.RsvEvent;
	import framework.util.rsv.RsvFile;

	public class LoadingThread
	{
		public var referenceRsvFile:RsvFile;
		public var callbacks:Vector.<Function>;
		
		public var isStartToLoad:Boolean;
		public var isPushToLoadQueue:Boolean;
		
		public static const PRIORITY_LAOD_ON_DEMAND:int = 0;
		public static const PRIORITY_LOAD_IN_BACK:int = 1;

		//
		public static var onLoadingIds:Vector.<String> = new Vector.<String>();
		private static function addOnLoadingId(id:String):void
		{
			CONFIG::debug
			{
				ASSERT(onLoadingIds.indexOf(id) < 0, "ASSERT");
			}
			onLoadingIds.push(id);
		}
		private static function removeOnLoadingId(id:String):void
		{
			var index:int = onLoadingIds.indexOf(id);
			CONFIG::debug
			{
				ASSERT(index >= 0, "ASSERT");
			}
			onLoadingIds.splice(index, 1);
		}

		//
		public function LoadingThread(rsv:RsvFile, callbacks:Vector.<Function>)
		{
			CONFIG::debug
			{
				ASSERT(rsv != null, "ASSERT");
			}
			this.referenceRsvFile = rsv;
			this.callbacks = callbacks;
			
			isPushToLoadQueue = false;
			isStartToLoad = false;
		}
		
		
		internal function load():void
		{
			CONFIG::debug
			{
				ASSERT(!isStartToLoad, "ASSERT");
			}
			isStartToLoad = true;
			
			addOnLoadingId(referenceRsvFile.id);
			
			referenceRsvFile.load(onComplete);
			
			
		}
		
		
		private function onComplete(ev:RsvEvent):void
		{
			if(callbacks != null)
			{
				for each(var callback:Function in callbacks)
				{
					if(callback != null)
					{
						callback(ev);
					}
				}
			}
			
			if(ev.type == "" + RsvEvent.LOADCOMPLETE)
			{
				removeOnLoadingId(referenceRsvFile.id);
			}
		}

		
		//
		public function get importanceWeight():int
		{
			return referenceRsvFile.importanceWeight;
		}
		
		internal function shouldWaitInPool():Boolean
		{
			return referenceRsvFile.importanceWeight < PRIORITY_LOAD_IN_BACK;
//			return !referenceRsvFile.isWaitingDownload() || (referenceRsvFile.importanceWeight < PRIORITY_LOAD_IN_BACK);
		}
		
		internal function increasePriority(additionalPriority:int, callBack:Function):void
		{
			++referenceRsvFile.importanceWeight;
			referenceRsvFile.importanceWeight += additionalPriority;
			
			if(callBack != null)
			{
				callbacks.push(callBack);
			}
		}
		
		internal function decreasePriority():void
		{
			--referenceRsvFile.importanceWeight;
			if(referenceRsvFile.importanceWeight < 1)
			{
				referenceRsvFile.importanceWeight = 0;
			}
		}
		
		
	}
}