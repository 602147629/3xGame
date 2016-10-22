package framework.model
{
	import flash.display.DisplayObject;
	
	import framework.view.ConstantUI;

	
	
	/**
	 * plz do read this comment before used this class.
	 * 
	 * This class be used for adjust a display object 's position
	 * base on specific align property instead of parent's align.
	 * 
	 * Don't set display object 's x or y property directly.
	 * Should use setPosition(). 
	 */
	public class DisplayObjectPositionTransformer
	{
		
		private var _displayObject:DisplayObject;
		private var _parentAlignH:int;
		private var _parentAlignV:int;
		
		private var _rawX:Number;
		private var _rawY:Number;
		
		private var _transformedX:Number;
		private var _transformedY:Number;
		
		private var _alignH:int;
		private var _alignV:int;
		
		public function DisplayObjectPositionTransformer(displayObject:DisplayObject)
		{
			_displayObject = displayObject;
		}
		
		public function setParentAlign(alignH:int, alignV:int, isUpdatePosition:Boolean = false):void
		{
			_parentAlignH = alignH;
			_parentAlignV = alignV;
			if(isUpdatePosition)
			{
				updatePosition();
			}
		}
		
		public function setPosition(x:Number, y:Number, isUpdatePosition:Boolean = false):void
		{
			_rawX = x;
			_rawY = y;
			if(isUpdatePosition)
			{
				updatePosition();
			}
		}
		
		public function setAlign(alignH:int, alignV:int, isUpdatePosition:Boolean = false):void
		{
			_alignH = alignH;
			_alignV = alignV;
			if(isUpdatePosition)
			{
				updatePosition();
			}
		}
		
		public function updatePosition():void
		{
			transformX();
			transformY();
			_displayObject.x = _transformedX;
			_displayObject.y = _transformedY
		}
		
		private function transformX():void
		{
			switch(_parentAlignH)
			{
				case ConstantUI.ALIGN_HORIZONTAL_LEFT:
					transformXBaseOnLeft();
					break;
				case ConstantUI.ALIGN_HORIZONTAL_NORMAL:
					transformXBaseOnNormal();
					break;
				case ConstantUI.ALIGN_HORIZONTAL_RIGHT:
					transformXBaseOnRight();
					break;
			}
		}
		
		private function transformXBaseOnLeft():void
		{
			switch(_alignH)
			{
				case ConstantUI.ALIGN_HORIZONTAL_LEFT:
					_transformedX = _rawX;
					break;
				case ConstantUI.ALIGN_HORIZONTAL_NORMAL:
					_transformedX = _rawX + FullScreenHandler.instance.getScreenXOffset() / 2;
					break;
				case ConstantUI.ALIGN_HORIZONTAL_RIGHT:
					_transformedY = _rawX + FullScreenHandler.instance.getScreenXOffset();
					break;
			}
		}
		
		private function transformXBaseOnNormal():void
		{
			switch(_alignH)
			{
				case ConstantUI.ALIGN_HORIZONTAL_LEFT:
					_transformedX = _rawX - FullScreenHandler.instance.getScreenXOffset() / 2;
					break;
				case ConstantUI.ALIGN_HORIZONTAL_NORMAL:
					_transformedX = _rawX;
					break;
				case ConstantUI.ALIGN_HORIZONTAL_RIGHT:
					_transformedX = _rawX + FullScreenHandler.instance.getScreenXOffset() / 2;
					break;
			}
		}
		
		private function transformXBaseOnRight():void
		{
			switch(_alignH)
			{
				case ConstantUI.ALIGN_HORIZONTAL_LEFT:
					_transformedX = _rawX - FullScreenHandler.instance.getScreenXOffset();
					break;
				case ConstantUI.ALIGN_HORIZONTAL_NORMAL:
					_transformedX = _rawX - FullScreenHandler.instance.getScreenXOffset() / 2;
					break;
				case ConstantUI.ALIGN_HORIZONTAL_RIGHT:
					_transformedX = _rawX;
					break;
			}
		}
		
		
		private function transformY():void
		{
			switch(_parentAlignV)
			{
				case ConstantUI.ALIGN_VERTIVAL_TOP:
					transformYBaseOnTop();
					break;
				case ConstantUI.ALIGN_VERTIVAL_CENTER:
					transformYBaseOnCenter();
					break;
				case ConstantUI.ALIGN_VERTIVAL_BOTTOM:
					transformYBaseOnBottom();
					break;
			}
		}
		
		private function transformYBaseOnTop():void
		{
			switch(_alignV)
			{
				case ConstantUI.ALIGN_VERTIVAL_TOP:
					_transformedY = _rawY;
					break;
				case ConstantUI.ALIGN_VERTIVAL_CENTER:
					_transformedY = _rawY + FullScreenHandler.instance.getScreenYOffset() / 2;
					break;
				case ConstantUI.ALIGN_VERTIVAL_BOTTOM:
					_transformedY = _rawY + FullScreenHandler.instance.getScreenYOffset();
					break;
			}
		}
		
		private function transformYBaseOnCenter():void
		{
			switch(_alignV)
			{
				case ConstantUI.ALIGN_VERTIVAL_TOP:
					_transformedY = _rawY - FullScreenHandler.instance.getScreenYOffset() / 2;
					break;
				case ConstantUI.ALIGN_VERTIVAL_CENTER:
					_transformedY = _rawY;
					break;
				case ConstantUI.ALIGN_VERTIVAL_BOTTOM:
					_transformedY = _rawY + FullScreenHandler.instance.getScreenYOffset() / 2;
					break;
			}
		}
		
		private function transformYBaseOnBottom():void
		{
			switch(_alignV)
			{
				case ConstantUI.ALIGN_VERTIVAL_TOP:
					_transformedY = _rawY - FullScreenHandler.instance.getScreenYOffset();
					break;
				case ConstantUI.ALIGN_VERTIVAL_CENTER:
					_transformedY = _rawY - FullScreenHandler.instance.getScreenYOffset() / 2;
					break;
				case ConstantUI.ALIGN_VERTIVAL_BOTTOM:
					_transformedY = _rawY;
					break;
			}
		}
	}
}