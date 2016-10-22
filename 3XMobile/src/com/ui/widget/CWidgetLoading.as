package com.ui.widget
{
	import com.ui.item.CItemWarning;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFilterUtil;
	import com.ui.util.CTimer;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment loading
	 * 创建时间：2014-7-2 下午6:39:08 
	 */
	public class CWidgetLoading extends Sprite
	{
		private var _loading:*;
		private var _aniStartX:Number = 400.30;
		private var _aniEndX:Number = 657.30;
		
		private var _barStartX:Number = 68.85;
		private var _barEndX:Number = 368.80;
		
		private var _timer:CTimer ;
		
		private var dotNum:int = 1;
		
		public function CWidgetLoading(loading:*)
		{
			_loading = loading;
			
			this.addChild(_loading);
			_loading.ani.stop();
			_loading.loadingbar.stop();
			
			_loading.tip.filters = [CFilterUtil.glowFilter2];
			
			CBaseUtil.regEvent(MediatorBase.G_CHANGE_WORLD,__onGameReady);
			
			CBaseUtil.regEvent(GameNotification.EVENT_SHOW_WARNING , __onCommonMessage);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE , __onDispose , false , 0 , true);
		}
		
		protected function __onDispose(event:Event):void
		{
			CBaseUtil.removeEvent(MediatorBase.G_CHANGE_WORLD,__onGameReady);
			CBaseUtil.removeEvent(GameNotification.EVENT_SHOW_WARNING , __onCommonMessage);
			_loading = null;
		}
		
		private function __onCommonMessage(d:Notification):void
		{
			this.visible = true;
			if(d.data != null)
			{
				var warning:CItemWarning = new CItemWarning(d.data.text);
				
				warning.x = (this.width - warning.width) / 2;
				warning.y = (this.height - warning.height) / 2;
				
				this.addChild(warning);
			}
		}
		
		private function __onGameReady(d:Notification):void
		{
			this.visible = false;
		}
		
		public function setProgress(p:Number):void
		{
			if(p < 99)
			{
				if(GameEngine.getInstance().currentLoaderID == "file_res_ui")
				{
					_loading.progresstf.text = "正在加载配置文件...";
				}else if(GameEngine.getInstance().currentLoaderID == "sceneSWF")
				{
					_loading.progresstf.text = "正在加载主场景...";
				}else if(GameEngine.getInstance().currentLoaderID == "commonSWF")
				{
					_loading.progresstf.text = "正在加载公共资源...";
				}
				TRACE_LOG(_loading.progresstf.text);
				_loading.ani.x = _aniStartX + (_aniEndX - _aniStartX) * p / 100 ; 
				if(_loading.loadingbar)
				{
					_loading.loadingbar.x = _barStartX + (_barEndX - _barStartX) * p / 100 ;
				}
			}
			else
			{
				if(_loading != null)
				{					
					(_loading as MovieClip).gotoAndStop(20);
				}
			}
		}
		
		public function setProgresstf(dotString:String):void
		{
			_loading.progresstf.text = dotString;
		}
		
		public function getMainBG(bg:String = "bmd.loading.bg"):BitmapData
		{
			var cls:Class = MovieClip(_loading).loaderInfo.applicationDomain.getDefinition(bg) as Class;
			if(cls != null)
			{
				return new cls();
			}
			else
			{
				return new BitmapData(1,1);
			}
		}
		
		private function __showStatus():void
		{
			if(dotNum >= 4)
			{
				dotNum = 0;
			}
			var dotString:String = "";
			for(var i :int = 0 ;i < dotNum ;i ++)
			{
				dotString += ".";
			}
			_loading.progresstf.text = " 正在初始化 " + dotString;
			dotNum ++ ;
		}
	}
}