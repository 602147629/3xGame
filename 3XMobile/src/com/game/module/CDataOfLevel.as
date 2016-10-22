package com.game.module
{
	import com.game.consts.ConstTaskType;
	import com.ui.util.CLevelConfigUtil;
	
	import framework.model.ConstantItem;
	import framework.model.DataRecorder;
	import framework.resource.faxb.levelproperty.Color;
	import framework.resource.faxb.levelproperty.CreateItems;
	import framework.resource.faxb.levelproperty.ElementDemand;
	import framework.resource.faxb.levelproperty.Item;
	import framework.resource.faxb.levelproperty.Level;
	import framework.resource.faxb.levelproperty.ShowItem;
	import framework.resource.faxb.levelproperty.Star;
	import framework.resource.faxb.levelproperty.Task;
	
	/**
	 * @author caihua
	 * @comment 正在玩的游戏的数据
	 * 创建时间：2014-6-25 下午6:51:14 
	 */
	public class CDataOfLevel extends CDataBase
	{
		private var _level:int = -1;
		private var _taskType:int;
		private var _levelConfig:Level;
		private var _task:Task;
		private var _oneStar:int; 
		private var _twoStar:int; 
		private var _threeStar:int; 
		
		private var _createMaxJellyNum:int;
		private var _jellyLeftStep:int;
		private var _clockLeftStep:int;
		private var _isHasBoat:Boolean;
 		private var _isRandomMap:Boolean;
		//收集列表
		private var _collectList:Vector.<ElementDemand> = new Vector.<ElementDemand>();
		
		private var _scoreNeed:Number = 0;
		private var _totalScore:Number = 0;
		
		private var _timeLimit:Number = 0 ;
		private var _stepLimit:int;
		
		private var _timeRemain:Number = 999;
		
		private var _d:DataRecorder;
		
		private var _toolItemList:Array;
		
		//{id:** , num:**}
		private var _inGameToolIdList:Array;
		
		private var _checkStep:int = 0;
		
		//用于debug调试 跳关
		public static var debugCurrentLevel:int = 0;
		
		//生成的二级消除体个数
		private var _collectDemand:Vector.<ElementDemand>;
		
		private var _animationSeleted:Vector.<int>;
		
		private var _useToolTimes:Array;
		
		//是否正在使用道具
		private var _isUsingTool:Boolean = false;
		
		private var _doEnergyCheck:Boolean = false;
		
		public function CDataOfLevel()
		{
			super("CDataOfLevel");
			init();
		}
		
		public function get isRandomMap():Boolean
		{
			return _isRandomMap;
		}

		public function init():void
		{
			_inGameToolIdList = new Array();
		}
		
		public function get level():int
		{
			return _level;
		}
		
		public function reset():void
		{
			_isUsingTool = false;
			_inGameToolIdList = new Array();
			_level = -1;
			_doEnergyCheck = false;
		}
		
		//拆分数据
		public function decode(level:int):void
		{	
			_isUsingTool = false;
			_inGameToolIdList = new Array();
			_level = level;
			
			if(!Debug.ISONLINE && Debug.IS_DEBUG_COMMAND)
			{
				_level = debugCurrentLevel;
//				_level = 81;
			}
			
			_levelConfig = CLevelConfigUtil.getLevelConfig(_level);
			
			_task = _levelConfig.task;
			
			if(_task.time != 0)
			{
				_taskType = ConstTaskType.TASK_TYPE_TIME;
			}
			else
			{
				_taskType = ConstTaskType.TASK_TYPE_STEP;
			}
			
			_oneStar = _levelConfig.score.oneStar;
			_twoStar = _levelConfig.score.twoStar;
			_threeStar = _levelConfig.score.threeStar;
			
			_timeLimit = _levelConfig.task.time;
			
			_timeRemain = _timeLimit;
			
			_stepLimit = _levelConfig.task.step;
			
			if(_levelConfig.task.starNum == 1)
			{
				_scoreNeed = oneStar;
			}
			else if(_levelConfig.task.starNum == 2)
			{
				_scoreNeed = twoStar;
			}
			else  if(_levelConfig.task.starNum == 3)
			{
				_scoreNeed = threeStar;
			}
			else
			{
				_scoreNeed = oneStar;	
			}
			
			_jellyLeftStep = _levelConfig.jellyLeaveStep;
			_createMaxJellyNum = _levelConfig.createJellyMaxNum;
			_clockLeftStep = _levelConfig.clockLeaveStep;
			_isHasBoat = _levelConfig.isHasBoat == "true";
			_isRandomMap = _levelConfig.isRandomMap != "false";
			
			_totalScore = _levelConfig.score.totalStar;
			
			_collectDemand = new Vector.<ElementDemand>();
			//任务
			if(_levelConfig.task.elementDemand && _levelConfig.task.elementDemand.length != 0)
			{
				_collectList = _levelConfig.task.elementDemand;
				
				for each(var demand:ElementDemand in _collectList)
				{
					if(demand.id >= ConstantItem.COLLECTED_MOVE_START_INDEX && demand.id <= ConstantItem.COLLECTED_MOVE_END_INDEX)
					{
						_collectDemand.push(demand);
					}
				}
			}
			
			if(_collectDemand.length > 0)
			{
				_checkStep = _stepLimit /_collectDemand[0].num;
			}
			
			//随机动画形态
			_animationSeleted = new Vector.<int>();
			
			for(var i:int = 0; i < ConstantItem.MAX_CARD_NUM; i++)
			{
				_animationSeleted.push(int(Math.random() * 2));
			}
			
			_useToolTimes = new Array();
		}
		
		/**
		 * 增加使用次数
		 */
		public function addUseTime(id:int , time:int = 1):void
		{
			//不在游戏中使用，不计数
			if(!_useToolTimes)
			{
				return;
			}
			
			if(!_useToolTimes[id])
			{
				_useToolTimes[id] = time;
			}
			else
			{
				_useToolTimes[id] += time;
			}
		}
		
		/**
		 * 获取使用次数
		 */
		public function getUseTime(id:int):int
		{
			if(!_useToolTimes)
			{
				return 0;
			}
			
			if(!_useToolTimes[id])
			{
				return 0;
			}
			else
			{
				return _useToolTimes[id];
			}
		}
		
		public function getCheckStep():int
		{
			return _checkStep; 
		}
		
		public function getCreateItems():CreateItems
		{
			return _levelConfig.createItems;
		}
		
		//开始关卡的道具列表
		public function get startItems():Vector.<ShowItem>
		{
			return _levelConfig.startItem.showItem == null ? new Vector.<ShowItem>() :_levelConfig.startItem.showItem;
		}
		
		//游戏中关卡的道具列表
		public function get gameItems():Vector.<Item>
		{
			return _levelConfig.gameItem.item == null ? new Vector.<Item>() :_levelConfig.gameItem.item;
		}
		
		public function limitColors():Vector.<Color>
		{
			return _levelConfig.limitColor.colors;
		}
		
		public function getScoreByStar(star:int):Number
		{
			if(star == 1)
			{
				return _oneStar;
			}
			else if(star == 2)
			{
				return _twoStar;
			}
			else
			{
				return _threeStar;
			}
		}
		
		public function isNeedCheckJellyItem():Boolean
		{
			return _createMaxJellyNum > 0;
		}
		
		public function isNeedCheckClockItem():Boolean
		{
			return _clockLeftStep > 0;
		}
		
		
		public function getCollectedDemand():Vector.<ElementDemand>
		{
			return _collectDemand;
		}
		
		public function get rewardList():Vector.<Star>
		{
			return _levelConfig.reward.star;
		}
		
		public function get taskType():int
		{
			return _taskType;
		}
		
		public function get levelConfig():Level
		{
			return _levelConfig;
		}
		
		public function get task():Task
		{
			return _task;
		}
		
		public function get oneStar():int
		{
			return _oneStar;
		}
		
		public function get twoStar():int
		{
			return _twoStar;
		}
		
		public function get threeStar():int
		{
			return _threeStar;
		}
		
		public function get totalScore():int
		{
			return _totalScore;
		}
		
		public function get scoreNeed():Number
		{
			return _scoreNeed;
		}
		
		public function get timeLimit():Number
		{
			return _timeLimit;
		}
		
		public function get stepLimit():int
		{
			return _stepLimit;
		}
		
		public function get timeRemain():Number
		{
			return _timeRemain;
		}
		
		public function set timeRemain(value:Number):void
		{
			_timeRemain = value;
			
			_timeRemain = _timeRemain > 0 ? _timeRemain : 0;
		}
		
		public function get collectList():Vector.<ElementDemand>
		{
			return _collectList;
		}
		
		/**
		 * 分数是否足够
		 */
		public function isScoreSatisfied():Boolean
		{
			return d.score >= scoreNeed;
		}
		
		/**
		 * 收集是否足够
		 */
		public function isCollectionSatisfied():Boolean
		{
			if(collectList.length == 0)
			{
				return true;
			}
			
			for(var i:int =0 ; i < collectList.length ; i++)
			{
				var element:ElementDemand = collectList[i];
				var collectedNum:int = _d.getCollectItemNum(element);
				
				if( collectedNum < element.num)
				{
					return false;
				}
			}
			
			return true;
		}
		
		public function get d():DataRecorder
		{
			return _d;
		}
		
		public function set d(value:DataRecorder):void
		{
			_d = value;
		}
		
		public function get animationSeleted():Vector.<int>
		{
			return _animationSeleted;
		}
		
		public function set stepLimit(value:int):void
		{
			_stepLimit = value;
		}
		
		public function get isUsingTool():Boolean
		{
			return _isUsingTool;
		}
		
		public function set isUsingTool(value:Boolean):void
		{
			_isUsingTool = value;
		}
		
		public function addToolInGame(id:int , num:int = 1):void
		{
			_inGameToolIdList.push({id:id , num:num});
		}
		
		/**
		 * 删除道具
		 */
		public function removeToolInGame(id:int):void
		{
			var temp:Array = new Array();
			
			for(var i:int = 0 ; i < _inGameToolIdList.length ; i++)
			{
				if(_inGameToolIdList[i].id != id)
				{
					temp.push(_inGameToolIdList[i]);
				}
			}
			
			_inGameToolIdList = temp;
		}
		
		public function get inGameToolIdList():Array
		{
			return _inGameToolIdList;
		}
		
		public function set inGameToolIdList(value:Array):void
		{
			_inGameToolIdList = value;
		}
		public function get doEnergyCheck():Boolean
		{
			return _doEnergyCheck;
		}
		
		public function set doEnergyCheck(value:Boolean):void
		{
			_doEnergyCheck = value;
		}
		
		public function get createMaxJellyNum():int
		{
			return _createMaxJellyNum;
		}
		
		public function get jellyLeftStep():int
		{
			return _jellyLeftStep;
		}
		
		public function get clockLeftStep():int
		{
			return _clockLeftStep;
		}
		
		public function set createMaxJellyNum(value:int):void
		{
			_createMaxJellyNum = value;
		}
		
		public function get isHasBoat():Boolean
		{
			return _isHasBoat;
		}
		
		
	}
}