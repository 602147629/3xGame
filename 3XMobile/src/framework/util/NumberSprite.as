package framework.util
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class NumberSprite extends Sprite
	{
		private var _isLeft:Boolean;
		private var _isAddZero:Boolean;
		private var _myClass:Class;
		private var _numOffset:Number;
		
		public function NumberSprite(myClass:Class, num:int, isLeft:Boolean = true, isAddZero:Boolean = false, numoffset:Number = 0)
		{
			_isLeft = isLeft;
			_myClass = myClass;
			_isAddZero = isAddZero;
			
			_numOffset = numoffset;
			
			if(_numOffset == 0)
			{
				var mc:MovieClip = new _myClass();
				_numOffset = mc.width;
			}
			
			goToNumber(num);
		}
		
		public function goToNumber(num:int):void
		{
			while(this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
			
			if(num < 0)
			{
				num = 0;
			}
			var numList:Array = splitNumtoStr(num);
			var i:int = 0;
			var mc:MovieClip;
			var numFrame:int;
			
			var xoffset:int = 0;
			
			
			
			if(_isAddZero)
			{
				if(num < 10)
				{
					mc = new _myClass();
					addChild(mc);
					mc.x = 0;
					mc.gotoAndStop(1);
					
					xoffset = _numOffset;
				}
			}
			
			if(_isLeft)
			{
				for (i = 0; i < numList.length; i +=  1)
				{
					numFrame = int(numList[i]);
					mc = new _myClass();
					addChild(mc);
					mc.x = _numOffset * (i) + xoffset;
					mc.gotoAndStop(numFrame + 1);
				}		
			}
			else
			{
				numList.reverse();
				for (i = numList.length - 1; i >= 0; i --)
				{
					numFrame = int(numList[i]);
					mc = new _myClass();
					addChild(mc);
					mc.x =  - _numOffset * ( i + 1);
					mc.gotoAndStop(numFrame + 1);
				}	
			}
		}
		
		private static function splitNumtoStr(num:int):Array
		{
			var arr:Array = [];
			var str:String = num.toString();
			for(var i:int=0;i<str.length;i+=1)
			{
				arr.push(str.slice(i,i + 1));
			}
			return arr;
		}
	}
}