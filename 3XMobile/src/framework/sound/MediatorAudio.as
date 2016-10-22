package framework.sound
{	
	import framework.datagram.DatagramView;
	import framework.fibre.core.Notification;
	import framework.fibre.core.SoundNotification;
	import framework.fibre.patterns.Mediator;
	import framework.model.StaticResProxy;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;
	
	public class MediatorAudio extends Mediator
	{
		public static const ID:String = "MEDIATORSOUND";
		
		public static const EVENT_SOUND_SHOW_HINT:String = "EVENT_SOUND_SHOW_HINT";
		public static const EVENT_SOUND_BINGO:String = "EVENT_SOUND_BINGO";
		public static const EVENT_SOUND_GOOD:String = "EVENT_SOUND_GOOD";
		public static const EVENT_SOUND_GREAT:String = "EVENT_SOUND_GREAT";
		public static const EVENT_SOUND_EXCELLENT:String = "EVENT_SOUND_EXCELLENT";
		public static const EVENT_SOUND_UNBELIEVABLE:String = "EVENT_SOUND_UNBELIEVABLE";
		public static const EVENT_SOUND_AMAZING:String = "EVENT_SOUND_AMAZING";
		public static const EVENT_SOUND_COLLECT_ITEM:String = "EVENT_SOUND_COLLECT_ITEM";
		public static const EVENT_SOUND_MOVE_ITEM:String = "EVENT_SOUND_MOVE_ITEM";
		public static const EVENT_SOUND_WIN:String = "EVENT_SOUND_WIN";
		public static const EVENT_SOUND_LOSE:String = "EVENT_SOUND_LOSE";
		public static const EVENT_SOUND_SELECT_ITEM:String = "EVENT_SOUND_SELECT_ITEM";
		public static const EVENT_SOUND_DESTORY_ICE:String = "EVENT_SOUND_DESTORY_ICE";
		public static const EVENT_SOUND_DESTORY_WALL:String = "EVENT_SOUND_DESTORY_WALL";
		
		public static const EVENT_SOUND_WARNING:String = "EVENT_SOUND_WARNING";
		
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION1:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION1";
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION2:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION2";
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION3:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION3";
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION4:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION4";
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION5:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION5";
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION6:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION6";
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION7:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION7";
		public static const EVENT_SOUND_SUCCESSIVE_ELIMINATION8:String = "EVENT_SOUND_SUCCESSIVE_ELIMINATION8";
		public static const EVENT_SOUND_SPECIAL_EFFECTS1:String = "EVENT_SOUND_SPECIAL_EFFECTS1";
		public static const EVENT_SOUND_ELIMINATE_EFFECTS1:String = "EVENT_SOUND_ELIMINATE_EFFECTS1";
		public static const EVENT_SOUND_SPECIAL_EFFECTS2:String = "EVENT_SOUND_SPECIAL_EFFECTS2";
		public static const EVENT_SOUND_ELIMINATE_EFFECTS2:String = "EVENT_SOUND_ELIMINATE_EFFECTS2";
		public static const EVENT_SOUND_ELIMINATE_EFFECTS3:String = "EVENT_SOUND_ELIMINATE_EFFECTS3";
		public static const EVENT_SOUND_ELIMINATE_EFFECTS4:String = "EVENT_SOUND_ELIMINATE_EFFECTS4";
		public static const EVENT_SOUND_ELIMINATE_EFFECTS5:String = "EVENT_SOUND_ELIMINATE_EFFECTS5";
		public static const EVENT_SOUND_SPECIAL_EFFECTS3:String = "EVENT_SOUND_SPECIAL_EFFECTS3";
		public static const EVENT_SOUND_ELIMINATE_EFFECTS6:String = "EVENT_SOUND_ELIMINATE_EFFECTS6";
		public static const EVENT_SOUND_ELIMINATE_EFFECTS7:String = "EVENT_SOUND_ELIMINATE_EFFECTS7";
		public static const EVENT_SOUND_CIRRUS:String = "EVENT_SOUND_CIRRUS";
		public static const EVENT_SOUND_BUG1:String = "EVENT_SOUND_BUG1";
		public static const EVENT_SOUND_BUG2:String = "EVENT_SOUND_BUG2";
		public static const EVENT_SOUND_GRASS:String = "EVENT_SOUND_GRASS";
		public static const EVENT_SOUND_BUBBLE:String = "EVENT_SOUND_BUBBLE";
		public static const EVENT_SOUND_SILVER_AWARD:String = "EVENT_SOUND_SILVER_AWARD";
		
		public static const EVENT_SOUND_WOODEN_MALLET:String = "EVENT_SOUND_WOODEN_MALLET";
		public static const EVENT_SOUND_MAGIC_WAND:String = "EVENT_SOUND_MAGIC_WAND";
		
		public static const EVENT_SOUND_MANUAL_BOTTLE:String = "EVENT_SOUND_MANUAL_BOTTLE";
		
		public static const EVENT_SOUND_FALL:String = "EVENT_SOUND_FALL";
		
		private static const NOTIFICATION_TO_LISTEN:Array = [
			GameNotification.SOMETHING_BEFORE_CLICK,
			/*GameNotification.AM_PANEL_POPUP_FROM_LAYER,
			GameNotification.AM_PANEL_REMOVE,
			
			GameNotification.AM_WORLD_ADD_TO_LAYER,*/
			GameNotification.AM_PANEL_REMOVE,
			GameNotification.AM_PANEL_POPUP_FROM_LAYER,
			EVENT_SOUND_SHOW_HINT,
			EVENT_SOUND_BINGO,
			EVENT_SOUND_GOOD,
			EVENT_SOUND_GREAT,
			EVENT_SOUND_EXCELLENT,
			EVENT_SOUND_UNBELIEVABLE,
			EVENT_SOUND_AMAZING,
			EVENT_SOUND_MOVE_ITEM,
			EVENT_SOUND_SELECT_ITEM,
			EVENT_SOUND_WIN,
			EVENT_SOUND_LOSE,
			EVENT_SOUND_COLLECT_ITEM,
			EVENT_SOUND_DESTORY_ICE,
			EVENT_SOUND_DESTORY_WALL,
			EVENT_SOUND_WARNING,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION1,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION2,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION3,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION4,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION5,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION6,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION7,
			EVENT_SOUND_SUCCESSIVE_ELIMINATION8,
			EVENT_SOUND_SPECIAL_EFFECTS1,
			EVENT_SOUND_ELIMINATE_EFFECTS1,
			EVENT_SOUND_SPECIAL_EFFECTS2,
			EVENT_SOUND_ELIMINATE_EFFECTS2,
			EVENT_SOUND_ELIMINATE_EFFECTS3,
			EVENT_SOUND_ELIMINATE_EFFECTS4,
			EVENT_SOUND_ELIMINATE_EFFECTS5,
			EVENT_SOUND_SPECIAL_EFFECTS3,
			EVENT_SOUND_ELIMINATE_EFFECTS6,
			EVENT_SOUND_ELIMINATE_EFFECTS7,
			EVENT_SOUND_CIRRUS,
			EVENT_SOUND_BUG1,
			EVENT_SOUND_BUG2,
			EVENT_SOUND_BUBBLE,
			EVENT_SOUND_SILVER_AWARD,
			EVENT_SOUND_WOODEN_MALLET,
			EVENT_SOUND_MAGIC_WAND,
			EVENT_SOUND_MANUAL_BOTTLE,
			EVENT_SOUND_FALL
		 ];
		
		public function MediatorAudio()
		{
			super(ID);
		}
		
		override public function onRegister():void
		{
			for(var i:int = 0; i < NOTIFICATION_TO_LISTEN.length; i++)
			{
				registerObserver(NOTIFICATION_TO_LISTEN[i], onGameNotification);
			}
		}
		
		public static function isRegister(notificationName:String):Boolean
		{
			return NOTIFICATION_TO_LISTEN.indexOf(notificationName) >= 0;
		}
		
		private function getParam(notification:Notification):String
		{
//			var soundEventId:String = notification.name;
			
			if(notification.data is DatagramView)
			{
				return (notification.data as DatagramView).viewID;
			}
			/*else if(notification.data is DatagramSomeThingClick)
			{
				return DatagramSomeThingClick.getLocatorString(notification.data);
			}*/			
			return null;
		}
		
		
		
		protected function onGameNotification(notification:Notification):void
		{
			var dataName:String = getParam(notification);
			
			/*CONFIG::debug
			{
				ASSERT(notification is SoundNotification, "notification "+notification.name+" is not SoundNotification");
			}*/
			if(dataName == ConstantUI.ITEM_FLOWTIP_UI_SCALE)
			{
				//tip remove sound
				return;
			}
			
			CONFIG::debug
			{
				ASSERT(notification is SoundNotification, "notification "+notification.name+" is not SoundNotification");
			}
			
			var isPlay:Boolean = (notification as SoundNotification).isPlay;
			var playStatus:String = isPlay?"Play":"Stop";
			var soundConfig : StaticSoundConfigEntry = StaticResProxy.inst.staticSoundConfig.getEntry(notification.name, dataName);
			
			TRACE_BOTTOM_ITEM("Sound_EventName: "+ notification.name + "\n  SubName: " + dataName + "\n   PlayStatus:  "+playStatus);
			
	
			if (soundConfig == null)
			{
//				TRACE_UISOUND("Sound_EventName: "+ notification.name + " SubName: " + dataName +"can not find!");
				return;
			}
			
			if (isPlay)
			{
				/*var soundVariation : SoundVariation = new SoundVariation(soundConfig.soundId, soundConfig.variations);
				soundVariation.play(soundConfig.category, soundConfig.loops, soundConfig.soundParams);*/
				
				SoundHandler.instance.play(soundConfig.soundId, soundConfig.category, soundConfig.soundParams, null, soundConfig.loops);
			}
			else
			{
				SoundHandler.instance.stopSoundById(soundConfig.soundId, soundConfig.category);	
				SoundHandler.instance.removeFromBufferAudio(soundConfig.soundId, soundConfig.category);
			}
			
		}
	}
}