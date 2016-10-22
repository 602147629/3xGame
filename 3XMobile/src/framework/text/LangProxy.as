package framework.text
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.text.TextField;
	
	import framework.fibre.patterns.Proxy;
	import framework.model.BackgroundLoadProxy;
	import framework.model.CurrentUserProxy;
	import framework.model.FileProxy;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;
	import framework.util.text.GameTextLocaliser;


	
	public class LangProxy extends Proxy
	{
		
		private var staticTextGroup:StaticTextGroup = new StaticTextGroup();
		public static var langXml:XML;
		
		private static var _inst:LangProxy;
		public static function get instance():LangProxy
		{
			if(_inst == null)
			{
				_inst = new LangProxy();
			}
			return _inst;
		}
		
		public function LangProxy()
		{
			super("LangProxy");
		}
		
		
		public function registerText(content:XML):void
		{
			langXml = content;
			
//			(GameEngine.getInstance().getTextLocaliser() as GameTextLocaliser).registerTextLanguageData(content);

//			staticTextGroup.createStaticTextGroup(content);
		}
		
//		private static function getUserCurrentLanguageCodeFromFlashVar():String
//		{
//			var pfLang:String = GameEngine.inst.getParameterString(ConfigKeys.PF_LANG);
//			var langCode:String = LangMapping.getLangCodeFromPfLang(pfLang);
//			return langCode;			
//		}
		
		public static function getUserCurrentLanguageCode():String
		{
			var settingLang:String; 
			return settingLang;
		}
		
		public function initCurrentLanguage():void
		{
			var langCode:String = getUserCurrentLanguageCode();
			changeLanguage(langCode);
			
//			startBackLoadLang(langCode);
			
		}

/*		public function addNonDefaultLangToBackLoadQueue():void
		{
			var list:Array = Rsv.getGroup_s(FileProxy.LANG_GROUP_ID).all();
			for each(var rsvFile:RsvFile in list)
			{
				if(rsvFile.id != getDefaultLanguageFileId())
				{
					var thread:LoadingThread = BackgroundLoadProxy.inst.addBackGroundLoad(rsvFile,fileHandler);
				}
			}
			
		}
*/
		
		public function startBackLoadLang():void
		{
			TRACE_LOADING("\n\n<<<<	background language file");
			
			var totalSize:int = 0;
			var currentLangCode:String = getUserCurrentLanguageCode();
			
			var list:Array = Rsv.getGroup_s(FileProxy.LANG_GROUP_ID).all();
			for each(var rsvFile:RsvFile in list)
			{
				if(rsvFile.id != "file_lang_" + currentLangCode)
				{
					BackgroundLoadProxy.inst.increasePriorityToLoadingThread(rsvFile.id);
					
					TRACE_LOADING(rsvFile.id + ", size = " + rsvFile.fileSize);
					totalSize += rsvFile.fileSize;
				}
			}
			
			TRACE_LOADING("total size = " + totalSize + "\n");
			
		}
		
		public function getDefaultLanguageFileId():String
		{
			return "file_lang";			
		}
			
/*		public function isNeedToCombineLanguageFileToFirstLoadGroup(fileId:String):Boolean
		{
			var langStr:String = "file_lang_" + GameSettingSharedObject.inst.getStringValue(GameSettingType.LANG_CODE);
			return fileId == langStr;
		}
*/
		
/*		public function fileHandler(ev:RsvEvent):void
		{
			var file:RsvFile = ev.from as RsvFile;
			if(ev.id == RsvEvent.CONTENTREADY)
			{	
				if(file.xml != null)
				{
					ResourceManager.getInstance().loadResXml(file.xml, null);
				}
			}
		}
*/
		
		public function getCurrentLanguage():String
		{
			return "chinese";
		}
		
		public function changeLanguage(langCode:String):void
		{
			
		}
		
		private var debugObj:Object;
		
		private function shotBefore():void
		{
			if(CurrentUserProxy.instance.dataInited)
			{
				debugObj = new Object();
				findInto(GameEngine.getInstance().stage);
			}
		}
		
		private function generateKey(t:DisplayObject):String
		{
			var key:String = "";
			while(!(t is Stage))
			{
				key = t.name +"."+key;
				t = t.parent;
			}
			return key;
		}
		
		private function findInto(displayContainer:DisplayObjectContainer):void
		{
			for(var i:int = 0 ; i < displayContainer.numChildren ; i++)
			{
				var disObj:DisplayObject = displayContainer.getChildAt(i);
				if(disObj is TextField)
				{
					debugObj[generateKey(disObj)] = (disObj as TextField).text;
				}
				
				if(disObj is DisplayObjectContainer)
				{
					findInto(disObj as DisplayObjectContainer);
				}
			}
				
		}
		
		private function shotAfter():void
		{
			if(CurrentUserProxy.instance.dataInited)
			{
				var objCopy:Object = debugObj;
				debugObj = new Object();
				findInto(GameEngine.getInstance().stage);
			}
			
			for(var key:String in objCopy)
			{
				if(objCopy[key] == debugObj[key])
				{
					if(objCopy[key] != "Click To Buy"
					&& objCopy[key] != "For Sale"
					)
					{
//						TRACE_TEST(key + "----" + objCopy[key] + "----" + debugObj[key]);
						
					}
				}
			}
		}
		
		
		public function getStaticTextKeyGroup(uiName:String):Vector.<String>
		{
			return staticTextGroup.getStaticTextKeyGroup(uiName);
		}
		
	}
}