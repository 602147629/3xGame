package framework.util.txtTip
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import framework.text.TextHandler;
	import framework.util.DisplayUtil;
	import framework.util.ResHandler;

	public class TextTip extends MovieClip
	{
		private static const MIN_LEN:int = 4;
		private static const MAX_LEN:int = 10;
		private static const TXT_SIZE:int = 18;
		private static const TXT_GAP:int = 2;
		private static const TXT_COLOR:int = 0xffffff;
		private static const TOP_LEFT_CORNER:String = "topleftcorner";
		private static const TOP_RIGHT_CORNER:String = "toprightcorner";
		private static const BOTTOM_LEFT_CORNER:String = "leftbottom";
		private static const BOTTOM_RIGHT_CORNER:String = "bottomrightcorner";
		private static const MIDDLE:String = "middle";
		
		private var _txtField:TextField;
		private var _backGroundContainer:Sprite;
		private var _textContainer:Sprite;
		
		public function TextTip()
		{
			init();
		}
		
		public function show(str:String):void
		{
			var txtLen:int = str.length;
			TextHandler.setText(_txtField, str);
			
			makeUi(txtLen);
		}
		
		public function clear():void
		{
			_txtField = null;

			DisplayUtil.removeAllChildren(_backGroundContainer);
			_backGroundContainer = null;
			
			DisplayUtil.removeAllChildren(_textContainer);
			_textContainer = null;
		}
		
		private function init():void
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			_backGroundContainer = new Sprite();
			this.addChild(_backGroundContainer);
			
			_textContainer = new Sprite();
			this.addChild(_textContainer);
			
			initTxt();
		}
		
		private function initTxt():void
		{
			_txtField = new TextField();
			_txtField.selectable = false;
			_txtField.multiline = true;
			_txtField.wordWrap = true;
			
			var format:TextFormat = new TextFormat();
			format.color = TXT_COLOR;
			format.size = TXT_SIZE;
			format.align= TextFormatAlign.LEFT;
			_txtField.defaultTextFormat = format;
			
			
			_textContainer.addChild(_txtField);
			_txtField.x = TXT_GAP;
		}
		
		private function setTxtWidth():void
		{
			_txtField.width = _backGroundContainer.width - TXT_GAP * 2;
			_txtField.height =  _backGroundContainer.height;
		}
		
		private function makeUi(len:int):void
		{
			var lineNum:int;
			var eachLineNum:int;
			if(len > MAX_LEN)
			{
				lineNum = Math.ceil( len/MAX_LEN);
				eachLineNum= MAX_LEN;
			}else
			{
				if(len > MIN_LEN)
				{
					lineNum = 2;
					eachLineNum= Math.ceil( len/lineNum);
				}else
				{
					lineNum = 2;
					eachLineNum= 2;
				}
			}
			
			makeLattice(lineNum,eachLineNum);
			
			setTxtWidth();
		}
		
		private function makeLattice(lineNum:int, eachLineNum:int):void
		{
			var allNum:int = lineNum * eachLineNum;
			for(var i:int =0 ;i< allNum; i++)
			{
				var mc:MovieClip=new MovieClip;
				if(i == 0)
				{
					mc = ResHandler.getMcFirstLoad(TOP_LEFT_CORNER);
				}
				else if(i == (eachLineNum-1))
				{
					mc = ResHandler.getMcFirstLoad(TOP_RIGHT_CORNER);
				}
				else if(i == (allNum - eachLineNum ))
				{
					mc = ResHandler.getMcFirstLoad(BOTTOM_LEFT_CORNER);
				}
				else if(i == (allNum - 1))
				{
					mc = ResHandler.getMcFirstLoad(BOTTOM_RIGHT_CORNER);
				}else
				{
					mc= ResHandler.getMcFirstLoad(MIDDLE);
				}
				
				mc.x = i % eachLineNum * (mc.width);
				mc.y = int(i / eachLineNum) * (mc.height);
				_backGroundContainer.addChild(mc);
			}
		}
	}
}