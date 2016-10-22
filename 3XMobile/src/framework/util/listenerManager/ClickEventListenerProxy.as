package framework.util.listenerManager
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramSomeThingClick;
	import framework.fibre.core.Fibre;
	import framework.util.UIUtil;
	import framework.view.notification.GameNotification;
	
	public class ClickEventListenerProxy
	{
		public function ClickEventListenerProxy()
		{
		}
		
		public static const BLACK_LIST:Array = 
		[
		
		]
		
		public static function stopEventListener(o : EventDispatcher, eventType : String, f:Function):void
		{
			if(o is DisplayObject)
			{
				if(eventType == TouchEvent.TOUCH_TAP)
				{
					var assetAllocationString:String = UIUtil.generateAssetAllocationString(o as DisplayObject);
					if(BLACK_LIST.indexOf(assetAllocationString) == -1 )
					{
						o.addEventListener(eventType, stopEventHandle);
					}
				}
			}
		}
		
		public static function preEventListener(o : EventDispatcher, eventType : String, f : Function):void
		{
			if(o is DisplayObject)
			{
				if(eventType == TouchEvent.TOUCH_TAP)
				{
					o.addEventListener(eventType, sendBtnBeforeClickNotificationHandle);
				}
			}
		}
		
		public static function afterEventListener(o : EventDispatcher, eventType : String, f : Function):void
		{
			if(o is DisplayObject)
			{
				if(eventType == TouchEvent.TOUCH_TAP)
				{
					o.addEventListener(eventType, sendBtnAfterClickNotificationHandle);
				}
			}
		}
		
		
		
		public static function free(o : EventDispatcher, e : String):void
		{
			o.removeEventListener(e, sendBtnBeforeClickNotificationHandle);
			o.removeEventListener(e, sendBtnAfterClickNotificationHandle);
			o.removeEventListener(e, stopEventHandle);
		}
		
		public static function sendBtnBeforeClickNotificationHandle(e:TouchEvent):void
		{	
			Fibre.getInstance().sendNotification(GameNotification.SOMETHING_BEFORE_CLICK,
				new DatagramSomeThingClick(UIUtil.generateAssetAllocationString(e.currentTarget as DisplayObject)), Fibre.SOUND_NOTIFICATION
			);	
		}
		
		public static function sendBtnAfterClickNotificationHandle(e:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(GameNotification.SOMETHING_AFTER_CLICK,
				new DatagramSomeThingClick(UIUtil.generateAssetAllocationString(e.currentTarget as DisplayObject))
			);
		}
		
		public static function stopEventHandle(e:TouchEvent):void
		{
			var assetAllocationString:String = UIUtil.generateAssetAllocationString(e.currentTarget as DisplayObject);

			e.stopImmediatePropagation();
		}
	}
}