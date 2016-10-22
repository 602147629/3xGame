package com.game.manager
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * 素材xmlswf管理类 
	 * @author melody
	 */	
	public class AssetManage
	{
		private static var _instance:AssetManage;
		
		private var gameDic:Dictionary;
		//场景动画比较特殊 单独处理;
		private var _sceneDic:Dictionary;
		//切图图片缓存
		private var _cutImgDic:Dictionary;
		
		public function AssetManage()
		{
			this.init();
		}
		public static function getInstance():AssetManage
		{ 
			if(_instance==null){
				_instance=new AssetManage();
			}
			return _instance;
		}
		private function init():void{
			gameDic=new Dictionary();
			_sceneDic=new Dictionary();
			_cutImgDic=new Dictionary();
		}
		public function get sceneDic():Dictionary
		{
			return _sceneDic;
		}
		public function addXml(id:String,xml:XML):void
		{
			gameDic[id]=xml;
		}
		public function getXml(id:String):XML{
			if(gameDic[id]) return gameDic[id];
			return null;
		}
		//获取图片
		public function getImg(id:String):BitmapData
		{
			if(gameDic[id]) return gameDic[id].data;
			return null;
		}
		//添加图片
		public function addImg(id:String,bitmapdata:*=null):void{
			
			if(gameDic[id])
			{
				gameDic[id].count+=1;
			}
			else
			{
				gameDic[id]={data:bitmapdata,count:1};
			}
		}
		//施释
		
		public function dispose(id:String,count:int=1):void{
			if(gameDic[id]){
				if(gameDic[id].count){
					gameDic[id].count-=1;
					if(gameDic[id].count<=0){
						gameDic[id].data.dispose();
						gameDic[id]=null;
						delete gameDic[id];
					}
				}else{
					gameDic[id]=null;
					delete gameDic[id];
				}
			}
		}
		//得到是否有
		public function hasDataById(id:String):Boolean
		{
			if(gameDic[id]){
				return true;
			}
			return false;
		}
		
		public function addCutImg(key:String,k:String,bitmapData:BitmapData):void
		{
			if(!_cutImgDic[key]) _cutImgDic[key]=new Dictionary();
			_cutImgDic[key][k]=bitmapData;
		}
		
		public function getCutImg(key:String,k:String):BitmapData
		{
			if(!_cutImgDic[key]) return null;
			if(!_cutImgDic[key][k]) return null;
			return _cutImgDic[key][k];
		}
		
	}
}