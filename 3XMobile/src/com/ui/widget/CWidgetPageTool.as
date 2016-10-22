package com.ui.widget
{
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	
	import flash.events.TouchEvent;
	import flash.text.TextField;
	
	import framework.view.notification.GameNotification;

	public class CWidgetPageTool extends CWidgetAbstract
	{
		private var _prevPageBtn:CButtonCommon;
		private var _firstPageBtn:CButtonCommon;
		private var _nextPageBtn:CButtonCommon;
		private var _lastPageBtn:CButtonCommon;
		
		private var _pageNumTxt:TextField;
		
		private var _currentPage:int;
		
		private var _totalPage:int;
		
		public function CWidgetPageTool()
		{
			super("panel.signup.rankList");
		}
		
		override protected function drawContent():void
		{
			_prevPageBtn = new CButtonCommon("left_small");
			this.mc.prevbtnpos.addChild(_prevPageBtn);
			
			_nextPageBtn = new CButtonCommon("right_small");
			this.mc.nextbtnpos.addChild(_nextPageBtn);
			
			_firstPageBtn = new CButtonCommon("z_n91_first");
			this.mc.firstpos.addChild(_firstPageBtn);
			
			_lastPageBtn = new CButtonCommon("z_n90_last");
			this.mc.lastpos.addChild(_lastPageBtn);
			
			_pageNumTxt = CBaseUtil.getTextField(mc.pageNumTxt, 14, 0xffffff);
			
			//翻页
			_prevPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onPrevPageClick);
			_nextPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onNextPageClick);
			_firstPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onFirstPageClick);
			_lastPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onLastPageClick);
		}
		
		protected function __onLastPageClick(event:TouchEvent):void
		{
			if(_currentPage != _totalPage)
			{
				_currentPage = _totalPage;
				CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_PAGE, _totalPage);
				__changeButtonState();
			}
		}
		
		protected function __onFirstPageClick(event:TouchEvent):void
		{
			if(_currentPage != 1)
			{
				_currentPage = 1;
				CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_PAGE, 1);
				__changeButtonState();
			}
		}
		
		protected function __onNextPageClick(event:TouchEvent):void
		{
			if(_currentPage < _totalPage)
			{
				_currentPage ++;
				CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_PAGE, _currentPage);
				__changeButtonState();
			}
		}
		
		protected function __onPrevPageClick(event:TouchEvent):void
		{
			if(_currentPage > 1)
			{
				_currentPage --;
				CBaseUtil.sendEvent(GameNotification.EVENT_CHANGE_PAGE, _currentPage);
				__changeButtonState();
			}
		}
		
		protected function __changeButtonState():void
		{
			if(_currentPage == 1)
			{
				this._prevPageBtn.enabled = false;
				this._firstPageBtn.enabled = false;
				if(_currentPage == _totalPage)
				{
					this._nextPageBtn.enabled = false;
					this._lastPageBtn.enabled = false;
				}
				else
				{
					this._nextPageBtn.enabled = true;
					this._lastPageBtn.enabled = true;
				}
			}
			else if(_currentPage == _totalPage)
			{
				this._nextPageBtn.enabled = false;
				this._lastPageBtn.enabled = false;
				this._prevPageBtn.enabled = true;
				this._firstPageBtn.enabled = true;
			}
			else
			{
				this._nextPageBtn.enabled = true;
				this._lastPageBtn.enabled = true;
				this._prevPageBtn.enabled = true;
				this._firstPageBtn.enabled = true;
			}
		}

		public function get totalPage():int
		{
			return _totalPage;
		}

		public function set totalPage(value:int):void
		{
			_totalPage = value;
			
			if(_pageNumTxt != null)
			{
				_pageNumTxt.text = _currentPage + "/" + _totalPage;
				__changeButtonState();
			}
		}

		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			_currentPage = value;
			
			if(_pageNumTxt != null)
			{
				_pageNumTxt.text = _currentPage + "/" + _totalPage;
				__changeButtonState();
			}
		}


	}
}