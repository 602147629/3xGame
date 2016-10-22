package framework.util
{
	import application.external.ExternalInterfaceProxy;
	import analytics.GlobalErrorCode;
	import framework.core.backSystem.GlobalTicker;
	import framework.core.game.highquality.QualityManager;
	import framework.core.gamesetting.GameSettingSharedObject;
	import framework.core.multimap.MultiMapsUtil;
	import framework.core.rpc.RpcProxy;
	import framework.core.tick.GameTicker;
	import framework.core.tick.ITickObject;
	import framework.core.user.UserManager;
	import framework.model.CurrentUserProxy;
	import rpc.share.RpcClientBase;
	import types.helpers.JSONUtils;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.getTimer;

	public class Stats extends Sprite implements ITickObject
	{
//		private var _timer:uint;
		private var currentFps:uint;
//		private var _ms:uint;
		private var lastRecordTime:uint;
//		private var _lowFps:int;
		
		private var fpsRecords:Vector.<int>;
		private var recordCategory:Object;// :Vector.<FpsData>;
		
		public static const SCREEN_FULL:String = "full city";
		public static const SCREEN_SMALL:String = "small city";
//		public static var test:Array = [];
		
//		private static const DEFAULT_FPS:int = 30;
		
		private var _isSendFpsStats:Boolean;
		
		private var _metricData:Array;;
		private var _gatheringData:Boolean;
		
		public function Stats()
		{
//			_isSendFpsStats = false;
			
//			GlobalTicker.add(this, update);
			GameTicker.getInstance().addToTickQueue(this);
			
			fpsRecords = new Vector.<int>();
			_metricData = new Array();
			
			recordCategory = new Object();// Vector.<FpsData>();
			recordCategory[SCREEN_FULL] = new FpsData(SCREEN_FULL);//, DEFAULT_FPS);
			recordCategory[SCREEN_SMALL] = new FpsData(SCREEN_SMALL);//, DEFAULT_FPS);
		}
		
		CONFIG::debug
		{
			public function initJSCallback():void
			{
//				ExternalInterfaceProxy.addCallback("getCurrentFPS", getCurrentFPS);
//				ExternalInterfaceProxy.addCallback("getCurrentMEM", getMem);
				//ExternalInterfaceProxy.addCallback("getMetricData", getMetricData);
//				ExternalInterfaceProxy.addCallback("getMetricData", getMetricDataWithStamp);
				
//				ExternalInterfaceProxy.addCallback("getFPS", getFPS);
//				ExternalInterfaceProxy.addCallback("getMemory", getMemory);
//				ExternalInterfaceProxy.addCallback("startGatheringMetricsData", startGatheringMetricsData);
//				ExternalInterfaceProxy.addCallback("stopGatheringMetricsData", stopGatheringMetricsData);
			}
			
			/**
			 * @see https://wiki.svc.fishonomics.com/display/TAF/Test+External+Interface+API+for+realtime+metrics+of+online+flash+game
			 */
			private function getFPS():Object
			{
				var fpsWindowArray:Array = [];
				
				for each(var data:Object in _metricData)
				{
					fpsWindowArray.push(data.fps);
				}
				
				return {fpsWindowArray:fpsWindowArray};
			}
			
			private function getMemory():Object
			{
				var memWindowArray:Array = [];
				
				for each(var data:Object in _metricData)
				{
					memWindowArray.push(data.memory);
				}
				
				return {memWindowArray:memWindowArray};
			}
			
			private function startGatheringMetricsData(settings:Object):Object
			{
				_metricData.splice(0, _metricData.length);
				_gatheringData = true;
				
				return {"gameState":0,"clientVersion":"1.0.2","serverVersion":"1.0.3"};
			}
			
			private function stopGatheringMetricsData():Object
			{
				_gatheringData = false;
				
				return {gameState:0};
			}
			
			private function getMetricDataWithStamp():String
			{
				return JSONUtils.encode(_metricData);
			}
			
			private function getMetricData():String
			{
				var data:Object = {};
				data.fps = getCurrentFPS();
				data.memory = System.totalMemory;
				
				return JSONUtils.encode(data);
			}
			
			private function getCurrentFPS():int
			{
				if(fpsRecords.length > 0)
				{
					return fpsRecords[fpsRecords.length - 1];
				}
				return 0
				
			}
			
			private function getAvgFps():int
			{
				if(fpsRecords.length > 0)
				{
					return getFpsInfo()[0];
				}
				return 0;
			}
			
			private function getMem():uint
			{
				return System.totalMemory >> 20;
			}
		}
		
		
//		public function getFps():int
//		{
//			return _fps;
//		}
		
		public function tickObject(psdTickMs:Number) : void
		{
			update(null);
		}
		
		public function isTickPaused() : Boolean
		{
			return false;
		}
		
		public function getFpsInfo():Array
		{
			var lowFps:int = int.MAX_VALUE;
			var totalFps:int = 0;
			for each(var fps:int in fpsRecords)
			{
				totalFps += fps;
				if(fps < lowFps)
				{
					lowFps = fps;
				}
			}
			
			var avFps:int = totalFps / fpsRecords.length;
			
			return [avFps, lowFps];	
		}
		
		private function getAverageFpsAndCleanRecord():Array
		{
			
			if(fpsRecords.length != 0)
			{
				var fpsInfo:Array = getFpsInfo();
				fpsRecords.splice(0, fpsRecords.length);
				return fpsInfo;
			}
			else
			{
				return null;
			}
		}
		
		
		public function sendFpsStats():void
		{
			if(!_isSendFpsStats)
			{
				_isSendFpsStats = true;

				var screenFullRecord:String = GameSettingSharedObject.instance.getStringValue(SCREEN_FULL);
				if(screenFullRecord != null && screenFullRecord != "")
				{
					RpcProxy.instance.sendLogEvent(GlobalErrorCode.LOG_FPS, screenFullRecord);
				}
				
				var screenSmallRecord:String = GameSettingSharedObject.instance.getStringValue(SCREEN_SMALL);
				if(screenSmallRecord != null && screenSmallRecord != "")
				{
					RpcProxy.instance.sendLogEvent(GlobalErrorCode.LOG_FPS, screenSmallRecord);
				}
				
			}
		}
		
		public function saveRecord(passTimer:Number, screenType:String):void
		{
			var statFps:Array = getAverageFpsAndCleanRecord();
			if(statFps != null)
			{
				var fpsData:FpsData = recordCategory[screenType];
				fpsData.setAvpFps(statFps[0]);
				fpsData.setLowFps(statFps[1]);

				fpsData.addTimeLength(passTimer);
				
				var o:Object = new Object();
				o.complexity = UserManager.instance.currentUser.getPopulation(0);
				o.settings = QualityManager.instance.isHighQuality ? 1:0;
				o.data = fpsData.getObject();
				o.version = Capabilities.version;
				o.os = Capabilities.os;
				o.playerType = Capabilities.playerType;
				o.data.city = MultiMapsUtil.getCurrentCityIdSafely();
				
				var saveData:String = JSONUtils.encode(o);
				GameSettingSharedObject.instance.setStringValue(screenType, saveData);
//				test.push(statFps[0]);
				//TRACE_RPC("AvpFps : " + statFps[0].toString() + "   LowFps : " + statFps[1].toString());
//				ouputAFPS();
			}
			
					
//			_lowFps = DEFAULT_FPS;
		}
		
//		private function ouputAFPS():void
//		{
//			trace("ouputAFPS");
//			var count:int = Stats.test.length;
//			for(var i:int = 0; i < count; ++i)
//			{
//				trace("ouputAFPS[" + i.toString() + "] = " + Stats.test[i].toString());
//			}
//		}
		
//		private function getFpsData(screenType:String):FpsData
//		{
//			for each(var fpsData:FpsData in _fpsDatas)
//			{
//				if(fpsData.screenType == screenType)
//				{
//					return fpsData;
//				}
//			}
//			
//			return null;
//		}
		
		private function update(e:Event):void
		{
			
			var _timer:Number = getTimer();
			const statPeriod:int = 1000;
			if (_timer - lastRecordTime > statPeriod)
			{
				fpsRecords.push(currentFps);
				
				CONFIG::debug
				{
					if(_gatheringData)
					{
						var mem:int = System.totalMemory;
						var timestamp:Number = new Date().getTime();
						
						var data:Object = {};
						
						data.fps = currentFps;
						data.memory = mem;
						data.timestamp = timestamp;
						
						_metricData.push(data);	
					}					
				}
				
//				if(currentFps < _lowFps)
//				{
//					_lowFps = currentFps;
//				}
				
				lastRecordTime=_timer;			
				currentFps = 0;
			}
			
			currentFps++;
		}
	}
}

class MetricData
{
	private var _fps:int;
	private var _mem:int;
	private var _timestamp:Number;
	
	public function MetricData(fps:int, mem:int, timestamp:Number)
	{
		_fps = fps;		
	}
	
	public function get fps():int
	{
		return _fps;
	}

	public function get mem():int
	{
		return _mem;
	}

	public function get timestamp():Number
	{
		return _timestamp;
	}

	
}

class FpsData
{
	private var _screenType:String;
	private var _timeLength:Number;
	private var _lowFps:int;
	private var _avpFps:int;
//	private var _o:Object;
	
	public function FpsData(screenType:String)//, lowFps:int)
	{
		_screenType = screenType;
//		_lowFps = lowFps;
		_timeLength = 0;
//		_o = new Object();
	}
	
	public function get screenType():String
	{
		return _screenType;
	}
	
	public function setLowFps(fps:int):void
	{
		_lowFps = fps;
//		if(fps < _lowFps && fps != 0)
//		{
//			_lowFps = fps;
//		}
//		
//		if(_lowFps > _avpFps)
//		{
//			_lowFps = _avpFps;
//		}
	}
	
	public function setAvpFps(fps:int):void
	{
		_avpFps = fps;
	}
	
//	public function setTimerLength(time:Number):void
//	{
//		_timeLength = time;
//	}
	
	public function addTimeLength(time:Number):void
	{
		_timeLength += time;
	}
	
	public function getObject():Object
	{
		var _o:Object = new Object();
		_o.screen = _screenType;
		_o.length = _timeLength;
		_o.avp_fps = _avpFps;
		_o.low_fps = _lowFps;
		return _o;
	}
}