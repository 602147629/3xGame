package framework.ui
{
	import com.game.event.GameEvent;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import framework.datagram.Datagram;
	import framework.fibre.core.Fibre;
	import framework.sound.MediatorAudio;
	import framework.util.DisplayUtil;

	public class AnimationMoveItem
	{
		private var _srcX:int;
		private var _srcY:int;
		private var _dstX:int;
		private var _dstY:int;
		private var _mcGrid:MovieClip;
		private var _animationParent:DisplayObjectContainer;
		private var _moveComplete:Function;
		private var _isDestory:Boolean;
		
		private var _isFindBug:Array;
		private var _isStartPlay:Boolean;
		private var _dropPoint:Point;
		public function AnimationMoveItem(srcX:int, srcY:int, dstX:int, dstY:int, mcGrid:MovieClip, animationParent:DisplayObjectContainer, moveComplete:Function, isFindBug:Array, dropPoint:Point)
		{
			_srcX = srcX;
			_srcY = srcY;
			_dstX = dstX;
			_dstY = dstY;
			_mcGrid = mcGrid;
			_animationParent = animationParent;
			_moveComplete = moveComplete;
			
			_dropPoint = dropPoint;
			
			_isDestory = false;
			_isFindBug = isFindBug;
			_isStartPlay = false;
		}
		
		public function startPlayNormalSpeed(isPlayNow:Boolean):void
		{
			if(!isPlayNow)
			{
				_mcGrid.x = _srcX * MediatorPanelMainUI.GRID_WIDHT;
				_mcGrid.y = _srcY * MediatorPanelMainUI.GRID_HEIGHT;
				
				_animationParent.addChild(_mcGrid);
				return;
			}
			
			_isStartPlay = true;
			
			
			var dx:Number = _dstX * MediatorPanelMainUI.GRID_WIDHT;
			var dy:Number = _dstY * MediatorPanelMainUI.GRID_HEIGHT;
			
			var dropSpeed:Number = 0.5;
			var speed:int = Math.abs(_dstY - _srcY) > 0 ? Math.abs(_dstY - _srcY): Math.abs(_dstX - _srcX);
			var animation:AnimationMoveItem = this;
			
			var tweenMax:TweenMax = TweenMax.to(_mcGrid, dropSpeed * speed, {x:dx, y:dy, ease:Linear.easeNone, onComplete:function():void
			{
//				DisplayUtil.removeFromParent(_mcGrid);
				
				CONFIG::debug
				{
					TRACE_ANIMATION_MOVE("finish playMoveAnimation srcX:"+ _srcX +" srcY: "+ _srcY +"dstX: "+ _dstX +" dstY: "+ _dstY);
				}
				
				var datagram:Datagram = new Datagram();
				datagram.injectParameterList[0] = animation;
				Fibre.getInstance().sendNotification(GameEvent.EVENT_REMOVE_ANIMATION_ITEM, datagram); 
				_isDestory = true;
				tweenMax.kill();
				_isStartPlay = false;
				
				//first remove from list  then call back
				if(_moveComplete != null)
				{
					_moveComplete();
				}
			}
			});
		}
		
		public function startPlay(main:MediatorPanelMainUI):void
		{
		
			Fibre.getInstance().sendNotification(MediatorAudio.EVENT_SOUND_FALL, null, Fibre.SOUND_NOTIFICATION);
			
			_isStartPlay = true;
			//refresh grid
			if(_srcY >= 0)
			{
				if(_isFindBug != null)
				{
					//falling bug
					if(_isFindBug.length > 0)
					{
						var callBack:Function = _isFindBug[0];
						if(callBack != null)
						{
							callBack();
						}
					}
					else
					{
						//ownMove bug
					}
					
				}
				else
				{
					
					main.removeNormalItemUI(_srcX, _srcY, false);
				}
				
			}
			
			_animationParent.addChild(_mcGrid);
			
			var dropX:int = _srcX;
			var dropY:int = _srcY;
			if(_dropPoint != null)
			{
				dropX = _dropPoint.x;
				dropY = _dropPoint.y;
			}
			
			_mcGrid.x = dropX * MediatorPanelMainUI.GRID_WIDHT;
			_mcGrid.y = dropY * MediatorPanelMainUI.GRID_HEIGHT;
			
			var dx:Number = _dstX * MediatorPanelMainUI.GRID_WIDHT;
			var dy:Number = _dstY * MediatorPanelMainUI.GRID_HEIGHT;
			
			var dropSpeed:Number = 0.3;
			if(Debug.isSlowSpeed)
			{
				dropSpeed = 2;
			}
			var speed:int = Math.abs(_dstY - _srcY) > 0 ? Math.abs(_dstY - _srcY): Math.abs(_dstX - _srcX);
			speed = Math.floor(speed *0.3);
			if(speed < 1)
			{
				speed = 1;
			}
			var animation:AnimationMoveItem = this;
			
			var tweenMax:TweenMax = TweenMax.to(_mcGrid, dropSpeed * speed, {x:dx, y:dy, ease:Linear.easeNone,onComplete:function():void
			{
				DisplayUtil.removeFromParent(_mcGrid);
				
				CONFIG::debug
				{
					TRACE_ANIMATION_MOVE("finish playMoveAnimation srcX:"+ _srcX +" srcY: "+ _srcY +"dstX: "+ _dstX +" dstY: "+ _dstY);
				}
				
				var datagram:Datagram = new Datagram();
				datagram.injectParameterList[0] = animation;
				Fibre.getInstance().sendNotification(GameEvent.EVENT_REMOVE_ANIMATION_ITEM, datagram); 
				_isDestory = true;
				tweenMax.kill();
				_isStartPlay = false;
				
				//first remove from list  then call back
				if(_moveComplete != null)
				{
					_moveComplete();
				}
			}
			});
		}
		
		public function startPlayUseRuler(midY:int):void
		{	
			_animationParent.addChild(_mcGrid);
			var dropSpeed:Number = 0.2;
			var animation:AnimationMoveItem = this;
			
			_mcGrid.x = _srcX * MediatorPanelMainUI.GRID_WIDHT;
			_mcGrid.y = _srcY * MediatorPanelMainUI.GRID_HEIGHT;
			
			
			if(_srcX != _dstX && (_dstY - _srcY > 1))
			{
				var dstXMid:Number = _srcX * MediatorPanelMainUI.GRID_WIDHT;
				var dstYMid:Number = midY * MediatorPanelMainUI.GRID_HEIGHT;
			}
			
			
			var dx:Number = _dstX * MediatorPanelMainUI.GRID_WIDHT;
			var dy:Number = _dstY * MediatorPanelMainUI.GRID_HEIGHT;
			
			
			var tweenMax:TweenMax = TweenMax.to(_mcGrid, dropSpeed, {x:dx, y:dy, onComplete:function():void
			{
				DisplayUtil.removeFromParent(_mcGrid);
				
				if(_moveComplete != null)
				{
					_moveComplete();
				}
				
				CONFIG::debug
				{
					TRACE_LOG("playMoveAnimation srcX:"+ _srcX +" srcY: "+ _srcY +"dstX: "+ _dstX +" dstY: "+ _dstY);
				}
				
				var datagram:Datagram = new Datagram();
				datagram.injectParameterList[0] = animation;
				Fibre.getInstance().sendNotification(GameEvent.EVENT_REMOVE_ANIMATION_ITEM, datagram); 
				_isDestory = true;
				tweenMax.kill();
			}
			});
		}

		public function get isDestory():Boolean
		{
			return _isDestory;
		}

	}
}