package framework.util
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import framework.core.tick.GameTicker;
	import framework.core.tick.ITickObject;

	public class TipPositionUtil implements ITickObject
	{
		private var activedTips:Dictionary = new Dictionary(true);
		private var nextTickTime:Number = -1;
		
		private static var _instance:TipPositionUtil;
		
		public function TipPositionUtil()
		{
			GameTicker.getInstance().addToTickQueue(this);
			updateNextTickTime();
		}
		
		private function updateNextTickTime():void
		{
			nextTickTime = getTimer() + 100;
		}
		
		public static function getInstance():TipPositionUtil
		{
			if(_instance == null)
			{
				_instance = new TipPositionUtil();
			}
			return _instance;
		}
		
		public function isTickPaused() : Boolean
		{
			return false;
		}

		public function tickObject(psdTickMs:Number) : void
		{
			if(getTimer() < nextTickTime)
			{
				return;
			}
			
			updateNextTickTime();
			
			for(var key:Object in activedTips)
			{
				var tip:DisplayObject = key as DisplayObject;
				if(tip.visible && tip.stage != null)
				{
					var callback:Function = activedTips[key];
					callback();
				}
			}
		}

		public function addTip(mapObject:MapObject, tip:DisplayObject, callbackAdjustment:Function = null):void
		{
			CONFIG::debug
			{
				ASSERT(activedTips[tip] == null, getQualifiedClassName(tip) + " is in dictionary already");
				ASSERT(tip != null);
			}
		
			if(callbackAdjustment == null)
			{
				if(mapObject != null)
				{
					var wrapper:MapObjectPositionWrapper = new MapObjectPositionWrapper(mapObject, tip);
					callbackAdjustment = wrapper.adjust;

/*					var iconPosition:AssetIconPositionDefine = StaticIconDefine.instance.getIconDefineByName(mapObject.res.className, mapObject.getDisplayFrame());
					if(iconPosition != null)
					{
						callbackAdjustment = getCallbackWithDefine(mapObject, tip, iconPosition);
					}
					else
					{
						callbackAdjustment = getCallbackWithoutDefine(mapObject, tip);
					}
*/					
				}
				
			}
			
			if(callbackAdjustment != null)
			{
				activedTips[tip] = callbackAdjustment;
				callbackAdjustment();
			}

			

			TipZoomUtil.getInstance().addTip(tip);
			
			CONFIG::debug
			{
				ASSERT(activedTips[tip] != null, getQualifiedClassName(tip) + " is not in dictionary");
			}
		}
		
		public function removeTip(tip:DisplayObject):void
		{
			CONFIG::debug
			{
				ASSERT(activedTips[tip] != null, getQualifiedClassName(tip) + " is not in dictionary");
			}

			delete activedTips[tip];
			
			TipZoomUtil.getInstance().removeTip(tip);

		}
		
		CONFIG::debug
		{
			public function hasTip(tip:DisplayObject):Boolean
			{
				return (activedTips[tip] != null);
			}
		}
		
/*		private function getCallbackWithDefine(mapObject:MapObject, tip:DisplayObject, iconPosition:AssetIconPositionDefine):Function
		{
			var callback:Function =
				function():void
				{
					tip.x = mapObject.x - iconPosition.xOffset;
					tip.y = mapObject.y - iconPosition.yOffset;
				};
			return callback;
		}
		
		private function getCallbackWithoutDefine(mapObject:MapObject, tip:DisplayObject):Function
		{
			var effectObjectPosition:Point =
				Camera.instance.getWorldPositionByCellPosition(mapObject.frame.columnNum, mapObject.frame.rowNum);
			
			var callback:Function =
				function():void
				{
					tip.x = mapObject.x - effectObjectPosition.x / 2;

					var height:Number = mapObject.resObject.height;
//					CONFIG::debug
//					{
//						ASSERT(height > 0);
//					}
					tip.y = mapObject.y - height;
//					tip.y = mapObject.y - (height > 0 ? height : effectObjectPosition.y / 2);
				};
			return callback;
		}
*/		
		
	}
}



import flash.display.DisplayObject;
import flash.geom.Point;

class MapObjectPositionWrapper
{
	private var mapObject:MapObject;
	private var tip:DisplayObject;

	private var lastFrame:int = -1;
	private var iconPosition:AssetIconPositionDefine;
	private static const TOP_LIMIT:int = 68;
	
	function MapObjectPositionWrapper(mapObject:MapObject, tip:DisplayObject):void
	{
		this.mapObject = mapObject;
		this.tip = tip;
	}
	
	public function adjust():void
	{
		var currentFrame:int = mapObject.getDisplayFrame();
		if(lastFrame != currentFrame)
		{
			lastFrame = currentFrame;
			
			if(mapObject.displayRes != null)
			{
				iconPosition = StaticIconDefine.instance.getIconDefineByName(mapObject.displayRes.className, currentFrame);
			}

		}
		
		var effectObjectPosition:Point =
			GameCamera.instance.getWorldPositionByCellPosition(mapObject.frame.columnNum, mapObject.frame.rowNum);
		
		if(iconPosition != null)
		{
			tip.x = mapObject.x - iconPosition.xOffset;
			tip.y = mapObject.y - iconPosition.yOffset;	
			
			if(iconPosition.xOffset == 0)
			{
				tip.x = mapObject.x - effectObjectPosition.x / 2;			
			}
		}
		else
		{		
			tip.x = mapObject.x - effectObjectPosition.x / 2;
			
			var height:Number = mapObject.resObject.height;
			tip.y = mapObject.y - height + 10;
			
			var limit:Number = TOP_LIMIT/ZoomHandle.getGameScale();
			
			var top:Number = tip.getBounds(mapObject.parent).top;
			if(top - limit < 0)
			{		
				tip.y -= top;
				tip.y += limit;
			}
		}
	}
}