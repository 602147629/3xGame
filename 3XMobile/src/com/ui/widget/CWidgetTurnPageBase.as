package com.ui.widget
{
	import com.greensock.TweenLite;
	import com.ui.button.CButton;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.model.ListInfo;
	
	/**
	 * @author caihua
	 * @comment 翻页面板
	 * 创建时间：2014-6-10 上午9:44:01
	 * 子类必须实现  setPara 
	 */
	public class CWidgetTurnPageBase extends CWidgetAbstract
	{
		protected var _dataList:ListInfo;
		
		protected var _container:Sprite;
		protected var _containerOldPos:Point;
		
		protected var _ITEM_SPAN:Point; //item间隔
		protected var _MASK_ZONE:Rectangle; //item间隔
		protected var _NUM_PER_PAGE:Point;
		protected var _dataListLastMode:String = ListInfo.MODE_KEEP_REMAIN;
		protected var _headBtn:CButton;
		protected var _tailBtn:CButton;
		protected var _nextPageBtn:CButton;
		protected var _prevPageBtn:CButton;
		protected var _nextOneBtn:CButton;
		protected var _prevOneBtn:CButton;
		
		private var _num:int = 0;
		private var _isTweening:Boolean;
		
		public function CWidgetTurnPageBase(id:String)
		{
			this.setPara();
			this._dataList = new ListInfo(this._NUM_PER_PAGE.x * this._NUM_PER_PAGE.y, this._dataListLastMode);
			super(id);
		}
		
		/**
		 * 设置属性
		 */
		protected function setPara():void
		{
			//每页横竖项数
			this._NUM_PER_PAGE = new Point(4, 3);
			//遮罩位置
			this._MASK_ZONE = new Rectangle(64, 68, 455.95, 295);
			//每项间隔
			this._ITEM_SPAN = new Point(115, 96.5);
			//最后一页填满模式
			this._dataListLastMode = ListInfo.MODE_KEEP_REMAIN;
			//item开始位置
			this._containerOldPos = new Point(79, 75);
			throw new Error("setPara unimplement");
		}
		
		override protected function drawContent():void
		{
			this._container = new Sprite();
			this._container.x = this._containerOldPos.x;
			this._container.y = this._containerOldPos.y;
			this.addChild(this._container);
			
			var cmask:Shape = new Shape();
			cmask.graphics.beginFill(0xFFFFFF);
			cmask.graphics.lineStyle(0, 0xFFFFFF);
			cmask.graphics.drawRect(this._MASK_ZONE.x, this._MASK_ZONE.y, this._MASK_ZONE.width, this._MASK_ZONE.height);
			cmask.graphics.endFill();
			this.addChild(cmask);
			this._container.mask = cmask;
		}
		
		/**
		 * 画初始页面
		 */
		protected function drawInit():void
		{
			while (this._container.numChildren > 0)
			{
				this._container.removeChildAt(0);
			}
			this.drawItems();
		}
		
		/**
		 * 向前到头
		 * @param	vertical	是否垂直上下翻动，默认为否，即水平左右翻动
		 */
		protected function goToHead(vertical:Boolean = false):void
		{
			if (!this._enterLock())
			{
				return;
			}
			
			if (this._dataList.canToHead)
			{
				this._dataList.head();
				if (vertical)
				{
					this.drawItems(0, this._ITEM_SPAN.y * this._NUM_PER_PAGE.y);
				}
				else
				{
					this.drawItems(this._ITEM_SPAN.x * this._NUM_PER_PAGE.x, 0);
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		/**
		 * 向前翻动一页
		 * @param	vertical	是否垂直上下翻动，默认为否，即水平左右翻动
		 */
		protected function prevPage(vertical:Boolean = false):void
		{
			if (!this._enterLock())
			{
				return;
			}
			
			if (this._dataList.canPrevPage)
			{
				this._dataList.prev();
				if (vertical)
				{
					this.drawItems(0, this._ITEM_SPAN.y * this._NUM_PER_PAGE.y);
				}
				else
				{
					this.drawItems(this._ITEM_SPAN.x * this._NUM_PER_PAGE.x, 0);
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		
		/**
		 * 向前翻动一个
		 * @param	vertical	是否垂直上下翻动，默认为否，即水平左右翻动
		 */
		protected function prevOne(vertical:Boolean = false):void
		{
			if (!this._enterLock())
			{
				return;
			}
			
			if (this._dataList.canPrevOne)
			{
				this._dataList.prevOne();
				if (vertical)
				{
					this.drawItems(0, this._ITEM_SPAN.y);
				}
				else
				{
					this.drawItems(this._ITEM_SPAN.x, 0);
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		/**
		 * 向后到尾
		 * @param	vertical	是否垂直上下翻动，默认为否，即水平左右翻动
		 */
		protected function gotoLast(vertical:Boolean = false):void
		{
			if (!this._enterLock())
			{
				return;
			}
			if (this._dataList.canToLast)
			{
				this._dataList.tail();
				if (vertical)
				{
					this.drawItems(0, -this._ITEM_SPAN.y * this._NUM_PER_PAGE.y);
				}
				else
				{
					this.drawItems(-this._ITEM_SPAN.x * this._NUM_PER_PAGE.x, 0);
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		public function gotoPage(page:int, vertical:Boolean = false, isUseTween:Boolean = true):void
		{
			if (!this._enterLock())
			{
				return;
			}
			if (this._dataList.canGotoPage(page))
			{
				this._dataList.turnTo(page);
				if (vertical)
				{
					this.drawItems(0, -this._ITEM_SPAN.y * this._NUM_PER_PAGE.y, isUseTween);
				}
				else
				{
					this.drawItems(-this._ITEM_SPAN.x * this._NUM_PER_PAGE.x, 0, isUseTween);
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		/**
		 * 向后翻动一页
		 * @param	vertical	是否垂直上下翻动，默认为否，即水平左右翻动
		 */
		protected function nextPage(vertical:Boolean = false):void
		{
			if (!this._enterLock())
			{
				return;
			}
			if (this._dataList.canNextPage)
			{
				this._dataList.next();
				if (vertical)
				{
					this.drawItems(0, -this._ITEM_SPAN.y * this._NUM_PER_PAGE.y);
				}
				else
				{
					this.drawItems(-this._ITEM_SPAN.x * this._NUM_PER_PAGE.x, 0);
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		/**
		 * 向后翻动一个
		 * @param	vertical	是否垂直上下翻动，默认为否，即水平左右翻动
		 */
		protected function nextOne(vertical:Boolean = false):void
		{
			if (!this._enterLock())
			{
				return;
			}
			if (this._dataList.canNextOne)
			{
				this._dataList.nextOne();
				if (vertical)
				{
					this.drawItems(0, -this._ITEM_SPAN.y);
				}
				else
				{
					this.drawItems(-this._ITEM_SPAN.x, 0);
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		/**
		 * 缓动的距离
		 */
		protected function drawItems(tweenDistanceX:Number = 0, tweenDistanceY:Number = 0, isUseTween:Boolean = true):void
		{
			var tweenDistance:Point = new Point(tweenDistanceX, tweenDistanceY)
			var list:Array = this._dataList.getCurrentPageData();
			this._num = 0;
			for each (var data:Object in list)
			{
				var item:Sprite = this.drawItem(data);
				item.x = -tweenDistance.x + (this._ITEM_SPAN.x * (this._num % this._NUM_PER_PAGE.x));
				item.y = -tweenDistance.y + (this._ITEM_SPAN.y * Math.floor(this._num / this._NUM_PER_PAGE.x));
				this._container.addChild(item);
				this._num++;
			}
			
			this.updataTurnPageBtn();
			
			if (tweenDistance.x != 0)
			{
				var endx:Number = this._container.x + tweenDistance.x;
				if(isUseTween)
				{
					TweenLite.to(this._container, 0.7, {x: endx, onComplete: tweenCompleteHandler});
				}else
				{
					this._container.x = endx;
					tweenCompleteHandler();
				}
			}
			else if (tweenDistance.y != 0)
			{
				var endY:Number = this._container.y + tweenDistance.y;
				if(isUseTween)
				{
					TweenLite.to(this._container, 0.7, {y: endY, onComplete: tweenCompleteHandler});
				}else
				{
					this._container.y = endY;
					tweenCompleteHandler();
				}
			}
			else
			{
				this._unlock();
			}
		}
		
		protected function drawItem(data:Object):Sprite
		{
			return null;
		}
		
		protected function updataTurnPageBtn():void
		{
			if (this._prevOneBtn != null)
			{
				this._prevOneBtn.enabled = this._dataList.canPrevOne;
			}
			if (this._nextOneBtn != null)
			{
				this._nextOneBtn.enabled = this._dataList.canNextOne;
			}
			if (this._prevPageBtn != null)
			{
				this._prevPageBtn.enabled = this._dataList.canPrevPage;
			}
			if (this._nextPageBtn != null)
			{
				this._nextPageBtn.enabled = this._dataList.canNextPage;
			}
			if (this._headBtn != null)
			{
				this._headBtn.enabled = this._dataList.canToHead;
			}
			if (this._tailBtn != null)
			{
				this._tailBtn.enabled = this._dataList.canToLast;
			}
		}
		
		/**
		 * 翻页缓动结束
		 */
		private function tweenCompleteHandler():void
		{
			var item:Sprite;
			var offsetX:Number = this._containerOldPos.x - this._container.x;
			var offsetY:Number = this._containerOldPos.y - this._container.y;
			this._container.x = this._containerOldPos.x;
			this._container.y = this._containerOldPos.y;
			for (var i:int = this._container.numChildren - 1; i >= 0; i--)
			{
				item = this._container.getChildAt(i) as Sprite;
				item.x = item.x - offsetX;
				item.y = item.y - offsetY;
				if (item.x < 0 || (this._ITEM_SPAN.x != 0 && item.x >= this._NUM_PER_PAGE.x * this._ITEM_SPAN.x) || item.y < 0 || (this._ITEM_SPAN.y != 0 && item.y >= this._NUM_PER_PAGE.y * this._ITEM_SPAN.y))
				{
					this._container.removeChildAt(i);
				}
			}
			this._unlock();
		}
		
		private function _enterLock():Boolean
		{
			if (this._isTweening)
			{
				return false;
			}
			else
			{
				this._isTweening = true;
				return true;
			}
		}
		
		private function _unlock():void
		{
			this._isTweening = false;
		}
		
		public function get __num():int
		{
			return this._num;
		}
	}
}