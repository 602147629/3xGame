package framework.model
{
	import framework.resource.faxb.award.MatchAwards;
	import framework.resource.faxb.elements.Elements;
	import framework.resource.faxb.functionopen.FunctionList;
	import framework.resource.faxb.items.Items;
	import framework.resource.faxb.levelproperty.LevelProperties;
	import framework.resource.faxb.levels.Levels;
	import framework.resource.faxb.notice.NoticeList;
	import framework.resource.faxb.onlineActivity.Activitys;
	import framework.resource.faxb.sceneui.SceneConfig;
	import framework.resource.faxb.score.DefalutScore;
	import framework.resource.faxb.score.Score;
	import framework.resource.faxb.score.Scores;
	import framework.resource.faxb.starreward.StarReward;
	import framework.resource.faxb.tutorial.Tutorial;

	public class DataManager
	{
		private var _levels:Levels;
		private var _elements:Elements;
		
		private var _levelProperty:LevelProperties;
		
		private var _sceneConfig:SceneConfig;
		
		private var _initSeed:int;
		
		private var _scoreData:Scores;
		
		private var _matchAwards:MatchAwards;
		
		private var _activitys:Activitys;
		
		private var _items:Items;
		
		private var _tutorialData:Tutorial;
		
		private var _starRewards:StarReward;
		
		public var seedArray:Array;
		
		private static var _instance:DataManager;
		
		public var randomIndex:int;
		private var _functionList:FunctionList;
		private var _noticeList:NoticeList;
		public function  reset():void
		{
			randomIndex = 0;
		}
		
		public function DataManager()
		{
		}
		
		public static function getInstance():DataManager
		{
			if (_instance == null)
			{
				_instance = new DataManager();
			}
			return _instance;
		}

		public function get levels():Levels
		{
			return _levels;
		}

		public function set levels(value:Levels):void
		{
			_levels = value;
		}

		public function get initSeed():int
		{
			return _initSeed;
		}

		public function set initSeed(value:int):void
		{
			_initSeed = value;
		}

		public function get elements():Elements
		{
			return _elements;
		}

		public function set elements(value:Elements):void
		{
			_elements = value;
		}

		public function set levelproperty(value:LevelProperties):void
		{
			_levelProperty = value;
		}
		
		public function get levelproperty():LevelProperties
		{
			return _levelProperty ;
		}
		
		public function set sceneConfig(value:SceneConfig):void
		{
			_sceneConfig = value;
		}
		
		public function get sceneConfig():SceneConfig
		{
			return _sceneConfig ;
		}

		public function get scoreData():Scores
		{
			return _scoreData;
		}
		
		public function getDefaultScore():DefalutScore
		{
			return _scoreData.defalutScore;
		}

		public function set scoreData(value:Scores):void
		{
			_scoreData = value;
		}
		
		public function getScoreById(id:int):Score
		{
			return _scoreData.score[id];	
		}

		public function get matchAwards():MatchAwards
		{
			return _matchAwards;
		}

		public function set matchAwards(value:MatchAwards):void
		{
			_matchAwards = value;
		}
		
		public function get activitys():Activitys
		{
			return _activitys;
		}
		
		public function set activitys(value:Activitys):void
		{
			_activitys = value;
		}

		public function get items():Items
		{
			return _items;
		}

		public function set items(value:Items):void
		{
			_items = value;
		}

		public function get tutorialData():Tutorial
		{
			return _tutorialData;
		}

		public function set tutorialData(value:Tutorial):void
		{
			_tutorialData = value;
		}

		public function get starRewards():StarReward
		{
			return _starRewards;
		}

		public function set starRewards(value:StarReward):void
		{
			_starRewards = value;
		}

		public function get functionList():FunctionList
		{
			return _functionList;
		}

		public function set functionList(value:FunctionList):void
		{
			_functionList = value;
		}

		public function get noticeList():NoticeList
		{
			return _noticeList;
		}

		public function set noticeList(value:NoticeList):void
		{
			_noticeList = value;
		}


	}
}