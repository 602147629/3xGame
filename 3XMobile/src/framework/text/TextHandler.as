package framework.text
{
	import com.ui.util.CFilterUtil;
	import com.ui.util.CFontUtil;
	
	import flash.events.TextEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import framework.text.FontManager;
	import framework.util.TextUtil;

	
	public class TextHandler
	{
		private static var fontManager:FontManager;
		
		public function TextHandler()
		{
		}

		public static function init():void
		{
			fontManager = new FontManager();
		}

		
		public static const alreadyInitTextFiled :Dictionary = new Dictionary(true);
		
		CONFIG::debug
		{
			private static var textError:Vector.<String> = new Vector.<String>();
		}
		
		public static function setText(textfield:TextField, text:String,useSystemFont:Boolean = true):void
		{
			
			
			if(text == null || text == "")
			{
				text = " ";
			}
			
			if(textfield == null)
			{
				CONFIG::debug
				{
					if(textError.indexOf(text) <0)
					{
						textError.push(text);					
						TRACE_LOG("null textField !  text is: "+ text);
					}
				}	
				return;
			}
			
			//wzm found no need check the text any more. because it will not cause redraw.
			//not redraw but still need time to set text by chg
			
			var textChanged:Boolean = false;
			if(textfield.text == text)
			{
				// No change to text
				// Textfield has been initialised when embedFonts is true
			}
			else
			{
				textfield.text = text;
				textChanged = true;
			}
			
			
			var tfm:TextFormat;
			
			if(alreadyInitTextFiled[textfield] == null)
			{
				if(!useSystemFont)
				{
					initTextField(textfield);
					tfm = textfield.getTextFormat();
				}
				else
				{
					tfm = setFont(textfield);
				}

				var size:int = int(tfm.size);
				alreadyInitTextFiled[textfield] = {"size":size,"currentSize":size};
			}
			
			/*if(textChanged)
			{
				matchTextFormatSize(textfield);
			}*/
			
		}
		
		private static function setFont(textfield:TextField):TextFormat
		{
			var tfm:TextFormat = textfield.getTextFormat();
			tfm.font = "宋体";
			textfield.defaultTextFormat = tfm;
			textfield.setTextFormat(tfm);
			textfield.filters = [/*shadropShadowFilter,*/ CFilterUtil.glowFilter];
			return tfm;
		}
		
		private static function matchTextFormatSize(textfield:TextField):void
		{
			var tfm:TextFormat = textfield.getTextFormat();
			
			alreadyInitTextFiled[textfield].currentSize = alreadyInitTextFiled[textfield].size;
			tfm.size = alreadyInitTextFiled[textfield].currentSize;
			
			textfield.setTextFormat(tfm);
			
			while(textfield.maxScrollV > 1 || textfield.maxScrollH > 0)
			{
				
				tfm = textfield.getTextFormat();
				alreadyInitTextFiled[textfield].currentSize = alreadyInitTextFiled[textfield].currentSize - 1;
				tfm.size = alreadyInitTextFiled[textfield].currentSize;
				textfield.setTextFormat(tfm);
				
				if(tfm.size <= 8)
				{
					break;
				}
			}
		}
		
		public static function getHtmlTextColor(content:String, color:String):String
		{
			var str:String = "<FONT COLOR='"+color+"'>"+content+"</FONT>";
			return str;
		}
		
		public static function getHtmlTextEvent(text:String, eventType:String, color:String = "#00ffff"):String
		{
			var htmlStr:String="<FONT style='text-decoration: overline'COLOR='"+ color + "'><u><a href= 'event:"+eventType+"'>"+text+"</a></u></FONT>";
			return htmlStr;
		}
		
		
		public static function removeHtmlTag(text:String):String
		{
			var token:RegExp = /<[^>]*>/;
			for(var i:int = 0; i < 100; i++)
			{
				text = text.replace(token, "");
				if(text.match(token) == null)
				{
					break;
				}
			}
			return text;
		}
		
		public static function setHtmlText(textfield:TextField, htmlText:String):void
		{
			textfield.htmlText = htmlText;
//			initTextField(textfield);
			setFont(textfield);
//			textfield.filters = [shadropShadowFilter];
			
		}
		
		
		
		public static function setTextByID(textfield:TextField, id:String,useSystemFont:Boolean = true):void
		{			
			setText(textfield, TextUtil.getText(id),useSystemFont);
		}
		
		public static function initTextField(textfield:TextField):void
		{
		
			var format:TextFormat = textfield.getTextFormat();
			
			textfield.antiAliasType = AntiAliasType.NORMAL;
//			textfield.selectable = false;
			textfield.embedFonts = true;
//			textfield.mouseEnabled = false;
			
			if (format.font == null ||
				format.font == "Arial" ||
				format.font == "Arial Black" ||
				format.font == "Times New Roman"||
				format.font == "SimHei"||
				format.font == "黑体")
			{				

			}
				format.font = "DroidSansFallback_embed";
//				format.font = "Arial";
				
				

			
			// SS: Removed try/catch to track down when an error might occur here
			// If you find an error please figure out the correct error handling, e.g. fix an art asset
//			try
//			{
				textfield.defaultTextFormat = format;
//			}
//			catch(e:Error)
//			{
//			}
			textfield.setTextFormat(format);
		}
	}
}