package framework.ui
{
	import com.game.consts.ConstLevelSpriteIcon;
	import com.game.event.GameEvent;
	import com.game.module.CDataManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.ui.item.CItemCloud;
	import com.ui.item.CItemLevelSprite;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CConfigUtil;
	import com.ui.util.CFlowCode;
	import com.ui.util.CGroupUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	
	import framework.datagram.DatagramNormal;
	import framework.datagram.DatagramView;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.model.DataManager;
	import framework.resource.faxb.notice.Update;
	import framework.resource.faxb.sceneui.Level;
	import framework.resource.faxb.sceneui.Levels;
	import framework.resource.faxb.tutorial.ShowArrow;
	import framework.rpc.DataUtil;
	import framework.rpc.NetworkManager;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;
	
	public class MediatorWorldMainScene extends MediatorBase
	{
		private var _flowerMC:Class;
		private var _isDragging:Boolean = false;
		private var _orignaly:Number = 0;
		
		public static var MAX_X:Number = 0;
		public static var MIN_X:Number = 0;
		
		public static var MAX_Y:Number = 0;
		public static var MIN_Y:Number = - 7 * 648 ; //地图总高度 - 一张地图高度
		
		public static const SINGLE_MAP_HEIGHT:Number = 648 ;
		
		public static const MAP_GROUP_LEN:int = 8;
		
		private var _levelSpriteLayer:Sprite;
		private var _mapSpriteLayer:Sprite;
		private var _cloudLayer:Sprite;
		
		private var _arrowLayer:Sprite;
		
		private var _cloudList:Array;
		
		public function MediatorWorldMainScene()
		{
			super(ConstantUI.SCENE_MAIN, ConstantUI.SCENE_MAIN, true);
		}
		
		override protected function start(d:DatagramView):void
		{
			this._mapSpriteLayer = new Sprite();
			mc.addChild(this._mapSpriteLayer);
			
			var index:int;
			var count:int;
			var len:int = CGroupUtil.getGroupLen();
			for(index = 0; index < len; index++)
			{
				var n:int = MAP_GROUP_LEN - count;
				if(n == 0)
				{
					n = MAP_GROUP_LEN;
					count = 0;
				}
				var c:Class = ResHandler.getClass("bmd.map" + n);
				var map:Bitmap = new Bitmap(new c() as BitmapData);
				_mapSpriteLayer.addChild(map);
				map.y = - ( index + 1 ) * map.height;
				count ++;
			}
			this._mapSpriteLayer.y = this._mapSpriteLayer.height;
			
			MIN_Y = - ( len - 1 ) * SINGLE_MAP_HEIGHT;
			
			this.mc.x = 0 ;
			this.mc.y = MIN_Y;
			
			_cloudList = new Array();
			
			_levelSpriteLayer = new Sprite();
			
			this.mc.addChild(_levelSpriteLayer);
			
			_cloudLayer = new Sprite();
			
			this.mc.addChild(_cloudLayer);
			
			_arrowLayer = new Sprite();
			
			this.mc.addChild(_arrowLayer);
			
			__initLevelSprite();
			
			__initEvent();
			
			var currentLevel:int = CDataManager.getInstance().dataOfGameUser.curLevel;
			
			Fibre.getInstance().sendNotification(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.USER_INFO_PANEL));
			
			CFlowCode.showPop();
			
			//检测大地图是否显示新手箭头
			CBaseUtil.sendEvent(GameEvent.EVENT_NOTICE_CHECK_WORLD, currentLevel);
			
			__checkShowNotice();
			
			NetworkManager.instance.sendLobbyOnlineUser();
		}
		
		private function __checkShowNotice():void
		{
			var upateConfig:Update = CConfigUtil.getNewNotice();
			var start:Number = Date.parse(upateConfig.starttime);
			var end:Number = Date.parse(upateConfig.endtime);
			var current:Number = new Date().getTime();
			if(current >= start && current <= end)
			{
				if(!DataUtil.instance.showNotice)
				{
					DataUtil.instance.showNotice = true;
					CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL, new DatagramView(ConstantUI.PANEL_UPDATE_NOTICE));
				}
			}
		}
		
		private function __initLevelSprite():void
		{
			for(var i:int = 0 ; i < DataManager.getInstance().sceneConfig.levels.length ; i++)
			{
				var levels:Levels = DataManager.getInstance().sceneConfig.levels[i];
				
				var groupLevelItems:Array = new Array();
				
				//初始化levelitem
				for(var j:int =0 ;j<levels.level.length ; j++)
				{
					var clsKey:String;
					var scale:Number = 1;
					
					if(levels.level[j].levelIcon == ConstLevelSpriteIcon.LEVEL_SPRITE_TYPE_FLOWER)
					{
						clsKey = "levelflower";
					}
					else if(levels.level[j].levelIcon == ConstLevelSpriteIcon.LEVEL_SPRITE_TYPE_ICE)
					{
						clsKey = "levelice";
					}
					else
					{
						clsKey = "levelstraw";
					}
					
					var levelItem:CItemLevelSprite = new CItemLevelSprite(clsKey , levels.level[j].id);
					_levelSpriteLayer.addChild(levelItem);
					levelItem.x = levels.level[j].x;
					levelItem.y = levels.level[j].y - 100;
					levelItem.scaleX = levelItem.scaleY = scale;
					groupLevelItems.push(levelItem);
				}
				//初始化云层
				var cloud:CItemCloud = new CItemCloud(levels.id , groupLevelItems);
				cloud.x = levels.x;
				cloud.y = levels.y;
				
				if(levels.id <= CDataManager.getInstance().dataOfGameUser.maxLevelGroup)
				{
					cloud.visible = false;
				}
				
				_cloudLayer.addChild(cloud);
				
				_cloudList.push(cloud);
			}
		}
		
		private function __initEvent():void
		{
			mc.addEventListener(TouchEvent.TOUCH_BEGIN , __onMouseDown , false, 0 ,true);
			mc.addEventListener(TouchEvent.TOUCH_END , __onMouseUp , false, 0 ,true);
			mc.addEventListener(TouchEvent.TOUCH_MOVE , __onMouseMove , false, 0 ,true);
			mc.addEventListener(TouchEvent.TOUCH_OUT , __onMouseOut , false , 0 , true);
			
			registerObserver(GameNotification.EVENT_PROGRESS_MAP_MOVED , __onMapMoved);
			registerObserver(GameNotification.EVENT_GROUP_UNLOCKED , __onUnlockGroup);
			registerObserver(GameEvent.EVENT_SHOW_TUTORIAL_WORLD_ARROW , __onShowArrow);
		}
		
		private function __onShowArrow(d:Notification):void
		{
			while(_arrowLayer.numChildren)
			{
				_arrowLayer.removeChildAt(0);
			}
			
			var showArrow:ShowArrow = d.data as ShowArrow;
			var cl:Class = ResHandler.getClass("tutorial.arrow");
			var arrow:MovieClip = new cl();
			arrow.scaleX = arrow.scaleY = 0.5;
			arrow.rotation = 45;
			var level:Level = CGroupUtil.getLevelPos(showArrow.levelId);
			arrow.x = level.x - 45;
			arrow.y = level.y - 160;
			this._arrowLayer.addChild(arrow);
		}
		
		private function __onUnlockGroup(notification:Notification):void
		{
			var len:int = _cloudList.length;
			for(var i:int = 0 ; i < len ; i++)
			{
				if(_cloudList[i].groupid == CDataManager.getInstance().dataOfGameUser.maxLevelGroup)
				{
					_cloudList[i].playUnlock();
					_cloudList[i].update();
					break;
				}
			}
		}
		
		protected function __onMouseOut(event:TouchEvent):void
		{
			if(_isDragging)
			{
				__fixPos(event);
				mc.stopDrag();
				_isDragging = false;
			}
		}
		
		protected function __onMouseMove(event:TouchEvent):void
		{
			if(_isDragging)
			{
				__fixPos(event);
				
				var nowY:Number = event.currentTarget.y;
				
				Fibre.getInstance().sendNotification(GameNotification.EVENT_WORLD_MAP_MOVED , new DatagramNormal({percent: Math.abs(nowY) / (MAX_Y - MIN_Y)}));
			}
		}
		
		private function __fixPos(event:TouchEvent):void
		{	
			event.currentTarget.x = event.currentTarget.x < MIN_X ? MIN_X : event.currentTarget.x;
			event.currentTarget.x = event.currentTarget.x > MAX_X ? MAX_X : event.currentTarget.x;
			
			event.currentTarget.y = event.currentTarget.y < MIN_Y ? MIN_Y : event.currentTarget.y;
			event.currentTarget.y = event.currentTarget.y > MAX_Y ? MAX_Y : event.currentTarget.y;
		}
		
		protected function __onMouseUp(event:TouchEvent):void
		{
			mc.stopDrag();
			_isDragging = false;
		}
		
		protected function __onMouseDown(event:TouchEvent):void
		{
			mc.startDrag();
			_isDragging = true;
			_orignaly = event.currentTarget.y;
		}
		
		private function __onMapMoved(notification:Notification):void
		{
			var params:Object = (notification.data as DatagramNormal).getParams();
			updateProgressBar(params.percent , params.useTween);	
		}
		
		private function updateProgressBar(percent:Number , useTween:Boolean = true):void
		{
			if(useTween)
			{
				TweenLite.to(mc , 1 , {y:  MIN_Y *  percent , ease:Cubic.easeOut});
			}
			else
			{
				mc.y = MIN_Y *  percent;
			}
		}
		
		override protected function end():void
		{
			super.end();
			
			mc.removeEventListener(TouchEvent.TOUCH_BEGIN , __onMouseDown);
			mc.removeEventListener(TouchEvent.TOUCH_END , __onMouseUp);
			mc.removeEventListener(TouchEvent.TOUCH_MOVE , __onMouseMove);
			mc.removeEventListener(TouchEvent.TOUCH_OUT , __onMouseOut);
			
			removeObserver(GameNotification.EVENT_PROGRESS_MAP_MOVED , __onMapMoved);
			removeObserver(GameNotification.EVENT_GROUP_UNLOCKED , __onUnlockGroup);
			removeObserver(GameEvent.EVENT_SHOW_TUTORIAL_WORLD_ARROW , __onShowArrow);
		}
	}
}