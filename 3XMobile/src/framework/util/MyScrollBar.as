package framework.util
{
	/*
	================================================================================
	
	《元件滚动条》
	
	更改了对文本滚动控制改为对元件的控制，并增加缓动效果。
	代码借鉴了：火山动态文本滚动条 V5 ，特此注明！
	
	对象高度有变更时调用init函数。
	--
	2011-7-7 增加外部侦听接口，判断是否在滚动状态，修改更新滚动内容高度调用。
	2012-8-15 修复拖动条出位问题。
	2012-12-28 设置滚轮缓动效果，修改调用方式，优化计算等若干问题。
	2013-4-19 因元件未添加到场景执行顺序导致访问对象没有属性的错误加ADDED_TO_STAGE事件。
	鼠标离开拖动条后的定位。
	2013-4-24 将mask遮罩方式改为scrollRect方式，解决flash滚轮控制与浏览器滚轮控制的冲突
	2013-5-6 完善定位功能,demo1改变窗体不归位，demo2改变窗体回归指定位置
	------------------------------------------------------------
	
	Copyright (c) 2011 [无空]
	
	My web:
	闪耀互动
	http://www.flashme.cn/
	E-mail:
	flashme@live.cn
	
	2011-3-4
	================================================================================
	*/
	import com.riaidea.text.RichTextField;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	
	public class MyScrollBar extends Sprite {
		
		//=============本类属性==============
		////接口元件
		private var scrollTextField:TextField;
		private var scrollBar_sprite:MovieClip;
		private var up_btn:MovieClip;
		private var down_btn:MovieClip;
		private var _slideMc:MovieClip;
//		private var bg_sprite:Sprite;
		private var _area:uint,_height:uint,_width:uint;
		////初始数据
		private var _slideHeight:Number;
		private var _slideStartY:Number;
		private var _slideDistance:Number;
		private var _textHeight:Number;
		private var areaY:int;
		private var _areaHeight:uint;
		private var easingSpeed:uint=8;
		private var Drag:Boolean=false;
		////上下滚动按钮按钮下时间
		private var putTime:Number;
		private var wheelY:int;
		private var maskRect:Rectangle = new Rectangle(0,0,500,400);
		public static const ROLL:String="RollEvent";
		
		/**
		 * @param scrollCon_fc:被滚动的元件
		 * @param scrollBarMc_fc：舞台上与本类所代理的滚动条元件
		 * @param area_fc：显示区域
		 * @param height_fc：滚动条高
		 * @param width_fc：滚动条宽
		 */
		public function MyScrollBar(scrollCon_fc:*, scrollBarMc_fc:MovieClip,area_fc:uint=0, height_fc:uint=0, width_fc:uint=0) 
		{
			//——————滚动条_sprite，滚动条按钮和滑块mc，被滚动的文本域初始化
			scrollTextField = scrollCon_fc;
			scrollBar_sprite = scrollBarMc_fc;
			
			up_btn = scrollBarMc_fc["btn_up"];
			down_btn = scrollBarMc_fc["btn_down"];
			
			UIUtil.setButtonMode(up_btn);
			UIUtil.setButtonMode(down_btn);
			
			_slideMc = scrollBarMc_fc["btn_slide"];
//			bg_sprite = scrollBarMc_fc["bg_mc"];
			
			_area = area_fc;
			_height = height_fc;
			_width = width_fc;
			
			addCon();
			addBar();	
		}
		
		private function addBar():void 
		{
			//——————注册侦听器
			//上滚动按钮
			up_btn.addEventListener(TouchEvent.TOUCH_TAP, upBtn);
			up_btn.stage.addEventListener(TouchEvent.TOUCH_END, upBtnUp);
			//下滚动按钮
			down_btn.addEventListener(TouchEvent.TOUCH_TAP, downBtn);
			down_btn.stage.addEventListener(TouchEvent.TOUCH_END, downBtnUp);
			//滑块
			_slideMc.addEventListener(TouchEvent.TOUCH_BEGIN, poleSprite);
			_slideMc.stage.addEventListener(TouchEvent.TOUCH_END, poleUp);
			//滑块背景点击
//			bg_sprite.addEventListener(TouchEvent.TOUCH_BEGIN, bgDown);
		}
		
		private function addCon():void 
		{
			
			//鼠标滚轮
//			scrollCon.addEventListener(TouchEvent.TOUCH_ROLL_OVER, mouseWheel);
			scrollTextField.scrollRect = maskRect;
			areaY = scrollTextField.y;
			
//			scrollBar_sprite.addEventListener(TouchEvent.TOUCH_TAP, bgDown);
			
			/*scrollCon.addEventListener(TouchEvent.TOUCH_OVER, handleMousIn);
			scrollCon.addEventListener(TouchEvent.TOUCH_OUT, handleMousOut);*/
			
			init(_area, 0, _height, _width);
			
		}
		/**
		 * @param area_fc：显示区域
		 * @param top_fc：重定义顶部起点
		 * @param height_fc：滚动条高
		 * @param width_fc：滚动条宽
		 */
		public function init(area_fc:uint=0, top_fc:int=0, height_fc:uint=0, width_fc:uint=0):void 
		{
			//重置时需要中断之前的事件
			Drag=false;
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, poleDown);
			maskRect.y=ConNewY(_slideMc.y);
			
			//areaY位置会重定义为scrollCon.y，scrollCon.y位置有变更。
			if(top_fc!=0){
				areaY = top_fc;
				maskRect.y=areaY;
				_slideMc.y=PoleNewY(maskRect.y);
			}
			
			scrollBar_sprite.mouseChildren = true;
			_slideMc.visible = true;

			
			//——————其他属性初始化
			
			if(area_fc==0)
			{
				//未接收到高度定义时默认让其上下距离相等
				area_fc=scrollTextField.parent.stage.stageHeight-areaY*2;
			}
			_areaHeight = area_fc;
//			bg_sprite.useHandCursor=false;
			//
			//遮罩
			maskRect.width=scrollTextField.width;
			maskRect.height=_areaHeight;
			
			if (height_fc==0) 
			{
//				bg_sprite.height=areaBg;
			} else {
//				bg_sprite.height=height_fc;
			}
			if (width_fc!=0) 
			{
//				bg_sprite.width=width_fc+2;
				_slideMc.width=width_fc;
				up_btn.width=up_btn.height=down_btn.width=down_btn.height=width_fc;
			}
//			down_btn.y=bg_sprite.y+bg_sprite.height-down_btn.height-1;
			_slideHeight = Math.floor(down_btn.y - up_btn.y - up_btn.height);
			_slideStartY = _slideMc.y = Math.floor(up_btn.y + up_btn.height);
			
			//调用函数更新高度
			renew();
			
		}
		
		private function renew():void 
		{
//			conHeight=getFullBounds(scrollCon).height;
			_textHeight = scrollTextField.textHeight;
			//判断滑块儿是否显示，并根据元件高度定义滑块高度
			/*if (conHeight>areaBg)
			{*/
				scrollBar_sprite.mouseChildren=true;
				
				
				if(_textHeight > _areaHeight)
				{
					_slideMc.visible = true;
					up_btn.enabled = true;
					down_btn.enabled = true;
					//定义一个高度因子
					var heightVar:Number = _areaHeight/_textHeight;
					//根据高度因子初始化滑块的高度
					_slideMc.height = Math.floor(_slideHeight * Math.pow(heightVar,0.3));
					//拖动条可响应的范围
					_slideDistance = Math.floor(_slideStartY);
					
					_slideMc.y = PoleNewY(maskRect.y);
					scrollTextField.scrollRect = maskRect;
				}
				else
				{
					_slideMc.visible = false;
					up_btn.enabled = false;
					down_btn.enabled = false;
					
				}
				
		/*	} 
			else 
			{
				scrollBar_sprite.mouseChildren=false;
				_slideMc.visible=false;
				//up_btn.enabled=false;
				//down_btn.enabled=false;
			}*/
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, downBtnDown);
			scrollTextField.removeEventListener(Event.ENTER_FRAME, wheelEnter);
		}
		
		/**
		 * 计算公式
		 */
		//以拖动条的位置计算来MC的位置，返回int值
		private function ConNewY(nowPosition:int):int 
		{
			//外部判断在滚动时的侦听
			dispatchEvent(new Event(MyScrollBar.ROLL));
			//return -(conHeight-areaBg)*(nowPosition-poleStartY)/totalPixels +areaY;
			return (_textHeight-_areaHeight)*(nowPosition-_slideStartY)/_slideDistance;
			
		}
		//以MC的位置来计算拖动条的位置，返回int值
		private function PoleNewY(nowPosition:int):int 
		{
			//外部判断在滚动时的侦听
			dispatchEvent(new Event(MyScrollBar.ROLL));
			//return totalPixels*(areaY-nowPosition)/(conHeight-areaBg) +poleStartY;
			return _slideDistance*nowPosition/(_textHeight-_areaHeight) +_slideStartY;
			
		}
		//解决设置scrollRect后获取DisplayObject.height不是原始高度的问题
		public function getFullBounds(displayObject : *):Rectangle 
		{
			var transform:Transform = displayObject.transform;
			var currentMatrix:Matrix = transform.matrix;
			var toGlobalMatrix:Matrix = transform.concatenatedMatrix;
			toGlobalMatrix.invert();
			transform.matrix = toGlobalMatrix;
			var rect:Rectangle = transform.pixelBounds.clone();
			transform.matrix = currentMatrix;
			return rect;
		}
		
		/**
		 * 滑块滚动
		 */
		private function poleSprite(event : TouchEvent):void 
		{
			Drag=true;
			//调用函数更新高度
			renew();
			//监听舞台，这样可以保证拖动滑竿的时候，鼠标在舞台的任意位置松手，都会停止拖动
			scrollBar_sprite.stage.addEventListener(TouchEvent.TOUCH_END, poleUp);
			//限定拖动范围
			var dragRect:Rectangle=new Rectangle(_slideMc.x,_slideStartY,0,_slideDistance);
			_slideMc.startDrag(false, dragRect);
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, poleDown);
		}
		
		private function poleDown(event : Event):void 
		{
			//在滚动过程中及时获得滑块所处位置
			var nowPosition:int=_slideMc.y;
			//新位置
			var newY:int=ConNewY(nowPosition);
			//缓动效果，scrollCon.y的位置： scrollCon.y += ((计算出的新位置)-scrollCon.y)/缓动值
			maskRect.y += (newY - maskRect.y)/easingSpeed;
			if(Drag==false&&newY==maskRect.y)
			{
				scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, poleDown);
				maskRect.y=ConNewY(nowPosition);
			}
			scrollTextField.scrollRect=maskRect;
			
		}
		
		private function poleUp(event : TouchEvent):void 
		{
			Drag=false;
			
			_slideMc.stopDrag();
			scrollBar_sprite.stage.removeEventListener(TouchEvent.TOUCH_END, poleUp);
			//scrollCon.addEventListener(Event.SCROLL, textScroll);
		}
		
		/**
		 * 滑块背景点击
		 */
		private function bgDown(event : TouchEvent):void 
		{
			//调用函数更新高度
			renew();
			var nowPosition:int;
			if ((scrollBar_sprite.mouseY-up_btn.y-up_btn.height) < (_slideMc.height / 2)) 
			{
				nowPosition=Math.floor(up_btn.y+up_btn.height);
			} 
			else if ((down_btn.y - scrollBar_sprite.mouseY) < _slideMc.height / 2) 
			{
				nowPosition=Math.floor(down_btn.y-_slideMc.height);
			} else 
			{
				nowPosition=scrollBar_sprite.mouseY-_slideMc.height/2;
			}
			_slideMc.y=nowPosition;
			maskRect.y=ConNewY(nowPosition);
			scrollTextField.scrollRect=maskRect;
			
		}
		
		/**
		 * 下滚动按钮
		 */
		private function downBtn(event : TouchEvent):void 
		{
			//调用函数更新高度
			renew();
			if (maskRect.y < (_textHeight-_areaHeight)) 
			{
				maskRect.y+=10;
				var nowPosition:int=maskRect.y;
				_slideMc.y=PoleNewY(nowPosition);
				scrollTextField.scrollRect=maskRect;
			}
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime = getTimer();
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, downBtnDown);
		}
		
		private function downBtnDown(event : Event):void 
		{
			if (getTimer() - putTime > 500) {
				if (maskRect.y < (_textHeight-_areaHeight)) 
				{
					
					maskRect.y += 3;
					var nowPosition:int = maskRect.y;
					_slideMc.y = PoleNewY(nowPosition);
					scrollTextField.scrollRect = maskRect;
				}
			}
		}
		
		private function downBtnUp(event : TouchEvent):void 
		{
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, downBtnDown);
		}
		
		/**
		 * 上滚动按钮
		 */
		private function upBtn(event : TouchEvent):void 
		{
			//调用函数更新高度
			renew();
			if (maskRect.y>0) 
			{
				maskRect.y-=10;
				var nowPosition:int=maskRect.y;
				_slideMc.y=PoleNewY(nowPosition);
				scrollTextField.scrollRect=maskRect;
			}
			//当鼠标在按钮上按下的时间大于设定时间时，连续滚动
			putTime=getTimer();
			scrollBar_sprite.addEventListener(Event.ENTER_FRAME, upBtnDown);
		}
		
		private function upBtnDown(event : Event):void 
		{
			if (getTimer()-putTime>500) 
			{
				if (maskRect.y>0) 
				{
					maskRect.y-=3;
					var nowPosition:int=maskRect.y;
					_slideMc.y=PoleNewY(nowPosition);
					scrollTextField.scrollRect=maskRect;
				}
			}
		}
		
		private function upBtnUp(event : TouchEvent):void 
		{
			scrollBar_sprite.removeEventListener(Event.ENTER_FRAME, upBtnDown);
		}
		
		/**
		 * 鼠标滚轮事件
		 */
		private function mouseWheel(event : TouchEvent):void 
		{
			
			if(_textHeight<_areaHeight)
			{
				return;
			}
			//调用函数更新高度
			renew();
			wheelY = (maskRect.y - Math.floor(event.delta*80));
			
			if (event.delta < 0) 
			{
				wheelY=wheelY > (_textHeight-_areaHeight)?_textHeight - _areaHeight:wheelY;
			} 
			else if (event.delta > 0) 
			{
				wheelY=wheelY < 0 ?0 :wheelY;
			}
			scrollTextField.addEventListener(Event.ENTER_FRAME, wheelEnter);
		}
		private function wheelEnter(e:Event):void 
		{
			
			maskRect.y += (wheelY-maskRect.y)/easingSpeed;
			
			_slideMc.y = PoleNewY(maskRect.y);
			scrollTextField.scrollRect = maskRect;
			if(maskRect.y == wheelY)
			{
				scrollTextField.removeEventListener(Event.ENTER_FRAME, wheelEnter);
			}
			
		}
		/**
		 * 解决鼠标滚轮的冲突
		 */
		private function handleMousIn(e:Event):void 
		{
//			mouseWheelEnabled(false);
		}
		
		private function handleMousOut(e:Event):void 
		{
//			mouseWheelEnabled(true);
		}
	/*	public function mouseWheelEnabled(value:Boolean):void {
			if (! value) {
				ExternalInterface.call("eval", "var _onFlashMousewheel = function(e){e = e || event;e.preventDefault && e.preventDefault();e.stopPropagation && e.stopPropagation();return e.returnValue = false;};if(window.addEventListener){var type = (document.getBoxObjectFor)?'DOMMouseScroll':'mousewheel';window.addEventListener(type, _onFlashMousewheel, false);}else{document.onmousewheel = _onFlashMousewheel;}");
			} else {
				ExternalInterface.call("eval", "if(window.removeEventListener){var type = (document.getBoxObjectFor)?'DOMMouseScroll':'mousewheel';window.removeEventListener(type, _onFlashMousewheel, false);}else{document.onmousewheel = null;}");
			}
		}*/
		
		
		
	}
}