package com.ui.widget
{
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import framework.util.ResHandler;
	import framework.util.playControl.PlayMovieClipToEndAndDestroy;
	
	/**
	 * 漂浮文字 
	 * @author Fanyu
	 * 
	 */	
	public class CWidgetFloatText extends Object
	{
		private var _timeId:uint;
		
		private var _lastStr:String;
		
		public function CWidgetFloatText()
		{
			super();
		}
		
		/**
		 * 单例模式工厂		
		 */
		public static function get instance() : CWidgetFloatText 
		{
			if ( _instance == null ) _instance = new CWidgetFloatText( );
			return _instance;
		}
		
		/**
		 * 单例实例
		 **/ 
		protected static var _instance : CWidgetFloatText;
		
		public function showTxt(textStr:String, delay:Number = 80):void
		{
			if(textStr == "" || textStr == null || _lastStr == textStr)
			{
				return;
			}
			
			_lastStr = textStr;
			
			var textBG:MovieClip = ResHandler.getMcFirstLoad("common.TipsTxt");
			var showStrTxt:TextField = CBaseUtil.getTextField(textBG.content.tipsTxt, 16, 0x8F0600);
			showStrTxt.htmlText = textStr;
			showStrTxt.y = textBG.height - showStrTxt.textHeight >> 1;
			GameEngine.getInstance().stage.addChild(textBG);
			
			textBG.x = GameEngine.getInstance().stage.stageWidth - textBG.width >> 1;
			textBG.y = GameEngine.getInstance().stage.stageHeight - textBG.height >> 1;
			
			_timeId = setTimeout( playMC, delay, textBG);
		}
		
		private function playMC(textBG:MovieClip):void
		{
			textBG.gotoAndPlay(1);
			new PlayMovieClipToEndAndDestroy(textBG, onPlayOver);
		}
		
		private function onPlayOver(mc:MovieClip):void
		{
			mc = null;
			_lastStr = null;
		}
	}
}