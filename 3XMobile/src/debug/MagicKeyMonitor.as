package debug
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	
	import framework.rpc.DataUtil;
	

	public class MagicKeyMonitor
	{
		private static const KEY_A:int = 65;
		private static const KEY_z:int = 122;
		
		private static const _GAMESTATE:String = "gamestate";
		
		private var inputStream:String = "";
		
		private var tfVersionNumber:TextField;
		private var _stage:Stage;
		
		public function MagicKeyMonitor(stage:Stage)
		{
			if (stage == null)
			{
				return;
			}
			_stage = stage;
			
			initVersionNumberView();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDone);
		}
		
		private function initVersionNumberView():void
		{
			tfVersionNumber = new TextField();
			_stage.addChild(tfVersionNumber);
					
			tfVersionNumber.text = Debug.VERSION_NUMBER;
			
			tfVersionNumber.background = true;
			tfVersionNumber.width = 70;
			tfVersionNumber.height = 20;
			tfVersionNumber.visible = false;
			tfVersionNumber.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function onKeyDone(e:KeyboardEvent):void
		{
			swichVisibleVersionNumber(e);
			checkSession(e);
		}
		
		private function swichVisibleVersionNumber(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.F1)
			{
				tfVersionNumber.visible = !tfVersionNumber.visible;
			}
		}
		
		private function checkSession(e:KeyboardEvent):void
		{
			if(e.keyCode >= KEY_A && e.keyCode <= KEY_z)
			{
				inputStream += String.fromCharCode(e.keyCode).toLocaleLowerCase();
				const maxLength:int = 128;
				if(inputStream.length > maxLength)
				{
					inputStream = inputStream.substr(inputStream.length - maxLength);
				}
				
				var found:Boolean = false;
				found ||= _checkGameState();
				if(found)
				{
					inputStream = "";
				}
				
			}
		}
		
		private function isActive(key:String):Boolean
		{
			var start:int = Math.max(0, inputStream.length - key.length);
			var currentKeys:String = inputStream.substr(start);
			return (currentKeys == key);
		}
		
		private function _checkGameState():Boolean
		{
			if(isActive(_GAMESTATE))
			{
				var state:String = "gameInLobby: "+ Debug.inLobby;
				state += " lobbyServer: "+ CONFIG::lobbyServer;
				state += " isOpenFCM: " + Debug.IS_OPEN_FCM;
				state += " isOpenWeb: " + Debug.OPEN_WEB;
				state += " isOpenStore: "+ Debug.OPEN_STORE;
				state += " qt : "+ DataUtil.instance.qt;
				state += " qid: "+  DataUtil.instance.myUserID;
				state += " stable false reason: "+ Debug.stableLog;
				System.setClipboard(state);
				return true;
			}
			return false;
		}
		
	
		

	}
}