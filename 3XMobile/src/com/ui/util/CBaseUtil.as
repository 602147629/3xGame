package com.ui.util
{
	import com.game.consts.ConstFlowTipSize;
	import com.game.consts.ConstGlobalConfig;
	import com.game.consts.ConstIcon;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfMatch;
	import com.netease.protobuf.Int64;
	import com.netease.protobuf.UInt64;
	import com.ui.item.CItemBitmap;
	import com.ui.widget.CWidgetFloatText;
	import com.ui.widget.CWidgetScrollBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import framework.controller.MessageQueue;
	import framework.datagram.DatagramView;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.model.DataManager;
	import framework.model.FileProxy;
	import framework.model.objects.BasicObject;
	import framework.resource.faxb.award.MatchInfo;
	import framework.resource.faxb.items.Item;
	import framework.resource.faxb.sceneui.Level;
	import framework.rpc.ConfigManager;
	import framework.rpc.DataUtil;
	import framework.rpc.GameLobbySocketCallback;
	import framework.rpc.NetworkManager;
	import framework.rpc.WebJSManager;
	import framework.ui.MediatorPanelMainUI;
	import framework.ui.MediatorWorldMainScene;
	import framework.util.ResHandler;
	import framework.util.ScrollBar;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.Product_Status;
	import qihoo.gamelobby.protos.SignCost;
	import qihoo.gamelobby.protos.UDV;
	import qihoo.gamelobby.protos.UserOrigin;
	import qihoo.triplecleangame.protos.CMsgGetNameImageResponse;
	
	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-6-30 上午11:07:02 
	 */
	public class CBaseUtil
	{
		//图标id列表  34 = 后退一步 
		private static const ICON_NAME_LIST:Array = ["1" , "21" , "3" , "12" , "33" , "34" , "4" , "14" , "13" , "2" , "31" , "32"];
		
		/** 
		 * UInt64转number 
		 * @param num
		 * @return 
		 */ 
		public static function toNumber(num:Int64):Number 
		{
			return (num.high * 0xFFFFFFFF) + num.low;
		}
		
		/**
		 * number 转 UInt64
		 * @param n
		 * @return 
		 */ 
		public static function fromNumber(n: Number):Int64 
		{
			return new Int64(n & 0xFFFFFFFFF , uint(n / 0xFFFFFFFF) );
		}
		
		/** 
		 * UInt64转number 
		 * @param num
		 * @return 
		 */ 
		public static function toNumber2(num:UInt64):Number 
		{
			if(num == null)
			{
				return 0;
			}
			return (num.high * 0xFFFFFFFF) + num.low;
		}
		
		/**
		 * number 转 UInt64
		 * @param n
		 * @return 
		 */ 
		public static function fromNumber2(n: Number):UInt64 
		{
			return new UInt64(n & 0xFFFFFFFFF , uint(n / 0xFFFFFFFF) );
		}
		
		/**
		 *  返回报名费的数量 
		 * @param udv
		 * @return 
		 * 
		 */		
		public static function signUpCostToNum(udv:UDV):Object
		{
			var ret:Object = new Object();
			if(udv.type.type == 1 &&　udv.type.iD == 2)
			{
				ret.num = toNumber(udv.value);
				ret.id = 2;
			}
			if(udv.type.type == 1 &&　udv.type.iD == 1)
			{
				ret.num = toNumber(udv.value);
				ret.id = 3;
			}
			if(udv.type.type == 3 &&　udv.type.iD == 1013104)
			{
				ret.num = toNumber(udv.value);
				ret.id = 1;
			}
			
			return ret;
		}
		
		/**
		 *  获取当前挑战费用 
		 * @param productID
		 * @return 
		 * 
		 */		
		public static function getCurrentSignUpCost(productID:int):Object
		{
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(productID);
			
			var curNum:int;
			var curID:int;
			
			var num:int;
			var id:int;
			var udv:UDV;
			for each(udv in matchData.signUpCost)
			{
				var obj:Object = CBaseUtil.signUpCostToNum(udv);
				num = obj.num;
				id = obj.id;
				break;
			}
			
			var reNum:int = Math.max(matchData.currentRobNum - 1, 0);
			
			var signCost:SignCost; 
			if(matchData.replayCost)
			{
				signCost = matchData.replayCost[reNum];
			}
			
			var list:Array = signCost ? signCost.udv : new Array();
			
			var replayNum:int;
			var reID:int;
			for each(udv in list)
			{
				var reObj:Object = CBaseUtil.signUpCostToNum(udv);
				replayNum = reObj.num;
				reID = reObj.id;
				break;
			}
			
			curNum = matchData.currentRobNum == 0 ? num : replayNum;
			curID = matchData.currentRobNum == 0 ? id : reID;
			
			var curCost:Object = new Object();
			curCost.num = curNum;
			curCost.id = curID;
			return curCost;
		}
		
		/**
		 *  毫秒转成时间字符串 
		 * @param s
		 * @return 
		 * 
		 */		
		public static function getTimeString(s:Number) : String
		{
			if(s < 1000){
				return '00:00:00';
			}
			
			var second : int = 1000;
			var minute : int = second * 60;
			var hour : int = minute * 60;
			var day : int = hour * 24;
			
			var days:String = String(Math.floor(s / day));
			var hours:String = String(Math.floor((s % day) / hour));
			var minutes:String = String(Math.floor((s % hour) / minute));
			var seconds:String = String(Math.floor((s % minute) / second));
			
			if(hours.length == 1) hours = '0'+hours;
			if(minutes.length == 1) minutes = '0'+minutes;
			if(seconds.length == 1) seconds = '0'+seconds;
			
			if(days == '0'){
				return hours + ':' + minutes + ':' + seconds;
			}else{
				return days + ':' + hours + ':' + minutes + ':' + seconds;
			}
		}
		
		public static function getHourString(s:Number):String
		{
			var start:Date = new Date(s)
			var minutes:String = "" + start.minutes;
			if(minutes.length == 1) 
			{
				minutes = "0" + minutes;
			}
			var hours:String = "" + start.hours;
			if(hours.length == 1) 
			{
				hours = "0" + hours;
			}
			
			return hours + ":" + minutes;
		}
		
		/**
		 * 获得请求url
		 * @return string
		 */ 
		public static function getQUrl(qid:UInt64):String 
		{
			if(!qid)
			{
				return "";
			}
			
			var qidString:String = String(toNumber2(qid));
			
			return ConstGlobalConfig.USER_INTERFACE.replace("{$qid}" , qidString);
		}
		
		/**
		 * 根据id获取消除体的图标
		 */
		public static function getCardMc(cardid:int):Sprite
		{
			var index:int = ConstIcon.getOBSIconById(cardid);
			
			if(index != -1)
			{
				return new CItemBitmap(index);
			}
			else
			{
				var basicObject:BasicObject = new BasicObject(cardid);
				return MediatorPanelMainUI.getBasicGridStatic(basicObject, CDataManager.getInstance().dataOfLevel.animationSeleted, true);
			}
		}
		
		
		public static function centerUI(mc:DisplayObject , size:Point = null):void
		{
			var width : Number = mc.width;
			var height:Number = mc.height;
			
			if(size)
			{
				width = size.x;
				height = size.y;
			}
			
			mc.x = (ConstantUI.currentScreenWidth - width ) /2;
			mc.y = (ConstantUI.currentScreenHeight - height ) /2;
		}
		
		/**
		 *  创建一个默认样式的滚动条 
		 * @param target 显示列表
		 * @param slider 滑块容器
		 * @param scrollBG 滑条容器
		 * @param maskPoint 遮罩大小
		 * @param scrollBGHeight 滑条高度
		 * @param mouseWheel 是否开启滚轮
		 * @return 
		 * 
		 */		
		public static function createScrollBar(target:Sprite, slider:Sprite, scrollBG:Sprite, maskPoint:Point, scrollBGHeight:int, mouseWheel:Boolean = false, mask:Sprite = null):ScrollBar
		{
			if(mask == null)
			{
				mask = new Sprite();
				mask.graphics.beginFill(0);
				mask.graphics.drawRect(0, 0, maskPoint.x, maskPoint.y);
				mask.graphics.endFill();
				mask.x = target.x;
				mask.y = target.y;
			}
			
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.CONST_UI_BG_SCROLLLINE , 
				new Rectangle(1, 50, 1, 80) , 
				new Point(3 , scrollBGHeight));
			bg.x = bg.y = 0;
			scrollBG.addChild(bg);
			
			var cls:Class = ResHandler.getClass(ConstantUI.CONST_UI_BG_SCROLLBAR);
			var btn:MovieClip = new cls();
			btn.x = btn.y = 0;
			slider.addChild(btn);
			
			var scrollBar:ScrollBar = new ScrollBar(target, mask, slider, scrollBG);
			scrollBar.mouseWheel = mouseWheel;
			
			return scrollBar;
		}
		
		public static function createCWidgetScrollBar(sliderbarStr:String, sliderbgStr:String, sliderbgScale9Rect:Rectangle, sliderbgRect:Point, maskSize:Point, itemGap:Number = 0 , withLayout:Boolean = false):CWidgetScrollBar
		{
			var cls:Class = ResHandler.getClass(sliderbarStr);
			var resource:MovieClip = new cls();
			
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass(sliderbgStr, sliderbgScale9Rect, sliderbgRect);
			
			var scrollBar:CWidgetScrollBar = new CWidgetScrollBar(resource, bg, maskSize.x, maskSize.y, itemGap , withLayout);
			return scrollBar;
		}
		
		/**
		 * 显示加载条 
		 * 
		 */		
		public static function showLoading():void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.ICON_LOADING));
		}
		
		/**
		 * 关闭加载条 
		 * 
		 */		
		public static function hideLoading():void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.ICON_LOADING));
		}
		
		/**
		 * 获取当前关卡在所有关卡的比例
		 * l ： 关卡的id
		 * 
		 * 视口点到 地图最下 / 地图总高度
		 */
		public static function calcLevelPercent(l:int):Number
		{
			var level:Level = CGroupUtil.getLevelPos(l);
			
			if(!level)
			{
				return 0;
			}
			
			var totalHeight:Number = Math.abs(MediatorWorldMainScene.MIN_Y) + Math.abs(MediatorWorldMainScene.SINGLE_MAP_HEIGHT) ;
			
			var currentLevelPercent:Number = (Math.abs(MediatorWorldMainScene.MIN_Y) - Math.abs(calcViewPortY(l))) / Math.abs(MediatorWorldMainScene.MIN_Y);
			
			return currentLevelPercent;
		}
		
		/**
		 * 计算当前level的视口Y 是个负数
		 */
		public static function calcViewPortY(l:int):Number
		{
			var level:Level = CGroupUtil.getLevelPos(l);
			
			if(!level)
			{
				return MediatorWorldMainScene.MIN_Y;
			}
			
			var resultY:Number = - (level.y - MediatorWorldMainScene.SINGLE_MAP_HEIGHT / 2 );
			
			resultY = resultY < MediatorWorldMainScene.MIN_Y ? MediatorWorldMainScene.MIN_Y : resultY;
			resultY = resultY > MediatorWorldMainScene.MAX_Y ? MediatorWorldMainScene.MAX_Y : resultY;
			
			return resultY;
		}
		
		public static function delayCall(f:Function , delayTime:Number = 0.3 , repeatCount:int = 1 , callback:Function = null):void
		{
			new CDelayedCall(f ,delayTime ,repeatCount , callback).start();
		}
		
		public static function playSound(soundKey:String , data:Object = null):void
		{
			Fibre.getInstance().sendNotification(soundKey, data, Fibre.SOUND_NOTIFICATION);
		}
		
		public static function sendEvent(event:String , data:Object = null):void
		{
			Fibre.getInstance().sendNotification(event , data);
		}
		
		public static function regEvent(event:String , func:Function):void
		{
			Fibre.getInstance().registerObserver(event , func);
		}
		
		public static function removeEvent(event:String , func:Function):void
		{
			Fibre.getInstance().removeObserver(event , func);
		}
		
		public static function showConfirm(msg:String , confirmFunc:Function = null , cancelFunc:Function = null , confirmParams:Object = null):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,new DatagramViewNormal(ConstantUI.PANEL_COMMON_CONFIRM , true ,{msg:msg , confirmFunc:confirmFunc ,cancelFunc:cancelFunc , confirmParams:confirmParams}));
		}
		
		public static function showMessage(msg:String):void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,new DatagramViewNormal(ConstantUI.DIALOG_COMMON_Message , true ,{text:msg}));
		}
		
		/**
		 * 防沉迷提示框 
		 * 
		 */		
		public static function getFCMTipsWin():Boolean
		{
			TRACE_LOG("防沉迷时间："+GameLobbySocketCallback.fcmTime);
			
			//验证防沉迷
			if(int(GameLobbySocketCallback.fcmTime / (ConfigManager.FCM_TIME * 3600000)) >= ConfigManager.FCM_TIME 
				&& GameLobbySocketCallback.userFcmStatus != 2 
				&& WebJSManager.originType != UserOrigin.UserOrigin_Visitor
				&& Debug.IS_OPEN_FCM)
			{
				showConfirm("亲爱的玩家，您已进入不健康游戏时间，为了您的健康，请您立即下线休息。休息超过3小时后才可继续游戏。", new Function());
				return true;
			}
			return false;
		}
		
		/**
		 * 数字转换成单位
		 */
		public static function num2text(num:Number, minNum:Number=0):String
		{
			if (0 == minNum)
			{
				minNum = 100000;
			}
			var text:String;
			if(num >= minNum)
			{
				text = Math.floor(num/10000) + "万";
			}
			else if (num > 100000000)
			{
				text = Math.floor(num/100000000) + "亿";
			}
			else
			{
				text = String(num);
			}
			return text;
		}
		
		/**
		 * SOCKET类型
		 */
		public static function getSocketType(socketName:String):int
		{
			if(socketName.indexOf(ConfigManager.SOCKET_LOBBY) != -1)
			{
				return ConstGlobalConfig.SOCKET_LOBBY;
			}
			else if(socketName.indexOf(ConfigManager.SOCKET_GAME) != -1)
			{
				return ConstGlobalConfig.SOCKET_GAME;
			}
			else
			{
				return ConstGlobalConfig.SOCKET_MATCH;
			}
		}
		
		/**
		 * 根据icon配置中的icon 获取 图标所在帧
		 * i : 帧数   
		 * ICON_NAME_LIST[i] : 是对应的icon
		 */
		public static function getIconFrameByIconId(iconid:int):int
		{
			for(var i:int = 0 ; i < ICON_NAME_LIST.length ; i++)
			{
				if(int(ICON_NAME_LIST[i]) == iconid)
				{
					return i + 1;
				}
			}
			return 1;
		}
		
		public static function getToolConfigById(id:int):Item
		{
			var items:Vector.<Item> = DataManager.getInstance().items.item;
			for(var i:int = 0 ; i < items.length ; i ++)
			{
				if(items[i].id == id)
				{
					return items[i];
				}
			}
			return null;
		}
		
		/**
		 * 根据道具的id获取道具的图标
		 */
		public static function getToolIconFrameByToolId(toolid:int):int
		{
			var config:Item =  getToolConfigById(toolid);
			var index:int = getIconFrameByIconId(config.icon);
			return index;
		}
		
		/**
		 *  整图切成帧数组 
		 * @param res
		 * @param size
		 * @return 
		 * 
		 */		
		public static function getFramesByBmp(res:String, size:Point, totalFrames:int):Array
		{
			var cl:Class = ResHandler.getClass(res);
			var bmpData:BitmapData = new cl();
			
			var frameWidth:int = size.x;
			var frameHeight:int = size.y;
			var frameBmpDatas:Array = new Array();
			
			var eachWnum:int = bmpData.width / frameWidth;
			var eachHnum:int = bmpData.height / frameHeight;
			var rect:Rectangle = new Rectangle(0, 0, frameWidth, frameHeight);
			var frameBmpData:BitmapData;
			var index:int = 0;
			while (index < totalFrames)
			{
				frameBmpData = new BitmapData(frameWidth, frameHeight);
				rect.x = index % eachWnum * frameWidth;
				rect.y = int(index / eachWnum) * frameHeight;
				frameBmpData.copyPixels(bmpData, rect, new Point(0, 0));
				frameBmpDatas.push(frameBmpData);
				index++;
			}
			return frameBmpDatas;
		}
		
		/**
		 * 是否是体力道具
		 */
		public static function isEnergyTool(id:int):Boolean
		{
			return id >= 10 && id <= 12;
		}
		
		public static function showSilverExchange():void
		{
			if(!Debug.inLobby)
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.DIALOG_COMMON_Message , true , {text:"网络不通啊，没法干活"}));
				return;
			}
			
			if(Debug.OPEN_STORE)
			{
				if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
				{
					WebJSManager.loginEnrol();
				}else
				{
					WebJSManager.gameFuncGetMall();
				}
			}else
			{
				CWidgetFloatText.instance.showTxt("功能暂未开放...");
			}
			
		}
		
		public static function showGoldExchange():void
		{
			if(!Debug.inLobby)
			{
				Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.DIALOG_COMMON_Message , true , {text:"网络不通啊，没法干活"}));
				return;
			}
			
			if(Debug.OPEN_STORE)
			{
				if(WebJSManager.originType == UserOrigin.UserOrigin_Visitor)
				{
					WebJSManager.loginEnrol();
				}else
				{
					WebJSManager.gameFuncGetPay();
				}
			}else
			{
				CWidgetFloatText.instance.showTxt("功能暂未开放...");
			}
			
		}
		
		/**
		 * 显示tip框
		 * pos:全局坐标
		 */
		public static function showTip(msg:String , pos:Point , size:Point = null , wordWrap:Boolean = true , direction:String = "up" , embedFont:Boolean = true , iconId:int = -1 , iconPos:Point = null , iconSize:Point = null):void
		{
			var params:Object = {};
			params.text = msg;
			
			if(pos)
			{
				pos = GameEngine.getInstance().globalToLocal(pos);
			}
			
			params.x = pos.x;
			params.y = pos.y;
			params.size = size ? size : ConstFlowTipSize.FLOW_TIP_MIDDLE;
			params.wordWrap = wordWrap;
			params.direction = direction;
			params.embedFont = embedFont;
			params.iconId = iconId;
			params.iconPos = iconPos;
			params.iconSize = iconSize;
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL ,new DatagramViewNormal(ConstantUI.ITEM_FLOWTIP_UI_SCALE , true ,params));
		}
		
		/**
		 * 关闭tip
		 */
		public static function closeTip():void
		{
			Fibre.getInstance().sendNotification(MediatorBase.G_CLOSE_PANEL , new DatagramView(ConstantUI.ITEM_FLOWTIP_UI_SCALE))
		}
		
		/**
		 * 视口移动到特定关卡
		 */
		public static function viewPortGotoLevel(level:int , useTween:Boolean = true):void
		{
			CBaseUtil.sendEvent(GameNotification.EVENT_SCENE_VIEW_PORT_MOVE , {level:level , useTween:useTween});
		}
		
		/**
		 *  替换资源中的文本 
		 * @param disObj
		 * @param size
		 * @param color
		 * @return 
		 * 
		 */		
		public static function getTextField(disObj:DisplayObject, size:int, color:uint, pos:String = null,  isDefaultFont:Boolean = false , glowColor:int = 0):TextField
		{
			var posStr:String = pos == null ? "center" : pos;
			var tf:TextField;
			if(isDefaultFont)
			{
				tf = new TextField();
				var tfm:TextFormat = new TextFormat(null, size, color, null, null, null, null, null, posStr);
				tf.defaultTextFormat = tfm;
			}else
			{
				tf = CFontUtil.getTextField(CFontUtil.getTextFormat(size , color, true, posStr));
			}
			tf.x = disObj.x;
			tf.y = disObj.y;
			if(pos != null)
			{
				tf.autoSize = pos;
			}
			tf.width = disObj.width;
			tf.height = disObj.height;
			tf.filters = disObj.filters;
			if(glowColor != 0)
			{
				tf.filters = [CFilterUtil.getTextGlowFilter(glowColor)];
			}
			
			disObj.parent.addChild(tf);
			
			if(disObj is TextField)
			{
				tf.text = TextField(disObj).text;
			}
			
			disObj.visible = false;
			
			return tf;
		}
		
		/**
		 * 取好友头像和名字，先从缓存取
		 */
		public static function getImageAndName(fid:UInt64 , useDelay:Boolean = false, callNetIfNoValue:Boolean = true):CMsgGetNameImageResponse
		{
			var d:CMsgGetNameImageResponse = CDataManager.getInstance().dataOfFriendList.getImg(fid);
			if(d == null && callNetIfNoValue)
			{
				NetworkManager.instance.sendServerGetFriendImageAndName(fid);
				
				if(useDelay)
				{
//					CBaseUtil.delayCall(function():void
//					{
//						NetworkManager.instance.sendServerGetFriendImageAndName(fid);
//					}, 0.3 , 1);
					
					MessageQueue.getInstance().pushMessage({func:NetworkManager.instance.sendServerGetFriendImageAndName , params:[fid]});
				}
				else
				{
					MessageQueue.getInstance().pushMessage({func:NetworkManager.instance.sendServerGetFriendImageAndName , params:[fid]});
				}
			}
			else
			{
				TRACE_LOG("缓存命中好友头像 qid = " + toNumber2(fid));
			}
			return d;
		}
		
		/**
		 * 获取好友的星值
		 */
		public static function getFriendStar(fid:UInt64, useDelay:Boolean = false , callNetIfNoValue:Boolean = true):int
		{
			var d:int = CDataManager.getInstance().dataOfFriendList.getStar(fid);
			if(d == -1 &&  callNetIfNoValue)
			{
				TRACE_LOG("好友星值未获取 qid = " + toNumber2(fid));
				
				if(useDelay)
				{
//					CBaseUtil.delayCall(function():void
//					{
//						NetworkManager.instance.sendServerGetFriendStarInfo(fid);
//					}, 0.3 , 1);
					
					MessageQueue.getInstance().pushMessage({func:NetworkManager.instance.sendServerGetFriendStarInfo , params:[fid]});
				}
				else
				{
					MessageQueue.getInstance().pushMessage({func:NetworkManager.instance.sendServerGetFriendStarInfo , params:[fid]});
				}
			}
			else
			{
				TRACE_LOG("缓存命中好友星值 qid = " + toNumber2(fid));
			}
			return d;
		}
		
		
		/**
		 * 画背景面板
		 * bgkey 参考 constantui
		 */
		public static function createBg(bgKey:String , scaleRect:Rectangle = null , destSize:Point = null , offsetY:Number = 38):Sprite
		{
			var sp:Sprite = new Sprite();
			var titleCls:Class = ResHandler.getClass(ConstantUI.CONST_UI_BG_TITLE);
			var title:Bitmap = new Bitmap(new titleCls()) ;
			sp.addChild(title);
			var bp:Bitmap;
			if(scaleRect == null)
			{
				var cls:Class = ResHandler.getClass(bgKey);
				bp = new Bitmap(new cls());
				sp.addChild(bp);
			}
			else
			{
				bp = CScaleImageUtil.CScaleImageFromClass(bgKey , 
					scaleRect ,destSize);
				sp.addChild(bp);
			}
			
			bp.y = title.height - offsetY;
			title.x = (bp.width - title.width) / 2;
			
			return sp;
		}
		
		/**
		 * 画底板
		 */
		public static function createBgSimple(type:String):Sprite
		{
			if(type == ConstantUI.CONST_UI_BG_LITTLE_WITHBORDER)
			{
				return CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , new Rectangle(195,50,2,2) , new Point(424 , 501));
			}
			else if(type == ConstantUI.CONST_UI_BG_BIG_WITHBORDER)
			{
				return CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , new Rectangle(195,50,2,2) , new Point(494 , 364));
			}
			else if(type == ConstantUI.CONST_UI_BG_WARNING)
			{
				return CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , new Rectangle(195,50,2,2) , new Point(387 , 238));
			}
			else if(type == ConstantUI.CONST_UI_BG_TIP)
			{
				return CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , new Rectangle(195,50,2,2) , new Point(413 , 273));
			}
			else if(type == ConstantUI.CONST_UI_BG_BIG_NOBORDER)
			{
				return CBaseUtil.createBg(ConstantUI.CONST_UI_BG_SCALE , new Rectangle(195,50,2,2) , new Point(691 , 502));
			}
			
			return null;
		}
		
		/**
		 * 第二组
		 */
		public static function checkSecondComplete(callback:Function = null , params:Object = null):Boolean
		{
			if(FileProxy.inst.finishSecondeLoadGroup)
			{
				return true;
			}
			else
			{
				CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PAENL_LOADING , true , {callback:callback , params:params}));
				return false;
			}
		}
		
		/**
		 *  获取比赛奖励内容 
		 * @param matchID
		 * @return 
		 * 
		 */		
		public static function getMatchAwardByID(matchID:int):MatchInfo
		{
			var list:Vector.<MatchInfo> = DataManager.getInstance().matchAwards.match;
			for each(var matchInfo:MatchInfo in list)
			{
				if(matchInfo.id == matchID)
				{
					return matchInfo;
				}
			}
			return null;
		}
		
		/**
		 *  弹出报名比赛提示 
		 * @param productID
		 * 
		 */		
		public static function popSignUp(productID:int, callBack:Function):void
		{
			if(CBaseUtil.getFCMTipsWin())
			{
				return;
			}
			var matchData:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(productID);
			var matchName:String;
			var currentMatchAward:MatchInfo = CBaseUtil.getMatchAwardByID(productID);
			if(currentMatchAward != null)
			{
				matchName = currentMatchAward.shortName;
			}
			else
			{
				matchName = matchData.matchName;
			}
			
			if(matchData.currentRobNum >= matchData.totalRobNum + 1)
			{
				CBaseUtil.showConfirm("您的挑战次数已用尽", new Function());
				return;
			}
			
			if(matchData.matchCD - matchData.matchEndTime <= 0)
			{
				CBaseUtil.showConfirm("当前比赛马上结束了，请等待报名下一场比赛", new Function());
				return;
			}
			
			var str:String = "";
			var curCost:Object = CBaseUtil.getCurrentSignUpCost(productID);
			if(curCost.id == 2)
			{
				str = curCost.num == 0 ? "" : "消耗 <b><font color='#ff0000'>" + curCost.num + "银豆</b></font> ";
			}
			else if(curCost.id == 1)
			{
				str = curCost.num == 0 ? "" : "消耗 <b><font color='#ff0000'>" + curCost.num + "金豆</b></font> ";
			}
			var tips:String = "是否" + str + "报名参加<b><font color='#ff0000'>" + matchName + "<b></font>？";
			
			if(curCost.id == 1)
			{
				CBaseUtil.showConfirm(tips, callBack, new Function(), curCost);
			}
			else
			{
				callBack.call(null, curCost);
			}
		}
		
		/**
		 * 播放一遍动画
		 */
		public static function playToEndAndStop(mc:MovieClip , callback:Function = null , visible:Boolean = false , remove:Boolean = false):void
		{
			mc.gotoAndPlay(1)
				
			var func:Function = function (e:Event):void
				{
					var target:MovieClip = (e.target as MovieClip);
					if(target.currentFrame == target.totalFrames)
					{
						target.stop();
						target.visible = visible;
						target.removeEventListener(Event.ENTER_FRAME , func);
						
						if(remove)
						{
							target.parent.removeChild(target);
						}
						
						if(callback != null)
						{
							callback();
						}
					}
				};
				
			mc.addEventListener(Event.ENTER_FRAME , func , false , 0 , true);
		}
		
		public static function playToEndWithClass(clsKey:String , callback:Function = null , visible:Boolean = false):void
		{
			var cls:Class = ResHandler.getClass("effect.hammer");
			var ani:MovieClip = new cls();
			
			playToEndAndStop(ani , callback , visible);
		}
		
		/**
		 * 设置显示对象的注册点
		 */
		public static function setRegPoint(target:DisplayObjectContainer , regX:Number = 0 , regY:Number = 0):void
		{
			var bounds:Rectangle = target.getBounds(target.parent);
			var currentRegX:Number = target.x - bounds.left;
			var currentRegY:Number = target.y - bounds.top;
			
			var xOffset:Number = regX - currentRegX;
			var yOffset:Number = regY - currentRegY;
			target.x += xOffset;
			target.y += yOffset;
			
			for(var i:int = 0; i < target.numChildren; i++) {
				target.getChildAt(i).x -= xOffset;
				target.getChildAt(i).y -= yOffset;
			}
		}
		
		/**
		 * 注册点居中
		 */
		public static function setRegPointCenter(target:DisplayObjectContainer):void
		{
			var regX:Number = target.width/2;
			var regY:Number = target.height/2;
			setRegPoint(target , regX , regY);
		}
		
		/**
		 *  文本转位图 
		 * @param tf
		 * @return 
		 * 
		 */		
		public static function textFieldToBitmap(tf:TextField):Bitmap
		{
			tf.visible = false;
			var bmd:BitmapData = new BitmapData(tf.textWidth , tf.textHeight , true , 0x00FFFFFF );
			var mat:Matrix = new Matrix();
			bmd.draw(tf , mat);
			var tfBmp:Bitmap = new Bitmap(bmd);
			tfBmp.x = tf.x;
			tfBmp.y = tf.y;
			
			return tfBmp;
		}
		
		/**
		 * 检测奖状弹出 
		 * 
		 */		
		public static function popDiploma():void
		{
			var infoData:Object = DataUtil.instance.diplomaList.shift();
			if(infoData == null)
			{
				return;
			}
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramViewNormal(ConstantUI.PANEL_MATCH_DIPLOMA, true, infoData));
		}
		
		/**
		 * 弹出比赛大厅 
		 * 
		 */		
		public static function popSignUpWin():void
		{
			var first:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getFirstMatch();
			if(DataUtil.instance.selectMatchProductID == 0)
			{
				if(first)
				{
					DataUtil.instance.selectMatchProductID = first.productID;
				}else
				{
					CBaseUtil.showConfirm("当前所有比赛正在维护...", new Function());
					return;
				}
			}else
			{
				var current:CDataOfMatch = CDataManager.getInstance().dataOfProduct.getMatchByID(DataUtil.instance.selectMatchProductID);
				if(current && CBaseUtil.getSignUpStatus(current.status))
					
				{
					
				}else
				{
					if(first)
					{
						DataUtil.instance.selectMatchProductID = first.productID;
					}else
					{
						CBaseUtil.showConfirm("当前所有比赛正在维护...", new Function());
						return;
					}
				}
			}
			
			NetworkManager.instance.reqMatchInfo(1, 8);
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_SIGNUP));
		}
		
		/**
		 * 下载好友的星值信息
		 */
		public static function startLoadFriendStarInfo():void
		{
			if(DataUtil.instance.isLoadingFriendData)
			{
				trace("isLoadingFriendData");
				return;
			}
			
			DataUtil.instance.isLoadingFriendData = true;
			
			var friendList:Array = CDataManager.getInstance().dataOfFriendList.getFriendList();
			
			var batch:CBatchExecute = new CBatchExecute(CBaseUtil.getFriendStar , friendList , 10 , 0.3 , 
			function():void
			{
				DataUtil.instance.isLoadingFriendData = false;
			}
			);
		}
		
		/**
		 *  是否可以显示在列表中的比赛 
		 * @param status
		 * @return 
		 * 
		 */		
		public static function getSignUpStatus(status:int):Boolean
		{
			return status != Product_Status.Product_Status_Init 
				&& status != Product_Status.Product_Status_Offline 
				&& status != Product_Status.Product_Status_Close;
		}
		
		/**
		 * 数组分片
		 */
		public static function splitArrayToPiece(input:Array , distance:int = 10):Array
		{
			var total:int = input.length;
			var count:int = 0;
			var result:Array = new Array();
			var temp:Array = new Array();
			for(var i:int = 0 ; i < total ; i++)
			{
				temp.push(input[i]);
				if(++count == distance)
				{
					result.push(temp);
					
					count = 0 ;
					
					temp = new Array();
				}
			}
			
			if(temp.length != 0)
			{
				result.push(temp);
			}
			
			return result;
		}
	}
}