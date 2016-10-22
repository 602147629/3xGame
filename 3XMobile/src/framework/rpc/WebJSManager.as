package framework.rpc
{
	import com.game.consts.ConstGameFlow;
	import com.game.consts.ConstUserType;
	import com.netease.protobuf.UInt64;
	import com.qihoo.gamelobby.js.GameLobbyClientJSConnector;
	import com.qihoo.gamelobby.js.GameLobbyJSWithDataEvent;
	import com.qihoo.gamelobby.js.GameLobbyWebJSConnector;
	import com.ui.util.CBaseUtil;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.UserOrigin;

	public class WebJSManager
	{
		private static var _js:GameLobbyClientJSConnector;
		private static var _jsWeb:GameLobbyWebJSConnector;
		
		private static var _dataCall:Function;
		
		private static var _mailCall:Function;
		
		public static var qid:String;
		
		public static var macUrl:UInt64;
		
		public static var visitorID:int = 0;
		
		public static var loginTime:int = 0;
		
		public static var originType:int = UserOrigin.UserOrigin_Visitor;
		
		public static const WEB_URL:String = "http://qipai.360.cn/rest/user/[qid]/inbox/?tags=3xiao&page_size=10&status=1";
		
		public static var isLoginChangeState:Boolean;
		
		public function WebJSManager()
		{
		}
		
		public static function init(inboxUrl:String):void
		{
			isLoginChangeState = false;
			
			_js = new GameLobbyClientJSConnector();
			_jsWeb = new GameLobbyWebJSConnector(inboxUrl);
			
			initJS();
		}
		
		private static function initJS():void
		{
			//连接JS准备
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_DOM_READY_CALLBACK,onReadyJSHandler);
			//关闭窗口
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_CLOSE_CALLBACK,onCloseJSHandler);
			//取登陆信息
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_GET_TYPE_CALLBACK, onGetTypeHandler);
			//取Qid
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_GET_QID_CALLBACK,onGetQidHandler);
			//取mac地址
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_GET_MAC_CALLBACK,onGetMACHandler);
			//取QT
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_GET_QT_CALLBACK,onGetQTHandler);
			//登陆状态更改
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_ON_CHANGE_LOGIN_STATE,onLoginStateHandler);
			//注册事件的响应
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_ON_ENROL,onEnrolHandler);
			//获得小信息数量提示
			_jsWeb.addEventListener(GameLobbyJSWithDataEvent.LOBBY_WEB_EVENT_LOAD_UNREAD_CALLBACK,onUnreadNumHandler);
			
			_js.addEventListener(GameLobbyJSWithDataEvent.LOBBY_EVENT_ON_BOSS_KEY,onCallBackHandler2);
			
			_jsWeb.addEventListener(GameLobbyJSWithDataEvent.LOBBY_WEB_EVENT_PAY_WINDOW_CLOSE_CALLBACK,onCallBackHandler2);
			_jsWeb.addEventListener(GameLobbyJSWithDataEvent.LOBBY_WEB_EVENT_MALL_BUY_SUCCESS_CALLBACK,onCallBackHandler2);
			_jsWeb.addEventListener(GameLobbyJSWithDataEvent.LOBBY_WEB_EVENT_MALL_WINDOW_CLOSE_CALLBACK,onCallBackHandler2);
			_jsWeb.addEventListener(GameLobbyJSWithDataEvent.LOBBY_WEB_EVENT_FCM_SUCCESS_CALLBACK,onCallBackHandler2);
			_jsWeb.addEventListener(GameLobbyJSWithDataEvent.LOBBY_WEB_EVENT_FCM_WINDOW_CLOSE_CALLBACK,onCallBackHandler2);
			
			
			TRACE_FLOW(ConstGameFlow.AS_CALL_JS_READY);
			
			
			_js.sendFlashReadyMessage();
		}
		
		private static function reset():void
		{
			_js.setTabCaption("欢乐三消");
			visitorID = int(_js.sendReadProfileMessage("visitor", "id"));
			loginTime = int(_js.sendReadProfileMessage("visitor", "login_time"));
			
			CONFIG::debug
				{
					TRACE("取出登陆时间"+loginTime,"visitor");
					TRACE("取出游客id"+visitorID,"visitor");
				}
				
				var dTime:int = new Date().getTime() / 1000 - loginTime;
			if(dTime > 7 * 24 * 60 * 60)
			{
				visitorID = 0;
			}
			getMAC();
		}
		
		/**
		 *  Js准备好之后登陆取qid 取mac地址 
		 * @param e
		 * 
		 */		
		private static function onReadyJSHandler(e:GameLobbyJSWithDataEvent):void
		{
			TRACE_FLOW(ConstGameFlow.JS_CALLBACK_AS_DOM_READY);
			reset();
		}
		
		/**
		 *  关闭窗口的回调 
		 * @param e
		 * 
		 */		
		private static function onCloseJSHandler(e:GameLobbyJSWithDataEvent):void
		{
			NetworkManager.instance.exitGame();
		}
		
		/**
		 *  取出登陆信息 
		 * @param e
		 * 
		 */		
		private static function onGetTypeHandler(e:GameLobbyJSWithDataEvent):void
		{
			if(e.Data != null)
			{
				TRACE_LOG("js获取用户类型:"+e.Data);
				
				switch(int(e.Data))
				{
					case ConstUserType.USER_TYPE_VISITOR:
						originType = UserOrigin.UserOrigin_Visitor;
						break;
					case ConstUserType.USER_TYPE_360:
						originType = UserOrigin.UserOrigin_Qihoo;
						break;
					case ConstUserType.USER_TYPE_WEIBO_SINA:
						originType = UserOrigin.UserOrigin_Other;
						break;
					case ConstUserType.USER_TYPE_RENREN:
						originType = UserOrigin.UserOrigin_Other;
						break;
					case ConstUserType.USER_TYPE_MAIL:
						originType = UserOrigin.UserOrigin_Other;
						break;
					case ConstUserType.USER_TYPE_FETION:
						originType = UserOrigin.UserOrigin_Other;
						break;
				}
			}
			else
			{
				TRACE_LOG("空数据");
			}
			
		}
		
		/**
		 *  取出qid 
		 * @param e
		 * 
		 */		
		private static function onGetQidHandler(e:GameLobbyJSWithDataEvent):void
		{
			qid = e.Data as String;
			
			TRACE_LOG("js获取QID:"+qid);
		}
		
		/**
		 *  取出QT
		 * @param e
		 * 
		 */		
		private static function onGetQTHandler(e:GameLobbyJSWithDataEvent):void
		{
			if(e.Data as String != "")
			{
				getQid();
			}else
			{
				qid = null;
			}
			
			_dataCall.call(null, e.Data);
		}
		
		/**
		 *  登陆状态切换 
		 * @param e
		 * 
		 */		
		private static function onLoginStateHandler(e:GameLobbyJSWithDataEvent):void
		{
			var isLoginSucc:Boolean = e.Data as Boolean;
			
			if(!isLoginSucc)
			{
				return;
			}
			
			TRACE_LOG("切换登陆")
			
			reset();
			
			CBaseUtil.sendEvent(GameNotification.EVENT_USER_CHANGE_LOGIN , {});
			
			NetworkManager.instance.restartGame();
			
			if(ConfigManager.isInit)//判断如果在loading条的状态下不用显示加载
			{
				CBaseUtil.showLoading();
			}
		}
		
		private static function onEnrolHandler(e:GameLobbyJSWithDataEvent):void
		{
			TRACE_LOG("切换账号的状态："+e.Data.state);
			if(e.Data != null && e.Data.state == 1)
			{
				isLoginChangeState = true;
			}
		}
		
		private static function add(evt:Event):void
		{
			var bin_loader:LoaderInfo= evt.currentTarget as LoaderInfo;
			var item:Class = bin_loader.applicationDomain.getDefinition("") as Class;	
		}
		
		private static function onCallBackHandler2(e:GameLobbyJSWithDataEvent):void
		{		
			if(e.Data !=null)
			{
				TRACE_LOG("Client CallBack!"+e.Data.toString());
				for(var o:String in e.Data)
				{
					TRACE_LOG(o+":"+e.Data[o]);
				}
			}
			else
			{
				TRACE_LOG("null");
			}
		}
		
		/**
		 *  取mac地址 
		 * @param e
		 * 
		 */		
		private static function onGetMACHandler(e:GameLobbyJSWithDataEvent):void
		{		
			if(e.Data != null)
			{
				var n:Number = parseInt(e.Data as String, 16);
				TRACE_LOG("MAC 地址___"+n);
				macUrl = CBaseUtil.fromNumber2(n);
			}
			else
			{
				TRACE_LOG("mac_null");
			}
		}
		
		/**
		 *  获取小信封未读数量 
		 * @param e
		 * 
		 */		
		private static function onUnreadNumHandler(e:GameLobbyJSWithDataEvent):void
		{
			if(e.Data !=null)
			{
				TRACE_LOG("小信封___"+e.Data.toString());
				if(_mailCall != null)
				{
					_mailCall.call(null, JSON.parse(e.Data.toString()));
				}
			}else
			{
				TRACE_LOG("读取小信封___"+null);
			}
		}
		
		/**
		 *  加载资源 
		 * @param dllName
		 * @param swfName
		 * 
		 */		
		public static function loadSwf(dllName:String, swfName:String):void
		{
			_js.loadSwf(dllName, swfName);
		}
		
		/**
		 *  在大厅内跳转页面 
		 * @param url
		 * 
		 */		
		public static function navigateByTab(url:String):void
		{
			TRACE_LOG("跳转地址：" + url);
			_js.navigateByTab(url);
		}
		
		/**
		 * 弹出注册页 
		 * 
		 */		
		public static function loginEnrol():void
		{
			_js.loginEnrol("", "visitorToUser", "", " ");				
		}
		
		/**
		 * 加载小信封 
		 * 
		 */		
		public static function gameFuncGetInbox():void
		{
			_jsWeb.gameFuncGetInbox();
		}
		
		/**
		 *  加载小信封数量 
		 * @param qid
		 * 
		 */		
		public static function gameLoadUnread(callBack:Function):void
		{
			_mailCall = callBack;
			TRACE_LOG("QID："+qid);
			if(qid != null)
			{
				_jsWeb.gameLoadUnread(qid);
			}
		}
		
		/**
		 * 获取MAC地址 
		 * 
		 */		
		public static function getMAC():void
		{
			_js.getMAC();
		}
		
		/**
		 * 获取登陆信息 
		 * 
		 */		
		public static function gameFuncLogin():void
		{
			_jsWeb.gameFuncLogin();
		}
		
		/**
		 * 充值 
		 * 
		 */		
		public static function gameFuncGetPay():void
		{
			_jsWeb.gameFuncGetPay();				
		}
		
		/**
		 * 弹出商城 
		 * 
		 */		
		public static function gameFuncGetMall():void
		{
			_jsWeb.gameFuncGetMall();
		}
		
		/**
		 * 弹出防沉迷 
		 * 
		 */		
		public static function gameFuncGetFcm():void
		{
			_jsWeb.gameFuncGetFcm();
		}
		
		/**
		 * 取出QT 
		 * 
		 */		
		public static function getQT(call:Function):void
		{
			if(call == null && _dataCall != null)
			{
				
			}else
			{
				_dataCall = call;
			}
			
			if(!_js)
			{
				init(WEB_URL);
			}
			
			_js.sendGetUserTypeMessage();
//			_js.sendGetUserQTMessage();
			CBaseUtil.delayCall(_js.sendGetUserQTMessage, 1, 1);
		}
		
		/**
		 * 获取登陆信息 
		 * 
		 */		
		public static function getQid():void
		{
			_js.sendGetUserQidMessage();
		}
		
		/**
		 *  设置游戏大厅上方信息栏  
		 * @param bstrBtnId
		 * @param bstrText
		 * @param bstrToolTip
		 * @param bstrContext
		 * 
		 */		
		public static function setToolbarButtonText(bstrBtnId:String="", bstrText:String="", bstrToolTip:String="", bstrContext:String=""):void
		{	
			_js.setToolbarButtonText(bstrBtnId, bstrText, bstrToolTip, bstrContext);
		}
		
		/**
		 *  设置登陆的开关 （1为禁止0为开放）
		 * @param state
		 * 
		 */			
		public static function setPropValue(state:int):void
		{
			if(_js)
			{
				_js.setPropValue(state);
			}
		}
		
		/**
		 *  写入本地文件 
		 * @param bstrSection
		 * @param bstrKey
		 * @param bstrValue
		 * 
		 */		
		public static function setProfile(bstrSection:String, bstrKey:String, bstrValue:String):void
		{
			if(_js)
			{
				_js.sendWriteProfileMessage(bstrSection, bstrKey, bstrValue);
			}
		}
	}
}