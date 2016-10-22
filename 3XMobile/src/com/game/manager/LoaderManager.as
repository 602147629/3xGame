package com.game.manager
{
	import com.game.consts.ResourceConst;
	import com.game.utils.ParseData;
	import com.game.utils.ResourceLoader;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * 加载管理类
	 * 首先会判断缓存中是否存在..没有再加载 
	 * @author melody
	 */	
	public class LoaderManager
	{
		private static var _instance:LoaderManager;
		
		private var _callBackDic:Dictionary;
		public function LoaderManager()
		{
			_callBackDic=new Dictionary();
		}
		public static function getInstance():LoaderManager{
			if(_instance==null){
				_instance=new LoaderManager();
			}
			return _instance;
		}
		/**
		 * @param key就是所谓的路径 也是存储的key
		 * @param type为加载的具体类型 在ResourceConst
		 * @param storageFun存储结束的回调
		 */ 
		public function load(key:String,type:int,storageFun:Function):void
		{
			if(AssetManage.getInstance().hasDataById(key)){
				if(storageFun != null){
					if(type == ResourceConst.TYPE_IMG) 
					{
						AssetManage.getInstance().addImg(key);
					}
					storageFun();
				}
			}else{
				if(!_callBackDic[key]){
					_callBackDic[key]=new Vector.<Function>;
					var resLoad:ResourceLoader=new ResourceLoader();
					resLoad.load(Debug.resPath + "." + key,type,key);
					resLoad.addEventListener(Event.COMPLETE,onLoadCom);
					
					CONFIG::debug
					{
						TRACE_LOADING("loading path: "+ Debug.resPath + "."+key);
					}
				}
				_callBackDic[key].push(storageFun);
			}
		}
		private function onLoadCom(e:Event):void{
			e.target.removeEventListener(Event.COMPLETE,onLoadCom);
			
			var parseda:ParseData=new ParseData(tranComplete,e.target.name,e.target.resource,e.target.type);
		}
		private function tranComplete(data:*,key:String,type:int):void{
			switch(type){
				case ResourceConst.TYPE_IMG:
					AssetManage.getInstance().addImg(key,data);
					break;
				case ResourceConst.TYPE_SWF:
					break;
				case ResourceConst.TYPE_XML:
					AssetManage.getInstance().addXml(key,data);
					break;
			}
			if(_callBackDic[key]){
				for each(var callBack:Function in _callBackDic[key]){
					if(callBack!=null) callBack();
				}
				_callBackDic[key]=null;
				delete _callBackDic[key];
			}
		}
	}
}