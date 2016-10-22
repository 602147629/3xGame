package debug
{
	import com.game.module.CDataOfLevel;
	import com.junkbyte.console.Cc;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.system.System;
	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.model.SwapLogicProxy;
	import framework.rpc.NetworkManager;
	import framework.view.mediator.MediatorBase;
	
	public class ConsoleWrapper
	{
		private var _fileReference:FileReference;
		private var root:DisplayObject;

		public function ConsoleWrapper(root:DisplayObject)
		{
			this.root = root;
			initConsole(root);
			initCommand();
			
			
		}

		private function initConsole(root:DisplayObject):void
		{
			Cc.startOnStage(root, "`"); // "`" - change for password. This will start hidden
			Cc.visible = false; // show console, because having password hides console.
			//C.tracing = true; // trace on flash's normal trace
			Cc.commandLine = true; // enable command line
			Cc.width = 700;
			Cc.height = 50;

			Cc.config.maxLines = 50000;
			Cc.config.commandLineAllowed = true; // enable command line

			//
			// End of setup
			//
		}
		
//		public function hide():void
//		{
//			this.visible=false;
//		}
//		public function show():void
//		{
//			this.visible=true;
//		}

		private function initCommand():void
		{
			Cc.info("Version Number:" + CONFIG::version);
			Cc.info("THIS_IS_A_DEBUG_VERSION:" + CONFIG::debug);
			Cc.info("ENABLE_RPC:" + CONFIG::enable_rpc);
			
			Cc.store("offline", handleOfflineCommands);	// these commands only be used offline
			
			Cc.store("pauseGame", pauseGame);
			
			Cc.info("in lobby:", Debug.inLobby);
			
			Cc.info("Force realod:" + Debug.force_reload);
			
			var date:Date = new Date();
			
			Cc.info("current time : " + date.hours + ":"+date.minutes+ ":"+date.seconds);
			
			Cc.store("setLevelOffline", setLevelOffline);
			Cc.store("addEnergy", addEnergy);
			Cc.store("passLevel", passLevel);
			Cc.store("useItem",  useItem);
		}
		
		private function useItem(itemId:int):void
		{
			SwapLogicProxy.inst.board.useItem(itemId);
		}
		
		private function setLevelOffline(level:int):void
		{
			CDataOfLevel.debugCurrentLevel = level;
		}
		
		private function passLevel():void
		{
			NetworkManager.instance.sendDebugMessage(2);
		}
		
		private function addEnergy(energy:int = 30):void
		{
			NetworkManager.instance.sendDebugMessage(1, energy);
		}
		
		private function pauseGame(isPause:Boolean = true):void
		{
			SwapLogicProxy.inst.setPause(isPause);
		}
		
		private function saveLang():void
		{
//			new RsvFile("file_lang_en", "./lang/lang_en.xml", false, "lang").load(function(e:RsvEvent):void{if(e.id == RsvEvent.CONTENTREADY)new FileReference().save(e.from.xml, "lang_en.xml");});
		}
		
	
		
		private function closePanel(viewId:String):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL, new DatagramView(viewId));
		}

	
		private function handleOfflineCommands(argString : String) : void
		{

		}
		
		
		
		private function copyLog():void
		{
			System.setClipboard(Cc.getAllLog());
		}

		
		private function loadRPC():void
		{
			_fileReference = new FileReference();
			_fileReference.addEventListener(Event.SELECT, onFileSelected);
			_fileReference.addEventListener(Event.COMPLETE, onFileLoaded);
			_fileReference.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			var fileFilter:FileFilter = new FileFilter("binary files", "*.bin");
			_fileReference.browse([fileFilter]);
		}
		
		private function onFileSelected(event:Event):void
		{
			var fileReference:FileReference = event.target as FileReference;
			fileReference.load();
		}
		
		private function onFileLoaded(event:Event):void
		{

		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			var fileReference:FileReference = event.target as FileReference;
			fileReference.removeEventListener(Event.SELECT, onFileSelected);
			fileReference.removeEventListener(Event.COMPLETE, onFileLoaded);
			fileReference.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			
			_fileReference = null;
		}
		
		private function getSession():void
		{
			var sessionString:String = ""//SessionManagement.getAuthResponseAsJSONString();
			
			Cc.info(sessionString + " copied to clipboard");
			System.setClipboard(sessionString);
		}
		
		private function frameRate(n:int = 0):void
		{

		}	
	}
}