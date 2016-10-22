package com.ui.util
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import framework.util.ResHandler;

	/**
	 * @author caihua
	 * @comment 
	 * 创建时间：2014-7-8 上午11:01:07 
	 */
	public class CFontUtil
	{
		public static function simpleTextFormat( color:uint = 0xFFFFFFFF , size:int = 14):TextFormat
		{
			return new TextFormat(fontNameRegular , size , color ,null ,null ,null ,null ,null , "center");
		}
		
		/**
		 * 注册字体
		 */
		public static function registerFont():void
		{
			var bold:Class = ResHandler.getClass("font.wryh.bold");
			var regular:Class = ResHandler.getClass("font.wryh.regular");
			if(bold && regular)
			{
				Font.registerFont(bold);
				Font.registerFont(regular);
			}
		}
		
		public static function get fontNameBold():String
		{
			var cls:Class = ResHandler.getClass("font.wryh.bold");
			if(!cls)
			{
				return "微软雅黑";
			}
			var font:Font = new cls();
			return font.fontName;
		}
		
		public static function get fontNameRegular():String
		{
			var cls:Class = ResHandler.getClass("font.wryh.regular");
			if(!cls)
			{
				return "微软雅黑";
			}
			var font:Font = new cls();
			return font.fontName;
		}
		
		/**
		 * 20号字体
		 */
		public static function get textFormatBig():TextFormat
		{
			return new TextFormat(fontNameRegular , 20 , null ,true ,null ,null ,null ,null , "center");
		}
		
		/**
		 * 16号字体
		 */
		public static function get textFormatMiddle():TextFormat
		{
			return new TextFormat(fontNameRegular , 16 , 0xFCF895 ,true ,null ,null ,null ,null , "center");
		}
		
		/**
		 * 12号字体
		 */
		public static function get textFormatSmall():TextFormat
		{
			return new TextFormat(fontNameRegular , 12 , null ,true ,null ,null ,null ,null , "center");
		}
		
		public static function getTextFormat(size:int , color:int = 0xffffff , bold:Boolean = true, pos:String = "center"):TextFormat
		{
			var ftName:String = "";
			if(bold)
			{
				ftName = fontNameBold;
			}
			else
			{
				ftName = fontNameRegular;
			}
			
			return new TextFormat(ftName , size , color ,bold ,null ,null ,null ,null , pos);
		}
		
		public static function getTextField(textFormat:TextFormat):TextField
		{
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			if(textFormat.bold)
			{
				textFormat.font = fontNameBold;
			}
			else
			{
				textFormat.font = fontNameRegular;
			}
			
			tf.defaultTextFormat = textFormat;
			
			
			return tf;
		}
		
		/**
		 * 绑定字体的tf
		 */
		public static function get textFieldBig():TextField
		{
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.defaultTextFormat = textFormatBig;
			return tf;
		}
		
		/**
		 * 绑定字体的tf
		 */
		public static function get textFieldMiddle():TextField
		{
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.defaultTextFormat = textFormatMiddle;
			return tf;
		}
		
		/**
		 * 绑定字体的tf
		 */
		public static function get textFieldSmall():TextField
		{
			var tf:TextField = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.defaultTextFormat = textFormatSmall;
			return tf;
		}
	}
}