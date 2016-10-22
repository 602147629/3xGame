package framework.model
{
	import framework.core.countdownSystem.CountDownSystem;
	import framework.fibre.patterns.Proxy;
	import framework.text.LangProxy;
	import framework.util.rsv.RsvEvent;
	import framework.util.rsv.RsvFile;
	
	public class BackgroundLoadProxy extends Proxy
	{
		public static const NAME:String = "BkLoadProxy";
		
		public static const PRIORITY_XML:int = 10;
		public static const PRIORITY_BITMAP:int = 5;
		public static const PRIORITY_SWF:int = 5;
		
		public static var inst:BackgroundLoadProxy;
		
		private var DomainLoaders:Array = new Array();// :Vector.<DomainLoader> = new Vector.<DomainLoader>();
		private var totalDomainCount:int;
		
		private var threadPool:Object = new Object(); //ensure one rsv file only push in queue once
		
		public function BackgroundLoadProxy()
		{
			inst = this;
			super(NAME);
			
		}

		public function addBackGroundLoad(rsv:RsvFile, callBack:Function = null):LoadingThread
		{
			var callbacks:Vector.<Function> = Vector.<Function>([fileHandler,callBack]);
			var thread:LoadingThread = createThread(rsv, callbacks);
			return thread;
		}

		private function createThread(rsv:RsvFile, callbacks:Vector.<Function>):LoadingThread
		{
			var thread:LoadingThread = new LoadingThread(rsv, callbacks);
			addToQueue(thread);
			return thread;

		}
		
		private function addToQueue(thread:LoadingThread):void
		{
			CONFIG::debug
			{
				ASSERT(threadPool[thread.referenceRsvFile.id] == null, thread.referenceRsvFile.id + "create twice");
			}
			
			threadPool[thread.referenceRsvFile.id] = thread;
			
		}
		

		private function fileHandler(ev:RsvEvent):void
		{
			var file:RsvFile = ev.from as RsvFile;
			
			if(ev.type == "" + RsvEvent.LOADCOMPLETE || ev.type == "" + RsvEvent.LOADERROR || ev.type == "" + RsvEvent.CONTENTERROR)
			{
				var domain:int = (file).fileDomain;
				var domainLoader:DomainLoader = queryDomainLoader(domain);
				
				domainLoader.removeLoading();
				
				startOneBackFileLoading();
			}

			if(ev.type==""+RsvEvent.CONTENTREADY)
			{
				
				
				var resProxy:StaticResProxy = fibre.retrieveProxy(StaticResProxy.NAME) as StaticResProxy;
				resProxy.updateFile([ev.from]);
				
				tryRegisterTextFile(file);
				
				/*CONFIG::debug
				{
					TRACE_LOADING("complete task, id = " + file.id);
				}*/

			}
			
		}
		
		private function tryRegisterTextFile(rsvFile:RsvFile):void
		{
			if(rsvFile.getLoadType() == FileProxy.LANG_GROUP_ID)
			{
				LangProxy.instance.registerText(rsvFile.xml);
			}
		}
		
		
		private function queryDomainLoader(domain:int):DomainLoader
		{
			CONFIG::debug
			{
				ASSERT(domain >= 0, "ASSERT");
			}
			
			var domainLoader:DomainLoader = DomainLoaders[domain];
			if(domainLoader == null)
			{
				domainLoader = new DomainLoader(domain);
				DomainLoaders[domain] = domainLoader;
				++totalDomainCount;
			}
			return domainLoader;
		}
		
		private function onChangeUndisposedThreadPriority(thread:LoadingThread):void
		{
			CONFIG::debug
			{
				ASSERT(!thread.isStartToLoad, "ASSERT");
			}
			
			if(!thread.shouldWaitInPool())
			{
				var domain:int = thread.referenceRsvFile.fileDomain;
				CONFIG::debug
				{
					if(thread.referenceRsvFile.getLoadType() != FileProxy.SPLIT_LOADING_GROUP_ID)
					{
						ASSERT(domain >= 0, "thread id = " + thread.referenceRsvFile.id + " has invalid domain");
					}
				}
				
				if(domain < 0)
				{
					return;
				}
				
				var domainLoader:DomainLoader = queryDomainLoader(domain);
				domainLoader.loadingQueuePriorityDirty = true;
				
				var index:int = domainLoader.loadingQueue.indexOf(thread);
				if(index < 0)
				{
					domainLoader.loadingQueue.push(thread);
				}
				startOneBackFileLoading();
			}
		}
		
		
		internal function startOneBackFileLoading():void
		{
			for each(var domainLoader:DomainLoader in DomainLoaders)
			{
				startDomainLoader(domainLoader);
			}

		}
		
		private function startDomainLoader(domainLoader:DomainLoader):void
		{
			if(domainLoader.bandwidthFull())
			{
				return;
			}
			
			resortLoadingQueue(domainLoader);

			
			while(domainLoader.loadingQueue.length > 0 && !domainLoader.bandwidthFull())
			{
				var nextThread:LoadingThread = domainLoader.loadingQueue.shift();
				if(nextThread.shouldWaitInPool())
				{
					continue;
				}
				
				domainLoader.addLoading();
				
				if(Debug.LOAD_RESOURCE_SEPARATE)
				{
					CountDownSystem.instance().addTask(
						100,
						function():void
						{
							CONFIG::debug
							{
								TRACE_RES("start load: " + nextThread.referenceRsvFile.path);
							}
							nextThread.load();
						},
						null);
				}
				else
				{
					nextThread.load();
				}
			}	
		}

		private function resortLoadingQueue(domainLoader:DomainLoader):void
		{
			if(domainLoader.loadingQueuePriorityDirty)
			{
				domainLoader.loadingQueuePriorityDirty = false;
				domainLoader.loadingQueue.sort(sortLoadingQueueThread); 
			}
			
		}
		
		private static function sortLoadingQueueThread(thread1:LoadingThread, thread2:LoadingThread):Number
		{
			var c1:int = thread1.importanceWeight;
			var c2:int = thread2.importanceWeight;
			if(c1 > c2) return -1;
			if(c1 < c2) return +1;
			return 0;
		}
		
		///
		
		private function queryUndisposedThread(id:String):LoadingThread
		{
			CONFIG::debug
			{
				ASSERT(threadPool[id] != null, id + " can't found in records");
			}
			
			var thread:LoadingThread = threadPool[id];
//			if(!thread.isDisposed)
			{
				return thread;
			}
	/*		else
			{
				return null;
			}*/
		}
		

		////////
		
		public function increasePriorityToLoadingThread(id:String, additionalPriority:int = 0, callBack:Function = null):void
		{
			var thread:LoadingThread = queryUndisposedThread(id);
			CONFIG::debug
			{
				if(thread == null)
				{
					TRACE_FILE("Can't find loading thread by id:" + id);
				}
			}
			
			if(thread != null)
			{
				
				thread.increasePriority(additionalPriority, callBack);
				
				if(!thread.isStartToLoad)
				{		
					if(!thread.isPushToLoadQueue)
					{
						thread.isPushToLoadQueue = true;
						CONFIG::debug
						{
							TRACE_FILE("start task, id = " + id);
						}
						onChangeUndisposedThreadPriority(thread);
					}
				}
			}
		}
		
		public function decreasePriorityToLoadingThread(id:String):void
		{
			var thread:LoadingThread = queryUndisposedThread(id);
			if(thread != null && !thread.isStartToLoad)
			{
				thread.decreasePriority();
				onChangeUndisposedThreadPriority(thread);
			}
		}


		
	}
}


import framework.game.InitState;
import framework.model.LoadingThread;


class DomainLoader
{
	public var id:int;
	public var loadingQueue:Vector.<LoadingThread> = new Vector.<LoadingThread>();
	public var loadingQueuePriorityDirty:Boolean = true;

	private var loadingCount:int;
	private static var totalLoadingCount:int;
	
	function DomainLoader(id:int)
	{
		this.id = id;
	}
	
	public function bandwidthFull():Boolean
	{
		CONFIG::debug
		{
			if(Debug.TEST_LOAD_SPLIT_GROUP)
			{
				return false;
			}
		}
		
		if(!InitState.isFinish(InitState.KEY_RPCPROXY))
		{
			if(totalLoadingCount >= 2)
			{
				return true;
			}
		}
//		else
//		{
//			if(totalLoadingCount >= 2)
//			{
//				return true;
//			}
//		}
		
		return loadingCount > 0;
	}
	
	public function addLoading():void
	{
		loadingCount++;
		totalLoadingCount++;
	}
	
	public function removeLoading():void
	{
		CONFIG::debug
		{
			ASSERT(loadingCount > 0, "domain id = " + id + " is overflow");
		}
		loadingCount--;
		totalLoadingCount--;
	}
	
}
