package com.ui.widget
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	
	/**
	 *  容器的滚动条 
	 * @author sunxiaobin
	 * 
	 */	
	public class CWidgetScrollBar extends Sprite
	{
		private const _upArrowSkin:String = "upArrow";
		private const _downArrowSkin:String = "downArrow";
		private const _sliderSkin:String = "slider";
		private const _draw:String = "drawSlip";
		
		private var _upArrowButton:SimpleButton;//上箭头
		private var _downArrowButton:SimpleButton;//下箭头
		private var _sliderButton:SimpleButton;//滑块
		private var _drawSlip:Bitmap;//滑条
		
		private var _content:Sprite;
		private var _viewContent:Sprite;//显示区域
		private var _scrollBarContent:Sprite;
		
		//属性
		private var _type:String;//样式
		private var _isFollow:Boolean;//是否随着输入显示
		private var _isMinst:Boolean;//是否是最小化
		private var _width:Number;//宽高
		private var _height:Number;
		private var _itemGap:Number;
		private var _viewHeight:Number;//实际高度
		private var _isViewScroll:Boolean = false;//是否显示滑块
		private var _isStopDrag:Boolean = true;//是否停止拖拽
		
		private var _sliderMoveStep:uint = 10;//移动步数
		
		private var _mouseSliderInstance:Number;
		private var _prevSliderPostion:int;
		private var _itemData:Array;
		private var _itemTotalNum:int;
		
		private var _withLayout:Boolean = false;
		
		public function CWidgetScrollBar(resouce:MovieClip, slipBitmap:Bitmap, width:Number = 400,height:Number = 200, itemGap:Number = 0 , withLayout:Boolean = false)
		{
			super();
			_width = width;
			_height = height;
			_itemGap = itemGap;
			_isFollow = false;
			_isMinst = false;
			_withLayout = withLayout;
			
			initScroll(resouce, slipBitmap);
		}
		/**
		 * 初始化滚动条 
		 * @param resouce
		 * 
		 */		
		private function initScroll( resouce:MovieClip, slipBitmap:Bitmap ):void
		{
			this._scrollBarContent = new Sprite();
			
			this._content = new Sprite();
			this._viewContent = new Sprite();
			this._viewContent.addChild( _content );
			this.addChild( _viewContent );
			
			_drawSlip = slipBitmap;
			_scrollBarContent.addChild( _drawSlip );
			
			_sliderButton = resouce[_sliderSkin] as SimpleButton;
			_scrollBarContent.addChild( _sliderButton );
			
			if(resouce[_upArrowSkin])
			{
				_upArrowButton = resouce[_upArrowSkin] as SimpleButton;
				_scrollBarContent.addChild( _upArrowButton );
			}
			if(resouce[_downArrowSkin])
			{
				_downArrowButton = resouce[_downArrowSkin] as SimpleButton;
				_scrollBarContent.addChild( _downArrowButton );
			}
			this.addChild( _scrollBarContent );
			this.addEvent();
			
			if( this._viewContent )
			{
				this._viewContent.scrollRect = new Rectangle(0, 0, _width - _scrollBarContent.width , _height);
			}
			this._drawSlip.height = _height;
			this.initPostion();
			this.reSetPostion();
			this.wetherView();
		}
		//初始化位置
		private function initPostion():void
		{
			if(_upArrowButton)
			{
				_upArrowButton.y = -2;
				_upArrowButton.x = -2;
				_downArrowButton.y = _height - _downArrowButton.height + 2;
				_downArrowButton.x = -2;
				_sliderButton.y = _upArrowButton.y +  _upArrowButton.height;
			}
			else
			{
				_sliderButton.y = 0;
			}
			_drawSlip.y = 0;
			_drawSlip.x = 0;
			_sliderButton.x = ( _drawSlip.width - _sliderButton.width ) * 0.5;
		}
		
		//添加监听
		private function addEvent():void
		{
			if(_upArrowButton)
			{
				_upArrowButton.addEventListener( TouchEvent.TOUCH_TAP, upArrowClick);
				_downArrowButton.addEventListener( TouchEvent.TOUCH_TAP, downArrowClick);
			}
			_sliderButton.addEventListener(TouchEvent.TOUCH_BEGIN, sliderDownClick);
			this.addEventListener( TouchEvent.TOUCH_ROLL_OVER, onMouseWheelHandler );
		}
		private function removeEvent():void
		{
			if(_upArrowButton)
			{
				_upArrowButton.removeEventListener( TouchEvent.TOUCH_TAP, upArrowClick);
				_downArrowButton.removeEventListener( TouchEvent.TOUCH_TAP, downArrowClick);
			}
			_sliderButton.removeEventListener( TouchEvent.TOUCH_BEGIN, sliderDownClick);
			this.removeEventListener( TouchEvent.TOUCH_ROLL_OVER, onMouseWheelHandler );
		}
		private function upArrowClick( e:TouchEvent ):void
		{
			if( !this._isViewScroll || this._isMinst ) return;
			
			var instance:Number;
			if(this._upArrowButton)
			{
				instance = this._downArrowButton.y - this._upArrowButton.y - this._upArrowButton.height - this._sliderButton.height;
			}else
			{
				instance = this._drawSlip.height - this._sliderButton.height;
			}
			this._sliderButton.y -= instance / this._sliderMoveStep;
			
			if(this._upArrowButton)
			{
				if( this._sliderButton.y < this._upArrowButton.y + this._upArrowButton.height )
				{
					this._sliderButton.y = this._upArrowButton.y + this._upArrowButton.height;
				}
			}else
			{
				if( this._sliderButton.y < 0 )
				{
					this._sliderButton.y = 0;
				}
			}
			
			updateContent();
		}
		private function downArrowClick( e:TouchEvent ):void
		{
			if( !this._isViewScroll || this._isMinst ) return;
			
			var instance:Number;
			if(this._upArrowButton)
			{
				instance = this._downArrowButton.y - this._upArrowButton.y - this._upArrowButton.height - this._sliderButton.height;
			}else
			{
				instance = this._drawSlip.height - this._sliderButton.height;
			}
			this._sliderButton.y += instance / this._sliderMoveStep;
			
			if(this._upArrowButton)
			{
				if( this._sliderButton.y > this._downArrowButton.y - this._sliderButton.height )
				{
					this._sliderButton.y = this._downArrowButton.y - this._sliderButton.height;
				}
			}else
			{
				if( this._sliderButton.y > this._drawSlip.height - this._sliderButton.height )
				{
					this._sliderButton.y = this._drawSlip.height - this._sliderButton.height;
				}
			}
			
			updateContent();
		}
		private function updateContent():void
		{	
			var instance:Number;
			var rate:Number;
			if(this._upArrowButton)
			{
				 instance = this._downArrowButton.y - this._upArrowButton.y - this._upArrowButton.height - this._sliderButton.height;
				 rate = (this._sliderButton.y  - this._upArrowButton.y - this._upArrowButton.height) / instance;
			}else
			{
				instance = this._drawSlip.height - this._sliderButton.height;
				rate = this._sliderButton.y / instance;
			}
			this._content.y = (this._height - this._content.height) * rate;
		}
		private function sliderDownClick( e:TouchEvent ):void
		{
			_isStopDrag = false;
			_mouseSliderInstance =  this._sliderButton.y - GameEngine.getInstance().stage.mouseY;
			GameEngine.getInstance().stage.addEventListener( TouchEvent.TOUCH_MOVE, mouseMoveFun);
			GameEngine.getInstance().stage.addEventListener( TouchEvent.TOUCH_END, sliderUpClick);
		}
		private function mouseMoveFun( e:TouchEvent ):void
		{
			if( _isStopDrag ) return;
			var mousey:Number = GameEngine.getInstance().stage.mouseY;
			this._sliderButton.y = _mouseSliderInstance + mousey;
			this.wetherSliderCross();
		}
		private function sliderUpClick( e:TouchEvent ):void
		{
			_isStopDrag = true;
			GameEngine.getInstance().stage.removeEventListener( TouchEvent.TOUCH_MOVE, mouseMoveFun);
			GameEngine.getInstance().stage.removeEventListener( TouchEvent.TOUCH_END, sliderUpClick);
		}
		private function onMouseWheelHandler(e:TouchEvent):void
		{
//			if(e.delta > 0)
//			{
//				upArrowClick(null);
//			}else if(e.delta < 0)
//			{
//				downArrowClick(null);
//			}
		}
		//滑块是否越界
		private function wetherSliderCross():void
		{
			var instance:Number;
			if(this._upArrowButton)
			{
				if( this._sliderButton.y < this._upArrowButton.y + this._upArrowButton.height )
				{
					this._sliderButton.y = this._upArrowButton.y + this._upArrowButton.height;
				}
				if( this._sliderButton.y > this._downArrowButton.y - this._sliderButton.height )
				{
					this._sliderButton.y = this._downArrowButton.y - this._sliderButton.height;
				}
				instance = this._downArrowButton.y - this._upArrowButton.y - this._upArrowButton.height - this._sliderButton.height;
			}else
			{
				if( this._sliderButton.y < 0 )
				{
					this._sliderButton.y = 0;
				}
				if( this._sliderButton.y > this._drawSlip.height - this._sliderButton.height )
				{
					this._sliderButton.y = this._drawSlip.height - this._sliderButton.height;
				}
				instance = this._drawSlip.height - this._sliderButton.height;
			}
			updateContent();
		}
		//重新设置位置
		private function reSetPostion():void
		{
			switch( type )
			{
				case "left":
					_viewContent.x =  _scrollBarContent.width;
					_viewContent.y = 0;
					_scrollBarContent.x = -5;
					_scrollBarContent.y = 0;
					break;
				case "right":
					_viewContent.x = 0;
					_viewContent.y = 0;
					_scrollBarContent.x = this._width - _scrollBarContent.width + 8 ;
					_scrollBarContent.y = 0;
					break;
				case "up":
					break;
				case "down":
					break;
				default:
					_viewContent.x = 0;
					_viewContent.y = 0;
					_scrollBarContent.x = this._width - _scrollBarContent.width + 8 ;
					_scrollBarContent.y = 0;
					break;
			}
		}
		/**
		 *增加数据 
		 * @param item
		 * 
		 */		
		public function addItem( item:* ):void
		{
			if( _itemData == null ) _itemData = new Array();
			_itemData.push( item );
			if( item is DisplayObject )
			{
				if(!_withLayout)
				{
					item.y =  this._itemTotalNum * (item.height + this._itemGap);
					item.x = 0;
				}
				this._content.addChild( item );
				this._itemTotalNum += 1;
				this._viewHeight = this._content.height;
				this.wetherView();
				return;
			}
			if( item is String )
			{
				var text:TextField = new TextField();
				text.text = item;
				this._content.addChild( text );
				this._viewHeight = this._content.height;
			}
			
			this.wetherView();
		}
		//增加数据
		private function addItemObject():void
		{
			if( this._content )
			{
				while( this._content.numChildren )
				{
					this._content.removeChildAt( 0 );
				}
			}
			for( var i:int = 0; i < this._itemData.length; i++ )
			{
				var temp:* = this._itemData[i];
				if( temp is DisplayObject )
				{
					temp.y =  this._itemTotalNum * (temp.height + this._itemGap);
					temp.x = 0;
					this._content.addChild( temp );
					this._itemTotalNum += 1;
					this._viewHeight += this._content.height;
					continue;
				}
				if( temp is String )
				{
					var text:TextField = new TextField();
					text.text = temp;
					this._content.addChild( text );
					this._viewHeight += this._content.height;
				}
			}
			this.wetherView();
		} 
		//是否显示
		private function wetherView():void
		{
			this._isViewScroll = false;
			if( this._viewHeight  > _height )
			{
				this._isViewScroll = true;
				this._sliderMoveStep = Math.floor(this._viewHeight / this._height);
			}
			else
			{
				this._isViewScroll = false;
			}
			this._sliderButton.visible = _isViewScroll;
			this._drawSlip.visible = _isViewScroll;
//			this._drawSlip.visible = true;
			if(this._isFollow)
			{
				if(this._upArrowButton)
				{
					this._sliderButton.y = this._downArrowButton.y - this._sliderButton.height;
				}else
				{
					this._sliderButton.y = 0;
				}
				this.updateContent();
			}
		}
		/**
		 *清理 
		 * 
		 */		
		public function clear():void
		{
			while(this._content.numChildren)
			{
				this._content.removeChildAt( 0 );
			}
			this._itemData = null;
			this._itemData = new Array();
			
			initPostion();
			
			this._content.y = 0;
			this._itemTotalNum = 0;
			this._isViewScroll = false;
			this._sliderButton.visible = _isViewScroll;
			this._drawSlip.visible = _isViewScroll;
		}
		/**
		 *设置数据 
		 * @param data
		 * 
		 */	
		public function setItemData( data:Array ):void
		{
			if( _itemData == null ) _itemData = new Array();
			while(_itemData.length)
			{
				_itemData.shift();
			}
			_itemData = data;
			addItemObject();
		}
		
		/**
		 * 更新滚动条
		 */		
		public function updateScroll(viewHeight:Number, swidth:int = 0, sheight:int = 0):void
		{
			this._isFollow = true;
			this._viewHeight = viewHeight;
			
			if(swidth != 0)
			{
				this._width = swidth;
			}
			if(sheight != 0)
			{
				this._height = sheight;
				this._drawSlip.height = _height;
				this.initPostion();
				this.reSetPostion();
			}
			if( this._viewContent )
			{
				this._viewContent.scrollRect = new Rectangle(0, 0, _width - _scrollBarContent.width , _height);
			}
			
			this.wetherView();
		}
		
		public function get type():String
		{
			return _type;
		}
		public function set type(value:String):void
		{
			_type = value;
			this.reSetPostion();
		}
		public function get isFollow():Boolean
		{
			return _isFollow;
		}
		public function set isFollow(value:Boolean):void
		{
			_isFollow = value;
		}

		public function get isMinst():Boolean
		{
			return _isMinst;
		}

		public function set isMinst(value:Boolean):void
		{
			_isMinst = value;
			this._scrollBarContent.visible = !this._isMinst;
		}
		
		public function get source():Sprite
		{
			return this._content;
		}

	}
}