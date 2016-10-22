package framework.view.animation
{
	import com.game.module.role.ConstantAction;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import framework.core.tick.GameTicker;
	import framework.core.tick.ITickObject;
	import framework.fibre.core.Fibre;
	import framework.model.StaticResProxy;
	import framework.resource.Resource;
	import framework.resource.ResourceFactory;
	import framework.resource.ResourceManager;
	import framework.resource.faxb.animation.Action;
	import framework.resource.faxb.animation.Animation;
	import framework.util.DisplayUtil;
	import framework.util.ResHandler;
	import framework.util.cacher.CachePlaceholder;
	import framework.util.cacher.PlaceholderHelper;
	import framework.util.faxb.FAXB;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;
	import framework.util.rsv.RsvFileConst;

	public class AnimationCache  implements ITickObject
	{
		private var _currentFrame:int;
		
		private var _id:String;
		
		private var _actions:Object;
		
		private var _animationData:Animation;
		
		private var _animationHolder:DisplayObjectContainer;
		
		private var _animationFileType:String;
		
		private var _currentActionId:String;
		
		
		private var _isPlay:Boolean;
		private var _isPlayOnce:Boolean;


		private var _playFinishCallBack:Function;
		
		private var _frameTickNumber:int;
		private var _tickNumber:int;
		
		private var _isDestory:Boolean;
		
		private var _placeHolderType:int;
		private var _isActorMainAnimation:Boolean;
		
		private var _isSwfAnimation:Boolean;

		public function get visible():Boolean
		{
			return _animationHolder.visible;
		}

		public function set visible(value:Boolean):void
		{
			_animationHolder.visible = value;
		}

		private var _loadDataComplete:Function;
		private var _loadAllResourcesComplete:Function;
		
		public static const GAME_FPS:int = 30;
		
		public static const ANIMATION_FINISH:String = "AnimationFinish";
		public static const PLAY_INJURE_ACTION:String = "playInjureAction";
		public static const ANIMATION_FINISH_ATTACK:String = "AnimationFinishAttack";
		public static const ANIMATION_FINISH_HURTED:String = "AnimationFinishHurted";

		public static const UPDATE_FRAME_POSITION:String = "UPDATE_FRAME_POSITION";
		
		private static const FRAME_ATTACK:String = "attack";
		private var _currentFrameData:FrameCache;
		private var _lastPosition:Number;
		
		private var _loadNumber:int = 0;
		
		private var _playCallBack:Function;
		
		public function AnimationCache(id:String, loadDataComplete:Function = null, loadAllResourcesComplete:Function = null, isShowContainor:Boolean = true)
		{
			_id = id;
			
			_loadAllResourcesComplete = loadAllResourcesComplete;
						
			_animationHolder = new Sprite();
			
			_animationHolder.visible = isShowContainor;
			
			_actions = new Object();
			
			_loadDataComplete = loadDataComplete;
			
			_isSwfAnimation = false;
			
			loadAnimation(id);
			
			_isPlay = false;
			
			_isDestory = false;
			
			_placeHolderType = PlaceholderHelper.PLACEHOLDER_TYPE_SANDGLASS;
			
			_isActorMainAnimation = false;
			
			_lastPosition = 0;
			
			
		}

		public function set isMainAnimation(value:int):void
		{
			_placeHolderType = value;
			_isActorMainAnimation = value != PlaceholderHelper.PLACEHOLDER_TYPE_NONE;
		}
		
		
		public function get isSwfAnimation():Boolean
		{
			return _isSwfAnimation;
		}
		
		private function startLoadAllResources():void
		{
			_loadNumber = _animationData.resourceIdentityList.resource.length;
			
			for each(var res:framework.resource.faxb.animation.Resource in _animationData.resourceIdentityList.resource)
			{
				ResourceManager.getInstance().getResource(res.identity).getContent("1", loadAllResourcesCompleteCallBack);
			}
		}
		
		private function loadAllResourcesCompleteCallBack(mc:DisplayObject):void
		{
			_loadNumber -- ;
			
			if(_loadNumber == 0)
			{				
				if(_loadAllResourcesComplete != null)
				{
					_loadAllResourcesComplete(this);
					_loadAllResourcesComplete = null;
				}
			}
		}

		public function get id():String
		{
			return _id;
		}

		public function get animationHolder():DisplayObjectContainer
		{
			return _animationHolder;
		}
		
		private var _height:Number = 0;
		
		public function getFirstFrameHeight(actionId:String = "1"):Number
		{
			if(_height == 0 && _isLoadDataComplete)
			{				
				var _heightHolder:Sprite = _heightHolder = new Sprite();
				
				var currentAction:ActionCache = _actions[actionId];
				
				if(_isSwfAnimation)
				{
					_height = currentAction.getMc().height;
				}
				else
				{					
					_currentFrameData = currentAction.getFrame(1);
					
					
					if(_currentFrameData != null)
					{
						
						for each(var image:DisplayObject in _currentFrameData.images)
						{			
							_heightHolder.addChild(image);
						}
					}
				}
				
				_height = _heightHolder.height;
			}
			
			
			
			return _height;
		}
		
		private function loadAnimation(id:String):void
		{				
			ResHandler.loadXmlHandler(id, loadImage);
		}
		
		private function removeLister():void
		{
			if(_isSwfAnimation)
			{
				if(_animationHolder.numChildren > 0)
				{
					var oldMc:DisplayObject = _animationHolder.getChildAt(0);
					
					if(oldMc is MovieClip)
					{
						if(oldMc.hasEventListener(Event.ENTER_FRAME))
						{
							oldMc.removeEventListener(Event.ENTER_FRAME, onFrame);
						}
						
					}
					else if(oldMc is CachePlaceholder)
					{
						if((oldMc as CachePlaceholder).content.hasEventListener(Event.ENTER_FRAME))
						{
							(oldMc as CachePlaceholder).content.removeEventListener(Event.ENTER_FRAME, onFrame);	
						}
					}
				}
			}	
		}
		
		public function setAction(actionId:String):void
		{
			_currentActionId = actionId;
			
			if(_isSwfAnimation)
			{
				removeLister();
				
				DisplayUtil.removeAllChildren(_animationHolder);
				var mc:DisplayObject = getAction().getMc();
				
				_animationHolder.addChild(mc);
				
				if(mc is MovieClip)
				{
					mc.addEventListener(Event.ENTER_FRAME, onFrame);
				}
				else if(mc is CachePlaceholder)
				{
					if((mc as CachePlaceholder).content as MovieClip)
					{
						(mc as CachePlaceholder).content.addEventListener(Event.ENTER_FRAME, onFrame);	
					}
				}
			}
			
			if(_animationData == null)
			{
				_playCallBack = function():void
				{
					if(_isSwfAnimation)
					{					
						setAction(_currentActionId);
						
						if(_isPlay)
						{							
							goToAndPlay(_currentFrame);
						}
					}
				};
			}
		}
		
		public function goToAndPlay(frame:int = 1, isPlayOnce:Boolean = false, callBack:Function = null):void
		{
			_currentFrame = frame;
			
			_isPlay = true;
			
			_isPlayOnce = isPlayOnce;
			
			_playFinishCallBack = callBack;
			
			if(_isSwfAnimation)
			{							
				getAction().gotoAndPlay(frame);
			}
		}
		
		public function goToAndStop(frame:int = 1):void
		{
			_currentFrame = frame;
			
			_isPlay = false;
			
			if(_isSwfAnimation)
			{
				getAction().gotoAndStop(frame);
			}
		}
		
		public function addAnimationResourcesNode(animationXml:XML):Animation
		{
			var animation:Animation = FAXB.unmarshal(animationXml, getQualifiedClassName(Animation));
			
			
			if(animation.resourceIdentityList.resource.length > 0)
			{
				_isSwfAnimation = RsvFile.fileExtension(animation.resourceIdentityList.resource[0].identity) == RsvFileConst.TAIL_SWF;	
				
				for each(var res:framework.resource.faxb.animation.Resource in animation.resourceIdentityList.resource)
				{
					var xml:XML = null;
					if(_isSwfAnimation)
					{
						xml = <res/>;
						xml.@id = res.identity;
						xml.@className = RsvFile.getFileName(res.identity);
					}
					ResourceFactory.createSimpleResource(res.identity, StaticResProxy.inst.getPath(res.identity), _placeHolderType, xml);
				}					
			}
	
			return animation;
		}
		
		
		private var _isLoadDataComplete:Boolean;	
		private function loadImage(id:String):void
		{
			if(_isDestory)
			{
				return;
			}
			var animationXml:XML = Rsv.getFile_s(id).xml;
			
			if(Rsv.getFile_s(id).contentData == null)
			{	
				_animationData = addAnimationResourcesNode(animationXml);
				Rsv.getFile_s(id).contentData = _animationData;
			}
			else
			{
				_animationData = Rsv.getFile_s(id).contentData as Animation;
				
				if(_animationData.resourceIdentityList.resource.length > 0)
				{				
					_isSwfAnimation = RsvFile.fileExtension(_animationData.resourceIdentityList.resource[0].identity) == RsvFileConst.TAIL_SWF;	
				}
			}
			
			if(_isSwfAnimation)
			{
				initActionsSwf();
			}
			else
			{				
				initActionsImage();
			}
			
			if(_loadAllResourcesComplete != null)
			{
				startLoadAllResources();
			}
			
			if(_playCallBack != null)
			{
				_playCallBack();
				_playCallBack = null;
			}
			
			_isLoadDataComplete = true;
		}
		
		public function tickObject(psdTickMs:Number):void
		{
			if(_tickNumber % _frameTickNumber == 0)
			{
				play();
			}
			_tickNumber++;
		}
		
		private function getSwfId(actionName:String):String
		{
			var fileName:String = RsvFile.getFileName(_id);
			var swfId:String = "a"+fileName + "_" + actionName +"."+ RsvFileConst.TAIL_SWF;
			return swfId;
		}

		
		private function initActionsSwf():void
		{		
			for each(var actionData:Action in _animationData.actionList.action)
			{			
				var action:ActionCache = new ActionCache(actionData, _animationData, loadCurrentActionSwfComplete, getSwfId(actionData.name));
				
				_actions[action.name] = action;
				
				if(_currentActionId == null)
				{
					_currentActionId = action.name;
				}			
			}

		}
		
		private function loadCurrentActionSwfComplete(mc:MovieClip, actionId:String):void
		{
			if(!mc.hasEventListener(Event.ENTER_FRAME))
			{
				if(actionId == _currentActionId)
				{					
					mc.addEventListener(Event.ENTER_FRAME, onFrame);
				}
			}
			
			
			if(_loadDataComplete != null)
			{
				_loadDataComplete(this, actionId);
				_loadDataComplete = null;
			}
		}
		
		private function initActionsImage():void
		{
			for each(var actionData:Action in _animationData.actionList.action)
			{			
				var action:ActionCache = new ActionCache(actionData, _animationData);
				
				_actions[action.name] = action;
				
				if(_currentActionId == null)
				{
					_currentActionId = action.name;
				}
			}
			
			GameTicker.getInstance().addToTickQueue(this);
			_frameTickNumber = GAME_FPS / _animationData.actionList.fps;
		}
		
		public function getAction():ActionCache
		{
			return _actions[_currentActionId];
		}
		
		
		private function onFrame(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			
			if(mc.currentLabel == FRAME_ATTACK)
			{
				Fibre.getInstance().sendNotification(PLAY_INJURE_ACTION, _id);
			}
			if(mc.currentFrame == mc.totalFrames)
			{
				Fibre.getInstance().sendNotification(ANIMATION_FINISH, this);
				
				if(_isPlayOnce)
				{
					if(_playFinishCallBack != null)
					{
						_playFinishCallBack();
						_playFinishCallBack = null;
					}
					
					mc.removeEventListener(Event.ENTER_FRAME, onFrame);
					destory();
				}
			}
		}
		
		
		
		public function updateFrameXoffset():void
		{
			if(_currentFrameData != null)
			{
				if(_isActorMainAnimation && _lastPosition != _currentFrameData.frameData.posX)
				{
					_lastPosition = _currentFrameData.frameData.posX;
					Fibre.getInstance().sendNotification(UPDATE_FRAME_POSITION, [this, _lastPosition]);				
				}
			}

		}

		private function play():void
		{
			
			if(!_isPlay)
			{
				return;
			}

	
			DisplayUtil.removeAllChildren(_animationHolder);
			
			var currentAction:ActionCache = getAction();
			if(currentAction == null)
			{
				CONFIG::debug
				{
					TRACE_LOG("Error ! can not find currentAction  : "+_currentActionId);
				}
				Fibre.getInstance().sendNotification(ANIMATION_FINISH, this);
				return;
			}
			else
			{				
				_currentFrameData = currentAction.getFrame(_currentFrame);
				
				updateFrameXoffset();
				
				if(_currentFrameData != null)
				{
					
					for each(var image:DisplayObject in _currentFrameData.images)
					{			
						_animationHolder.addChild(image);
					}
					
					if(_currentFrame == 1 && _currentFrameData.isLoadComplete())
					{						
						if(_loadDataComplete != null)
						{							
							_loadDataComplete(this, _currentActionId);
							
							_loadDataComplete = null;
						}
					}
				}
				else
				{
					CONFIG::debug
					{
						TRACE_LOG("error! " +" totalFrame: "+ currentAction.totalFrame + " currentFrame: "+ _currentFrame);
					}
				}
			}
			

			if(_currentFrameData.frameData.attack == 1)
			{

				Fibre.getInstance().sendNotification(PLAY_INJURE_ACTION, _id);

			}
			
			if (_currentFrameData.repeatNumber  == 1)
			{
				if(_currentFrame <= currentAction.totalFrame )
				{
					_currentFrame++;
				}
				
				_currentFrameData.repeatNumber = _currentFrameData.frameData.repeatNum;
			}
			else if(_currentFrameData.repeatNumber > 1)
			{
				_currentFrameData.repeatNumber --;
			}
			else
			{
				CONFIG::debug
				{
					ASSERT(false, "repeatNumber can not less than 1 ! animationId: " + _animationData.id);
				}
			}
			
			
			if (_currentFrame > currentAction.totalFrame)
			{
				Fibre.getInstance().sendNotification(ANIMATION_FINISH, this);
				_currentFrame = 1;
				
				if(_isPlayOnce)
				{
					if(_playFinishCallBack != null)
					{
						_playFinishCallBack();
						_playFinishCallBack = null;
					}
					destory();
				}
			}
		}
		
		public function isTickPaused() : Boolean
		{
			return false;
		}
		
		public function destory():void
		{			
			if(_animationData != null)
			{	
				if(!_isSwfAnimation)
				{
					CONFIG::debug
					{
						TRACE_LOG("remove Animaton id: "+_id);
					}
					GameTicker.getInstance().removeTickQueue(this);
				}
				else
				{
					removeLister();
				}
				_animationData = null;
			}
			
			DisplayUtil.removeFromDisplayTree(_animationHolder);
			_actions = null;
			_isDestory = true;			
		}

		public function get currentFrame():int
		{
			return _currentFrame;
		}

	}
}