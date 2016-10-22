package framework.util
{
	import com.junkbyte.console.Cc;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;

	public class ErrorUtil
	{
//		private static var _errors:Vector.<String> = new Vector.<String>();
		
		public function ErrorUtil()
		{
		}
		
		public static function getUserInformation():String
		{
			var userInfomation:String =" FbId: " ;
			return userInfomation;
		}
		
		public static function reportError(msg:String, errorCode:int):void
		{
			CONFIG::debug
			{
				TRACE_RPC("ERROR: " + msg);
			}
			
			CONFIG::enable_rpc
			{
				if(GameEngine.getInstance.getParameterString(SimCityConfigKeys.ERROR_LOG_ENABLE) == "true")
				{
					sendErrorLog(msg, errorCode);
				}
			}
			
			if(MediatorWorldSim.gameMapOpenned)
			{
				CONFIG::debug
				{
					msg += getUserInformation();
					
					UIUtil.popUpConfirmPanel("Save Rpc Log",msg + "\n\n Please save the log!","Save","Cancel",function():void{
						ShortCutTool.save_rpc_action();
					});
					
					UIUtil.popUpConfirmPanel("Save City",msg + "\n\n Do you want to save city?","Save","Cancel",function():void{
						ShortCutTool.saveCity();
					});
					return;
				}
				
				Fibre.getInstance().sendNotification(GameNotification.G_POP_UP_PANEL,new DatagramViewPanelError(errorCode));
			}
			else
			{
				showErrorOnLoadingBar();
//				_errors.push(msg);
			}
		}
		
		private static function sendErrorLog(msg:String, errorCode:int):void
		{
			var log:ErrorLog = new ErrorLog();
			log.userId = GameEngine.getInstance.getConfigParameterAsString(ConfigKeys.FACEBOOK_USER_ID);
			log.appName = "simcity";
			log.source = "";
			if(errorCode >= 3000)
			{
				// sync error
				log.infoId = errorCode.toString();
			}
			else
			{
				var lines:Array = msg.split("\n");
				if(lines.length > 1)
				{
					log.infoId = lines[0] + "\n" + lines[1];
				}
				else
				{
					log.infoId = msg;
				}
			}
			log.time = new Date();
			log.content = msg + "\n"
				+ GameEngine.getInstance.toString() + "\n"
				+ SessionManagement.getAuthResponseAsJSONString() + "\n"
				+ RpcProxy.instance.getRpcQueue(RpcProxy.QUEUE_CORE).toString();
			
			CONFIG::debug
			{
				log.content += "\n" + Cc.getAllLog();
			}
			
			var byteArray:ByteArray = new ByteArray();
			log.write(byteArray);
			byteArray.compress();
			
			var request:URLRequest = new URLRequest(GameEngine.getInstance.getParameterString(SimCityConfigKeys.ERROR_LOG_URL));
			request.method = URLRequestMethod.POST;
			request.contentType = "application/octet-stream";
			request.data = byteArray;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{trace("error log sent");});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void{trace("error log send fail: io error");});
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:Event):void{trace("error log send fail: security error");});
			loader.load(request);
		}
		
		private static function showErrorOnLoadingBar():void
		{
			if(GameLoader.inst != null)
			{
				GameLoader.inst.showError();
			}
		}
		
/*		public static function checkErrors():void
		{
			if(_errors.length > 0 && ResHandler.getMcFirstLoad(ConstantUI.getUIName(ConstantUI.PANEL_CONFIRM), true) != null)
			{
				var msg:String = _errors.toString();
				_errors.length = 0;
				
				GameEngine.inst.stage.addChild(GameEngine.inst);
				GameEngine.inst.showAllLayer();
				
				CONFIG::debug
				{ 
					TRACE_ERROR(msg);
					
					UIUtil.switchConfirmPanel("Save Rpc Log", msg + "\n\n Please save the log!","Save","Cancel",function():void{
						ShortCutTool.save_rpc_action();
					});
					
					return;
				}
				
				Fibre.getInstance().sendNotification(GameNotification.G_CHANGE_WORLD,new DatagramViewPanelError(0));
				
			}
		}
*/		
	}
}